import "package:easy_tasbeeh/features/counter/screens/combo_selection_screen.dart";
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CounterAppBar extends ConsumerWidget implements PreferredSizeWidget {
  final VoidCallback onShowLayoutDialog;

  const CounterAppBar({
    super.key,
    required this.onShowLayoutDialog,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        },
      ),
      actions: [
        IconButton(
          onPressed: onShowLayoutDialog,
          icon: const Icon(Icons.swap_vert_rounded),
          tooltip: 'Swap Layout',
        ),
        IconButton(
          onPressed: () => _openComboScreen(context),
          icon: const Icon(Icons.view_carousel),
          tooltip: 'Dhikr Collection',
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  void _openComboScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ComboSelectionScreen()),
    );
  }
}
