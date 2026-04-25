import 'dart:ui';

import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:easy_tasbeeh/features/counter/widgets/counter_button.dart';
import 'package:flutter/material.dart';

class CounterPreview extends StatelessWidget {
  final String selectedBackground;
  final double backgroundOpacity;
  final int count;
  final PressButtonStyle previewStyle;
  final bool centerButton;
  final VoidCallback onTap;

  const CounterPreview({
    super.key,
    required this.selectedBackground,
    required this.backgroundOpacity,
    required this.count,
    required this.previewStyle,
    required this.centerButton,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.45, // Increased height for better visibility
      width: size.width * 0.6, // Slightly wider for better balance
      margin: const EdgeInsets.symmetric(horizontal: 24),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildBackground(),
          _buildBadge(),
          Positioned.fill(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: FittedBox(fit: BoxFit.scaleDown, child: _buildContent()),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: Builder(
          key: ValueKey(selectedBackground),
          builder: (context) {
            final colorScheme = Theme.of(context).colorScheme;
            return Container(
              decoration: BoxDecoration(
                color: selectedBackground.isEmpty ? colorScheme.surface : null,
                image: selectedBackground.isEmpty
                    ? null
                    : DecorationImage(
                        image: AssetImage(selectedBackground),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black.withValues(alpha: backgroundOpacity),
                          BlendMode.darken,
                        ),
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return Positioned(
      top: 12,
      right: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'PREVIEW',
          style: TextStyle(
            color: Colors.white,
            fontSize: 8,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final glassyContainer = ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'تقبل الله منا ومنكم',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'May Allah accept your dhikr',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    final button = SizedBox(
      width: 90,
      height: 90,
      child: CounterButton(onTap: onTap, previewStyle: previewStyle),
    );

    if (centerButton) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          button,
          const SizedBox(height: 24),
          glassyContainer,
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        glassyContainer,
        const SizedBox(height: 24),
        button,
      ],
    );
  }
}
