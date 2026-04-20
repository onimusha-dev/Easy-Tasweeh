import 'package:easy_tasweeh/core/models/dhikr_model.dart';
import 'package:easy_tasweeh/core/theme/schemes/app_colors.dart';
import 'package:flutter/material.dart';

class DhikrDetailScreen extends StatelessWidget {
  final DhikrItem item;

  const DhikrDetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text('Dhikr Detail', style: textTheme.titleMedium),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero section (The "Word")
            _buildHeroSection(context, item),

            const SizedBox(height: 32),

            // 2. Dictionary Entry (Transliteration & Translation)
            _buildDictionaryEntry(context, item),

            const SizedBox(height: 40),

            // 3. Dictionary Commentary (Virtues & Benefits)
            if (item.benefit != null)
              _buildDictionaryBenefit(context, item.benefit!),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context, DhikrItem item) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SelectableText(
        item.arabic,
        textAlign: TextAlign.center,
        style: textTheme.displaySmall?.copyWith(
          fontSize: 40,
          height: 1.5,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDictionaryEntry(BuildContext context, DhikrItem item) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
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
                style: textTheme.headlineSmall?.copyWith(
                  fontSize: 22,
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.3,
                ),
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
              height: 1.5,
              fontSize: 17,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDictionaryBenefit(BuildContext context, String benefit) {
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
                color: colorScheme.primary,
                letterSpacing: 2.0,
                fontWeight: FontWeight.w700,
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
                color: AppIconColors.amber(context).withValues(alpha: 0.3),
                width: 2,
              ),
            ),
          ),
          child: SelectableText(
            benefit,
            style: textTheme.bodyLarge?.copyWith(
              height: 1.7,
              color: colorScheme.onSurfaceVariant,
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
