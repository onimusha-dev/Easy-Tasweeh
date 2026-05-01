import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:easy_tasbeeh/core/widgets/app_card.dart';
import 'package:easy_tasbeeh/core/widgets/app_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReminderTimeTile extends ConsumerWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool enabled;
  final ReminderTime time;
  final ValueChanged<bool> onToggle;
  final ValueChanged<TimeOfDay> onTimePicked;
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppCard(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _TimeChip(
                label: time.label,
                color: enabled ? colorScheme.primary : colorScheme.outline,
                onTap: () => _pickTime(context),
              ),
              AppSwitch(
                value: enabled,
                onChanged: onToggle,
                activeColor: colorScheme.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickTime(BuildContext context) async {
    final initial = TimeOfDay(hour: time.hour, minute: time.minute);
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      helpText: 'SELECT REMINDER TIME',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: Theme.of(context).colorScheme.primary,
                ),
          ),
          child: MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child ?? const SizedBox.shrink(),
          ),
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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final effectiveColor = color ?? scheme.primary;

    return Material(
      color: effectiveColor.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: effectiveColor.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.access_time_rounded, size: 16, color: effectiveColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: effectiveColor,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
