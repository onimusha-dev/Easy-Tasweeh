class DhikrReference {
  final String text;
  final String source;

  const DhikrReference({required this.text, required this.source});
}

abstract class DhikrItem {
  String get id;
  String get arabic;
  String get transliteration;
  String get translation;
  String? get category;
  String? get benefit;
  String? get explanation;
  List<DhikrReference>? get references;

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
  @override
  final String? explanation;
  @override
  final List<DhikrReference>? references;

  const BaseDhikrItem({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.translation,
    this.category,
    this.benefit,
    this.explanation,
    this.references,
  });
}

const List<DhikrItem> dhikrList = [
  BaseDhikrItem(
    id: 'subhanallah',
    arabic: 'سُبْحَانَ اللَّهِ',
    transliteration: 'SubhanAllah',
    translation: 'Glory be to Allah',
    category: 'Praise',
    benefit: 'Purifies the heart and recognizes Allah\'s perfection.',
    explanation:
        'SubhanAllah is a declaration of Allah\'s perfection. It means that Allah is far removed from any imperfection, deficiency, or need. When we say it, we are acknowledging that He is the Creator who is flawless in His wisdom and actions.',
    references: [
      DhikrReference(
        text: 'Exalt the name of your Lord, the Most High.',
        source: 'Al-A\'la 87:1',
      ),
      DhikrReference(
        text: 'Everything in the heavens and the earth glorifies Allah.',
        source: 'Al-Jumu\'ah 62:1',
      ),
    ],
  ),
  BaseDhikrItem(
    id: 'alhamdulillah',
    arabic: 'الْحَمْدُ لِلَّهِ',
    transliteration: 'Alhamdulillah',
    translation: 'All praise be to Allah',
    category: 'Gratitude',
    benefit: 'Increases blessings and cultivates gratitude.',
    explanation:
        'Alhamdulillah is the ultimate expression of gratitude. It recognizes that every single blessing—big or small—comes from Allah. It is not just a thank you, but an acknowledgement that He alone is worthy of all praise regardless of our circumstances.',
    references: [
      DhikrReference(
        text: 'All praise is due to Allah, Lord of the worlds.',
        source: 'Al-Fatihah 1:2',
      ),
      DhikrReference(
        text: 'If you are grateful, I will surely increase you [in favor].',
        source: 'Ibrahim 14:7',
      ),
    ],
  ),
  BaseDhikrItem(
    id: 'allahu_akbar',
    arabic: 'اللَّهُ أَكْبَرُ',
    transliteration: 'Allahu Akbar',
    translation: 'Allah is the Greatest',
    category: 'Greatness',
    benefit: 'Reminds us that Allah is greater than all worries.',
    explanation:
        'Allahu Akbar is a powerful reminder that no matter how big our problems or ambitions seem, Allah is greater. It humbles the human soul and brings perspective, shifting our focus from the creation to the Creator.',
    references: [
      DhikrReference(
        text: '...and the remembrance of Allah is greater.',
        source: 'Al-Ankabut 29:45',
      ),
      DhikrReference(
        text: 'And your Lord glorify.',
        source: 'Al-Muddathir 74:3',
      ),
    ],
  ),
  BaseDhikrItem(
    id: 'la_ilaha_illallah',
    arabic: 'لَا إِلَٰهَ إِلَّا اللَّهُ',
    transliteration: 'La ilaha illallah',
    translation: 'There is no god but Allah',
    category: 'Faith',
    benefit: 'The key to Paradise and the foundation of faith.',
    explanation:
        'This is the Kalimah (statement) of Tawheed, the very foundation of Islam. It is a rejection of all false deities and an affirmation that only Allah has the right to be worshipped, obeyed, and loved ultimately.',
    references: [
      DhikrReference(
        text: 'So know, [O Muhammad], that there is no deity except Allah.',
        source: 'Muhammad 47:19',
      ),
      DhikrReference(
        text: 'Allah—there is no deity except Him, the Ever-Living, the Sustainer of existence.',
        source: 'Al-Baqarah 2:255',
      ),
    ],
  ),
  BaseDhikrItem(
    id: 'astaghfirullah',
    arabic: 'أَسْتَغْفِرُ اللَّهَ',
    transliteration: 'Astaghfirullah',
    translation: 'I seek forgiveness from Allah',
    category: 'Forgiveness',
    benefit: 'Opens the doors of mercy and provision.',
    explanation:
        'Istighfar (seeking forgiveness) is a way to cleanse the soul. It is an admission of our human flaws and a turn towards the infinite mercy of Allah. It brings peace to the heart and relief from the burden of sins.',
    references: [
      DhikrReference(
        text: '...Ask forgiveness of your Lord. Indeed, He is ever a Perpetual Forgiver.',
        source: 'Nuh 71:10',
      ),
      DhikrReference(
        text: 'And seek forgiveness of Allah. Indeed, Allah is ever Forgiving and Merciful.',
        source: 'An-Nisa 4:106',
      ),
    ],
  ),
  BaseDhikrItem(
    id: 'la_hawla',
    arabic: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
    transliteration: 'La hawla wa la quwwata illa billah',
    translation: 'There is no power except with Allah',
    category: 'Submission',
    benefit: 'A treasure from the treasures of Paradise.',
    explanation:
        'This phrase is an expression of complete reliance on Allah (Tawakkul). It means we have no ability to move from one state to another, nor any power to perform any act, except through the help and will of Allah.',
    references: [
      DhikrReference(
        text: 'It is a treasure from the treasures of Paradise.',
        source: 'Sahih Bukhari',
      ),
      DhikrReference(
        text: 'And whoever relies upon Allah—then He is sufficient for him.',
        source: 'At-Talaq 65:3',
      ),
    ],
  ),
  BaseDhikrItem(
    id: 'salawat',
    arabic: 'صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ',
    transliteration: 'Sallallahu Alayhi wa Sallam',
    translation: 'May Allah bless him and grant him peace',
    category: 'Blessings',
    benefit: 'Brings blessings to the person reciting it.',
    explanation:
        'Sending Salawat upon the Prophet Muhammad (PBUH) is a divine command. It shows our love for him and our appreciation for his guidance. For every one blessing we send, Allah sends ten blessings upon us.',
    references: [
      DhikrReference(
        text: 'Indeed, Allah and His angels send blessings upon the Prophet. O you who have believed, ask [Allah to confer] blessing upon him and ask [Allah to grant him] peace.',
        source: 'Al-Ahzab 33:56',
      ),
    ],
  ),
  BaseDhikrItem(
    id: 'bismillah',
    arabic: 'بِسْمِ اللَّهِ',
    transliteration: 'Bismillah',
    translation: 'In the name of Allah',
    category: 'Start',
    benefit: 'Brings barakah (blessing) to any task started.',
    explanation:
        'Starting with Bismillah connects our mundane actions to the Divine. It transforms ordinary tasks into acts of worship and invites Allah\'s presence and blessings into whatever we are about to do.',
    references: [
      DhikrReference(
        text: 'Recite in the name of your Lord who created.',
        source: 'Al-Alaq 96:1',
      ),
    ],
  ),
  BaseDhikrItem(
    id: 'ar_rahman',
    arabic: 'الرَّحْمَنُ',
    transliteration: 'Ar-Rahmaan',
    translation: 'The Beneficent',
    category: 'Names of Allah',
    explanation:
        'Allah, Ar-Rahmaan, bestows His Mercy (Rahmah) upon all the creatures in this universe.',
    references: [
      DhikrReference(
        text: 'In the name of Allah, the Beneficent, the Merciful.',
        source: 'Al-Fatihah 1:1',
      ),
      DhikrReference(
        text:
            'There is none in the heavens and the earth but cometh unto the Beneficent as a slave.',
        source: 'Maryam 19:93',
      ),
      DhikrReference(
        text: 'The Beneficent One, Who is established on the Throne.',
        source: 'Taha 20:5',
      ),
    ],
  ),
];
