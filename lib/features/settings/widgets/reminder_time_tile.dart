import 'package:easy_tasweeh/core/service/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A self-contained tile that handles a single daily reminder.
/// It combines:
///   • a toggle switch to enable/disable the reminder
///   • a time-picker button showing the current scheduled time
class ReminderTimeTile extends ConsumerWidget {
  /// Label displayed in the tile title, e.g. "Morning Reminder"
  final String title;

  /// Short description shown as subtitle
  final String subtitle;

  /// Icon drawn inside the leading container
  final IconData icon;

  /// Whether this reminder is currently enabled
  final bool enabled;

  /// The time currently scheduled for this reminder
  final ReminderTime time;

  /// Called when the user toggles the switch
  final ValueChanged<bool> onToggle;

  /// Called when the user picks a new time
  final ValueChanged<TimeOfDay> onTimePicked;

  /// Custom icon color
  final Color? iconColor;

  const ReminderTimeTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.enabled,
    required this.time,
    required this.onToggle,
    required this.onTimePicked,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 4,
          ),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (iconColor ?? scheme.primary).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor ?? scheme.primary, size: 20),
          ),
          title: Text(
            title,
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            subtitle,
            style: textTheme.bodySmall?.copyWith(color: scheme.outline),
          ),
          trailing: enabled
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _TimeChip(
                      label: time.label,
                      color: iconColor,
                      onTap: () => _pickTime(context),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, size: 18),
                      onPressed: () => onToggle(false),
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      color: scheme.outline,
                    ),
                  ],
                )
              : TextButton.icon(
                  onPressed: () => _pickTime(context),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Set Time'),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    backgroundColor: (iconColor ?? scheme.primary).withValues(
                      alpha: 0.05,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Future<void> _pickTime(BuildContext context) async {
    final initial = TimeOfDay(hour: time.hour, minute: time.minute);
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      helpText: 'SELECT REMINDER TIME',
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
    if (picked != null) {
      onTimePicked(picked);
    }
  }
}

class _TimeChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final Color? color;

  const _TimeChip({required this.label, this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final effectiveColor = color ?? scheme.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: effectiveColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: effectiveColor.withValues(alpha: 0.25)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: effectiveColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: 4),
              Icon(Icons.edit_rounded, size: 10, color: effectiveColor),
            ],
          ],
        ),
      ),
    );
  }
}
