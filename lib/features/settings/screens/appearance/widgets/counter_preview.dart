import 'package:easy_tasweeh/core/service/settings_provider.dart';
import 'package:easy_tasweeh/features/counter/widgets/counter_button.dart';
import 'package:flutter/material.dart';

class CounterPreview extends StatelessWidget {
  final String selectedBackground;
  final double backgroundOpacity;
  final int count;
  final PressButtonStyle previewStyle;
  final VoidCallback onTap;

  const CounterPreview({
    super.key,
    required this.selectedBackground,
    required this.backgroundOpacity,
    required this.count,
    required this.previewStyle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.35, // Reduced from 0.45 to prevent overflow
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
          Padding(
            padding: const EdgeInsets.all(12),
            child: FittedBox(fit: BoxFit.scaleDown, child: _buildContent()),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 44),
        Text(
          '$count',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w900,
          ),
        ),
        const Text(
          'تقبل الله منا ومنكم',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w300,
          ),
        ),
        Text(
          'May Allah accept your dhikr',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 12,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 44),
        SizedBox(
          width: 100,
          height: 100,
          child: CounterButton(onTap: onTap, previewStyle: previewStyle),
        ),
      ],
    );
  }
}
