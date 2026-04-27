import 'package:easy_tasbeeh/core/models/dhikr_model.dart';
import 'package:easy_tasbeeh/core/theme/app_typography.dart';
import 'package:easy_tasbeeh/core/utils/dhikr_utils.dart';
import 'package:flutter/material.dart';

class DhikrDetailScreen extends StatelessWidget {
  final DhikrItem item;

  const DhikrDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final accentColor = DhikrUtils.getCategoryColor(context, item.category);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text('Dhikr Detail', style: textTheme.titleMedium),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero section (The "Word")
            _buildHeroSection(context, item, accentColor),

            const SizedBox(height: 20),

            // 2. Dictionary Entry (Transliteration & Translation)
            _buildDictionaryEntry(context, item),

            const SizedBox(height: 20),

            // 3. Explanation section
            if (item.explanation != null) ...[
              _buildExplanationSection(context, item.explanation!, accentColor),
              const SizedBox(height: 20),
            ],

            // 4. Reference section
            if (item.references != null && item.references!.isNotEmpty) ...[
              _buildReferenceSection(context, item.references!, accentColor),
              const SizedBox(height: 20),
            ],

            // 5. Dictionary Commentary (Virtues & Benefits)
            if (item.benefit != null)
              _buildDictionaryBenefit(context, item.benefit!, accentColor),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildExplanationSection(
    BuildContext context,
    String explanation,
    Color accentColor,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EXPLANATION',
            style: textTheme.labelSmall?.copyWith(
              color: accentColor.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),
          SelectableText(explanation, style: textTheme.bodyLarge),
        ],
      ),
    );
  }

  Widget _buildReferenceSection(
    BuildContext context,
    List<DhikrReference> references,
    Color accentColor,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'REFERENCE',
            style: textTheme.labelSmall?.copyWith(
              color: accentColor.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 16),
          ...references.asMap().entries.map((entry) {
            final index = entry.key;
            final ref = entry.value;
            return Column(
              children: [
                if (index > 0) ...[
                  const SizedBox(height: 24),
                  Divider(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                    height: 1,
                  ),
                  const SizedBox(height: 24),
                ],
                _buildReferenceItem(context, ref, accentColor),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildReferenceItem(
    BuildContext context,
    DhikrReference ref,
    Color accentColor,
  ) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.format_quote_rounded,
              color: accentColor.withValues(alpha: 0.3),
              size: 24,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SelectableText(
                ref.text,
                style: textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          ref.source,
          style: textTheme.labelLarge?.copyWith(color: accentColor),
        ),
      ],
    );
  }

  Widget _buildHeroSection(
    BuildContext context,
    DhikrItem item,
    Color accentColor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: accentColor.withValues(alpha: 0.1)),
      ),
      child: SelectableText(
        item.arabic,
        textAlign: TextAlign.center,
        style: AppTypography.arabicDisplay(accentColor),
      ),
    );
  }

  Widget _buildDictionaryEntry(BuildContext context, DhikrItem item) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 4,
            children: [
              SelectableText(
                item.transliteration,
                style: textTheme.headlineSmall,
              ),
              if (item.category != null)
                Text(
                  '(${item.category!.toLowerCase()})',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.primary,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 1.5,
            width: 32,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          SelectableText(
            item.translation,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDictionaryBenefit(
    BuildContext context,
    String benefit,
    Color accentColor,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'VIRTUES',
              style: textTheme.labelSmall?.copyWith(
                color: accentColor.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Divider(
                color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                thickness: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.only(left: 16),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: accentColor.withValues(alpha: 0.3),
                width: 3,
              ),
            ),
          ),
          child: SelectableText(
            benefit,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      ],
    );
  }
}
