import 'package:easy_tasbeeh/core/models/dhikr_model.dart';
import 'package:easy_tasbeeh/core/theme/app_typography.dart';
import 'package:easy_tasbeeh/core/utils/dhikr_utils.dart';
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
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final accentColor = DhikrUtils.getCategoryColor(context, item.category);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(color: Colors.transparent),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DhikrDetailScreen(item: item),
              ),
            );
          },
          child: IntrinsicHeight(
            child: Row(
              children: [
                SizedBox(
                  width: 60,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Translucent numbering box (expands)
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.15),
                          ),
                          child: Center(
                            child: Text(
                              DhikrUtils.toArabicDigits(index),
                              style: AppTypography.arabicTitle(accentColor),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(12, 16, 12, isLast ? 40 : 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            item.arabic,
                            textAlign: TextAlign.right,
                            style: AppTypography.arabicBody(
                              colorScheme.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.translation,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 8, 16),
                  child: Align(
                    alignment: isLast ? Alignment.topCenter : Alignment.center,
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: colorScheme.outlineVariant,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
