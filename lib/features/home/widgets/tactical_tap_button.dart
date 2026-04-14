import 'dart:math' as math;

import 'package:flutter/material.dart';

class TacticalTapButton extends StatefulWidget {
  final VoidCallback? onTap;
  final VoidCallback? onTapDown;

  const TacticalTapButton({super.key, required this.onTap, this.onTapDown});

  @override
  State<TacticalTapButton> createState() => _TacticalTapButtonState();
}

class _TacticalTapButtonState extends State<TacticalTapButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    _controller.forward();
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
    final colorScheme = Theme.of(context).colorScheme;

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
        child: SizedBox(
          height: 280,
          width: 280,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow/shadow wavy layer
              CustomPaint(
                size: const Size(280, 280),
                painter: WavyCirclePainter(
                  color: colorScheme.primary.withValues(alpha: 0.15),
                  waves: 10,
                  amplitude: 8,
                ),
              ),
              // Inner main wavy layer
              CustomPaint(
                size: const Size(240, 240),
                painter: WavyCirclePainter(
                  color: colorScheme.primary,
                  waves: 10,
                  amplitude: 8,
                ),
              ),
            ],
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
