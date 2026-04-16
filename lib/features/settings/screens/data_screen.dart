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
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          const SizedBox(height: 8),
          buildSettingTile(
            context,
            icon: Icons.delete_sweep_rounded,
            title: 'Reset all data',
            subtitle: 'Clear history and preferences',
            iconColor: Colors.red,
            onTap: () => _confirmReset(context),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

Future<void> _confirmReset(BuildContext context) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Reset all data?'),
      content: const Text(
        'This will permanently delete your session history and reset all preferences. This cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, true),
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(ctx).colorScheme.error,
          ),
          child: const Text('Reset'),
        ),
      ],
    ),
  );
  if (confirmed == true && context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All data cleared.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
