class SayingItem {
  final String content;
  final String source;
  final String? arabic;

  const SayingItem({required this.content, required this.source, this.arabic});
}

const List<SayingItem> hadiths = [
  SayingItem(
    arabic:
        "مَثَلُ الَّذِي يَذْكُرُ رَبَّهُ وَالَّذِي لَا يَذْكُرُ رَبَّهُ مَثَلُكُرُ رَبَّهُ وَالَّذِي لَا يَذْكُرُ رَبَّهُ مَثَلُكُرُ رَبَّهُ وَالَّذِي لَا يَذْكُرُ رَبَّهُ مَثَلُكُرُ رَبَّهُ وَالَّذِي لَا يَذْكُرُ رَبَّهُ مَثَلُ الْحَيِّ وَالْمَيِّتِ",
    content:
        "He who remembers his Lord and he who does not are like the living and the dead.",
    source: "Sahih Bukhari",
  ),
  SayingItem(
    arabic: "لَا يَزَالُ لِسَانُكَ رَطْبًا مِنْ ذِكْرِ اللَّهِ",
    content: "Keep your tongue moist with the remembrance of Allah.",
    source: "Tirmidhi",
  ),
  SayingItem(
    arabic:
        "أَلَا أُنَبِّئُكُمْ بِخَيْرِ أَعْمَالِكُمْ... ذِكْرُ اللَّهِ تَعَالَى",
    content:
        "Shall I not inform you of the best of your actions... It is the remembrance of Allah.",
    source: "Tirmidhi",
  ),
  SayingItem(
    arabic: "أَنَا عِنْدَ ظَنِّ عَبْدِي بِي، وَأَنَا مَعَهُ إِذَا ذَكَرَنِي",
    content:
        "Allah says: 'I am as My servant thinks I am, and I am with him when he remembers Me.'",
    source: "Hadith Qudsi",
  ),
];
