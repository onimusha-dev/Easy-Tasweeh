import 'package:collection/collection.dart';
import 'package:drift/drift.dart';
import 'package:easy_tasbeeh/core/models/counter_models.dart';
import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:easy_tasbeeh/database/dao/count_history_dao.dart';
import 'package:easy_tasbeeh/database/dao/current_count_dao.dart';
import 'package:easy_tasbeeh/database/db.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'count_repository.g.dart';

@Riverpod(keepAlive: true)
CountRepository countRepository(Ref ref) {
  return CountRepository(ref);
}

const int sessionIdSingle = 1;
const int sessionIdCombo = 2;

class CountRepository {
  final Ref _ref;

  CountRepository(this._ref);

  CurrentCountDao get _currentCountDao => _ref.read(currentCountDaoProvider);
  CountHistoryDao get _countHistoryDao => _ref.read(countHistoryDaoProvider);

  CounterSession _mapToSession(CurrentCountTableData data) {
    return CounterSession(
      id: data.id,
      currentCount: data.currentCount,
      targetCount: data.targetCount,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
      dhikrId: data.dhikrId,
      comboName: data.comboName,
      sessionMode: data.sessionMode,
    );
  }

  // --- Public API ---

  // Watch current count progress by ID
  Stream<CounterSession?> watchCountById(int id) {
    return _currentCountDao.watchCountById(id).map((data) {
      if (data == null) return null;
      return _mapToSession(data);
    });
  }

  // --- Session Management ---

  // Get or initialize the current count session based on the active mode
  Future<CounterSession> getOrCreateCurrentCount({int? sessionId}) async {
    final settings = _ref.read(settingsProvider);
    final isComboRequested = sessionId != null
        ? sessionId == sessionIdCombo
        : settings.dhikr.activeComboIndex >= 0;

    final targetSessionId =
        sessionId ?? (isComboRequested ? sessionIdCombo : sessionIdSingle);

    final counts = await _currentCountDao.getAllCounts();
    CurrentCountTableData? existing = counts.firstWhereOrNull(
      (c) => c.id == targetSessionId,
    );

    final expectedMode = isComboRequested ? 'combo' : 'single';
    final expectedDhikrId = isComboRequested
        ? 'combo'
        : settings.dhikr.lastDhikrId;
    final expectedComboName = isComboRequested
        ? (settings.dhikr.activeComboIndex >= 0 &&
                  settings.dhikr.activeComboIndex <
                      settings.dhikr.comboPresets.length
              ? settings
                    .dhikr
                    .comboPresets[settings.dhikr.activeComboIndex]
                    .name
              : null)
        : null;

    if (existing == null) {
      final newSession = CurrentCountTableData(
        id: targetSessionId,
        targetCount: isComboRequested ? 99 : 33,
        currentCount: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        dhikrId: expectedDhikrId,
        comboName: expectedComboName,
        sessionMode: expectedMode,
      );

      await _currentCountDao.insertCount(
        CurrentCountTableCompanion(
          id: Value(targetSessionId),
          targetCount: Value(newSession.targetCount),
          currentCount: Value(0),
          dhikrId: Value(newSession.dhikrId),
          comboName: Value(newSession.comboName),
          sessionMode: Value(newSession.sessionMode),
        ),
      );
      return _mapToSession(newSession);
    } else {
      // Sync existing session if metadata changed
      bool needsUpdate =
          existing.sessionMode != expectedMode ||
          existing.comboName != expectedComboName ||
          existing.dhikrId != expectedDhikrId;

      if (needsUpdate) {
        final updated = existing.copyWith(
          sessionMode: expectedMode,
          dhikrId: expectedDhikrId,
          comboName: Value(expectedComboName),
          updatedAt: DateTime.now(),
        );
        await _currentCountDao.updateCount(
          CurrentCountTableCompanion(
            id: Value(targetSessionId),
            sessionMode: Value(expectedMode),
            dhikrId: Value(expectedDhikrId),
            comboName: Value(expectedComboName),
            updatedAt: Value(updated.updatedAt),
          ),
        );
        return _mapToSession(updated);
      }
      return _mapToSession(existing);
    }
  }

  // Atomic increment for the active session
  Future<CounterSession> increment() async {
    final session = await getOrCreateCurrentCount();
    await _currentCountDao.incrementCount(session.id);

    // Fetch updated state for the notifier
    final updated = (await _currentCountDao.getAllCounts()).firstWhere(
      (c) => c.id == session.id,
    );
    return _mapToSession(updated);
  }

  // Reset the specified session (or current active) to 0
  Future<void> reset({int? sessionId}) async {
    final session = await getOrCreateCurrentCount(sessionId: sessionId);
    await _currentCountDao.updateCount(
      CurrentCountTableCompanion(
        id: Value(session.id),
        currentCount: const Value(0),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // Save specified session (or current active) to history and reset it
  Future<void> saveAndReset({bool isRestorable = true, int? sessionId}) async {
    final current = await getOrCreateCurrentCount(sessionId: sessionId);

    if (current.currentCount > 0) {
      final isCombo = current.id == sessionIdCombo;
      final settings = _ref.read(settingsProvider);

      // Determine comboIndex if in combo mode
      int? comboIndex;
      if (isCombo) {
        comboIndex = settings.dhikr.activeComboIndex;
      }

      await _countHistoryDao.insertHistory(
        CountHistoryTableCompanion(
          targetCount: Value(current.targetCount),
          currentCount: Value(current.currentCount),
          createdAt: Value(DateTime.now()),
          dhikrId: Value(current.dhikrId),
          comboName: Value(current.comboName),
          sessionMode: Value(current.sessionMode),
          isRestorable: Value(isRestorable),
          comboIndex: Value(comboIndex),
        ),
      );

      // Reset the current count in DB
      await reset(sessionId: current.id);
    } else {
      // Even if count is 0, we ensure it's clean
      await reset(sessionId: current.id);
    }
  }

  // Restore the most recent history record into the active session
  Future<bool> restoreLastSession() async {
    final history = await _countHistoryDao.watchAllHistory().first;
    if (history.isEmpty) return false;

    // Filter for the last restorable record that meets the user's conditions:
    // 1. Under today
    // 2. Not completed (if target > 0)
    // 3. Not 0
    final now = DateTime.now();
    final last = history.firstWhereOrNull((h) {
      if (h.isRestorable != true) return false;

      final date = h.createdAt.toLocal();
      final isToday =
          date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
      if (!isToday) return false;

      final isZero = h.currentCount <= 0;
      if (isZero) return false;

      final isCompleted = h.targetCount > 0 && h.currentCount >= h.targetCount;
      if (isCompleted) return false;

      return true;
    });

    if (last == null) return false;

    final isCombo = last.sessionMode == 'combo';
    final sessionId = isCombo ? sessionIdCombo : sessionIdSingle;

    // Ensure session exists
    await getOrCreateCurrentCount(sessionId: sessionId);

    await _currentCountDao.updateCount(
      CurrentCountTableCompanion(
        id: Value(sessionId),
        currentCount: Value(last.currentCount),
        targetCount: Value(last.targetCount),
        dhikrId: Value(last.dhikrId),
        comboName: Value(last.comboName),
        sessionMode: Value(last.sessionMode),
        updatedAt: Value(DateTime.now()),
      ),
    );

    // Delete the history record after restoration
    await _countHistoryDao.deleteById(last.id);
    return true;
  }

  // Update target for specified session (or current active)
  Future<void> setTarget(int target, {int? sessionId}) async {
    final session = await getOrCreateCurrentCount(sessionId: sessionId);
    await _currentCountDao.updateCount(
      CurrentCountTableCompanion(
        id: Value(session.id),
        targetCount: Value(target),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // Update Dhikr ID for a specific session
  Future<void> setDhikrId(String dhikrId, {int? sessionId}) async {
    final session = await getOrCreateCurrentCount(sessionId: sessionId);
    await _currentCountDao.updateCount(
      CurrentCountTableCompanion(
        id: Value(session.id),
        dhikrId: Value(dhikrId),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // Watch all history records
  Stream<List<HistoryRecord>> watchAllHistory() {
    return _countHistoryDao.watchAllHistory().map((list) {
      return list
          .map(
            (data) => HistoryRecord(
              id: data.id,
              targetCount: data.targetCount,
              currentCount: data.currentCount,
              createdAt: data.createdAt,
              dhikrId: data.dhikrId,
              comboName: data.comboName,
              sessionMode: data.sessionMode,
              isRestorable: data.isRestorable,
              comboIndex: data.comboIndex,
            ),
          )
          .toList();
    });
  }

  Future<void> deleteHistoryById(int id) => _countHistoryDao.deleteById(id);
  Future<void> deleteAllHistory() => _countHistoryDao.deleteAll();
}
