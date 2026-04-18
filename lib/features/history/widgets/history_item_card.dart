import 'package:easy_tasweeh/core/utils/color_utils.dart';
import 'package:easy_tasweeh/core/utils/date_time_utils.dart';
import 'package:easy_tasweeh/database/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HistoryItemCard extends StatefulWidget {
  final CountHistoryTableData data;
  final int index;

  const HistoryItemCard({super.key, required this.data, required this.index});

  @override
  State<HistoryItemCard> createState() => _HistoryItemCardState();
}

class _HistoryItemCardState extends State<HistoryItemCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final bool isCompleted =
        widget.data.currentCount >= widget.data.targetCount;
    final double percentage = widget.data.targetCount > 0
        ? (widget.data.currentCount / widget.data.targetCount) * 100
        : 0;

    final Color statusColor = setPercentageCompletionColor(percentage);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTap: () async {
          // Logic for whatever tapping the card should do can go here

          // Keep the highlight visible for a short duration
          await Future.delayed(const Duration(milliseconds: 400));
          if (mounted) setState(() => _isPressed = false);
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: (_isHovered || _isPressed)
                ? LinearGradient(
                    colors: [
                      Colors.transparent,
                      statusColor.withValues(alpha: 0.02),
                      statusColor.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : const LinearGradient(
                    colors: [Colors.transparent, Colors.transparent],
                  ),
            border: Border(
              bottom: BorderSide(
                color: theme.dividerColor.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'سُبْحَانَ اللَّهِ', // Hardcoded demo title
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w200,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'SubhanAllah', // Hardcoded demo title
                        style: TextStyle(color: theme.hintColor, fontSize: 16),
                      ),
                    ],
                  ),
                  if (isCompleted)
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Colors.green,
                      size: 18,
                    ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '${widget.data.currentCount}',
                          style: textTheme.bodyLarge?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.normal,
                            fontSize: 28,
                          ),
                        ),
                        TextSpan(
                          text: ' /${widget.data.targetCount}',
                          style: textTheme.bodyMedium?.copyWith(
                            color: theme.hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    getFormattedHistoryTimestamp(widget.data.createdAt),
                    style: textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.05, delay: (widget.index * 40).ms);
  }
}
