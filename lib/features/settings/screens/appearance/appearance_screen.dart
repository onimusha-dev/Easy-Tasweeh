import 'package:easy_tasweeh/core/service/settings_provider.dart';
import 'package:easy_tasweeh/core/theme/theme.dart';
import 'package:easy_tasweeh/features/settings/screens/appearance/bg_changer_preview_screen.dart';
import 'package:easy_tasweeh/features/settings/screens/appearance/press_btn_changer_preview_screen.dart';
import 'package:easy_tasweeh/features/settings/widgets/settings_tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Appearance',
          style: Theme.of(context).textTheme.titleMedium,
        ),
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
                icon: Icons.color_lens_outlined,
                title: 'Accent colour',
                subtitle: 'Choose your app\'s color scheme',
                iconColor: AppIconColors.pink(context),
                trailing: const _ColourDot(),
                onTap: () => _showColorSchemeDialog(context, ref),
                showChevron: false,
              ),
              buildSettingTile(
                context,
                icon: Icons.brightness_6_outlined,
                title: 'Theme',
                subtitle: 'Light, Dark, System',
                iconColor: AppIconColors.purple(context),
                onTap: () => _showThemeDialog(context, ref),
                showChevron: false,
              ),
            ],
          ),

          const SizedBox(height: 16),

          buildSettingsGroup(
            context,
            children: [
              buildSettingTile(
                context,
                icon: Icons.touch_app_outlined,
                title: 'Counter style',
                subtitle: 'Circle, minimal, or full screen tap',
                iconColor: AppIconColors.teal(context),
                onTap: () =>
                    _push(context, const PressBtnChangerPreviewScreen()),
              ),
              buildSettingTile(
                context,
                icon: Icons.wallpaper_outlined,
                title: 'Counter background',
                subtitle: 'Choose your counter background',
                iconColor: AppIconColors.blue(context),
                onTap: () => _push(context, const BgChangerPreviewScreen()),
              ),
              buildSettingTile(
                context,
                icon: Icons.auto_awesome_outlined,
                title: 'Particle effect',
                subtitle: 'Enable floating background particles',
                iconColor: AppIconColors.teal(context),
                trailing: Switch(
                  value: ref.watch(settingsProvider).showParticles,
                  onChanged: (v) => ref
                      .read(settingsProvider.notifier)
                      .toggleShowParticles(v),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          buildSettingsGroup(
            context,
            title: 'SIZE',
            children: [
              buildSettingTile(
                context,
                icon: Icons.photo_size_select_small_rounded,
                title: 'Button size',
                subtitle:
                    'Current: ${ref.watch(settingsProvider).buttonSize.toInt()}px',
                iconColor: AppIconColors.pink(context),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(56, 0, 16, 16),
                child: Slider(
                  value: ref.watch(settingsProvider).buttonSize,
                  min: 150,
                  max: 320,
                  divisions: 17,
                  onChanged: (v) =>
                      ref.read(settingsProvider.notifier).setButtonSize(v),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('Select Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ThemeMode.values.map((mode) {
            return RadioListTile<ThemeMode>(
              title: Text(mode.name.toUpperCase()),
              value: mode,
              groupValue: ref.watch(settingsProvider).themeMode,
              onChanged: (v) {
                if (v != null) {
                  ref.read(settingsProvider.notifier).setThemeMode(v);
                }
                Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showColorSchemeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        final current = ref.watch(settingsProvider).colorScheme;
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Text('Select Accent'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppColorScheme.values.map((scheme) {
              return RadioListTile<AppColorScheme>(
                title: Text(scheme.name.toUpperCase()),
                value: scheme,
                groupValue: current,
                onChanged: (v) {
                  if (v != null) {
                    ref.read(settingsProvider.notifier).setColorScheme(v);
                  }
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _ColourDot extends StatelessWidget {
  const _ColourDot();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.circle,
      ),
    );
  }
}
