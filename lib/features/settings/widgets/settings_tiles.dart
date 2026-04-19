import 'package:flutter/material.dart';

Widget buildSettingSectionTitle(BuildContext context, String title) {
  return Text(title, style: Theme.of(context).textTheme.labelSmall);
}

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
}) {
  Widget? trailingWidget;

  if (trailing != null) {
    trailingWidget = trailing;
  } else if (trailingLabel != null) {
    trailingWidget = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(4, 4, 8, 4),
          decoration: BoxDecoration(
            color: Theme.of(
              context,
            ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            trailingLabel,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        if (showChevron) ...[
          const SizedBox(width: 4),
          Icon(
            Icons.chevron_right_rounded,
            size: 16,
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
        ],
      ],
    );
  } else if (showChevron && onTap != null) {
    // Default: just chevron for tappable tiles
    trailingWidget = Icon(
      Icons.chevron_right_rounded,
      size: 18,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }

  return ListTile(
    dense: true,
    visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    leading: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: (iconColor ?? Theme.of(context).colorScheme.primary).withValues(
          alpha: 0.1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        color: iconColor ?? Theme.of(context).colorScheme.primary,
        size: 20,
      ),
    ),
    title: Text(title, style: Theme.of(context).textTheme.titleSmall),
    subtitle: Text(
      subtitle,
      style: TextStyle(
        color: Theme.of(context).colorScheme.outline,
        fontSize: Theme.of(context).textTheme.bodySmall?.fontSize,
      ),
    ),
    trailing: trailingWidget,
    onTap: onTap,
  );
}

Widget buildSettingsGroup(
  BuildContext context, {
  String? title,
  required List<Widget> children,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (title != null)
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 0, 8),
          child: buildSettingSectionTitle(context, title),
        ),
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Theme.of(
              context,
            ).colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(children: children),
        ),
      ),
    ],
  );
}
