import 'package:easy_tasbeeh/core/theme/app_layout.dart';
import 'package:flutter/material.dart';

import 'app_card.dart';

class AppListTile extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String subtitle;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final Widget? trailing;
  final String? trailingLabel;
  final bool showChevron;
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
    this.trailingLabel,
    this.showChevron = false,
    this.onTap,
    this.margin = const EdgeInsets.only(bottom: AppLayout.spaceTileGap),
    this.iconSize = AppLayout.iconSizeMedium,
    this.iconContainerSize = AppLayout.iconContainerSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    Widget? effectiveTrailing = trailing;
    if (trailing == null && (trailingLabel != null || showChevron)) {
      effectiveTrailing = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingLabel != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                trailingLabel!,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          if (showChevron) ...[
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: colorScheme.outlineVariant,
            ),
          ],
        ],
      );
    }

    return AppCard(
      onTap: onTap,
      margin: margin,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          if (effectiveTrailing != null) ...[
            const SizedBox(width: 8),
            effectiveTrailing,
          ],
        ],
      ),
    );
  }
}
