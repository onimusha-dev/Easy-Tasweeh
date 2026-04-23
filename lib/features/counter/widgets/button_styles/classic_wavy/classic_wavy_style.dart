import 'dart:math' as math;
import 'package:flutter/material.dart';

class ClassicWavyStyle extends StatelessWidget {
  final Animation<double> rippleAnimation;

  const ClassicWavyStyle({
    super.key,
    required this.rippleAnimation,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: rippleAnimation,
            builder: (context, child) {
              return Container(
                width: 240 * rippleAnimation.value,
                height: 240 * rippleAnimation.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colorScheme.primary.withValues(
                      alpha: (1 - rippleAnimation.value) * 0.5,
                    ),
                    width: 2,
                  ),
                ),
              );
            },
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final size = constraints.maxWidth * 0.8;
                  return CustomPaint(
                    size: Size(size, size),
                    painter: _WavyCirclePainter(
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
                    painter: _WavyCirclePainter(
                      color: Colors.white,
                      waves: 7,
                      amplitude: size * 0.03,
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WavyCirclePainter extends CustomPainter {
  final Color color;
  final int waves;
  final double amplitude;

  _WavyCirclePainter({
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

      final double rValley = baseRadius - amplitude;
      final double rPeak = baseRadius + amplitude;

      final double x1 = centerX + rValley * math.cos(startAngle);
      final double y1 = centerY + rValley * math.sin(startAngle);

      final double x2 = centerX + rValley * math.cos(endAngle);
      final double y2 = centerY + rValley * math.sin(endAngle);

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
  bool shouldRepaint(covariant _WavyCirclePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.waves != waves ||
        oldDelegate.amplitude != amplitude;
  }
}
