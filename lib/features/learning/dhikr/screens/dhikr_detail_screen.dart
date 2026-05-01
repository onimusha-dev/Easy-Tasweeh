import 'package:easy_tasbeeh/core/models/dhikr_model.dart';
import 'package:easy_tasbeeh/core/theme/app_typography.dart';
import 'package:easy_tasbeeh/core/utils/dhikr_utils.dart';
import 'package:easy_tasbeeh/core/widgets/app_card.dart';
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
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(context, item, accentColor),
            const SizedBox(height: 16),
            _buildDictionaryEntry(context, item),
            const SizedBox(height: 16),
            if (item.explanation != null) ...[
              _buildSection(context, 'EXPLANATION', item.explanation!, accentColor),
              const SizedBox(height: 16),
            ],
            if (item.references != null && item.references!.isNotEmpty) ...[
              _buildReferenceSection(context, item.references!, accentColor),
              const SizedBox(height: 16),
            ],
            if (item.benefit != null)
              _buildSection(context, 'VIRTUES & BENEFITS', item.benefit!, accentColor),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    String content,
    Color accentColor,
  ) {
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.labelSmall?.copyWith(
              color: accentColor,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),
          SelectableText(
            content,
            style: textTheme.bodyLarge?.copyWith(height: 1.6),
          ),
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

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'REFERENCE',
            style: textTheme.labelSmall?.copyWith(
              color: accentColor,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 16),
          ...references.asMap().entries.map((entry) {
            final index = entry.key;
            final ref = entry.value;
            return Column(
              children: [
                if (index > 0) ...[
                  const SizedBox(height: 16),
                  Divider(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.1),
                    height: 1,
                  ),
                  const SizedBox(height: 16),
                ],
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.format_quote_rounded,
                          color: accentColor.withValues(alpha: 0.2),
                          size: 24,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SelectableText(
                            ref.text,
                            style: textTheme.bodyLarge?.copyWith(
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      ref.source,
                      style: textTheme.labelLarge?.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHeroSection(
    BuildContext context,
    DhikrItem item,
    Color accentColor,
  ) {
    return AppCard(
      backgroundColor: accentColor.withValues(alpha: 0.05),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Center(
        child: SelectableText(
          item.arabic,
          textAlign: TextAlign.center,
          style: AppTypography.arabicDisplay(accentColor),
        ),
      ),
    );
  }

  Widget _buildDictionaryEntry(BuildContext context, DhikrItem item) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AppCard(
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
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (item.category != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item.category!.toUpperCase(),
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          SelectableText(
            item.translation,
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.7),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
