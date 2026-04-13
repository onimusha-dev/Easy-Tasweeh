import 'package:easy_tasweeh/core/service/settings_provider.dart';
import 'package:easy_tasweeh/features/settings/widgets/settings_tiles.dart';
import 'package:easy_tasweeh/features/settings/widgets/vibration_intensity_tile.dart';
import 'package:flutter/material.dart';
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
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          const SizedBox(height: 8),

          // ── Sound ──────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 6),
            child: buildSectionTitle(context, 'SOUND'),
          ),
          buildSettingTile(
            context,
            icon: Icons.volume_up_outlined,
            title: 'Tap sound',
            subtitle: 'Play a soft click on each count',
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
            trailing: Switch(
              value: settings.goalReachedSound,
              onChanged: (v) => notifier.toggleGoalReachedSound(v),
            ),
          ),

          // ── Haptics ────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 6),
            child: buildSectionTitle(context, 'HAPTICS'),
          ),
          buildSettingTile(
            context,
            icon: Icons.vibration_rounded,
            title: 'Haptic feedback',
            subtitle: 'Vibrate on each tap',
            trailing: Switch(
              value: settings.hapticEnabled,
              onChanged: (v) => notifier.toggleHaptic(v),
            ),
          ),

          // Intensity sliders — shown only when haptic is on
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: settings.hapticEnabled
                ? Column(
                    key: const ValueKey('haptic_on'),
                    children: [
                      buildSettingTile(
                        context,
                        icon: Icons.electric_bolt_outlined,
                        title: 'Haptic intensity',
                        subtitle: 'Light, medium, or strong',
                        trailingLabel: _intensityLabel(
                          settings.vibrationAmplitude,
                        ),
                        onTap: () {},
                      ),
                      VibrationIntensityTile(
                        label: 'TAP INTENSITY',
                        subtitle: 'Strength of each dhikr tap vibration',
                        icon: Icons.touch_app_rounded,
                        value: settings.vibrationAmplitude,
                        onChanged: (v) => notifier.setVibrationAmplitude(v),
                        onChangedEnd: (v) async {
                          if (await Vibration.hasVibrator()) {
                            Vibration.vibrate(duration: 60, amplitude: v);
                          }
                        },
                      ),
                      VibrationIntensityTile(
                        label: 'COMPLETION INTENSITY',
                        subtitle: 'Strength when a target is reached',
                        icon: Icons.flag_rounded,
                        value: settings.completionVibrationAmplitude,
                        onChanged: (v) =>
                            notifier.setCompletionVibrationAmplitude(v),
                        onChangedEnd: (v) async {
                          if (await Vibration.hasVibrator()) {
                            Vibration.vibrate(duration: 300, amplitude: v);
                          }
                        },
                      ),
                    ],
                  )
                : const SizedBox.shrink(key: ValueKey('haptic_off')),
          ),

          buildSettingTile(
            context,
            icon: Icons.pattern_outlined,
            title: 'Goal haptic pattern',
            subtitle: 'Special pulse when goal reached',
            trailing: Switch(
              value: settings.goalHapticPattern,
              onChanged: (v) => notifier.toggleGoalHapticPattern(v),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  String _intensityLabel(int amplitude) {
    if (amplitude <= 64) return 'Light';
    if (amplitude <= 150) return 'Medium';
    if (amplitude <= 210) return 'Strong';
    return 'Max';
  }
}
