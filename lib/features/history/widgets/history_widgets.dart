import 'package:easy_tasbeeh/core/widgets/app_section.dart';
import 'package:flutter/material.dart';

class HistorySection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const HistorySection({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return AppSection(
      title: title,
      isLargeTitle: true,
      padding: const EdgeInsets.only(bottom: 24),
      children: children,
    );
  }
}
