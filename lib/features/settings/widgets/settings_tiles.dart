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
        const SizedBox(width: 4),
        Icon(
          Icons.chevron_right_rounded,
          size: 16,
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ],
    );
  } else {
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
    leading: Icon(
      icon,
      color: iconColor ?? Theme.of(context).colorScheme.primary,
      size: 22,
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
