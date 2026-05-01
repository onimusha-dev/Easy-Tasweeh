import 'package:easy_tasbeeh/core/models/dhikr_model.dart';
import 'package:easy_tasbeeh/core/service/settings/settings_state.dart';
import 'package:easy_tasbeeh/core/service/settings_provider.dart';
import 'package:easy_tasbeeh/features/counter/widgets/counter_button.dart';
import 'package:easy_tasbeeh/features/counter/widgets/counter_progress.dart';
import 'package:easy_tasbeeh/features/counter/widgets/dhikr_display.dart';
import 'package:flutter/material.dart';

class CounterLayout extends StatelessWidget {
  final SettingsState settings;
  final int current;
  final int target;
  final double progress;
  final DhikrItem currentDhikr;
  final VoidCallback? onIncrement;

  const CounterLayout({
    super.key,
    required this.settings,
    required this.current,
    required this.target,
    required this.progress,
    required this.currentDhikr,
    this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!settings.centerButton) ...[
                    Column(
                      children: [
                        CounterProgress(
                          colorScheme: colorScheme,
                          progress: progress,
                          textTheme: textTheme,
                          currentCountData: current,
                          targetCount: target,
                          settings: settings,
                        ),
                        const SizedBox(height: 16),
                        DhikrDisplay(currentDhikr: currentDhikr),
                      ],
                    ),
                    _buildCounterButton(settings),
                  ] else ...[
                    CounterProgress(
                      colorScheme: colorScheme,
                      progress: progress,
                      textTheme: textTheme,
                      currentCountData: current,
                      targetCount: target,
                      settings: settings,
                    ),
                    _buildCounterButton(settings),
                    DhikrDisplay(currentDhikr: currentDhikr),
                  ],
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCounterButton(SettingsState settings) {
    return SizedBox(
      width: settings.buttonSize,
      height: settings.buttonSize,
      child: CounterButton(
        onTap: onIncrement,
        previewStyle: settings.pressButtonStyle,
      ),
    );
  }
}
