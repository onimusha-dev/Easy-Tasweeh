import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:easy_tasbeeh/core/constants/app_constants.dart';
import 'package:easy_tasbeeh/core/service/notification_service.dart';
import 'package:easy_tasbeeh/core/service/shared_preferences.dart';
import 'package:easy_tasbeeh/database/db.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// BackupService handles creating and restoring local backups.
/// It zips the SQLite database and SharedPreferences into a single file.
class BackupService {
  final AppDatabase db;

  BackupService(this.db);

  /// Get the path to the main database file
  Future<String> _getDatabasePath() async {
    final directory = await getApplicationSupportDirectory();
    return p.join(directory.path, 'easy_tasbeeh_db.sqlite');
  }

  /// Creates a ZIP file containing the database, preferences, and metadata.
  /// Returns the File object pointing to the ZIP in the temporary directory.
  Future<File?> _generateBackupZip() async {
    try {
      final dbPath = await _getDatabasePath();
      final dbFile = File(dbPath);

      if (!await dbFile.exists()) {
        debugPrint('Backup: Database file not found at $dbPath');
        return null;
      }

      final tempDir = await getTemporaryDirectory();
      final backupWorkDir = Directory(
        p.join(
          tempDir.path,
          'backup_work_${DateTime.now().millisecondsSinceEpoch}',
        ),
      );
      await backupWorkDir.create(recursive: true);

      final filesToZip = <String>[];

      // 1. Copy Database
      final dbBackupFile = await dbFile.copy(
        p.join(backupWorkDir.path, 'database.sqlite'),
      );
      filesToZip.add(dbBackupFile.path);

      // 2. Copy WAL/SHM sidecar files if they exist (important for SQLite consistency)
      final walFile = File('$dbPath-wal');
      if (await walFile.exists()) {
        final walBackup = await walFile.copy(
          p.join(backupWorkDir.path, 'database.sqlite-wal'),
        );
        filesToZip.add(walBackup.path);
      }

      final shmFile = File('$dbPath-shm');
      if (await shmFile.exists()) {
        final shmBackup = await shmFile.copy(
          p.join(backupWorkDir.path, 'database.sqlite-shm'),
        );
        filesToZip.add(shmBackup.path);
      }

      // 3. Export Preferences (SharedPreferences)
      final prefsJson = AppPreferences.exportToJson();
      final prefsFile = File(p.join(backupWorkDir.path, 'preferences.json'));
      await prefsFile.writeAsString(prefsJson);
      filesToZip.add(prefsFile.path);

      // 4. Create Metadata
      final metadata = {
        'app_name': AppConstants.appName,
        'backup_date': DateTime.now().toIso8601String(),
        'version': AppConstants.appVersion,
        'platform': defaultTargetPlatform.toString(),
      };
      final metadataFile = File(p.join(backupWorkDir.path, 'metadata.json'));
      await metadataFile.writeAsString(jsonEncode(metadata));
      filesToZip.add(metadataFile.path);

      // 5. ZIP everything
      final archive = Archive();
      for (final filePath in filesToZip) {
        final file = File(filePath);
        final bytes = await file.readAsBytes();
        archive.addFile(ArchiveFile(p.basename(filePath), bytes.length, bytes));
      }

      final zipData = ZipEncoder().encode(archive);

      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final zipPath = p.join(tempDir.path, 'EasyTasbeeh_Backup_$timestamp.zip');
      final zipFile = File(zipPath);
      await zipFile.writeAsBytes(zipData);

      // Cleanup work directory
      await backupWorkDir.delete(recursive: true);

      return zipFile;
    } catch (e) {
      debugPrint('Error generating backup zip: $e');
      return null;
    }
  }

  /// Create a backup and let the user pick a location to save it.
  Future<bool> createAndSaveBackup() async {
    final zipFile = await _generateBackupZip();
    if (zipFile == null) return false;

    try {
      final fileName = p.basename(zipFile.path);
      final bytes = await zipFile.readAsBytes();

      // Open "Save As" dialog to let the user pick a location and name
      final String? outputFile = await FilePicker.platform.saveFile(
        dialogTitle: 'Save Backup',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: ['zip'],
        bytes: bytes,
      );

      if (outputFile == null) {
        debugPrint('Backup save cancelled by user');
        return false;
      }

      debugPrint('Backup saved to: $outputFile');
      await NotificationService().showBackupSuccessNotification();
      return true;
    } catch (e) {
      debugPrint('Error saving backup: $e');
      await NotificationService().showBackupErrorNotification(e.toString());
      return false;
    }
  }

  /// Create a backup and save it to a specific directory (for automatic backups).
  Future<bool> saveBackupToDirectory(String directoryPath) async {
    final zipFile = await _generateBackupZip();
    if (zipFile == null) return false;

    try {
      final targetPath = p.join(directoryPath, p.basename(zipFile.path));
      await zipFile.copy(targetPath);
      return true;
    } catch (e) {
      debugPrint('Error saving backup to directory: $e');
      return false;
    }
  }

  /// Pick a backup ZIP file and restore data from it.
  Future<bool> restoreBackup() async {
    Directory? restoreDir;
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
        withData: true, // Important for some platforms
      );

      if (result == null || result.files.isEmpty) {
        debugPrint('Restore: No file selected');
        return false;
      }

      final pickedFile = result.files.single;
      final Uint8List bytes;

      if (pickedFile.bytes != null) {
        bytes = pickedFile.bytes!;
      } else if (pickedFile.path != null) {
        bytes = await File(pickedFile.path!).readAsBytes();
      } else {
        debugPrint('Restore: Could not read file data');
        return false;
      }

      final archive = ZipDecoder().decodeBytes(bytes);

      final tempDir = await getTemporaryDirectory();
      restoreDir = Directory(
        p.join(
          tempDir.path,
          'restore_${DateTime.now().millisecondsSinceEpoch}',
        ),
      );
      await restoreDir.create(recursive: true);

      // 1. Extract files
      for (final file in archive) {
        if (file.isFile) {
          final data = file.content as List<int>;
          final outFile = File(p.join(restoreDir.path, file.name));
          await outFile.writeAsBytes(data);
        }
      }

      // 2. Validate Metadata
      final metadataFile = File(p.join(restoreDir.path, 'metadata.json'));
      if (!await metadataFile.exists()) {
        debugPrint('Restore: metadata.json missing in backup');
        await restoreDir.delete(recursive: true);
        return false;
      }

      final metadata = jsonDecode(await metadataFile.readAsString());
      if (metadata['app_name'] != AppConstants.appName) {
        debugPrint(
          'Restore: Invalid app name in metadata: ${metadata['app_name']}',
        );
        await restoreDir.delete(recursive: true);
        return false;
      }

      // 3. Restore Preferences
      final prefsFile = File(p.join(restoreDir.path, 'preferences.json'));
      if (await prefsFile.exists()) {
        final prefsJson = await prefsFile.readAsString();
        await AppPreferences.importFromJson(prefsJson);
      }

      // 4. Restore Database
      final backupDbFile = File(p.join(restoreDir.path, 'database.sqlite'));
      if (await backupDbFile.exists()) {
        await db.close();
        await Future.delayed(const Duration(milliseconds: 600));

        final dbPath = await _getDatabasePath();
        final currentDb = File(dbPath);

        // Ensure parent directory exists
        await Directory(p.dirname(dbPath)).create(recursive: true);

        if (await currentDb.exists()) {
          await currentDb.delete();
        }

        // Clear sidecars
        final walFile = File('$dbPath-wal');
        if (await walFile.exists()) await walFile.delete();
        final shmFile = File('$dbPath-shm');
        if (await shmFile.exists()) await shmFile.delete();

        // Copy new database
        await backupDbFile.copy(dbPath);

        // Restore sidecars if present
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

        debugPrint('Restore: Database files restored successfully');
      }
      await NotificationService().showRestoreSuccessNotification();
      await restoreDir.delete(recursive: true);
      return true;
    } catch (e) {
      debugPrint('Error during restore: $e');
      await NotificationService().showRestoreErrorNotification(e.toString());
      if (restoreDir != null && await restoreDir.exists()) {
        try {
          await restoreDir.delete(recursive: true);
        } catch (_) {}
      }
      return false;
    }
  }

  /// Select a directory using the system picker
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

  /// Data Management Helpers
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
        buffer.writeln(
          '${h.id},"${h.dhikrId}",${h.currentCount},${h.targetCount},"${h.createdAt}"',
        );
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

/// Provider for BackupService (Manual definition to avoid .g.dart)
final backupServiceProvider = Provider<BackupService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return BackupService(db);
});

/// Static method for Workmanager background task
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
    debugPrint('Background backup failed: $e');
    await NotificationService().showBackupErrorNotification(
      'Automatic backup failed: $e',
    );
  } finally {
    container.dispose();
  }
}
