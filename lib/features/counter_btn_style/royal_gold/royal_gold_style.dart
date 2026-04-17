import 'package:flutter/material.dart';

class RoyalGoldStyle extends StatefulWidget {
  final VoidCallback? onTap;
  final VoidCallback? onTapDown;

  const RoyalGoldStyle({
    super.key,
    this.onTap,
    this.onTapDown,
  });

  @override
  State<RoyalGoldStyle> createState() => _RoyalGoldStyleState();
}

class _RoyalGoldStyleState extends State<RoyalGoldStyle>
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
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      Colors.amber.shade200,
                      Colors.amber.shade700,
                      Colors.amber.shade900,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: -2,
                    ),
                  ],
                ),
                child: Center(
                  child: FractionallySizedBox(
                    widthFactor: 0.8,
                    heightFactor: 0.8,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 1,
                        ),
                        gradient: LinearGradient(
                          colors: [
                            Colors.amber.shade700,
                            Colors.amber.shade400,
                          ],
                          begin: Alignment.bottomRight,
                          end: Alignment.topLeft,
                        ),
                      ),
                      child: const Icon(
                        Icons.star_rounded,
                        color: Colors.white,
                        size: 45,
                        shadows: [
                          Shadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
