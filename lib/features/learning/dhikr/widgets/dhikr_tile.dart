import 'package:easy_tasbeeh/core/models/dhikr_model.dart';
import 'package:easy_tasbeeh/core/theme/app_typography.dart';
import 'package:easy_tasbeeh/core/utils/dhikr_utils.dart';
import 'package:easy_tasbeeh/core/widgets/app_card.dart';
import 'package:easy_tasbeeh/features/learning/dhikr/screens/dhikr_detail_screen.dart';
import 'package:flutter/material.dart';

class DhikrTile extends StatelessWidget {
  final DhikrItem item;
  final int index;
  final bool isLast;

  const DhikrTile({
    super.key,
    required this.item,
    required this.index,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final accentColor = DhikrUtils.getCategoryColor(context, item.category);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4), // Further reduced gap
      child: AppCard(
        padding: EdgeInsets.zero,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DhikrDetailScreen(item: item),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      item.arabic.characters.first,
                      style: AppTypography.arabicTitle(accentColor).copyWith(fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.transliteration,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.arabic,
                        style: AppTypography.arabicBody(
                          colorScheme.onSurface.withValues(alpha: 0.7),
                        ).copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: colorScheme.outlineVariant,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
