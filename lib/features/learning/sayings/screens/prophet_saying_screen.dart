import 'package:easy_tasweeh/core/models/saying_model.dart';
import 'package:easy_tasweeh/features/learning/sayings/widgets/saying_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProphetSayingScreen extends StatelessWidget {
  const ProphetSayingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text('Prophet\'s Sayings', style: textTheme.titleMedium),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        itemCount: hadiths.length + 1,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == hadiths.length) {
            return const SizedBox(height: 24); // spacing at the bottom
          }
          final item = hadiths[index];
          return SayingTile(
            item: item,
          ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.1);
        },
      ),
    );
  }
}
