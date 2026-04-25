import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:easy_tasbeeh/core/constants/app_constants.dart';
import 'package:easy_tasbeeh/core/service/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class BackupEngine {
  static Future<String> getDatabasePath() async {
    final directory = await getApplicationSupportDirectory();
    return p.join(directory.path, 'easy_tasbeeh_db.sqlite');
  }

  static Future<File?> generateBackupZip() async {
    try {
      final dbPath = await getDatabasePath();
      final dbFile = File(dbPath);

      if (!await dbFile.exists()) return null;

      final tempDir = await getTemporaryDirectory();
      final backupWorkDir = Directory(
        p.join(
          tempDir.path,
          'backup_work_${DateTime.now().millisecondsSinceEpoch}',
        ),
      );
      await backupWorkDir.create(recursive: true);

      final filesToZip = <String>[];

      // Copy Database & Sidecars
      final dbBackup = await dbFile.copy(
        p.join(backupWorkDir.path, 'database.sqlite'),
      );
      filesToZip.add(dbBackup.path);

      for (var ext in ['-wal', '-shm']) {
        final sidecar = File('$dbPath$ext');
        if (await sidecar.exists()) {
          final sidecarBackup = await sidecar.copy(
            p.join(backupWorkDir.path, 'database.sqlite$ext'),
          );
          filesToZip.add(sidecarBackup.path);
        }
      }

      // Export Preferences
      final prefsJson = AppPreferences.exportToJson();
      final prefsFile = File(p.join(backupWorkDir.path, 'preferences.json'));
      await prefsFile.writeAsString(prefsJson);
      filesToZip.add(prefsFile.path);

      // Metadata
      final packageInfo = await PackageInfo.fromPlatform();
      final metadata = {
        'app_name': AppConstants.appName,
        'backup_date': DateTime.now().toIso8601String(),
        'version': packageInfo.version,
        'platform': defaultTargetPlatform.toString(),
      };
      final metadataFile = File(p.join(backupWorkDir.path, 'metadata.json'));
      await metadataFile.writeAsString(jsonEncode(metadata));
      filesToZip.add(metadataFile.path);

      // ZIP
      final archive = Archive();
      for (final filePath in filesToZip) {
        final file = File(filePath);
        final bytes = await file.readAsBytes();
        archive.addFile(ArchiveFile(p.basename(filePath), bytes.length, bytes));
      }

      final zipData = ZipEncoder().encode(archive);
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final zipFile = File(
        p.join(tempDir.path, 'EasyTasbeeh_Backup_$timestamp.zip'),
      );
      await zipFile.writeAsBytes(zipData);

      await backupWorkDir.delete(recursive: true);
      return zipFile;
    } catch (e) {
      debugPrint('BackupEngine Error: $e');
      return null;
    }
  }
}
