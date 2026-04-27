import 'package:easy_tasbeeh/core/models/dhikr_model.dart';
import 'package:easy_tasbeeh/core/theme/app_typography.dart';
import 'package:easy_tasbeeh/core/utils/dhikr_utils.dart';
import 'package:flutter/material.dart';

class DhikrTile extends StatelessWidget {
  final DhikrItem item;
  final int index;
  final bool isSelected;
  final bool isLast;
  final VoidCallback onTap;

  const DhikrTile({
    super.key,
    required this.item,
    required this.index,
    this.isSelected = false,
    this.isLast = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final accentColor = DhikrUtils.getCategoryColor(context, item.category);

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isSelected
            ? accentColor.withValues(alpha: 0.08)
            : Colors.transparent,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: IntrinsicHeight(
            child: Row(
              children: [
                // Arabic Number Indicator
                Container(
                  width: 56,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(
                      alpha: isSelected ? 0.2 : 0.1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      DhikrUtils.toArabicDigits(index),
                      style: AppTypography.arabicTitle(
                        isSelected ? accentColor : colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),

                // Text Info
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16, 12, 12, isLast ? 40 : 12),
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
                              isSelected ? accentColor : colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Text(
                          item.transliteration,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
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
