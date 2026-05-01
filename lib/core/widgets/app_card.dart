import 'package:flutter/material.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool showBorder;
  final double? width;
  final double? height;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.margin,
    this.padding,
    this.borderRadius = 16,
    this.backgroundColor,
    this.borderColor,
    this.showBorder = true,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: width,
      height: height,
      margin: margin ?? const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: backgroundColor ?? colorScheme.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(borderRadius),
        border: showBorder
            ? Border.all(
                color: borderColor ??
                    colorScheme.outlineVariant.withValues(alpha: 0.1),
                width: 1,
              )
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(12),
            child: child,
          ),
        ),
      ),
    );
  }
}
