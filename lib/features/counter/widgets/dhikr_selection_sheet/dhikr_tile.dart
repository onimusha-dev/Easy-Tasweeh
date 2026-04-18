import 'package:easy_tasweeh/core/models/dhikr_model.dart';
import 'package:flutter/material.dart';

class DhikrTile extends StatefulWidget {
  final DhikrItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const DhikrTile({
    super.key,
    required this.item,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  State<DhikrTile> createState() => _DhikrTileState();
}

class _DhikrTileState extends State<DhikrTile> {
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 100,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: (_isPressed || _isHovered)
                ? LinearGradient(
                    colors: [
                      Colors.green.withValues(alpha: 0.1),
                      Colors.green.withValues(alpha: 0.2),
                      Colors.green.withValues(alpha: 0.1),
                    ],
                  )
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.item.arabic,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  Text(
                    widget.item.transliteration,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: colorScheme.onSurface.withValues(alpha: 0.75),
                    ),
                  ),
                  Text(
                    widget.item.translation,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              if (widget.isSelected) ...[
                const Icon(Icons.check_circle, color: Colors.green),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
