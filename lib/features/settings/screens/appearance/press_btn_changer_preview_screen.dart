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
        actions: [
          if (hasChanges)
            TextButton(
              onPressed: () async {
                await ref
                    .read(settingsProvider.notifier)
                    .setPressButtonStyle(activeStyle);
                if (mounted) {
                  setState(() => _selectedStyle = null);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Button style updated!')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          const SizedBox(width: 8),
        ],
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
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Styles',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStyleGrid(activeStyle),
                  const SizedBox(height: 32),
                ],
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
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: _availableStyles.length,
      itemBuilder: (context, index) {
        final item = _availableStyles[index];
        final style = item['style'] as PressButtonStyle;
        final isSelected = activeStyle == style;
        final colorScheme = Theme.of(context).colorScheme;

        return GestureDetector(
          onTap: () => setState(() => _selectedStyle = style),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.outlineVariant,
                width: isSelected ? 3 : 1,
              ),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: IgnorePointer(
                          child: CounterButton(
                            onTap: () {},
                            previewStyle: style,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item['name']!,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Icon(
                      Icons.check_circle,
                      size: 20,
                      color: colorScheme.primary,
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
