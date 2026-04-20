import 'package:easy_tasweeh/core/theme/schemes/app_colors.dart';
import 'package:easy_tasweeh/features/learning/dhikr/screens/learn_dhikr_screen.dart';
import 'package:easy_tasweeh/features/learning/sayings/screens/prophet_saying_screen.dart';
import 'package:easy_tasweeh/features/settings/widgets/settings_tiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text('Learning Hub', style: textTheme.titleMedium),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          Text(
            'EXPLORE & LEARN',
            style: textTheme.labelSmall?.copyWith(
              color: colorScheme.outline,
              letterSpacing: 2.0,
              fontWeight: FontWeight.w900,
            ),
          ).animate().fadeIn().slideX(begin: -0.1),
          
          const SizedBox(height: 16),
          
          buildSettingsGroup(
            context,
            children: [
              buildSettingTile(
                context,
                icon: Icons.menu_book_rounded,
                iconColor: AppIconColors.green(context),
                title: 'Learn Dhikr',
                subtitle: 'Master the common dhikrs, their meanings and virtues',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LearnDhikrScreen()),
                  );
                },
              ),
              _buildDivider(context),
              buildSettingTile(
                context,
                icon: Icons.auto_awesome_rounded,
                iconColor: AppIconColors.amber(context),
                title: 'Prophet\'s Sayings',
                subtitle: 'Authentic hadiths about the rewards of remembrance',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProphetSayingScreen()),
                  );
                },
              ),
            ],
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
          
          const SizedBox(height: 32),
          
          _buildFeaturedTip(context),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      indent: 64,
      endIndent: 20,
      color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3),
    );
  }

  Widget _buildFeaturedTip(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppIconColors.blue(context).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppIconColors.blue(context).withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline_rounded, color: AppIconColors.blue(context), size: 20),
              const SizedBox(width: 12),
              Text(
                'DAILY TIP',
                style: textTheme.labelSmall?.copyWith(
                  color: AppIconColors.blue(context),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'The best way to remember Allah is through constant, small acts of devotion throughout your day. Consistency is the key to a tranquil heart.',
            style: textTheme.bodyMedium?.copyWith(
              height: 1.6,
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).scale(begin: const Offset(0.98, 0.98));
  }
}
