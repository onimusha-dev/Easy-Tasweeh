import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:easy_tasbeeh/core/constants/app_constants.dart';
import 'package:easy_tasbeeh/core/service/shared_preferences.dart';
import 'package:easy_tasbeeh/database/dao/count_history_dao.dart';
import 'package:easy_tasbeeh/database/dao/current_count_dao.dart';
import 'package:easy_tasbeeh/database/db.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'backup_service.g.dart';

@riverpod
class BackupService extends _$BackupService {
  @override
  void build() {}

  static Future<void> performAutomaticBackup() async {
    final prefs = await SharedPreferences.getInstance();
    final backupDir = prefs.getString('backupDirectory');
    if (backupDir == null) return;

    // Ensure AppPreferences is initialized for the background isolate
    await AppPreferences.init();

    final container = ProviderContainer();
    try {
      final backupService = container.read(backupServiceProvider.notifier);
      await backupService.autoBackup(backupDir);
    } catch (e) {
      debugPrint('Background backup failed: $e');
    } finally {
      container.dispose();
    }
  }

  Future<String> _getDatabasePath() async {
    final directory = await getApplicationSupportDirectory();
    return p.join(directory.path, 'easy_tasbeeh_db.sqlite');
  }

  Future<File?> createBackupZip() async {
    try {
      final dbPath = await _getDatabasePath();
      final dbFile = File(dbPath);

      if (!await dbFile.exists()) {
        debugPrint('Backup: Database file not found at $dbPath');
        return null;
      }

      final tempDir = await getTemporaryDirectory();
      final backupDir = Directory(p.join(tempDir.path, 'backup_temp'));
      if (await backupDir.exists()) {
        await backupDir.delete(recursive: true);
      }
      await backupDir.create(recursive: true);

      // 1. Copy Database & sidecars (WAL/SHM)
      final filesToZip = <String>[];

      final backupDbPath = p.join(backupDir.path, 'database.sqlite');
      await dbFile.copy(backupDbPath);
      filesToZip.add(backupDbPath);

      // Check for WAL/SHM
      final walFile = File('$dbPath-wal');
      if (await walFile.exists()) {
        final backupWalPath = p.join(backupDir.path, 'database.sqlite-wal');
        await walFile.copy(backupWalPath);
        filesToZip.add(backupWalPath);
      }

      final shmFile = File('$dbPath-shm');
      if (await shmFile.exists()) {
        final backupShmPath = p.join(backupDir.path, 'database.sqlite-shm');
        await shmFile.copy(backupShmPath);
        filesToZip.add(backupShmPath);
      }

      // 2. Export Preferences
      final prefsJson = AppPreferences.exportToJson();
      final prefsFile = File(p.join(backupDir.path, 'preferences.json'));
      await prefsFile.writeAsString(prefsJson);
      filesToZip.add(prefsFile.path);

      // 3. Create Metadata
      final metadata = {
        'app_name': AppConstants.appName,
        'backup_date': DateTime.now().toIso8601String(),
        'version': AppConstants.appVersion,
      };
      final metadataFile = File(p.join(backupDir.path, 'metadata.json'));
      await metadataFile.writeAsString(jsonEncode(metadata));
      filesToZip.add(metadataFile.path);

      // 4. Create ZIP
      final archive = Archive();
      for (final filePath in filesToZip) {
        final file = File(filePath);
        if (await file.exists()) {
          final bytes = await file.readAsBytes();
          debugPrint(
            'Adding to ZIP: ${p.basename(filePath)} (${bytes.length} bytes)',
          );
          archive.addFile(
            ArchiveFile(p.basename(filePath), bytes.length, bytes),
          );
        }
      }

      final zipData = ZipEncoder().encode(archive);

      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final zipPath = p.join(
        tempDir.path,
        'easy_tasbeeh_backup_$timestamp.zip',
      );

      final zipFile = File(zipPath);
      await zipFile.writeAsBytes(zipData);

      final zipSize = await zipFile.length();
      debugPrint('Backup ZIP created: $zipPath ($zipSize bytes)');

      // Clean up temp directory
      await backupDir.delete(recursive: true);

      return zipFile;
    } catch (e, stack) {
      debugPrint('Error creating backup: $e');
      debugPrint(stack.toString());
      return null;
    }
  }

  Future<bool> exportBackup() async {
    final zipFile = await createBackupZip();
    if (zipFile == null) return false;

    try {
      final zipSize = await zipFile.length();
      debugPrint('Exporting backup: ${zipFile.path} ($zipSize bytes)');

      if (zipSize == 0) {
        debugPrint('Error: ZIP file is 0 bytes!');
        return false;
      }

      final result = await Share.shareXFiles(
        [XFile(zipFile.path)],
        subject:
            'Easy Tasbeeh Backup - ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
      );

      // On Android, status is often 'unavailable'. We consider that success if it didn't throw.
      if (defaultTargetPlatform == TargetPlatform.android) {
        return result.status != ShareResultStatus.dismissed;
      }

      return result.status == ShareResultStatus.success;
    } catch (e) {
      debugPrint('Error sharing backup: $e');
      return false;
    }
  }

  Future<bool> autoBackup(String directoryPath) async {
    try {
      final zipFile = await createBackupZip();
      if (zipFile == null) return false;

      final fileName = p.basename(zipFile.path);
      final targetPath = p.join(directoryPath, fileName);

      await zipFile.copy(targetPath);
      return true;
    } catch (e) {
      debugPrint('Error during auto backup: $e');
      return false;
    }
  }

  Future<String?> selectBackupDirectory() async {
    try {
      final String? selectedDirectory = await FilePicker.platform
          .getDirectoryPath();
      return selectedDirectory;
    } catch (e) {
      debugPrint('Error selecting directory: $e');
      return null;
    }
  }

  Future<void> clearAllData() async {
    try {
      // 1. Clear Database
      // Use DAOs to clear data instead of deleting file directly to avoid connection issues
      await ref.read(countHistoryDaoProvider).deleteAll();
      await ref.read(currentCountDaoProvider).deleteAll();

      // 2. Clear Preferences
      await AppPreferences.instance.clear();
    } catch (e) {
      debugPrint('Error clearing data: $e');
      rethrow;
    }
  }

  Future<void> clearHistoryOnly() async {
    try {
      await ref.read(countHistoryDaoProvider).deleteAll();
      await ref.read(currentCountDaoProvider).deleteAll();
    } catch (e) {
      debugPrint('Error clearing history: $e');
      rethrow;
    }
  }

  Future<int> getHistoryCount() async {
    final db = ref.read(appDatabaseProvider);
    final count = await db
        .select(db.countHistoryTable)
        .get()
        .then((v) => v.length);
    return count;
  }

  Future<String> getDatabaseSizeString() async {
    try {
      final dbPath = await _getDatabasePath();
      final file = File(dbPath);
      if (await file.exists()) {
        final bytes = await file.length();
        if (bytes < 1024) return '$bytes B';
        if (bytes < 1024 * 1024) {
          return '${(bytes / 1024).toStringAsFixed(1)} KB';
        }
        return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
      }
    } catch (e) {
      debugPrint('Error getting DB size: $e');
    }
    return '0 B';
  }

  Future<bool> exportHistoryToCSV() async {
    try {
      final db = ref.read(appDatabaseProvider);
      final history = await db.select(db.countHistoryTable).get();

      if (history.isEmpty) return false;

      final buffer = StringBuffer();
      buffer.writeln('ID,Dhikr,Count,Target,Date');

      for (var h in history) {
        final date = DateFormat('yyyy-MM-dd HH:mm:ss').format(h.createdAt);
        buffer.writeln(
          '${h.id},"${h.dhikrId}",${h.currentCount},${h.targetCount},"$date"',
        );
      }

      final tempDir = await getTemporaryDirectory();
      final csvFile = File(p.join(tempDir.path, 'easy_tasbeeh_history.csv'));
      await csvFile.writeAsString(buffer.toString());

      final result = await Share.shareXFiles([
        XFile(csvFile.path),
      ], subject: 'Easy Tasbeeh History Export');
      return result.status == ShareResultStatus.success;
    } catch (e) {
      debugPrint('Error exporting CSV: $e');
      return false;
    }
  }

  // Refactor restoreBackup to use a common private method
  Future<bool> restoreBackup() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
      );

      if (result == null || result.files.isEmpty) return false;

      final zipFile = File(result.files.single.path!);
      return await _restoreFromFile(zipFile);
    } catch (e) {
      debugPrint('Error picking backup: $e');
      return false;
    }
  }

  Future<bool> _restoreFromFile(File zipFile) async {
    try {
      final bytes = await zipFile.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      final tempDir = await getTemporaryDirectory();
      final restoreDir = Directory(p.join(tempDir.path, 'restore_temp'));
      if (await restoreDir.exists()) {
        await restoreDir.delete(recursive: true);
      }
      await restoreDir.create(recursive: true);

      // Extract archive
      for (final file in archive) {
        final filename = file.name;
        if (file.isFile) {
          final data = file.content as List<int>;
          final outFile = File(p.join(restoreDir.path, filename));
          await outFile.create(recursive: true);
          await outFile.writeAsBytes(data);
        }
      }

      // Validate Metadata
      final metadataFile = File(p.join(restoreDir.path, 'metadata.json'));
      if (!await metadataFile.exists()) {
        debugPrint('Restore: metadata.json missing');
        return false;
      }

      final metadata = jsonDecode(await metadataFile.readAsString());
      if (metadata['app_name'] != AppConstants.appName) {
        debugPrint('Restore: Incorrect app name (${metadata['app_name']})');
        return false;
      }

      // 1. Restore Preferences
      final prefsFile = File(p.join(restoreDir.path, 'preferences.json'));
      if (await prefsFile.exists()) {
        final prefsJson = await prefsFile.readAsString();
        await AppPreferences.importFromJson(prefsJson);
      }

      // 2. Restore Database
      final backupDbFile = File(p.join(restoreDir.path, 'database.sqlite'));
      if (await backupDbFile.exists()) {
        // Close current database connection
        final db = ref.read(appDatabaseProvider);
        await db.close();

        // Brief delay to ensure file handles are released
        await Future.delayed(const Duration(milliseconds: 200));

        final dbPath = await _getDatabasePath();

        // Remove existing sidecars to avoid corruption if the new DB doesn't have them
        final walFile = File('$dbPath-wal');
        if (await walFile.exists()) await walFile.delete();
        final shmFile = File('$dbPath-shm');
        if (await shmFile.exists()) await shmFile.delete();

        // Copy main database
        await backupDbFile.copy(dbPath);

        // Restore sidecars if present in backup
        final backupWalFile = File(
          p.join(restoreDir.path, 'database.sqlite-wal'),
        );
        if (await backupWalFile.exists()) {
          await backupWalFile.copy('$dbPath-wal');
        }

        final backupShmFile = File(
          p.join(restoreDir.path, 'database.sqlite-shm'),
        );
        if (await backupShmFile.exists()) {
          await backupShmFile.copy('$dbPath-shm');
        }
      }

      // Clean up
      await restoreDir.delete(recursive: true);

      debugPrint('Restore completed successfully');
      return true;
    } catch (e, stack) {
      debugPrint('Error during restore logic: $e');
      debugPrint(stack.toString());
      return false;
    }
  }
}
