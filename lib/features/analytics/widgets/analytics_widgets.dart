import 'package:easy_tasbeeh/core/widgets/app_list_tile.dart';
import 'package:easy_tasbeeh/core/widgets/app_section.dart';
import 'package:flutter/material.dart';

class AnalyticsSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const AnalyticsSection({
    super.key,
    this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return AppSection(
      title: title,
      isLargeTitle: true,
      children: children,
    );
  }
}

class AnalyticsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;
  final String? value;

  const AnalyticsTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return AppListTile(
      icon: icon,
      title: title,
      subtitle: subtitle,
      iconColor: iconColor,
      trailingLabel: value,
      showChevron: false,
      margin: const EdgeInsets.only(bottom: 8),
    );
  }
}
