import 'package:flutter/material.dart';

Widget buildSectionTitle(BuildContext context, String title) {
  return Text(
    title,
    style: Theme.of(context).textTheme.labelSmall?.copyWith(
      fontWeight: FontWeight.w900,
      letterSpacing: 1.5,
      color: Theme.of(context).colorScheme.outline,
    ),
  );
}

Widget buildSettingTile(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String subtitle,
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
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
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
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    leading: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 18),
    ),
    title: Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
      ),
    ),
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
