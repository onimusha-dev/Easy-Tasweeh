import 'package:easy_tasweeh/core/widgets/premium_dialog.dart';
import 'package:easy_tasweeh/database/repository/count_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArchiveDialog extends ConsumerWidget {
  const ArchiveDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PremiumDialog(
      icon: Icons.archive_outlined,
      title: 'Archive Session?',
      description: 'This will save your current progress to history and reset the counter for a new start.',
      confirmLabel: 'Archive',
      color: Theme.of(context).colorScheme.error,
      onConfirm: () {
        ref.read(countRepositoryProvider).saveAndReset();
        ScaffoldMessenger.of(context).removeCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Session archived successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }
}
