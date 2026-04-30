import 'package:easy_tasbeeh/core/theme/schemes/app_colors.dart';
import 'package:flutter/material.dart';

class SelectionItemTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final Color? iconColor;

  const SelectionItemTile({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.isSelected,
    required this.onTap,
    required this.onEdit,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final primaryIconColor = iconColor ?? AppIconColors.purple(context);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(9),
              child: Icon(
                icon,
                color: isSelected ? primaryIconColor : colorScheme.outline,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? primaryIconColor.withValues(alpha: 0.8)
                          : colorScheme.outline,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isSelected
                          ? colorScheme.onSurface
                          : colorScheme.onSurface.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onEdit,
              icon: Icon(
                Icons.edit_rounded,
                color: colorScheme.outlineVariant,
                size: 18,
              ),
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
