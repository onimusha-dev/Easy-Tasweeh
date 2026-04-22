class SayingItem {
  final String content;
  final String source;
  final String? arabic;

  const SayingItem({required this.content, required this.source, this.arabic});
}

const List<SayingItem> hadiths = [
  SayingItem(
    arabic:
        "إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ، وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى",
    content:
        "Actions are judged by intentions, and every person will get what they intended.",
    source: "Sahih Bukhari & Muslim",
  ),
  SayingItem(
    arabic:
        "مَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الْآخِرِ فَلْيَقُلْ خَيْرًا أَوْ لِيَصْمُتْ",
    content:
        "Whoever believes in Allah and the Last Day, let him speak good or remain silent.",
    source: "Sahih Bukhari & Muslim",
  ),
  SayingItem(
    arabic:
        "لَا يُؤْمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لِأَخِيهِ مَا يُحِبُّ لِنَفْسِهِ",
    content:
        "None of you truly believes until he loves for his brother what he loves for himself.",
    source: "Sahih Bukhari & Muslim",
  ),
  SayingItem(
    arabic: "الْمُسْلِمُ مَنْ سَلِمَ الْمُسْلِمُونَ مِنْ لِسَانِهِ وَيَدِهِ",
    content:
        "The Muslim is the one from whose tongue and hand the Muslims are safe.",
    source: "Sahih Bukhari",
  ),
  SayingItem(
    arabic:
        "انْظُرُوا إِلَى مَنْ هُوَ أَسْفَلَ مِنْكُمْ، وَلَا تَنْظُرُوا إِلَى مَنْ هُوَ فَوْقَكُمْ",
    content:
        "Look at those who are lower than you, and do not look at those above you.",
    source: "Sahih Muslim",
  ),
  SayingItem(
    arabic: "طَلَبُ الْعِلْمِ فَرِيضَةٌ عَلَى كُلِّ مُسْلِمٍ",
    content: "Seeking knowledge is an obligation upon every Muslim.",
    source: "Sunan Ibn Majah",
  ),
  SayingItem(
    arabic:
        "الرَّاحِمُونَ يَرْحَمُهُمُ الرَّحْمَنُ، ارْحَمُوا مَنْ فِي الْأَرْضِ يَرْحَمْكُمْ مَنْ فِي السَّمَاءِ",
    content:
        "The merciful are shown mercy by the Most Merciful. Have mercy on those on earth, and the One in heaven will have mercy on you.",
    source: "Sunan Tirmidhi",
  ),
  SayingItem(
    arabic:
        "السَّاعِي عَلَى الْأَرْمَلَةِ وَالْمِسْكِينِ كَالْمُجَاهِدِ فِي سَبِيلِ اللَّهِ",
    content:
        "The one who strives to help widows and the poor is like the one who strives in the path of Allah.",
    source: "Sahih Bukhari & Muslim",
  ),
  SayingItem(
    arabic:
        "اتَّقِ اللَّهَ حَيْثُمَا كُنْتَ، وَأَتْبِعِ السَّيِّئَةَ الْحَسَنَةَ تَمْحُهَا، وَخَالِقِ النَّاسَ بِخُلُقٍ حَسَنٍ",
    content:
        "Fear Allah wherever you are, follow a bad deed with a good deed to erase it, and treat people with good character.",
    source: "Sunan Tirmidhi",
  ),
  SayingItem(
    arabic:
        "لَيْسَ الشَّدِيدُ بِالصُّرَعَةِ، إِنَّمَا الشَّدِيدُ الَّذِي يَمْلِكُ نَفْسَهُ عِنْدَ الْغَضَبِ",
    content:
        "The strong is not the one who overcomes people by his strength, but the strong is the one who controls himself while in anger.",
    source: "Sahih Bukhari & Muslim",
  ),
  SayingItem(
    arabic: "الدُّنْيَا سِجْنُ الْمُؤْمِنِ وَجَنَّةُ الْكَافِرِ",
    content:
        "This world is a prison for the believer and a paradise for the disbeliever.",
    source: "Sahih Muslim",
  ),
  SayingItem(
    arabic: "مَنْ صَمَتَ نَجَا",
    content: "Whoever remains silent is saved.",
    source: "Sunan Tirmidhi",
  ),
  SayingItem(
    arabic:
        "لَا تَحَاسَدُوا، وَلَا تَنَاجَشُوا، وَلَا تَبَاغَضُوا، وَلَا تَدَابَرُوا، وَكُونُوا عِبَادَ اللَّهِ إِخْوَانًا",
    content:
        "Do not envy one another, do not artificially inflate prices, do not hate one another, do not turn your backs on each other, and be servants of Allah as brothers.",
    source: "Sahih Muslim",
  ),
  SayingItem(
    arabic:
        "إِيَّاكُمْ وَالْحَسَدَ، فَإِنَّ الْحَسَدَ يَأْكُلُ الْحَسَنَاتِ كَمَا تَأْكُلُ النَّارُ الْحَطَبَ",
    content:
        "Beware of envy, for envy consumes good deeds just as fire consumes wood.",
    source: "Sunan Abi Dawud",
  ),
  SayingItem(
    arabic:
        "الْحَلَالُ بَيِّنٌ، وَالْحَرَامُ بَيِّنٌ، وَبَيْنَهُمَا مُشَبَّهَاتٌ لَا يَعْلَمُهَا كَثِيرٌ مِنَ النَّاسِ",
    content:
        "The lawful is clear, the unlawful is clear, and between them are doubtful matters which many people do not know.",
    source: "Sahih Bukhari & Muslim",
  ),
  SayingItem(
    arabic:
        "لَا يُؤْمِنُ أَحَدُكُمْ حَتَّى أَكُونَ أَحَبَّ إِلَيْهِ مِنْ وَالِدِهِ وَوَلَدِهِ وَالنَّاسِ أَجْمَعِينَ",
    content:
        "None of you truly believes until I am more beloved to him than his father, his child, and all of mankind.",
    source: "Sahih Bukhari & Muslim",
  ),
  SayingItem(
    arabic:
        "سَيِّدُ الْأَسْتَغْفَارِ أَنْ تَقُولَ: اللَّهُمَّ أَنْتَ رَبِّي لَا إِلَهَ إِلَّا أَنْتَ...",
    content:
        "The master of seeking forgiveness is to say: 'O Allah, You are my Lord, there is no god but You...'",
    source: "Sahih Bukhari",
  ),
  SayingItem(
    arabic: "تَبَسُّمُكَ فِي وَجْهِ أَخِيكَ لَكَ صَدَقَةٌ",
    content: "Your smile in the face of your brother is a charity for you.",
    source: "Sunan Tirmidhi",
  ),
  SayingItem(
    arabic: "خَيْرُ النَّاسِ أَنْفَعُهُمْ لِلنَّاسِ",
    content: "The best of people are those who are most beneficial to others.",
    source: "Al-Mu'jam Al-Awsat",
  ),
  SayingItem(
    arabic:
        "مَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الْآخِرِ فَلْيُكْرِمْ جَارَهُ",
    content:
        "Whoever believes in Allah and the Last Day, let him honor his neighbor.",
    source: "Sahih Bukhari & Muslim",
  ),
  SayingItem(
    arabic:
        "أَفْضَلُ الْإِيمَانِ أَنْ تَعْلَمَ أَنَّ اللَّهَ مَعَكَ حَيْثُمَا كُنْتَ",
    content:
        "The best faith is to know that Allah is with you wherever you are.",
    source: "Al-Tabarani",
  ),
  SayingItem(
    arabic: "الْحَيَاءُ لَا يَأْتِي إِلَّا بِخَيْرٍ",
    content: "Modesty does not bring anything except good.",
    source: "Sahih Bukhari & Muslim",
  ),
  SayingItem(
    arabic:
        "نَظَرُ الْمُسْلِمِ فِي وَجْهِ أَخِيهِ الْمُسْلِمِ بِالْمَوَدَّةِ عِبَادَةٌ",
    content: "Looking at a Muslim brother with love is an act of worship.",
    source: "Mishkat al-Masabih",
  ),
  SayingItem(
    arabic:
        "لَيْسَ مِنَّا مَنْ لَمْ يَرْحَمْ صَغِيرَنَا وَيُوَقِّرْ كَبِيرَنَا",
    content:
        "He is not one of us who does not have mercy on our young and respect our elders.",
    source: "Sunan Tirmidhi",
  ),
  SayingItem(
    arabic: "الْمُؤْمِنُ مِرْآةُ الْمُؤْمِنِ",
    content: "The believer is a mirror to the believer.",
    source: "Sunan Abi Dawud",
  ),
];
