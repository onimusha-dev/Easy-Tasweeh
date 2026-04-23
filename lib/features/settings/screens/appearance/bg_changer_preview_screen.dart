import 'package:easy_tasbeeh/core/models/appearance_data.dart';
import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:easy_tasbeeh/features/settings/screens/appearance/widgets/counter_preview.dart';
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

          // Fixed Header Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 16, 8),
            child: SizedBox(
              height: 48, // Consistent height
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CHOOSE BACKGROUND',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.1,
                    ),
                  ),
                  if (hasChanges)
                    TextButton(
                      onPressed: () async {
                        final messenger = ScaffoldMessenger.of(context);
                        await ref
                            .read(settingsProvider.notifier)
                            .setBackground(activeBg);
                        if (mounted) {
                          setState(() => _selectedBackground = null);
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text('Appearance updated!'),
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
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _buildBackgroundGrid(activeBg),
                ),
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
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: availableBackgrounds.length,
      itemBuilder: (context, index) {
        final bg = availableBackgrounds[index];
        final isSelected = activeBg == bg.path;
        final colorScheme = Theme.of(context).colorScheme;

        return GestureDetector(
          onTap: () => setState(() => _selectedBackground = bg.path),
          child: Column(
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? colorScheme.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        if (bg.path.isEmpty)
                          Container(
                            color: colorScheme.surface,
                            child: Icon(
                              Icons.block_rounded,
                              color: colorScheme.outline.withValues(alpha: 0.3),
                              size: 24,
                            ),
                          )
                        else
                          Image.asset(bg.path, fit: BoxFit.cover),
                        if (isSelected)
                          Container(
                            color: colorScheme.primary.withValues(alpha: 0.2),
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check_rounded,
                                  color: colorScheme.primary,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                bg.name.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 8,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? colorScheme.primary : colorScheme.outline,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
