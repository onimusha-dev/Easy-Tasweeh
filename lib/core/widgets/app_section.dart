import 'package:easy_tasbeeh/core/theme/app_layout.dart';
import 'package:easy_tasbeeh/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class AppSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  final bool isLargeTitle;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? titlePadding;

  const AppSection({
    super.key,
    this.title,
    required this.children,
    this.isLargeTitle = false,
    this.padding = const EdgeInsets.only(bottom: AppLayout.spaceXXL),
    this.titlePadding = const EdgeInsets.only(
      left: AppLayout.spaceMedium,
      bottom: AppLayout.spaceLarge,
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: titlePadding ?? EdgeInsets.zero,
              child: AppSectionTitle(title: title!, isLarge: isLargeTitle),
            ),
          ...children,
        ],
      ),
    );
  }
}

class AppSectionTitle extends StatelessWidget {
  final String title;
  final bool isLarge;

  const AppSectionTitle({
    super.key,
    required this.title,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = isLarge
        ? theme.textTheme.titleMedium
        : theme.textTheme.titleSmall;

    return Text(
      title,
      style: style?.copyWith(
        fontWeight: AppTypography.weightBlack,
        letterSpacing: 1.2,
        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
      ),
    );
  }
}
