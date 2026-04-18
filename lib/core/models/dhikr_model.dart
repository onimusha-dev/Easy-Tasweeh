abstract class DhikrItem {
  String get id;
  String get arabic;
  String get transliteration;
  String get translation;
  String? get category;
  String? get benefit;

  const DhikrItem();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DhikrItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class BaseDhikrItem extends DhikrItem {
  @override
  final String id;
  @override
  final String arabic;
  @override
  final String transliteration;
  @override
  final String translation;
  @override
  final String? category;
  @override
  final String? benefit;

  const BaseDhikrItem({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    this.category,
    this.benefit,
  });
}

const List<DhikrItem> dhikrList = [
  BaseDhikrItem(
    id: 'subhanallah',
    arabic: 'سُبْحَانَ اللَّهِ',
    transliteration: 'SubhanAllah',
    translation: 'Glory be to Allah',
    benefit: 'Purifies the heart and recognizes Allah\'s perfection.',
    category: 'Praise',
  ),
  BaseDhikrItem(
    id: 'alhamdulillah',
    arabic: 'الْحَمْدُ لِلَّهِ',
    transliteration: 'Alhamdulillah',
    translation: 'All praise be to Allah',
    benefit: 'Increases blessings and cultivates gratitude.',
    category: 'Gratitude',
  ),
  BaseDhikrItem(
    id: 'allahu_akbar',
    arabic: 'اللَّهُ أَكْبَرُ',
    transliteration: 'Allahu Akbar',
    translation: 'Allah is the Greatest',
    benefit: 'Reminds us that Allah is greater than all worries.',
    category: 'Greatness',
  ),
  BaseDhikrItem(
    id: 'la_ilaha_illallah',
    arabic: 'لَا إِلَٰهَ إِلَّا اللَّهُ',
    transliteration: 'La ilaha illallah',
    translation: 'There is no god but Allah',
    benefit: 'The key to Paradise and the foundation of faith.',
    category: 'Faith',
  ),
  BaseDhikrItem(
    id: 'astaghfirullah',
    arabic: 'أَسْتَغْفِرُ اللَّهَ',
    transliteration: 'Astaghfirullah',
    translation: 'I seek forgiveness from Allah',
    benefit: 'Opens the doors of mercy and provision.',
    category: 'Forgiveness',
  ),
  BaseDhikrItem(
    id: 'la_hawla',
    arabic: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
    transliteration: 'La hawla wa la quwwata illa billah',
    translation: 'There is no power except with Allah',
    benefit: 'A treasure from the treasures of Paradise.',
    category: 'Submission',
  ),
  BaseDhikrItem(
    id: 'salawat',
    arabic: 'صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ',
    transliteration: 'Sallallahu Alayhi wa Sallam',
    translation: 'May Allah bless him and grant him peace',
    benefit: 'Brings blessings to the person reciting it.',
    category: 'Blessings',
  ),
  BaseDhikrItem(
    id: 'bismillah',
    arabic: 'بِسْمِ اللَّهِ',
    transliteration: 'Bismillah',
    translation: 'In the name of Allah',
    benefit: 'Brings barakah (blessing) to any task started.',
    category: 'Start',
  ),
];
