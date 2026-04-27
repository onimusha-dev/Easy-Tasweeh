import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:easy_tasbeeh/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ColorSchemeSheet extends ConsumerWidget {
  const ColorSchemeSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ColorSchemeSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final schemes = [
      _SchemeOption(
        id: AppColorScheme.sage,
        name: 'Sage Garden',
        colors: isDark
            ? [
                const Color(0xFFA6CFB6),
                const Color(0xFFB8D0C0),
                const Color(0xFF2D4B39),
                const Color(0xFF141A17),
              ]
            : [
                const Color(0xFF5A7863),
                const Color(0xFF90AB8B),
                const Color(0xFFD8E4C0),
                const Color(0xFFEBF4DD),
              ],
      ),
      _SchemeOption(
        id: AppColorScheme.sunset,
        name: 'Sunset Glow',
        colors: [
          const Color(0xFFFF9B17), // Primary (Deep Orange)
          const Color(0xFFFCB454), // Secondary (Light Orange)
          const Color(0xFFFFF085), // Container (Yellow)
          const Color(0xFFF16767), // Surface/Accent (Coral)
        ],
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.onSurface.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Accent Colour',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: colorScheme.onSurface,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Personalize your tasbeeh experience',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.5,
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Scheme Options
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: schemes.map((option) {
                      final isSelected = settings.colorScheme == option.id;
                      final itemWidth =
                          (MediaQuery.of(context).size.width - 64) / 2 -
                          0.5; // Subtract a bit for sub-pixel precision

                      return InkWell(
                        onTap: () {
                          ref
                              .read(settingsProvider.notifier)
                              .setColorScheme(option.id);
                          Navigator.pop(context);
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: itemWidth,
                          padding: const EdgeInsets.fromLTRB(12, 24, 12, 16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? option.colors[0].withValues(alpha: 0.08)
                                : colorScheme.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected
                                  ? option.colors[0]
                                  : colorScheme.outlineVariant.withValues(
                                      alpha: 0.4,
                                    ),
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // 4 Small Circles at Corners
                              SizedBox(
                                width: 52,
                                height: 52,
                                child: Stack(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: _ColorDot(color: option.colors[0]),
                                    ),
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: _ColorDot(color: option.colors[1]),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: _ColorDot(color: option.colors[2]),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: _ColorDot(color: option.colors[3]),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                option.name,
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      color: isSelected
                                          ? option.colors[0]
                                          : colorScheme.onSurface,
                                      fontSize: 13,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;
  const _ColorDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}

class _SchemeOption {
  final AppColorScheme id;
  final String name;
  final List<Color> colors; // 4 colors: Primary, Secondary, Container, Surface

  _SchemeOption({required this.id, required this.name, required this.colors});
}
