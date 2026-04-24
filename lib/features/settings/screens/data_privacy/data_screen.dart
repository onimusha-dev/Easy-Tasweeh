import 'package:easy_tasbeeh/core/service/backup_service.dart';
import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:easy_tasbeeh/core/theme/schemes/app_colors.dart';
import 'package:easy_tasbeeh/core/widgets/premium_dialog.dart';
import 'package:easy_tasbeeh/features/settings/widgets/settings_tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DataPrivacyScreen extends ConsumerWidget {
  const DataPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Data & Privacy',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          const SizedBox(height: 8),

          const SizedBox(height: 8),

          buildSettingsGroup(
            context,
            title: 'Backup & Restore',
            children: [
              buildSettingTile(
                context,
                icon: Icons.upload_rounded,
                title: 'Export Backup',
                subtitle: 'Share or save settings and history to a file',
                iconColor: Colors.blue,
                onTap: () => _handleExport(context, ref),
              ),
              buildSettingTile(
                context,
                icon: Icons.download_rounded,
                title: 'Restore Backup',
                subtitle: 'Restore from a previously saved file',
                iconColor: Colors.orange,
                onTap: () => _handleRestore(context, ref),
              ),
            ],
          ),

          const SizedBox(height: 16),

          buildSettingsGroup(
            context,
            title: 'Data Portability',
            children: [
              buildSettingTile(
                context,
                icon: Icons.table_chart_outlined,
                title: 'Export History (CSV)',
                subtitle: 'View your data in Excel or other apps',
                iconColor: Colors.green,
                onTap: () => _handleCSVExport(context, ref),
              ),
            ],
          ),

          const SizedBox(height: 16),

          buildSettingsGroup(
            context,
            title: 'Automatic Backup',
            children: [
              buildSettingTile(
                context,
                icon: Icons.folder_open_rounded,
                title: 'Backup Location',
                subtitle:
                    ref.watch(settingsProvider).backupDirectory ??
                    'No location selected',
                iconColor: AppIconColors.sage(context),
                onTap: () => _selectDirectory(context, ref),
              ),
              buildSettingTile(
                context,
                icon: Icons.history_rounded,
                title: 'Daily Auto-Backup',
                subtitle: 'Back up your data every 24 hours',
                iconColor: Colors.indigo,
                trailing: Switch(
                  value: ref.watch(settingsProvider).periodicBackupEnabled,
                  onChanged: (v) {
                    if (ref.read(settingsProvider).backupDirectory == null &&
                        v) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please select a backup location first',
                          ),
                        ),
                      );
                      return;
                    }
                    ref.read(settingsProvider.notifier).togglePeriodicBackup(v);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          buildSettingsGroup(
            context,
            title: 'Danger Zone',
            children: [
              buildSettingTile(
                context,
                icon: Icons.history_toggle_off_rounded,
                title: 'Clear session history',
                subtitle: 'Deletes all history but keeps settings',
                iconColor: Colors.orange,
                onTap: () => _confirmClearHistory(context, ref),
                showChevron: false,
              ),
              buildSettingTile(
                context,
                icon: Icons.delete_sweep_rounded,
                title: 'Reset all data',
                subtitle: 'Clear history and preferences',
                iconColor: Colors.red,
                onTap: () => _confirmReset(context, ref),
                showChevron: false,
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Future<void> _handleExport(BuildContext context, WidgetRef ref) async {
    try {
      final success = await ref
          .read(backupServiceProvider.notifier)
          .exportBackup();
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Backup exported successfully!')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Export failed: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _handleRestore(BuildContext context, WidgetRef ref) async {
    // Warn the user first
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => PremiumDialog(
        icon: Icons.download_rounded,
        title: 'Restore Backup?',
        description:
            'This will overwrite your current data and settings. '
            'The app will restart afterwards. Continue?',
        confirmLabel: 'Continue',
        color: Colors.orange,
        onConfirm: () => Navigator.of(ctx).pop(true),
      ),
    );
    if (confirmed != true) return;

    try {
      final success = await ref
          .read(backupServiceProvider.notifier)
          .restoreBackup();
      if (success && context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => PremiumDialog(
            icon: Icons.restart_alt_rounded,
            title: 'Restore Complete',
            description: 'The app needs to restart to apply the changes.',
            confirmLabel: 'Restart Now',
            color: Colors.green,
            onConfirm: () => Phoenix.rebirth(context),
          ),
        );
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Restore cancelled or failed.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Restore failed: $e')));
      }
    }
  }

  Future<void> _handleCSVExport(BuildContext context, WidgetRef ref) async {
    try {
      final success = await ref
          .read(backupServiceProvider.notifier)
          .exportHistoryToCSV();
      if (!success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No history data to export')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('CSV Export failed: $e')));
      }
    }
  }

  Future<void> _selectDirectory(BuildContext context, WidgetRef ref) async {
    try {
      final path = await ref
          .read(backupServiceProvider.notifier)
          .selectBackupDirectory();
      if (path != null) {
        await ref.read(settingsProvider.notifier).setBackupDirectory(path);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to select directory: $e')),
        );
      }
    }
  }

  void _confirmClearHistory(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => PremiumDialog(
        icon: Icons.history_toggle_off_rounded,
        title: 'Clear history?',
        description:
            'This will permanently delete all your past tasbeeh records. Your settings will be preserved.',
        confirmLabel: 'Clear',
        color: Colors.orange,
        onConfirm: () async {
          try {
            await ref.read(backupServiceProvider.notifier).clearHistoryOnly();
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('History cleared.')));
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to clear history: $e')),
              );
            }
          }
        },
      ),
    );
  }

  void _confirmReset(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (_) => PremiumDialog(
        icon: Icons.delete_sweep_rounded,
        title: 'Reset all data?',
        description:
            'This will permanently delete your session history and reset all preferences. This cannot be undone.',
        confirmLabel: 'Reset',
        color: Theme.of(context).colorScheme.error,
        onConfirm: () async {
          try {
            await ref.read(backupServiceProvider.notifier).clearAllData();
            if (context.mounted) {
              Phoenix.rebirth(context);
            }
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to clear data: $e')),
              );
            }
          }
        },
      ),
    );
  }
}

enum _ExportAction { share, saveToFolder }

// ignore: unused_element
class _ExportOptionsSheet extends StatelessWidget {
  const _ExportOptionsSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Export Backup',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.share_rounded),
              title: const Text('Share'),
              subtitle: const Text('Send via email, cloud, messaging, etc.'),
              onTap: () => Navigator.pop(context, _ExportAction.share),
            ),
            ListTile(
              leading: const Icon(Icons.save_alt_rounded),
              title: const Text('Save to Folder'),
              subtitle: const Text('Choose a folder on this device'),
              onTap: () => Navigator.pop(context, _ExportAction.saveToFolder),
            ),
          ],
        ),
      ),
    );
  }
}
