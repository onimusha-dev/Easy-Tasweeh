import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:easy_tasbeeh/core/constants/app_constants.dart';
import 'package:easy_tasbeeh/core/service/notification_service.dart';
import 'package:easy_tasbeeh/core/service/shared_preferences.dart';
import 'package:easy_tasbeeh/database/db.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'backup/backup_engine.dart';

class BackupService {
  final AppDatabase db;
  BackupService(this.db);

  Future<bool> createAndSaveBackup() async {
    final zipFile = await BackupEngine.generateBackupZip();
    if (zipFile == null) return false;

    try {
      final fileName = p.basename(zipFile.path);
      final bytes = await zipFile.readAsBytes();

      final String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Backup',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: ['zip'],
        bytes: bytes,
      );

      if (outputFile == null) return false;

      await NotificationService().showBackupSuccessNotification();
      return true;
    } catch (e) {
      await NotificationService().showBackupErrorNotification(e.toString());
      return false;
    }
  }

  Future<bool> saveBackupToDirectory(String directoryPath) async {
    final zipFile = await BackupEngine.generateBackupZip();
    if (zipFile == null) return false;

    try {
      final targetPath = p.join(directoryPath, p.basename(zipFile.path));
      await zipFile.copy(targetPath);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> restoreBackup() async {
    Directory? restoreDir;
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) return false;

      final notificationService = NotificationService();
      const int progressId = 500;

      await notificationService.showProgressNotification(
        id: progressId,
        title: 'Restoring Backup',
        body: 'Initializing...',
        progress: 0,
        maxProgress: 100,
        indeterminate: true,
      );

      final pickedFile = result.files.single;
      final Uint8List bytes = pickedFile.bytes ?? await File(pickedFile.path!).readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      final tempDir = await getTemporaryDirectory();
      restoreDir = Directory(p.join(tempDir.path, 'restore_${DateTime.now().millisecondsSinceEpoch}'));
      await restoreDir.create(recursive: true);

      for (int i = 0; i < archive.length; i++) {
        final file = archive[i];
        if (file.isFile) {
          final outFile = File(p.join(restoreDir.path, file.name));
          await outFile.writeAsBytes(file.content as List<int>);
        }
        await notificationService.showProgressNotification(
          id: progressId,
          title: 'Restoring Backup',
          body: 'Extracting files...',
          progress: ((i + 1) / archive.length * 50).toInt(),
          maxProgress: 100,
        );
      }

      final metadataFile = File(p.join(restoreDir.path, 'metadata.json'));
      if (!await metadataFile.exists()) throw 'Metadata missing';
      
      final metadata = jsonDecode(await metadataFile.readAsString());
      if (metadata['app_name'] != AppConstants.appName) throw 'Invalid backup file';

      final prefsFile = File(p.join(restoreDir.path, 'preferences.json'));
      if (await prefsFile.exists()) {
        await notificationService.showProgressNotification(
          id: progressId,
          title: 'Restoring Backup',
          body: 'Restoring preferences...',
          progress: 60,
          maxProgress: 100,
        );
        await AppPreferences.importFromJson(await prefsFile.readAsString());
      }

      final backupDbFile = File(p.join(restoreDir.path, 'database.sqlite'));
      if (await backupDbFile.exists()) {
        await notificationService.showProgressNotification(
          id: progressId,
          title: 'Restoring Backup',
          body: 'Restoring database...',
          progress: 80,
          maxProgress: 100,
        );
        await db.close();
        await Future.delayed(const Duration(milliseconds: 600));

        final dbPath = await BackupEngine.getDatabasePath();
        final currentDb = File(dbPath);

        if (await currentDb.exists()) await currentDb.delete();
        for (var ext in ['-wal', '-shm']) {
          final sidecar = File('$dbPath$ext');
          if (await sidecar.exists()) await sidecar.delete();
        }

        await backupDbFile.copy(dbPath);
        for (var ext in ['-wal', '-shm']) {
          final backupSidecar = File(p.join(restoreDir.path, 'database.sqlite$ext'));
          if (await backupSidecar.exists()) {
            await backupSidecar.copy('$dbPath$ext');
          }
        }
      }
      
      await notificationService.showProgressNotification(
        id: progressId,
        title: 'Restoring Backup',
        body: 'Finalizing...',
        progress: 100,
        maxProgress: 100,
      );
      
      // Small delay to ensure all file operations are fully committed
      await Future.delayed(const Duration(milliseconds: 500));
      await notificationService.cancelNotification(progressId);
      await notificationService.showRestoreSuccessNotification();
      await restoreDir.delete(recursive: true);
      return true;
    } catch (e) {
      await NotificationService().cancelNotification(500); // Progress ID
      await NotificationService().showRestoreErrorNotification(e.toString());
      if (restoreDir != null && await restoreDir.exists()) {
        await restoreDir.delete(recursive: true);
      }
      return false;
    }
  }

  Future<String?> selectBackupDirectory() async {
    return await FilePicker.platform.getDirectoryPath();
  }

  Future<void> clearAllData() async {
    await db.transaction(() async {
      await db.delete(db.countHistoryTable).go();
      await db.delete(db.currentCountTable).go();
    });
    await AppPreferences.instance.clear();
  }

  Future<void> clearHistoryOnly() async {
    await db.transaction(() async {
      await db.delete(db.countHistoryTable).go();
      await db.delete(db.currentCountTable).go();
    });
  }

  Future<String> getDatabaseSizeString() async {
    try {
      final file = File(await BackupEngine.getDatabasePath());
      if (await file.exists()) {
        final bytes = await file.length();
        if (bytes < 1024) return '$bytes B';
        if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
        return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
      }
    } catch (_) {}
    return '0 B';
  }

  Future<bool> exportHistoryToCSV() async {
    try {
      final history = await db.select(db.countHistoryTable).get();
      if (history.isEmpty) return false;

      final buffer = StringBuffer();
      buffer.writeln('ID,Dhikr,Count,Target,Date');
      for (var h in history) {
        buffer.writeln('${h.id},"${h.dhikrId}",${h.currentCount},${h.targetCount},"${h.createdAt}"');
      }

      final tempDir = await getTemporaryDirectory();
      final csvFile = File(p.join(tempDir.path, 'EasyTasbeeh_History.csv'));
      await csvFile.writeAsString(buffer.toString());

      final result = await Share.shareXFiles([XFile(csvFile.path)]);
      return result.status == ShareResultStatus.success;
    } catch (_) {
      return false;
    }
  }
}

final backupServiceProvider = Provider<BackupService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return BackupService(db);
});

@pragma('vm:entry-point')
Future<void> performAutomaticBackupTask() async {
  final prefs = await SharedPreferences.getInstance();
  final backupDir = prefs.getString('backupDirectory');
  if (backupDir == null) return;

  await AppPreferences.init();
  final container = ProviderContainer();
  try {
    final backupService = container.read(backupServiceProvider);
    final success = await backupService.saveBackupToDirectory(backupDir);
    if (success) {
      await NotificationService().showInstantBackupAndRestoreNotification(
        id: 201,
        title: 'Automatic Backup Complete',
        body: 'Your daily backup was created successfully.',
      );
    }
  } catch (e) {
    await NotificationService().showBackupErrorNotification('Automatic backup failed: $e');
  } finally {
    container.dispose();
  }
}
