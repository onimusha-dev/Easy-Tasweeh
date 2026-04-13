import 'package:flutter/material.dart';

/// A settings tile with a labelled slider for controlling vibration intensity.
///
/// [label]     – displayed as the tile title, e.g. "Tap Vibration"
/// [subtitle]  – short description
/// [icon]      – leading icon
/// [value]     – current amplitude (1–255)
/// [onChanged] – called whenever the slider moves (live preview friendly)
/// [onChangedEnd] – called when the user lifts the finger (persist here)
class VibrationIntensityTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final int value;
  final ValueChanged<int> onChanged;
  final ValueChanged<int>? onChangedEnd;

  const VibrationIntensityTile({
    super.key,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
    this.onChangedEnd,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          dense: true,
          visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: scheme.primary, size: 18),
          ),
          title: Text(
            label,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.5,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: scheme.outline,
              fontSize: textTheme.bodySmall?.fontSize,
            ),
          ),
          trailing: _IntensityBadge(value: value),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 60, right: 24, bottom: 8),
          child: Row(
            children: [
              Icon(
                Icons.vibration_rounded,
                size: 14,
                color: scheme.outline,
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3,
                    thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 7),
                    overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 16),
                  ),
                  child: Slider(
                    min: 1,
                    max: 255,
                    divisions: 50,
                    value: value.toDouble(),
                    onChanged: (v) => onChanged(v.round()),
                    onChangeEnd: onChangedEnd != null
                        ? (v) => onChangedEnd!(v.round())
                        : null,
                  ),
                ),
              ),
              Icon(
                Icons.vibration_rounded,
                size: 20,
                color: scheme.outline,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _IntensityBadge extends StatelessWidget {
  final int value;
  const _IntensityBadge({required this.value});

  String get _label {
    if (value <= 64) return 'LIGHT';
    if (value <= 150) return 'MEDIUM';
    if (value <= 210) return 'STRONG';
    return 'MAX';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: scheme.primaryContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.25)),
      ),
      child: Text(
        _label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              color: scheme.primary,
            ),
      ),
    );
  }
}
