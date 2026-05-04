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

// const List<DhikrItem> dhikrList = [
//   BaseDhikrItem(
//     id: 'subhanallah',
//     arabic: 'سُبْحَانَ اللَّهِ',
//     transliteration: 'SubhanAllah',
//     translation: 'Glory be to Allah',
//     category: 'Praise',
//     benefit: 'Purifies the heart and recognizes Allah\'s perfection.',
//     explanation:
//         'SubhanAllah is a declaration of Allah\'s perfection. It means that Allah is far removed from any imperfection, deficiency, or need. When we say it, we are acknowledging that He is the Creator who is flawless in His wisdom and actions.',
//     references: [
//       DhikrReference(
//         text: 'Exalt the name of your Lord, the Most High.',
//         source: 'Al-A\'la 87:1',
//       ),
//       DhikrReference(
//         text: 'Everything in the heavens and the earth glorifies Allah.',
//         source: 'Al-Jumu\'ah 62:1',
//       ),
//     ],
//   ),
//   BaseDhikrItem(
//     id: 'alhamdulillah',
//     arabic: 'الْحَمْدُ لِلَّهِ',
//     transliteration: 'Alhamdulillah',
//     translation: 'All praise be to Allah',
//     category: 'Gratitude',
//     benefit: 'Increases blessings and cultivates gratitude.',
//     explanation:
//         'Alhamdulillah is the ultimate expression of gratitude. It recognizes that every single blessing—big or small—comes from Allah. It is not just a thank you, but an acknowledgement that He alone is worthy of all praise regardless of our circumstances.',
//     references: [
//       DhikrReference(
//         text: 'All praise is due to Allah, Lord of the worlds.',
//         source: 'Al-Fatihah 1:2',
//       ),
//       DhikrReference(
//         text: 'If you are grateful, I will surely increase you [in favor].',
//         source: 'Ibrahim 14:7',
//       ),
//     ],
//   ),
//   BaseDhikrItem(
//     id: 'allahu_akbar',
//     arabic: 'اللَّهُ أَكْبَرُ',
//     transliteration: 'Allahu Akbar',
//     translation: 'Allah is the Greatest',
//     category: 'Greatness',
//     benefit: 'Reminds us that Allah is greater than all worries.',
//     explanation:
//         'Allahu Akbar is a powerful reminder that no matter how big our problems or ambitions seem, Allah is greater. It humbles the human soul and brings perspective, shifting our focus from the creation to the Creator.',
//     references: [
//       DhikrReference(
//         text: '...and the remembrance of Allah is greater.',
//         source: 'Al-Ankabut 29:45',
//       ),
//       DhikrReference(
//         text: 'And your Lord glorify.',
//         source: 'Al-Muddathir 74:3',
//       ),
//     ],
//   ),
//   BaseDhikrItem(
//     id: 'la_ilaha_illallah',
//     arabic: 'لَا إِلَٰهَ إِلَّا اللَّهُ',
//     transliteration: 'La ilaha illallah',
//     translation: 'There is no god but Allah',
//     category: 'Faith',
//     benefit: 'The key to Paradise and the foundation of faith.',
//     explanation:
//         'This is the Kalimah (statement) of Tawheed, the very foundation of Islam. It is a rejection of all false deities and an affirmation that only Allah has the right to be worshipped, obeyed, and loved ultimately.',
//     references: [
//       DhikrReference(
//         text: 'So know, [O Muhammad], that there is no deity except Allah.',
//         source: 'Muhammad 47:19',
//       ),
//       DhikrReference(
//         text:
//             'Allah—there is no deity except Him, the Ever-Living, the Sustainer of existence.',
//         source: 'Al-Baqarah 2:255',
//       ),
//     ],
//   ),
//   BaseDhikrItem(
//     id: 'astaghfirullah',
//     arabic: 'أَسْتَغْفِرُ اللَّهَ',
//     transliteration: 'Astaghfirullah',
//     translation: 'I seek forgiveness from Allah',
//     category: 'Forgiveness',
//     benefit: 'Opens the doors of mercy and provision.',
//     explanation:
//         'Istighfar (seeking forgiveness) is a way to cleanse the soul. It is an admission of our human flaws and a turn towards the infinite mercy of Allah. It brings peace to the heart and relief from the burden of sins.',
//     references: [
//       DhikrReference(
//         text:
//             '...Ask forgiveness of your Lord. Indeed, He is ever a Perpetual Forgiver.',
//         source: 'Nuh 71:10',
//       ),
//       DhikrReference(
//         text:
//             'And seek forgiveness of Allah. Indeed, Allah is ever Forgiving and Merciful.',
//         source: 'An-Nisa 4:106',
//       ),
//     ],
//   ),
//   BaseDhikrItem(
//     id: 'la_hawla',
//     arabic: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
//     transliteration: 'La hawla wa la quwwata illa billah',
//     translation: 'There is no power except with Allah',
//     category: 'Submission',
//     benefit: 'A treasure from the treasures of Paradise.',
//     explanation:
//         'This phrase is an expression of complete reliance on Allah (Tawakkul). It means we have no ability to move from one state to another, nor any power to perform any act, except through the help and will of Allah.',
//     references: [
//       DhikrReference(
//         text: 'It is a treasure from the treasures of Paradise.',
//         source: 'Sahih Bukhari',
//       ),
//       DhikrReference(
//         text: 'And whoever relies upon Allah—then He is sufficient for him.',
//         source: 'At-Talaq 65:3',
//       ),
//     ],
//   ),
// ];

const List<DhikrItem> dhikrList = [
  // --- YOUR ORIGINAL 6 (unchanged) ---

  // --- ADDITIONS START HERE ---
  BaseDhikrItem(
    id: 'bismillah',
    arabic: 'بِسْمِ اللَّهِ',
    transliteration: 'Bismillah',
    translation: 'In the name of Allah',
    category: 'Beginning',
    benefit: 'Brings blessings in actions.',
    explanation: 'Saying Bismillah aligns actions with remembrance of Allah.',
    references: [
      DhikrReference(
        text: 'Recite in the name of your Lord who created.',
        source: 'Al-‘Alaq 96:1',
      ),
    ],
  ),

  BaseDhikrItem(
    id: 'subhanallahi_wabihamdihi',
    arabic: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
    transliteration: 'SubhanAllahi wa bihamdihi',
    translation: 'Glory and praise be to Allah',
    category: 'Praise',
    benefit: 'Sins are forgiven.',
    explanation:
        'A powerful dhikr mentioned in authentic hadith for forgiveness.',
    references: [
      DhikrReference(
        text: 'Whoever says it 100 times will have sins forgiven.',
        source: 'Sahih Bukhari',
      ),
    ],
  ),

  BaseDhikrItem(
    id: 'subhanallahil_azeem',
    arabic: 'سُبْحَانَ اللَّهِ الْعَظِيمِ',
    transliteration: 'SubhanAllahil Azeem',
    translation: 'Glory be to Allah, the Great',
    category: 'Praise',
    benefit: 'Heavy on the scale.',
    explanation:
        'A beloved phrase to Allah, light on tongue but heavy in reward.',
    references: [
      DhikrReference(
        text: 'Two words beloved to Allah...',
        source: 'Sahih Bukhari',
      ),
    ],
  ),

  BaseDhikrItem(
    id: 'allahumma_salli',
    arabic: 'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ',
    transliteration: 'Allahumma salli ala Muhammad',
    translation: 'Send blessings upon Muhammad',
    category: 'Salawat',
    benefit: 'Receives blessings from Allah.',
    explanation: 'Sending salawat earns multiplied rewards.',
    references: [
      DhikrReference(
        text: 'Allah and His angels send blessings upon the Prophet.',
        source: 'Al-Ahzab 33:56',
      ),
    ],
  ),

  BaseDhikrItem(
    id: 'rabbi_ighfirli',
    arabic: 'رَبِّ اغْفِرْ لِي',
    transliteration: 'Rabbi ighfir li',
    translation: 'My Lord, forgive me',
    category: 'Forgiveness',
    benefit: 'Direct plea for mercy.',
    explanation: 'A simple yet powerful request for forgiveness.',
    references: [
      DhikrReference(
        text: 'My Lord, forgive and have mercy.',
        source: 'Al-Mu’minun 23:118',
      ),
    ],
  ),

  BaseDhikrItem(
    id: 'rabbi_zidni',
    arabic: 'رَبِّ زِدْنِي عِلْمًا',
    transliteration: 'Rabbi zidni ilma',
    translation: 'Increase me in knowledge',
    category: 'Knowledge',
    benefit: 'Growth in knowledge.',
    explanation: 'Encourages continuous learning.',
    references: [
      DhikrReference(
        text: 'My Lord, increase me in knowledge.',
        source: 'Ta-Ha 20:114',
      ),
    ],
  ),

  BaseDhikrItem(
    id: 'inna_lillahi',
    arabic: 'إِنَّا لِلَّهِ وَإِنَّا إِلَيْهِ رَاجِعُونَ',
    transliteration: 'Inna lillahi wa inna ilayhi raji’un',
    translation: 'We belong to Allah and return to Him',
    category: 'Patience',
    benefit: 'Comfort in hardship.',
    explanation: 'Reminds of life’s temporary nature.',
    references: [
      DhikrReference(
        text: 'Indeed we belong to Allah...',
        source: 'Al-Baqarah 2:156',
      ),
    ],
  ),

  BaseDhikrItem(
    id: 'hasbunallahu',
    arabic: 'حَسْبُنَا اللَّهُ وَنِعْمَ الْوَكِيلُ',
    transliteration: 'Hasbunallahu wa ni’mal wakeel',
    translation: 'Allah is sufficient for us',
    category: 'Reliance',
    benefit: 'Removes fear and anxiety.',
    explanation: 'A declaration of complete trust in Allah.',
    references: [
      DhikrReference(
        text: 'Allah is sufficient for us...',
        source: 'Aal-e-Imran 3:173',
      ),
    ],
  ),

  BaseDhikrItem(
    id: 'la_ilaha_anta',
    arabic: 'لَا إِلَٰهَ إِلَّا أَنْتَ سُبْحَانَكَ',
    transliteration: 'La ilaha illa anta subhanaka',
    translation: 'There is no deity except You',
    category: 'Repentance',
    benefit: 'Removes distress.',
    explanation: 'Dua of Prophet Yunus (AS).',
    references: [
      DhikrReference(text: 'The dua of Yunus...', source: 'Al-Anbiya 21:87'),
    ],
  ),

  BaseDhikrItem(
    id: 'allahumma_inni_zalim',
    arabic: 'اللَّهُمَّ إِنِّي ظَلَمْتُ نَفْسِي',
    transliteration: 'Allahumma inni zalamtu nafsi',
    translation: 'I have wronged myself',
    category: 'Forgiveness',
    benefit: 'Leads to forgiveness.',
    explanation: 'A deep expression of repentance.',
    references: [
      DhikrReference(text: 'Indeed, I have wronged myself...', source: 'Quran'),
    ],
  ),

  BaseDhikrItem(
    id: 'ya_hayy',
    arabic: 'يَا حَيُّ يَا قَيُّومُ',
    transliteration: 'Ya Hayyu Ya Qayyum',
    translation: 'O Ever-Living, Sustainer',
    category: 'Names of Allah',
    benefit: 'Powerful dua.',
    explanation: 'Calling upon Allah by His greatest names.',
    references: [
      DhikrReference(
        text: 'Allah—no deity except Him...',
        source: 'Al-Baqarah 2:255',
      ),
    ],
  ),

  BaseDhikrItem(
    id: 'allahumma_afini',
    arabic: 'اللَّهُمَّ عَافِنِي',
    transliteration: 'Allahumma afini',
    translation: 'Grant me health',
    category: 'Well-being',
    benefit: 'Protection and health.',
    explanation: 'A common prophetic dua.',
    references: [
      DhikrReference(text: 'Ask Allah for well-being.', source: 'Hadith'),
    ],
  ),

  BaseDhikrItem(
    id: 'allahumma_anta_salam',
    arabic: 'اللَّهُمَّ أَنْتَ السَّلَامُ',
    transliteration: 'Allahumma anta salam',
    translation: 'You are peace',
    category: 'Peace',
    benefit: 'Brings inner peace.',
    explanation: 'Recited after prayer.',
    references: [
      DhikrReference(text: 'You are Peace...', source: 'Sahih Muslim'),
    ],
  ),

  BaseDhikrItem(
    id: 'allahumma_barik',
    arabic: 'اللَّهُمَّ بَارِكْ',
    transliteration: 'Allahumma barik',
    translation: 'O Allah, bless',
    category: 'Blessing',
    benefit: 'Protects from envy.',
    explanation: 'Used to invoke blessings.',
    references: [
      DhikrReference(
        text: 'Why did you not say Allahumma barik?',
        source: 'Hadith',
      ),
    ],
  ),

  BaseDhikrItem(
    id: 'allahumma_tawakkaltu',
    arabic: 'اللَّهُمَّ عَلَيْكَ تَوَكَّلْتُ',
    transliteration: 'Allahumma alayka tawakkaltu',
    translation: 'I rely upon You',
    category: 'Trust',
    benefit: 'Strengthens reliance.',
    explanation: 'Affirms dependence on Allah.',
    references: [DhikrReference(text: 'And rely upon Allah.', source: 'Quran')],
  ),

  BaseDhikrItem(
    id: 'la_ilaha_illa_ant_subhanak',
    arabic:
        'لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنتُ مِنَ الظَّالِمِينَ',
    transliteration: 'Full dua of Yunus',
    translation: 'I was among the wrongdoers',
    category: 'Repentance',
    benefit: 'Relieves distress.',
    explanation: 'Complete dua of Yunus (AS).',
    references: [
      DhikrReference(text: 'Dua of Yunus...', source: 'Al-Anbiya 21:87'),
    ],
  ),
];
