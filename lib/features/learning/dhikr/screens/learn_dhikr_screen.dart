import 'package:collection/collection.dart';
import 'package:easy_tasweeh/core/models/dhikr_model.dart';
import 'package:easy_tasweeh/features/learning/dhikr/widgets/dhikr_tile.dart';
import 'package:easy_tasweeh/features/settings/widgets/settings_tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LearnDhikrScreen extends StatelessWidget {
  const LearnDhikrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text('Learn Tasweeh', style: textTheme.titleMedium),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          const SizedBox(height: 8),
          buildSettingsGroup(
            context,
            title: 'All Dhikrs',
            children: dhikrList.mapIndexed((itemIdx, item) {
              return DhikrTile(
                item: item,
                isLast: itemIdx == dhikrList.length - 1,
              );
            }).toList(),
          ).animate().fadeIn().slideY(begin: 0.1),
          const SizedBox(height: 58),
        ],
      ),
    );
  }
}
