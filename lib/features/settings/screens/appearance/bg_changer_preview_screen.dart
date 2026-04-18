import 'package:easy_tasweeh/core/service/settings_provider.dart';
import 'package:easy_tasweeh/features/settings/screens/appearance/widgets/counter_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BgChangerPreviewScreen extends ConsumerStatefulWidget {
  const BgChangerPreviewScreen({super.key});

  @override
  ConsumerState<BgChangerPreviewScreen> createState() =>
      _BgChangerPreviewScreenState();
}

class _BgChangerPreviewScreenState
    extends ConsumerState<BgChangerPreviewScreen> {
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
          CounterPreview(
            selectedBackground: activeBg,
            backgroundOpacity: settings.backgroundOpacity,
            count: _demoCount,
            previewStyle: settings.pressButtonStyle,
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
