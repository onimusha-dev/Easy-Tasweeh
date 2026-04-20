import 'package:easy_tasweeh/core/widgets/premium_dialog.dart';
import 'package:easy_tasweeh/features/settings/widgets/settings_tiles.dart';
import 'package:flutter/material.dart';

class DataScreen extends StatelessWidget {
  const DataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Data', style: Theme.of(context).textTheme.titleMedium),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          const SizedBox(height: 8),
          buildSettingsGroup(
            context,
            children: [
              buildSettingTile(
                context,
                icon: Icons.delete_sweep_rounded,
                title: 'Reset all data',
                subtitle: 'Clear history and preferences',
                iconColor: Colors.red,
                onTap: () => _confirmReset(context),
                showChevron: false,
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => PremiumDialog(
        icon: Icons.delete_sweep_rounded,
        title: 'Reset all data?',
        description:
            'This will permanently delete your session history and reset all preferences. This cannot be undone.',
        confirmLabel: 'Reset',
        color: Theme.of(context).colorScheme.error,
        onConfirm: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('All data cleared.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }
}
