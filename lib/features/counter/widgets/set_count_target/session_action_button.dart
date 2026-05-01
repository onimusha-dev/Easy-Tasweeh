import 'package:easy_tasbeeh/core/theme/theme.dart';
import 'package:easy_tasbeeh/core/widgets/premium_dialog.dart';
import 'package:easy_tasbeeh/database/repository/count_repository.dart';
import 'package:easy_tasbeeh/features/counter/widgets/set_count_target/archive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SessionActionButton extends ConsumerWidget {
  final int currentCount;

  const SessionActionButton({super.key, required this.currentCount});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final appColors = Theme.of(context).extension<AppColors>();

    if (currentCount > 0) {
      return SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: () {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (context) => const ArchiveDialog(),
            );
          },
          icon: const Icon(Icons.archive_outlined, size: 18),
          label: const Text(
            'Archive Session',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          style: FilledButton.styleFrom(
            backgroundColor: appColors?.destructiveColor.withValues(alpha: 0.1),
            foregroundColor: appColors?.destructiveColor,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
    } else {
      return SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: () {
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
                    Navigator.pop(context); // Close bottom sheet
                    ScaffoldMessenger.of(context).removeCurrentSnackBar();
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
                },
              ),
            );
          },
          icon: const Icon(Icons.restore_rounded, size: 18),
          label: const Text(
            'Restore Last Session',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
            foregroundColor: colorScheme.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );
    }
  }
}
