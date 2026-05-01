import 'package:easy_tasbeeh/core/theme/app_layout.dart';
import 'package:easy_tasbeeh/core/theme/schemes/app_colors.dart';
import 'package:easy_tasbeeh/features/learning/dhikr/screens/learn_dhikr_screen.dart';
import 'package:easy_tasbeeh/features/learning/hub/widgets/featured_tip.dart';
import 'package:easy_tasbeeh/features/learning/sayings/screens/prophet_saying_screen.dart';
import 'package:easy_tasbeeh/features/learning/hub/widgets/learning_widgets.dart';
import 'package:flutter/material.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Learning Hub',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: AppLayout.screenPadding,
        children: const [_LearningCategories(), FeaturedTip()],
      ),
    );
  }
}

class _LearningCategories extends StatelessWidget {
  const _LearningCategories();

  @override
  Widget build(BuildContext context) {
    return LearningSection(
      title: 'EXPLORE & LEARN',
      children: [
        LearningTile(
          icon: Icons.menu_book_rounded,
          iconColor: AppIconColors.green(context),
          title: 'Learn Dhikr',
          subtitle: 'Master the common dhikrs, their meanings and virtues',
          onTap: () => _push(context, const LearnDhikrScreen()),
        ),
        LearningTile(
          icon: Icons.auto_awesome_rounded,
          iconColor: AppIconColors.amber(context),
          title: 'Prophet\'s Sayings',
          subtitle: 'Authentic hadiths about the rewards of remembrance',
          onTap: () => _push(context, const ProphetSayingScreen()),
        ),
      ],
    );
  }

  void _push(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}
