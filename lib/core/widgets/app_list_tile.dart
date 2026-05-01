import 'package:flutter/material.dart';

import 'app_card.dart';

class AppListTile extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String subtitle;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final double iconSize;
  final double iconContainerSize;

  const AppListTile({
    super.key,
    this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor,
    this.iconBackgroundColor,
    this.trailing,
    this.onTap,
    this.margin,
    this.iconSize = 22,
    this.iconContainerSize = 44,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
      onTap: onTap,
      margin: margin,
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              width: iconContainerSize,
              height: iconContainerSize,
              decoration: BoxDecoration(
                color: iconBackgroundColor ?? colorScheme.surface,
                borderRadius: BorderRadius.circular(iconContainerSize * 0.27),
              ),
              child: Icon(
                icon,
                color: iconColor ?? colorScheme.primary,
                size: iconSize,
              ),
            ),
            const SizedBox(width: 16),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 8), trailing!],
        ],
      ),
    );
  }
}
