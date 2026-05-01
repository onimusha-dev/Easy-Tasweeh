import 'package:easy_tasbeeh/core/widgets/app_card.dart';
import 'package:easy_tasbeeh/core/widgets/app_list_tile.dart';
import 'package:flutter/material.dart';

Widget buildSettingTile(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String subtitle,
  Color? iconColor,
  Widget? trailing,
  String? trailingLabel,
  VoidCallback? onTap,
  bool showChevron = true,
  ShapeBorder shape = const RoundedRectangleBorder(),
}) {
  final colorScheme = Theme.of(context).colorScheme;

  Widget? effectiveTrailing = trailing;
  if (trailing == null && trailingLabel != null) {
    effectiveTrailing = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            trailingLabel,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
  } else if (trailing == null && showChevron && onTap != null) {
    effectiveTrailing = Icon(
      Icons.chevron_right_rounded,
      size: 22,
      color: colorScheme.outlineVariant,
    );
  }

  return AppListTile(
    icon: icon,
    title: title,
    subtitle: subtitle,
    iconColor: iconColor,
    trailing: effectiveTrailing,
    onTap: onTap,
  );
}

Widget buildTwoPartSettingTile(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String subtitle,
  required Widget action,
  Color? iconColor,
  VoidCallback? onTap,
  ShapeBorder shape = const RoundedRectangleBorder(),
}) {
  final theme = Theme.of(context);
  final colorScheme = theme.colorScheme;

  return AppCard(
    onTap: onTap,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor ?? colorScheme.primary,
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
          ],
        ),
        const SizedBox(height: 12),
        action,
      ],
    ),
  );
}

Widget buildSettingSectionTitle(
  BuildContext context,
  String title, {
  bool isLarge = false,
}) {
  final theme = Theme.of(context);
  final style = isLarge
      ? theme.textTheme.titleMedium
      : theme.textTheme.titleSmall;

  return Text(
    title,
    style: style?.copyWith(fontWeight: FontWeight.w900, letterSpacing: 1.5),
  );
}

Widget buildSettingsGroup(
  BuildContext context, {
  String? title,
  required List<Widget> children,
  bool showBorder = true,
  bool isLargeTitle = false,
  Color? borderColor,
  double? borderWidth,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: buildSettingSectionTitle(
              context,
              title,
              isLarge: isLargeTitle,
            ),
          ),
          const SizedBox(height: 12),
        ],
        ...children,
      ],
    ),
  );
}
