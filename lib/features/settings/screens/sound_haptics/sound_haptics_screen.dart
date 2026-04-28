import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:easy_tasbeeh/core/widgets/app_switch.dart';
import 'package:easy_tasbeeh/core/theme/theme.dart';
import 'package:easy_tasbeeh/features/settings/widgets/setting_chip.dart';
import 'package:easy_tasbeeh/features/settings/widgets/settings_tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';

class SoundHapticsScreen extends ConsumerWidget {
  const SoundHapticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sound & Haptics',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          // ── Sound Section ────────────────────────────────────────────────
          buildSettingsGroup(
            context,
            title: 'Sound',
            children: [
              buildSettingTile(
                context,
                icon: Icons.volume_up_outlined,
                title: 'Tap sound',
                subtitle: 'Play a soft click on each count',
                iconColor: AppIconColors.amber(context),
                trailing: AppSwitch(
                  value: settings.tapSound,
                  onChanged: (v) => notifier.toggleTapSound(v),
                ),
              ),
              buildSettingTile(
                context,
                icon: Icons.music_note_outlined,
                title: 'Goal reached sound',
                subtitle: 'Play a tone when target is hit',
                iconColor: AppIconColors.coral(context),
                trailing: AppSwitch(
                  value: settings.goalReachedSound,
                  onChanged: (v) => notifier.toggleGoalReachedSound(v),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Haptics Section ──────────────────────────────────────────────
          buildSettingsGroup(
            context,
            title: 'Haptics',
            children: [
              buildSettingTile(
                context,
                icon: Icons.vibration_rounded,
                title: 'Haptic feedback',
                subtitle: 'Vibrate on each tap',
                iconColor: AppIconColors.amber(context),
                trailing: AppSwitch(
                  value: settings.hapticEnabled,
                  onChanged: (v) {
                    notifier.toggleHaptic(v);
                    if (v) {
                      HapticFeedback.selectionClick();
                      Vibration.vibrate(duration: 20);
                    }
                  },
                ),
              ),
              buildSettingTile(
                context,
                icon: Icons.pattern_outlined,
                title: 'Goal haptic pattern',
                subtitle: 'Special pulse when goal reached',
                iconColor: AppIconColors.coral(context),
                trailing: AppSwitch(
                  value: settings.goalHapticPattern,
                  onChanged: (v) => notifier.toggleGoalHapticPattern(v),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const SizedBox(height: 16),

          // ── Behavior Section ─────────────────────────────────────────────
          buildSettingsGroup(
            context,
            title: 'Behavior',
            children: [
              buildTwoPartSettingTile(
                context,
                icon: Icons.speed_rounded,
                title: 'Freeze duration',
                subtitle: 'Prevent accidental rapid tapping',
                iconColor: AppIconColors.sage(context),
                action: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SettingChip(
                      label: '${settings.tapFreezeDuration} ms',
                      enabled: settings.tapFreezeEnabled,
                      onTap: () => _showFreezeDurationDialog(context, ref),
                    ),
                    AppSwitch(
                      value: settings.tapFreezeEnabled,
                      onChanged: (v) => notifier.toggleTapFreeze(v),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Milestones Section ──────────────────────────────────────────
          buildSettingsGroup(
            context,
            title: 'Milestones',
            children: [
              buildTwoPartSettingTile(
                context,
                icon: Icons.repeat_rounded,
                title: 'Milestone vibration',
                subtitle: 'Vibrate every X counts',
                iconColor: AppIconColors.blue(context),
                action: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SettingChip(
                      label: '${settings.milestoneValue}',
                      enabled: settings.vibrateOnMilestone,
                      onTap: () => _showMilestoneDialog(context, ref),
                    ),
                    AppSwitch(
                      value: settings.vibrateOnMilestone,
                      onChanged: (v) => notifier.toggleVibrateOnMilestone(v),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showFreezeDurationDialog(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(settingsProvider.notifier);
    final current = ref.watch(settingsProvider).tapFreezeDuration;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Delay'),
        content: RadioGroup<int>(
          groupValue: current,
          onChanged: (v) {
            if (v != null) {
              notifier.setTapFreezeDuration(v);
            }
            Navigator.pop(context);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [50, 100, 150, 200, 300, 500].map((val) {
              return RadioListTile<int>(
                title: Text('$val ms'),
                value: val,
                activeColor: Theme.of(context).colorScheme.primary,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showMilestoneDialog(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(settingsProvider.notifier);
    final current = ref.watch(settingsProvider).milestoneValue;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Milestone'),
        content: RadioGroup<int>(
          groupValue: current,
          onChanged: (v) {
            if (v != null) {
              notifier.setMilestoneValue(v);
              // Preview haptic + vibration
              HapticFeedback.mediumImpact();
              Vibration.vibrate(duration: 60);
            }
            Navigator.pop(context);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [33, 100, 1000].map((val) {
              return RadioListTile<int>(
                title: Text('Every $val counts'),
                value: val,
                activeColor: Theme.of(context).colorScheme.primary,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}


