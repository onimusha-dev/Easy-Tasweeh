import 'package:easy_tasbeeh/core/models/dhikr_model.dart';
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Learn Dhikr',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchField(context),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
          _filteredDhikrs.isEmpty
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 64,
                          color: colorScheme.outlineVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No dhikrs found',
                          style: textTheme.bodyLarge?.copyWith(
                            color: colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: _filteredDhikrs.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        indent: 60,
                        endIndent: 16,
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.3,
                        ),
                      ),
                      itemBuilder: (context, index) {
                        return DhikrTile(
                          item: _filteredDhikrs[index],
                          index: index + 1,
                          isLast: index == _filteredDhikrs.length - 1,
                        );
                      },
                    ),
                  ),
                ),
          // ),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: _filterDhikrs,
        decoration: InputDecoration(
          hintText: 'Search dhikr...',
          hintStyle: TextStyle(color: colorScheme.outline),
          prefixIcon: Icon(Icons.search_rounded, color: colorScheme.outline),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close_rounded, color: colorScheme.outline),
                  onPressed: () {
                    _searchController.clear();
                    _filterDhikrs('');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
