import 'package:easy_tasbeeh/core/theme/theme.dart';
import 'package:easy_tasbeeh/core/widgets/premium_dialog.dart';
import 'package:easy_tasbeeh/database/repository/count_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SaveProgressDialog extends ConsumerWidget {
  final String title;
  final String description;
  final String confirmLabel;
  final VoidCallback onConfirm;

  const SaveProgressDialog({
    super.key,
    this.title = 'Save progress?',
    this.description =
        'You have active progress. This action will save your current session to history.',
    this.confirmLabel = 'Archive',
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PremiumDialog(
      icon: Icons.track_changes_rounded,
      title: title,
      description: description,
      confirmLabel: confirmLabel,
      color: Theme.of(context).extension<AppColors>()?.destructiveColor,
      onConfirm: () {
        ref.read(countRepositoryProvider).saveAndReset();
        onConfirm();
      },
    );
  }

  static void show(
    BuildContext context, {
    String? title,
    String? description,
    String? confirmLabel,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (context) => SaveProgressDialog(
        title: title ?? 'Save progress?',
        description: description ??
            'You have active progress. This action will save your current session to history.',
        confirmLabel: confirmLabel ?? 'Archive',
        onConfirm: onConfirm,
      ),
    );
  }
}
