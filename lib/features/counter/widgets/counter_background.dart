import 'package:easy_tasbeeh/core/service/settings/settings_state.dart';
import 'package:easy_tasbeeh/features/counter/widgets/particle_background.dart';
import 'package:flutter/material.dart';

class CounterBackground extends StatelessWidget {
  final SettingsState settings;
  final Widget child;

  const CounterBackground({
    super.key,
    required this.settings,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: settings.background.isEmpty ? colorScheme.surface : null,
        image: settings.background.isEmpty
            ? null
            : DecorationImage(
                image: AssetImage(settings.background),
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: settings.backgroundOpacity),
                  BlendMode.darken,
                ),
                fit: BoxFit.cover,
              ),
      ),
      child: Stack(
        children: [
          if (settings.showParticles)
            const Positioned.fill(child: ParticleBackground()),
          child,
        ],
      ),
    );
  }
}
