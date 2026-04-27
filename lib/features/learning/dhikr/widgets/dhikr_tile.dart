import 'package:easy_tasbeeh/core/models/dhikr_model.dart';
import 'package:easy_tasbeeh/core/utils/dhikr_utils.dart';
import 'package:easy_tasbeeh/features/learning/dhikr/screens/dhikr_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                      // Solid accent strip
                      Container(width: 3, color: accentColor),
                      // Translucent numbering box (expands)
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.15),
                          ),
                          child: Center(
                            child: Text(
                              DhikrUtils.toArabicDigits(index),
                              style: GoogleFonts.amiri(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: accentColor,
                              ),
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
                        Text(
                          item.arabic,
                          style: GoogleFonts.amiri(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.translation,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.outline,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
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
