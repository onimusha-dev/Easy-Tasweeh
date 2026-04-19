import 'package:easy_tasweeh/core/service/settings_provider.dart';
import 'package:easy_tasweeh/features/counter/widgets/counter_button.dart';
import 'package:easy_tasweeh/features/settings/screens/appearance/widgets/counter_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PressBtnChangerPreviewScreen extends ConsumerStatefulWidget {
  const PressBtnChangerPreviewScreen({super.key});

  @override
  ConsumerState<PressBtnChangerPreviewScreen> createState() =>
      _PressBtnChangerPreviewScreenState();
}

class _PressBtnChangerPreviewScreenState
    extends ConsumerState<PressBtnChangerPreviewScreen> {
  PressButtonStyle? _selectedStyle;
  int _demoCount = 33;

  final List<Map<String, dynamic>> _availableStyles = [
    {'name': 'Classic Wavy', 'style': PressButtonStyle.first},
    {'name': 'Modern Ring', 'style': PressButtonStyle.second},
    {'name': 'Glass Square', 'style': PressButtonStyle.third},
    {'name': 'Teal Circular', 'style': PressButtonStyle.tealCircular},
    {'name': 'Slate Rounded', 'style': PressButtonStyle.slateRounded},
    {'name': 'Amber Gradient', 'style': PressButtonStyle.amberGradient},
    {'name': 'Purple Outlined', 'style': PressButtonStyle.purpleOutlined},
    {'name': 'Coral Soft', 'style': PressButtonStyle.coralSoft},
    {'name': 'Midnight Glass', 'style': PressButtonStyle.midnightGlass},
    {'name': 'Neon Glow', 'style': PressButtonStyle.neonGlow},
    {'name': 'Emerald Minimal', 'style': PressButtonStyle.emeraldMinimal},
    {'name': 'Royal Gold', 'style': PressButtonStyle.royalGold},
  ];

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final activeStyle = _selectedStyle ?? settings.pressButtonStyle;
    final hasChanges = activeStyle != settings.pressButtonStyle;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Button Styles',
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          CounterPreview(
            selectedBackground: settings.background,
            backgroundOpacity: settings.backgroundOpacity,
            count: _demoCount,
            previewStyle: activeStyle,
            onTap: () => setState(() => _demoCount++),
          ),

          // Fixed Header Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 16, 8),
            child: SizedBox(
              height: 48, // Consistent height
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CHOOSE BUTTON STYLE',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  if (hasChanges)
                    TextButton(
                      onPressed: () async {
                        await ref
                            .read(settingsProvider.notifier)
                            .setPressButtonStyle(activeStyle);
                        if (mounted) {
                          setState(() => _selectedStyle = null);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Button style updated!'),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'SAVE',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 60), // Fixed width placeholder
                ],
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: _buildStyleGrid(activeStyle),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStyleGrid(PressButtonStyle activeStyle) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.1,
      ),
      itemCount: _availableStyles.length,
      itemBuilder: (context, index) {
        final item = _availableStyles[index];
        final style = item['style'] as PressButtonStyle;
        final isSelected = activeStyle == style;
        final colorScheme = Theme.of(context).colorScheme;

        return GestureDetector(
          onTap: () => setState(() => _selectedStyle = style),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? colorScheme.primary.withValues(alpha: 0.05)
                  : colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.outlineVariant.withValues(alpha: 0.3),
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 56,
                        height: 56,
                        child: IgnorePointer(
                          child: CounterButton(
                            onTap: () {},
                            previewStyle: style,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item['name']!.toUpperCase(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontSize: 9,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
