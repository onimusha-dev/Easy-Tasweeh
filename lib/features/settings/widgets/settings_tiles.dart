import 'package:easy_tasbeeh/core/theme/app_layout.dart';
import 'package:easy_tasbeeh/core/widgets/app_card.dart';
import 'package:easy_tasbeeh/core/widgets/app_list_tile.dart';
import 'package:easy_tasbeeh/core/widgets/app_section.dart';
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
  return AppListTile(
    icon: icon,
    title: title,
    subtitle: subtitle,
    iconColor: iconColor,
    trailing: trailing,
    trailingLabel: trailingLabel,
    showChevron: showChevron && onTap != null,
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
    margin: const EdgeInsets.only(bottom: AppLayout.spaceTileGap),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
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
  return AppSectionTitle(title: title, isLarge: isLarge);
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
  return AppSection(
    title: title,
    isLargeTitle: isLargeTitle,
    padding: const EdgeInsets.only(bottom: 12),
    children: children,
  );
}
