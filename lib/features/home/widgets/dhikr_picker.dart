import 'package:flutter/material.dart';

class DhikrItem {
  final String arabic;
  final String transliteration;
  final String translation;

  const DhikrItem({
    required this.arabic,
    required this.transliteration,
    required this.translation,
  });
}

const _dhikrList = [
  DhikrItem(
    arabic: 'سُبْحَانَ اللَّهِ',
    transliteration: 'SubhanAllah',
    translation: 'Glory be to Allah',
  ),
  DhikrItem(
    arabic: 'الْحَمْدُ لِلَّهِ',
    transliteration: 'Alhamdulillah',
    translation: 'All praise be to Allah',
  ),
  DhikrItem(
    arabic: 'اللَّهُ أَكْبَرُ',
    transliteration: 'Allahu Akbar',
    translation: 'Allah is the Greatest',
  ),
  DhikrItem(
    arabic: 'لَا إِلَٰهَ إِلَّا اللَّهُ',
    transliteration: 'La ilaha illallah',
    translation: 'There is no god but Allah',
  ),
  DhikrItem(
    arabic: 'أَسْتَغْفِرُ اللَّهَ',
    transliteration: 'Astaghfirullah',
    translation: 'I seek forgiveness from Allah',
  ),
  DhikrItem(
    arabic: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
    transliteration: 'La hawla wa la quwwata illa billah',
    translation: 'There is no power except with Allah',
  ),
  DhikrItem(
    arabic: 'صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ',
    transliteration: 'Sallallahu Alayhi wa Sallam',
    translation: 'May Allah bless him and grant him peace',
  ),
  DhikrItem(
    arabic: 'بِسْمِ اللَّهِ',
    transliteration: 'Bismillah',
    translation: 'In the name of Allah',
  ),
];

class DhikrPicker extends StatefulWidget {
  const DhikrPicker({super.key});

  @override
  State<DhikrPicker> createState() => _DhikrPickerState();
}

class _DhikrPickerState extends State<DhikrPicker> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'DHIKR',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: 2,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: _dhikrList.length,
            separatorBuilder: (context, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final item = _dhikrList[index];
              final isSelected = index == _selectedIndex;
              return GestureDetector(
                onTap: () => setState(() => _selectedIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  width: 130,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.outlineVariant,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        item.transliteration,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.onSurface,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.arabic,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isSelected
                              ? Theme.of(
                                  context,
                                ).colorScheme.onPrimary.withValues(alpha: 0.8)
                              : Theme.of(context).colorScheme.outline,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.translation,
                        style: TextStyle(
                          fontSize: 9,
                          color: isSelected
                              ? Theme.of(
                                  context,
                                ).colorScheme.onPrimary.withValues(alpha: 0.6)
                              : Theme.of(context).colorScheme.outline,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
