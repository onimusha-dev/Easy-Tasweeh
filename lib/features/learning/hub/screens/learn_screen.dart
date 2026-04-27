import 'package:easy_tasbeeh/core/theme/schemes/app_colors.dart';
import 'package:easy_tasbeeh/features/learning/dhikr/screens/learn_dhikr_screen.dart';
import 'package:easy_tasbeeh/features/learning/hub/widgets/featured_tip.dart';
import 'package:easy_tasbeeh/features/learning/sayings/screens/prophet_saying_screen.dart';
import 'package:easy_tasbeeh/features/settings/widgets/settings_tiles.dart';
import 'package:flutter/material.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text('Learning Hub', style: textTheme.titleLarge),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          Text(
            'EXPLORE & LEARN',
            style: textTheme.labelSmall?.copyWith(color: colorScheme.outline),
          ),

          const SizedBox(height: 16),

          buildSettingsGroup(
            context,
            children: [
              buildSettingTile(
                context,
                icon: Icons.menu_book_rounded,
                iconColor: AppIconColors.green(context),
                title: 'Learn Dhikr',
                subtitle:
                    'Master the common dhikrs, their meanings and virtues',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LearnDhikrScreen(),
                    ),
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
                    MaterialPageRoute(
                      builder: (context) => const ProphetSayingScreen(),
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 32),

          const FeaturedTip(),
        ],
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(
      height: 1,
      indent: 64,
      endIndent: 20,
      color: Theme.of(
        context,
      ).colorScheme.outlineVariant.withValues(alpha: 0.3),
    );
  }
}
