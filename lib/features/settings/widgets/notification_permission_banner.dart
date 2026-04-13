import 'package:easy_tasweeh/core/service/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_settings/app_settings.dart';

/// Displays a contextual banner about notification permission status.
/// - If permission is already granted  → shows a subtle "active" indicator.
/// - If permission is not granted      → shows a warning with a request button.
class NotificationPermissionBanner extends ConsumerWidget {
  const NotificationPermissionBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final granted =
        ref.watch(settingsProvider).notificationPermissionGranted;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    if (granted) {
      return _BannerCard(
        color: scheme.primaryContainer,
        icon: Icons.notifications_active_rounded,
        iconColor: scheme.primary,
        title: 'NOTIFICATIONS ACTIVE',
        subtitle: 'Daily reminders will be delivered as scheduled.',
        trailing: Icon(
          Icons.check_circle_rounded,
          size: 18,
          color: scheme.primary,
        ),
      );
    }

    return _BannerCard(
      color: scheme.errorContainer,
      icon: Icons.notifications_off_rounded,
      iconColor: scheme.error,
      title: 'PERMISSION REQUIRED',
      subtitle: 'Enable notifications to receive daily reminders.',
      trailing: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: scheme.error,
          textStyle: text.labelSmall?.copyWith(
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
          ),
        ),
        onPressed: () async {
          // Try in-app request first; if denied permanently, open Settings.
          final granted = await ref
              .read(settingsProvider.notifier)
              .requestNotificationPermission();
          if (!granted && context.mounted) {
            AppSettings.openAppSettings(type: AppSettingsType.notification);
          }
        },
        child: const Text('ENABLE'),
      ),
    );
  }
}

class _BannerCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _BannerCard({
    required this.color,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.6)),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: text.labelSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.4,
                    color: iconColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: text.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
