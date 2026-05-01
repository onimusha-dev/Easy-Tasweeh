import 'package:easy_tasbeeh/core/theme/app_layout.dart';
import 'package:easy_tasbeeh/core/widgets/app_list_tile.dart';
import 'package:easy_tasbeeh/core/widgets/app_section.dart';
import 'package:flutter/material.dart';

class LearningSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const LearningSection({
    super.key,
    this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return AppSection(
      title: title,
      isLargeTitle: false,
      children: children,
    );
  }
}

class LearningTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;
  final VoidCallback? onTap;

  const LearningTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppListTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      iconColor: iconColor,
      onTap: onTap,
      showChevron: true,
      margin: const EdgeInsets.only(bottom: AppLayout.spaceTileGap),
    );
  }
}
