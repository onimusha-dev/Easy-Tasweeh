import 'package:flutter/material.dart';

class EmptyHistoryView extends StatelessWidget {
  const EmptyHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Opacity(
        opacity: 0.5,
        child: Column(
          children: [
            const Spacer(flex: 2),
            const Icon(Icons.history_toggle_off_rounded, size: 64),
            const SizedBox(height: 16),
            Text(
              'No sessions documented.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}
