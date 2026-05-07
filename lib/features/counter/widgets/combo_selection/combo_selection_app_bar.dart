import 'package:easy_tasbeeh/core/widgets/premium_dialog.dart';
import 'package:easy_tasbeeh/features/counter/providers/counter_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComboSelectionAppBar extends ConsumerWidget
    implements PreferredSizeWidget {
  const ComboSelectionAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final countAsync = ref.watch(counterProvider);
    final currentCount = countAsync.value?.currentCount ?? 0;

    final canRestore = ref.watch(canRestoreProvider).value ?? false;

    return AppBar(
      title: Text(
        'Dhikr Selection',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () {
            if (currentCount > 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cannot restore with active progress'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (!canRestore) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('No session to restore'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else {
              _handleRestore(context, ref);
            }
          },
          icon: Icon(
            Icons.restore_rounded,
            color: (currentCount > 0 || !canRestore)
                ? colorScheme.outline.withValues(alpha: 0.5)
                : colorScheme.primary,
          ),
          tooltip: 'Restore Last Session',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Future<void> _handleRestore(BuildContext context, WidgetRef ref) async {
    showDialog(
      context: context,
      builder: (context) => PremiumDialog(
        icon: Icons.restore_rounded,
        title: 'Restore Session?',
        description:
            'Are you sure you want to restore your last incomplete session?',
        confirmLabel: 'Restore',
        onConfirm: () async {
          final success = await ref
              .read(counterProvider.notifier)
              .restoreLastSession();
          if (context.mounted) {
            _showRestoreResult(context, success);
          }
        },
      ),
    );
  }

  void _showRestoreResult(BuildContext context, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Last incomplete session restored'
              : 'No eligible session found to restore',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
