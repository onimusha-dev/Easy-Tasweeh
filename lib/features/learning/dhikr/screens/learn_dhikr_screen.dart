import 'package:easy_tasbeeh/core/models/dhikr_model.dart';
import 'package:easy_tasbeeh/core/widgets/empty_state.dart';
import 'package:easy_tasbeeh/core/widgets/search_field.dart';
import 'package:easy_tasbeeh/features/learning/dhikr/widgets/dhikr_tile.dart';
import 'package:flutter/material.dart';

class LearnDhikrScreen extends StatefulWidget {
  const LearnDhikrScreen({super.key});

  @override
  State<LearnDhikrScreen> createState() => _LearnDhikrScreenState();
}

class _LearnDhikrScreenState extends State<LearnDhikrScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<DhikrItem> _filteredDhikrs = dhikrList;

  void _filterDhikrs(String query) {
    setState(() {
      _filteredDhikrs = dhikrList
          .where(
            (item) =>
                item.transliteration.toLowerCase().contains(
                  query.toLowerCase(),
                ) ||
                item.translation.toLowerCase().contains(query.toLowerCase()) ||
                item.arabic.contains(query) ||
                (item.category?.toLowerCase().contains(query.toLowerCase()) ??
                    false),
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
        title: Text('Learn Dhikr', style: textTheme.titleMedium),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // The List (scrolls behind the search bar)
          _filteredDhikrs.isEmpty
              ? const Center(
                  child: EmptyState(
                    icon: Icons.search_off_rounded,
                    message: 'No dhikrs found',
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 80, 16, 40),
                  itemCount: _filteredDhikrs.length,
                  itemBuilder: (context, index) {
                    return DhikrTile(
                      item: _filteredDhikrs[index],
                      index: index + 1,
                      isLast: index == _filteredDhikrs.length - 1,
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
                hintText: 'Search dhikr...',
                onChanged: _filterDhikrs,
                onClear: () {
                  _searchController.clear();
                  _filterDhikrs('');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
