import 'package:easy_tasweeh/core/service/settings_provider.dart';
import 'package:easy_tasweeh/core/theme/theme.dart';
import 'package:easy_tasweeh/features/settings/widgets/settings_tiles.dart';
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
            title: 'SOUND',
            children: [
              buildSettingTile(
                context,
                icon: Icons.volume_up_outlined,
                title: 'Tap sound',
                subtitle: 'Play a soft click on each count',
                iconColor: AppIconColors.amber(context),
                trailing: Switch(
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
                trailing: Switch(
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
            title: 'HAPTICS',
            children: [
              buildSettingTile(
                context,
                icon: Icons.vibration_rounded,
                title: 'Haptic feedback',
                subtitle: 'Vibrate on each tap',
                iconColor: AppIconColors.amber(context),
                trailing: Switch(
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
                trailing: Switch(
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
            title: 'BEHAVIOR',
            children: [
              buildSettingTile(
                context,
                icon: Icons.timer_outlined,
                title: 'Tap freeze',
                subtitle: 'Prevent accidental rapid tapping',
                iconColor: Colors.blueGrey,
                trailing: Switch(
                  value: settings.tapFreezeEnabled,
                  onChanged: (v) => notifier.toggleTapFreeze(v),
                ),
              ),
              if (settings.tapFreezeEnabled)
                buildSettingTile(
                  context,
                  icon: Icons.speed_rounded,
                  title: 'Freeze duration',
                  subtitle: 'Delay: ${settings.tapFreezeDuration} ms',
                  iconColor: Colors.teal,
                  onTap: () => _showFreezeDurationDialog(context, ref),
                  showChevron: false,
                ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Milestones Section ──────────────────────────────────────────
          buildSettingsGroup(
            context,
            title: 'MILESTONES',
            children: [
              buildSettingTile(
                context,
                icon: Icons.repeat_rounded,
                title: 'Vibrate on milestone',
                subtitle: 'Vibrate every X counts',
                iconColor: AppIconColors.blue(context),
                trailing: Switch(
                  value: settings.vibrateOnMilestone,
                  onChanged: (v) => notifier.toggleVibrateOnMilestone(v),
                ),
              ),
              if (settings.vibrateOnMilestone)
                buildSettingTile(
                  context,
                  icon: Icons.numbers_rounded,
                  title: 'Milestone value',
                  subtitle: 'Current: every ${settings.milestoneValue} counts',
                  iconColor: AppIconColors.purple(context),
                  onTap: () => _showMilestoneDialog(context, ref),
                  showChevron: false,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
