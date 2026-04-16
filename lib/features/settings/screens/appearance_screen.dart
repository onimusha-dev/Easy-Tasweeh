import 'package:easy_tasweeh/core/service/settings_provider.dart';
import 'package:easy_tasweeh/core/theme/theme.dart';
import 'package:easy_tasweeh/features/settings/widgets/settings_tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final settings = ref.watch(settingsProvider);
    // final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Appearance',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          const SizedBox(height: 8),
          buildSettingTile(
            context,
            icon: Icons.color_lens_outlined,
            title: 'Accent colour',
            subtitle: 'Choose your app\'s color scheme',
            iconColor: AppIconColors.pink(context),
            trailing: _ColourDot(),
            onTap: () => _showColorSchemeDialog(context, ref),
          ),
          buildSettingTile(
            context,
            icon: Icons.brightness_6_outlined,
            title: 'Theme',
            subtitle: 'Light, Dark, System',
            iconColor: AppIconColors.purple(context),
            onTap: () => _showThemeDialog(context, ref),
          ),
          buildSettingTile(
            context,
            icon: Icons.touch_app_outlined,
            title: 'Counter style',
            subtitle: 'Circle, minimal, or full screen tap',
            iconColor: AppIconColors.teal(context),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Counter styles coming soon!')),
              );
            },
          ),
          buildSettingTile(
            context,
            icon: Icons.wallpaper_outlined,
            title: 'Counter background',
            subtitle: 'Choose your counter background',
            iconColor: AppIconColors.blue(context),
            onTap: () {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Counter backgrounds coming soon!'),
                ),
              );
            },
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showThemeDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
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
