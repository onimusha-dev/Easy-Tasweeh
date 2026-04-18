import 'package:easy_tasweeh/core/models/dhikr_model.dart';
import 'package:easy_tasweeh/core/service/settings_provider.dart';
import 'package:easy_tasweeh/features/counter/dhikr_selection_sheet/dhikr_selection_sheet.dart';
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

    return Center(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.05),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: Column(
          key: ValueKey(currentDhikr.arabic),
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (settings.showArabic)
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  currentDhikr.arabic,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 48,
                    color: colorScheme.onSurface,
                    height: 1.4,
                    letterSpacing: 0,
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
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: colorScheme.onSurface,
                  letterSpacing: 0.5,
                ),
              ),
            if (settings.showTransliteration && settings.showTranslation)
              const SizedBox(height: 6),
            if (settings.showTranslation)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  '"${currentDhikr.translation}"',
                  textAlign: TextAlign.center,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.outline,
                    fontStyle: FontStyle.italic,
                    height: 1.3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.visible,
                ),
              ),
            const SizedBox(height: 24),
            IconButton(
              onPressed: () => DhikrSelectionSheet.show(context),
              icon: const Icon(Icons.swap_horiz_rounded, size: 24),

              //   label: const Text('Change Dhikr'),
              style: IconButton.styleFrom(
                foregroundColor: colorScheme.primary,
                // textStyle: textTheme.labelLarge?.copyWith(
                //   fontWeight: FontWeight.bold,
                //   letterSpacing: 1.1,
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
