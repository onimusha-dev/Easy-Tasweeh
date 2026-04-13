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

  const ReminderTimeTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.enabled,
    required this.time,
    required this.onToggle,
    required this.onTimePicked,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        ListTile(
          dense: true,
          visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: scheme.primary, size: 18),
          ),
          title: Text(
            title,
            style: textTheme.titleSmall,
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: scheme.outline,
              fontSize: textTheme.bodySmall?.fontSize,
            ),
          ),
          trailing: Switch(
            value: enabled,
            onChanged: onToggle,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        // Time picker row – shown always but dimmed when disabled
        AnimatedOpacity(
          opacity: enabled ? 1.0 : 0.4,
          duration: const Duration(milliseconds: 200),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 72, right: 24, bottom: 8),
            child: Row(
              children: [
                Icon(
                  Icons.schedule_rounded,
                  size: 14,
                  color: scheme.outline,
                ),
                const SizedBox(width: 6),
                Text(
                  'Scheduled at',
                  style: textTheme.bodySmall?.copyWith(
                    color: scheme.outline,
                  ),
                ),
                const SizedBox(width: 8),
                _TimeChip(
                  label: time.label,
                  onTap: enabled
                      ? () => _pickTime(context)
                      : null,
                ),
              ],
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
          child: child!,
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

  const _TimeChip({required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: scheme.primaryContainer.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: scheme.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: scheme.primary,
                  ),
            ),
            if (onTap != null) ...[
              const SizedBox(width: 4),
              Icon(Icons.edit_rounded, size: 10, color: scheme.primary),
            ],
          ],
        ),
      ),
    );
  }
}
