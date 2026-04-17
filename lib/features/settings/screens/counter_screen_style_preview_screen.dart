import 'package:easy_tasweeh/core/service/settings_provider.dart';
import 'package:easy_tasweeh/features/counter/increase_count_tap_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CounterScreenStylePreviewScreen extends ConsumerStatefulWidget {
  const CounterScreenStylePreviewScreen({super.key});

  @override
  ConsumerState<CounterScreenStylePreviewScreen> createState() =>
      _CounterScreenStylePreviewScreenState();
}

class _CounterScreenStylePreviewScreenState
    extends ConsumerState<CounterScreenStylePreviewScreen> {
  String? _selectedBackground;
  int _demoCount = 33;

  final List<Map<String, String>> _availableBackgrounds = [
    {'name': 'Ocean Mist', 'path': 'assets/images/bg/bg-1.png'},
    {'name': 'Emerald Forest', 'path': 'assets/images/bg/bg-2.png'},
    {'name': 'Dusk Rose', 'path': 'assets/images/bg/bg-3.png'},
    {'name': 'manhaten', 'path': 'assets/images/bg/bg-4.png'},
    {'name': 'fire craket', 'path': 'assets/images/bg/bg-5.png'},
    {'name': 'nebula', 'path': 'assets/images/bg/bg-6.png'},
    {'name': 'lamon', 'path': 'assets/images/bg/bg-7.png'},
  ];

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final activeBg = _selectedBackground ?? settings.background;
    final hasChanges = activeBg != settings.background;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Live Preview',
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
                    .setBackground(activeBg);
                if (mounted) {
                  setState(() => _selectedBackground = null);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Appearance updated!')),
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
            selectedBackground: activeBg,
            backgroundOpacity: settings.backgroundOpacity,
            count: _demoCount,
            onTap: () => setState(() => _demoCount++),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Backgrounds',
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
                  _buildBackgroundGrid(activeBg),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundGrid(String activeBg) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: _availableBackgrounds.length,
      itemBuilder: (context, index) {
        final bg = _availableBackgrounds[index];
        final isSelected = activeBg == bg['path'];
        final colorScheme = Theme.of(context).colorScheme;

        return GestureDetector(
          onTap: () => setState(() => _selectedBackground = bg['path']),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outlineVariant,
                      width: isSelected ? 3 : 1,
                    ),
                    image: DecorationImage(
                      image: AssetImage(bg['path']!),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Icon(
                            Icons.check_circle,
                            color: colorScheme.primary,
                          ),
                        )
                      : null,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                bg['name']!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected
                      ? colorScheme.primary
                      : colorScheme.onSurface,
                ),
              ),
            ],
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
  final VoidCallback onTap;

  const _CounterScreenStylePreview({
    required this.selectedBackground,
    required this.backgroundOpacity,
    required this.count,
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
                child: IncreaseCountTapButton(onTap: onTap),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
