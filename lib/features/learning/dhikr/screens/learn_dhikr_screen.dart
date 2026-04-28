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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Learn Dhikr', style: textTheme.titleLarge),
              centerTitle: true,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
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
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          _filteredDhikrs.isEmpty
              ? const SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyState(
                    icon: Icons.search_off_rounded,
                    message: 'No dhikrs found',
                  ),
                )
              : SliverToBoxAdapter(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: _filteredDhikrs.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        indent: 60,
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
        ],
      ),
    );
  }
}
