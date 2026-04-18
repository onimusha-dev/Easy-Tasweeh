import 'package:flutter/material.dart';

class EmeraldMinimalStyle extends StatefulWidget {
  final VoidCallback? onTap;
  final VoidCallback? onTapDown;

  const EmeraldMinimalStyle({
    super.key,
    this.onTap,
    this.onTapDown,
  });

  @override
  State<EmeraldMinimalStyle> createState() => _EmeraldMinimalStyleState();
}

class _EmeraldMinimalStyleState extends State<EmeraldMinimalStyle>
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
                  color: const Color(0xFFE0F2F1),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: Colors.green, width: 0.5),
                ),
                padding: const EdgeInsets.all(4),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.green.shade600,
                    borderRadius: BorderRadius.circular(36),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.shade600.withValues(alpha: 0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.add_rounded, color: Colors.white, size: 40),
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
