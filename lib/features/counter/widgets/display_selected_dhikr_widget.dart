import 'package:easy_tasweeh/core/models/dhikr_model.dart';
import 'package:easy_tasweeh/core/service/settings_provider.dart';
import 'package:easy_tasweeh/features/counter/widgets/dhikr_selection_sheet/dhikr_selection_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DisplaySelectedDhikrWidget extends ConsumerWidget {
  final DhikrItem currentDhikr;

  const DisplaySelectedDhikrWidget({super.key, required this.currentDhikr});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final settings = ref.watch(settingsProvider);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.1),
        ),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: Column(
          key: ValueKey(currentDhikr.arabic),
          mainAxisSize: MainAxisSize.min,
          children: [
            if (settings.showArabic)
              SizedBox(
                height: 70, // Fixed height for consistency during transitions
                width: double.infinity,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Text(
                    currentDhikr.arabic,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: textTheme.displayMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            if (settings.showArabic &&
                (settings.showTransliteration || settings.showTranslation))
              const SizedBox(height: 12),
            if (settings.showTransliteration)
              Text(
                currentDhikr.transliteration,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface.withValues(alpha: 0.8),
                  letterSpacing: 0.2,
                ),
              ),
            if (settings.showTransliteration && settings.showTranslation)
              const SizedBox(height: 8),
            if (settings.showTranslation)
              Text(
                currentDhikr.translation,
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.visible,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                  fontStyle: FontStyle.italic,
                  height: 1.4,
                ),
              ),
            const SizedBox(height: 24),
            InkWell(
              onTap: () => DhikrSelectionSheet.show(context),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  Icons.more_horiz_rounded,
                  size: 16,
                  color: colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
