import 'package:easy_tasweeh/core/service/settings_provider.dart';
import 'package:easy_tasweeh/features/counter/increase_count_tap_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PressBtnPreviewScreen extends ConsumerStatefulWidget {
  const PressBtnPreviewScreen({super.key});

  @override
  ConsumerState<PressBtnPreviewScreen> createState() =>
      _PressBtnPreviewScreenState();
}

class _PressBtnPreviewScreenState
    extends ConsumerState<PressBtnPreviewScreen> {
  PressButtonStyle? _selectedStyle;
  int _demoCount = 33;

  final List<Map<String, dynamic>> _availableStyles = [
    {'name': 'Classic Wavy', 'style': PressButtonStyle.first},
    {'name': 'Modern Ring', 'style': PressButtonStyle.second},
    {'name': 'Glass Style', 'style': PressButtonStyle.third},
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
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
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
          _CounterScreenStylePreview(
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
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
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
                          child: IncreaseCountTapButton(
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
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
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

class _CounterScreenStylePreview extends StatelessWidget {
  final String selectedBackground;
  final double backgroundOpacity;
  final int count;
  final PressButtonStyle previewStyle;
  final VoidCallback onTap;

  const _CounterScreenStylePreview({
    required this.selectedBackground,
    required this.backgroundOpacity,
    required this.count,
    required this.previewStyle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.45,
      width: size.width * 0.5,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: Container(
                key: ValueKey(selectedBackground),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(selectedBackground),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withValues(alpha: backgroundOpacity),
                      BlendMode.darken,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Badge
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'PREVIEW',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ),

          // Demo Button
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 44),
              Text(
                '$count',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'تقبل الله منا ومنكم',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w300,
                ),
              ),
              Text(
                'May Allah accept your dhikr',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
              const SizedBox(height: 44),
              SizedBox(
                width: 130,
                height: 130,
                child: IncreaseCountTapButton(
                  onTap: onTap,
                  previewStyle: previewStyle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}