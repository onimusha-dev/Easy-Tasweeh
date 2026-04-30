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
  // Shape is injected by buildSettingsGroup to clip the ink splash correctly.
  ShapeBorder shape = const RoundedRectangleBorder(),
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
    trailingWidget = Icon(
      Icons.chevron_right_rounded,
      size: 18,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }

  return GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              icon,
              color: iconColor ?? Theme.of(context).colorScheme.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 2),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          if (trailingWidget != null) ...[
            const SizedBox(width: 8),
            trailingWidget,
          ],
        ],
      ),
    ),
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
  final scheme = Theme.of(context).colorScheme;

  return GestureDetector(
    onTap: onTap,
    behavior: HitTestBehavior.opaque,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Icon(icon, color: iconColor ?? scheme.primary, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          action,
          const SizedBox(height: 16),
        ],
      ),
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
  const r = Radius.circular(8);
  const none = Radius.zero;
  final n = children.length;

  // Assign each child the border radius that matches its position in the card
  // so the ListTile ink splash is clipped to the card's rounded corners.
  final shaped = List<Widget>.generate(n, (i) {
    final borderRadius = BorderRadius.only(
      topLeft: i == 0 ? r : none,
      topRight: i == 0 ? r : none,
      bottomLeft: i == n - 1 ? r : none,
      bottomRight: i == n - 1 ? r : none,
    );

    return Material(
      color: Colors.transparent,
      clipBehavior: Clip.antiAlias,
      borderRadius: borderRadius,
      child: children[i],
    );
  });

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (title != null)
        buildSettingSectionTitle(context, title, isLarge: isLargeTitle),
      const SizedBox(height: 12),
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
          border: showBorder
              ? Border.all(
                  color:
                      borderColor ??
                      Theme.of(
                        context,
                      ).colorScheme.outlineVariant.withValues(alpha: 0.5),
                  width: borderWidth ?? 1.0,
                )
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(children: shaped),
        ),
      ),
    ],
  );
}
