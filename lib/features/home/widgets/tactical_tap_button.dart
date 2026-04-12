import 'package:flutter/material.dart';

class TacticalTapButton extends StatefulWidget {
  final VoidCallback? onTap; // null = frozen/disabled
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
      duration: const Duration(milliseconds: 50),
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
    return AnimatedOpacity(
      opacity: 1.0,
      duration: const Duration(milliseconds: 100),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: isFrozen ? null : _handleTapDown,
        onTapUp: isFrozen ? null : _handleTapUp,
        onTapCancel: isFrozen ? null : _handleTapCancel,
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: Tween<double>(begin: 1.0, end: 0.94).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOut),
          ),
          child: Container(
            height: 280,
            width: 280,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
              border: Border.all(
                color: Theme.of(
                  context,
                ).colorScheme.onPrimary.withValues(alpha: 0.1),
                width: 8,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.fingerprint_rounded,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'TAP',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
