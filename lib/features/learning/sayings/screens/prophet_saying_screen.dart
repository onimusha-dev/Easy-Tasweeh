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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: colorScheme.surface,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('Prophet\'s Sayings', style: textTheme.titleLarge),
              centerTitle: true,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
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
          _filteredHadiths.isEmpty
              ? const SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptyState(
                    icon: Icons.search_off_rounded,
                    message: 'No sayings found',
                  ),
                )
              : SliverToBoxAdapter(
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: _filteredHadiths.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                        indent: 56,
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.3,
                        ),
                      ),
                      itemBuilder: (context, index) {
                        return SayingTile(
                          item: _filteredHadiths[index],
                          index: index + 1,
                          isLast: index == _filteredHadiths.length - 1,
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
