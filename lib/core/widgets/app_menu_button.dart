import 'package:flutter/material.dart';

class AppMenuItem {
  final String value;
  final String label;
  final IconData icon;
  final bool isDestructive;

  AppMenuItem({
    required this.value,
    required this.label,
    required this.icon,
    this.isDestructive = false,
  });
}

class AppMenuButton extends StatelessWidget {
  final List<AppMenuItem> items;
  final Function(String) onSelected;
  final double offsetRight;
  final Color? iconColor;

  const AppMenuButton({
    super.key,
    required this.items,
    required this.onSelected,
    this.offsetRight = 0,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Transform.translate(
      offset: Offset(offsetRight, 0),
      child: Builder(
        builder: (context) {
          return IconButton(
            onPressed: () => _showMenu(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            splashRadius: 20,
            icon: Icon(
              Icons.more_vert_rounded,
              size: 22,
              color: iconColor ?? colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          );
        },
      ),
    );
  }

  void _showMenu(BuildContext context) async {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;
    
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    final String? result = await showMenu<String>(
      context: context,
      position: position,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      elevation: 8,
      surfaceTintColor: colorScheme.surface,
      color: colorScheme.surface,
      items: items.map((item) {
        return PopupMenuItem<String>(
          value: item.value,
          height: 44,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.icon,
                size: 18,
                color: item.isDestructive
                    ? colorScheme.error
                    : colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Text(
                item.label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: item.isDestructive
                      ? colorScheme.error
                      : colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),
        );
      }).toList(),
    );

    if (result != null) {
      onSelected(result);
    }
  }
}
