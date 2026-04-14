import 'package:easy_tasweeh/database/repository/count_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArchiveDialog extends ConsumerWidget {
  const ArchiveDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text('Archive Session'),
      content: const Text(
        'Do you want to save this session to history and reset the counter?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('CANCEL'),
        ),
        FilledButton(
          onPressed: () {
            ref.read(countRepositoryProvider).saveAndReset();
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Session archived successfully'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: const Text('ARCHIVE'),
        ),
      ],
    );
  }
}
