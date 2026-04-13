import 'package:flutter/material.dart';

class TasweehScreen extends StatelessWidget {
  const TasweehScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'LEARN TASWEEH',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildHeroSection(context),
          const SizedBox(height: 32),
          _buildTasweehCard(
            context,
            title: 'SubhanAllah',
            arabic: 'سُبْحَانَ ٱللَّٰهِ',
            transliteration: 'Glory be to Allah',
            benefit: 'Purifies the heart and recognizes Allah\'s perfection.',
            icon: Icons.auto_awesome_rounded,
          ),
          const SizedBox(height: 16),
          _buildTasweehCard(
            context,
            title: 'Alhamdulillah',
            arabic: 'ٱلْحَمْدُ لِلَّٰهِ',
            transliteration: 'Praise be to Allah',
            benefit: 'Increases blessings and cultivates gratitude.',
            icon: Icons.favorite_rounded,
          ),
          const SizedBox(height: 16),
          _buildTasweehCard(
            context,
            title: 'Allahu Akbar',
            arabic: 'ٱللَّٰهُ أَكْبَرُ',
            transliteration: 'Allah is the Greatest',
            benefit: 'Reminds us that Allah is greater than all worries.',
            icon: Icons.security_rounded,
          ),
          const SizedBox(height: 32),
          _buildInfoSection(context),
        ],
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(
          context,
        ).colorScheme.primaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.menu_book_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 12),
              Text(
                'WHAT IS DHIKR?',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Dhikr is the remembrance of Allah. It is a spiritual exercise that brings tranquility to the soul and strengthens your connection with the Creator.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.6,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasweehCard(
    BuildContext context, {
    required String title,
    required String arabic,
    required String transliteration,
    required String benefit,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(
            context,
          ).colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      icon,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    title.toUpperCase(),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
              child: Column(
                children: [
                  Text(
                    arabic,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontFamily: 'Amiri',
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    transliteration.toUpperCase(),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                benefit,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TASWEEH FATIMA',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 12),
        Text(
          'It is highly recommended to recite:\n• 33 times SubhanAllah\n• 33 times Alhamdulillah\n• 34 times Allahu Akbar\n\nTotaling 100 recitations, often performed after daily prayers.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            height: 1.6,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }
}
