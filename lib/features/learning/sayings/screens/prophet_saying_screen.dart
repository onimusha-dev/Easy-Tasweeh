import 'package:easy_tasbeeh/core/models/saying_model.dart';
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
              title: Text(
                'Prophet\'s Sayings',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_buildSearchField(context)],
              ),
            ),
          ),
          _filteredHadiths.isEmpty
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
                          'No sayings found',
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
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLow,
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
        onChanged: _filterHadiths,
        decoration: InputDecoration(
          hintText: 'Search sayings...',
          hintStyle: TextStyle(color: colorScheme.outline),
          prefixIcon: Icon(Icons.search_rounded, color: colorScheme.outline),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.close_rounded, color: colorScheme.outline),
                  onPressed: () {
                    _searchController.clear();
                    _filterHadiths('');
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
