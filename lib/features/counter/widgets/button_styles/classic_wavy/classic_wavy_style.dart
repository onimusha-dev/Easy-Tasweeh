import 'dart:math' as math;
import 'package:flutter/material.dart';

class ClassicWavyStyle extends StatefulWidget {
  final VoidCallback? onTap;
  final VoidCallback? onTapDown;

  const ClassicWavyStyle({
    super.key,
    this.onTap,
    this.onTapDown,
  });

  @override
  State<ClassicWavyStyle> createState() => _ClassicWavyStyleState();
}

class _ClassicWavyStyleState extends State<ClassicWavyStyle>
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
        ),
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
