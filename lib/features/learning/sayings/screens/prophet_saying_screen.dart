import 'package:easy_tasbeeh/core/models/saying_model.dart';
import 'package:easy_tasbeeh/core/widgets/empty_state.dart';
import 'package:easy_tasbeeh/core/widgets/search_field.dart';
import 'package:easy_tasbeeh/features/learning/sayings/widgets/saying_tile.dart';
import 'package:flutter/material.dart';

class ProphetSayingScreen extends StatefulWidget {
  const ProphetSayingScreen({super.key});

  @override
  State<ProphetSayingScreen> createState() => _ProphetSayingScreenState();
}

class _ProphetSayingScreenState extends State<ProphetSayingScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<SayingItem> _filteredHadiths = hadiths;

  void _filterHadiths(String query) {
    setState(() {
      _filteredHadiths = hadiths
          .where(
            (item) =>
                item.content.toLowerCase().contains(query.toLowerCase()) ||
                item.source.toLowerCase().contains(query.toLowerCase()) ||
                (item.arabic?.contains(query) ?? false),
          )
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text('Prophet\'s Sayings', style: textTheme.titleMedium),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // The List (scrolls behind the search bar)
          _filteredHadiths.isEmpty
              ? const Center(
                  child: EmptyState(
                    icon: Icons.search_off_rounded,
                    message: 'No sayings found',
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 80, 16, 40),
                  itemCount: _filteredHadiths.length,
                  itemBuilder: (context, index) {
                    return SayingTile(
                      item: _filteredHadiths[index],
                      index: index + 1,
                      isLast: index == _filteredHadiths.length - 1,
                    );
                  },
                ),

          // Floating Glass Search Bar Area
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SearchField(
                controller: _searchController,
                hintText: 'Search sayings...',
                onChanged: _filterHadiths,
                onClear: () {
                  _searchController.clear();
                  _filterHadiths('');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
