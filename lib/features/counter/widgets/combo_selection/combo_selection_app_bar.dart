import 'package:easy_tasbeeh/core/widgets/premium_dialog.dart';
import 'package:easy_tasbeeh/database/repository/count_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ComboSelectionAppBar extends ConsumerWidget
    implements PreferredSizeWidget {
  const ComboSelectionAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final countAsync = ref.watch(currentCountStreamProvider);
    final currentCount = countAsync.asData?.value?.currentCount ?? 0;

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
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: currentCount > 0 ? 0.3 : 1.0,
          child: IconButton(
            onPressed: currentCount > 0 ? null : () => _handleRestore(context, ref),
            icon: const Icon(Icons.restore_rounded),
            tooltip: 'Restore Last Session',
          ),
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
              .read(countRepositoryProvider)
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
