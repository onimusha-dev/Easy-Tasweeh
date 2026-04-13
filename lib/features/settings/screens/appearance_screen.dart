import 'package:easy_tasweeh/core/service/settings_provider.dart';
import 'package:easy_tasweeh/features/settings/widgets/settings_tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppearanceScreen extends ConsumerWidget {
  const AppearanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Appearance',
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
            icon: Icons.brightness_6_outlined,
            title: 'Theme',
            subtitle: 'Light, Dark, or follow system',
            trailingLabel: 'System',
            onTap: () {},
          ),
          buildSettingTile(
            context,
            icon: Icons.color_lens_outlined,
            title: 'Accent colour',
            subtitle: 'Choose your app highlight colour',
            trailing: _ColourDot(),
            onTap: () {},
          ),
          buildSettingTile(
            context,
            icon: Icons.touch_app_outlined,
            title: 'Counter style',
            subtitle: 'Circle, minimal, or full screen tap',
            trailingLabel: 'Circle',
            onTap: () {},
          ),
          buildSettingTile(
            context,
            icon: Icons.text_fields_rounded,
            title: 'Font size',
            subtitle: 'Adjust counter number size',
            trailingLabel: 'Medium',
            onTap: () {},
          ),
          buildSettingTile(
            context,
            icon: Icons.screen_lock_portrait_outlined,
            title: 'Keep screen on',
            subtitle: 'Prevent sleep while counting',
            trailing: Switch(
              value: settings.keepScreenOn,
              onChanged: (v) => notifier.toggleKeepScreenOn(v),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
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
