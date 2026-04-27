import 'package:easy_tasbeeh/core/models/dhikr_model.dart';
import 'package:easy_tasbeeh/core/utils/dhikr_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DhikrTile extends StatelessWidget {
  final DhikrItem item;
  final int index;
  final bool isSelected;
  final VoidCallback onTap;

  const DhikrTile({
    super.key,
    required this.item,
    required this.index,
    this.isSelected = false,
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
                      style: GoogleFonts.amiri(
                        color: isSelected ? accentColor : colorScheme.onSurface,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Text Info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.arabic,
                          style: GoogleFonts.amiri(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? accentColor
                                : colorScheme.onSurface,
                            height: 1.3,
                          ),
                        ),
                        Text(
                          item.transliteration,
                          style: TextStyle(
                            fontSize: 13,
                            color: colorScheme.outline,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (isSelected)
                  Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: accentColor,
                      size: 22,
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
