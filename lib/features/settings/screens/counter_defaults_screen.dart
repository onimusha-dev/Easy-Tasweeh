import 'package:easy_tasweeh/core/service/settings_provider.dart';
import 'package:easy_tasweeh/features/settings/widgets/settings_tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CounterDefaultsScreen extends ConsumerWidget {
  const CounterDefaultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Counter Defaults',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          const SizedBox(height: 8),
          buildSettingTile(
            context,
            icon: Icons.gps_fixed_rounded,
            title: 'Default goal',
            subtitle: 'Starting goal for new sessions',
            trailingLabel: '33',
            onTap: () {},
          ),
          buildSettingTile(
            context,
            icon: Icons.refresh_rounded,
            title: 'Auto-reset on goal',
            subtitle: 'Reset and track rounds',
            trailing: Switch(
              value: settings.autoResetOnGoal,
              onChanged: (v) => notifier.toggleAutoResetOnGoal(v),
            ),
          ),
          buildSettingTile(
            context,
            icon: Icons.format_list_bulleted_rounded,
            title: 'Default dhikr',
            subtitle: 'Pre-select dhikr on app open',
            trailingLabel: 'SubhanAllah',
            onTap: () {},
          ),
          buildSettingTile(
            context,
            icon: Icons.history_rounded,
            title: 'Resume last session',
            subtitle: 'Continue where you left off',
            trailing: Switch(
              value: settings.resumeLastSession,
              onChanged: (v) => notifier.toggleResumeLastSession(v),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
