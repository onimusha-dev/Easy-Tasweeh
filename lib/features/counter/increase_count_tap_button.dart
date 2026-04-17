import 'dart:math' as math;

import 'package:easy_tasweeh/core/service/settings_provider.dart';
import 'package:easy_tasweeh/features/counter_btn_style/counter_button_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class IncreaseCountTapButton extends ConsumerStatefulWidget {
  final VoidCallback? onTap;
  final VoidCallback? onTapDown;
  final PressButtonStyle? previewStyle;

  const IncreaseCountTapButton({
    super.key,
    required this.onTap,
    this.onTapDown,
    this.previewStyle,
  });

  @override
  ConsumerState<IncreaseCountTapButton> createState() =>
      _IncreaseCountTapButtonState();
}

class _IncreaseCountTapButtonState extends ConsumerState<IncreaseCountTapButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _rippleController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
    _rippleController.forward(from: 0.0);
    widget.onTapDown?.call();
  }

  void _handleTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  void _handleTapCancel() {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final bool isFrozen = widget.onTap == null;
    final settings = ref.watch(settingsProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final activeStyle = widget.previewStyle ?? settings.pressButtonStyle;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: isFrozen ? null : _handleTapDown,
      onTapUp: isFrozen ? null : _handleTapUp,
      onTapCancel: isFrozen ? null : _handleTapCancel,
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 0.92).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            alignment: Alignment.center,
            children: [
              AnimatedBuilder(
                animation: _rippleController,
                builder: (context, child) {
                  return Container(
                    width: 240 * _rippleController.value,
                    height: 240 * _rippleController.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: colorScheme.primary.withValues(
                          alpha: (1 - _rippleController.value) * 0.5,
                        ),
                        width: 2,
                      ),
                    ),
                  );
                },
              ),
              Container(
                constraints: const BoxConstraints(
                  maxWidth: 240,
                  maxHeight: 240,
                ),
                child: _buildButtonStyle(activeStyle, colorScheme),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButtonStyle(PressButtonStyle style, ColorScheme colorScheme) {
    switch (style) {
      case PressButtonStyle.first:
        return _buildWavyStyle();
      case PressButtonStyle.second:
        return _buildRingStyle(colorScheme);
      case PressButtonStyle.third:
        return _buildSquareStyle(colorScheme);
      case PressButtonStyle.tealCircular:
        return const TealCircularStyle();
      case PressButtonStyle.slateRounded:
        return const SlateRoundedStyle();
      case PressButtonStyle.amberGradient:
        return const AmberGradientStyle();
      case PressButtonStyle.purpleOutlined:
        return const PurpleOutlinedStyle();
      case PressButtonStyle.coralSoft:
        return const CoralSoftStyle();
      case PressButtonStyle.midnightGlass:
        return const MidnightGlassStyle();
      case PressButtonStyle.neonGlow:
        return const NeonGlowStyle();
      case PressButtonStyle.emeraldMinimal:
        return const EmeraldMinimalStyle();
      case PressButtonStyle.royalGold:
        return const RoyalGoldStyle();
    }
  }

  Widget _buildWavyStyle() {
    return Stack(
      alignment: Alignment.center,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.maxWidth * 0.8;
            return CustomPaint(
              size: Size(size, size),
              painter: WavyCirclePainter(
                color: Colors.white.withValues(alpha: 0.15),
                waves: 10,
                amplitude: size * 0.03,
              ),
            );
          },
        ),
        LayoutBuilder(
          builder: (context, constraints) {
            final size = constraints.maxWidth * 0.6;
            return CustomPaint(
              size: Size(size, size),
              painter: WavyCirclePainter(
                color: Colors.white,
                waves: 7,
                amplitude: size * 0.03,
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRingStyle(ColorScheme colorScheme) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer glow
        Container(
          width: 160,
          height: 160,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withValues(alpha: 0.2),
                blurRadius: 30,
                spreadRadius: 10,
              ),
            ],
          ),
        ),
        // Main ring
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
          ),
          child: Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSquareStyle(ColorScheme colorScheme) {
    return Center(
      child: Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.5),
            width: 2,
          ),
        ),
        child: Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}

class WavyCirclePainter extends CustomPainter {
  final Color color;
  final int waves;
  final double amplitude;

  WavyCirclePainter({
    required this.color,
    required this.waves,
    required this.amplitude,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final baseRadius = math.min(centerX, centerY) - amplitude;

    final path = Path();
    final double step = 2 * math.pi / waves;

    for (int i = 0; i < waves; i++) {
      final double startAngle = i * step;
      final double endAngle = (i + 1) * step;

      // Radius at the peaks and valleys
      final double rValley = baseRadius - amplitude;
      final double rPeak = baseRadius + amplitude;

      // Start point (Valley)
      final double x1 = centerX + rValley * math.cos(startAngle);
      final double y1 = centerY + rValley * math.sin(startAngle);

      // End point (Valley)
      final double x2 = centerX + rValley * math.cos(endAngle);
      final double y2 = centerY + rValley * math.sin(endAngle);

      // Control points for the "bump" (Peak)
      // cubicTo(x1, y1, x2, y2, x3, y3) needs two control points
      final double cp1Angle = startAngle + step * 0.2;
      final double cp2Angle = startAngle + step * 0.8;

      final double xc1 = centerX + rPeak * math.cos(cp1Angle);
      final double yc1 = centerY + rPeak * math.sin(cp1Angle);

      final double xc2 = centerX + rPeak * math.cos(cp2Angle);
      final double yc2 = centerY + rPeak * math.sin(cp2Angle);

      if (i == 0) {
        path.moveTo(x1, y1);
      }
      path.cubicTo(xc1, yc1, xc2, yc2, x2, y2);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant WavyCirclePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.waves != waves ||
        oldDelegate.amplitude != amplitude;
  }
}
