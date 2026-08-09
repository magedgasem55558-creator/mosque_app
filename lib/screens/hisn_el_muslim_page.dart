import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ===================== بيانات الأذكار الموسّعة (15 فئة) =====================
class AzkarData {
  static const List<Map<String, dynamic>> categories = [
    {
      'title': 'أذكار الصباح',
      'icon': Icons.wb_sunny_rounded,
      'color': Colors.amber,
      'items': [
        {'text': 'أَصْبَحْنَا وَأَصْبَحَ المُلْكُ لِلَّهِ وَالحَمْدُ لِلَّهِ، لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ المُلْكُ وَلَهُ الحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، رَبِّ أَسْأَلُكَ خَيْرَ مَا فِي هَذَا اليَوْمِ وَخَيْرَ مَا بَعْدَهُ، وَأَعُوذُ بِكَ مِنْ شَرِّ مَا فِي هَذَا اليَوْمِ وَشَرِّ مَا بَعْدَهُ.', 'count': 1},
        {'text': 'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ.', 'count': 1},
        {'text': 'اللَّهُمَّ أَنْتَ رَبِّي لاَ إِلَهَ إِلاَّ أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لاَ يَغْفِرُ الذُّنُوبَ إِلاَّ أَنْتَ.', 'count': 1},
        {'text': 'رَضِيتُ بِاللَّهِ رَبَّاً، وَبِالإِسْلاَمِ دِيناً، وَبِمُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ نَبِيّاً.', 'count': 3},
        {'text': 'بِسْمِ اللَّهِ الَّذِي لاَ يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الأَرْضِ وَلاَ فِي السَّمَاءِ وَهُوَ السَّمِيعُ العَلِيمُ.', 'count': 3},
        {'text': 'حَسْبِيَ اللَّهُ لاَ إِلَهَ إِلاَّ هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ العَرْشِ العَظِيمِ.', 'count': 7},
        {'text': 'يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ أَصْلِحْ لِي شَأْنِي كُلَّهُ وَلاَ تَكِلْنِي إِلَى نَفْسِي طَرْفَةَ عَيْنٍ.', 'count': 3},
        {'text': 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ.', 'count': 3},
        {'text': 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ: عَدَدَ خَلْقِهِ، وَرِضَا نَفْسِهِ، وَزِنَةَ عَرْشِهِ، وَمِدَادَ كَلِمَاتِهِ.', 'count': 3},
        {'text': 'اللَّهُمَّ عَافِنِي فِي بَدَنِي، اللَّهُمَّ عَافِنِي فِي سَمْعِي، اللَّهُمَّ عَافِنِي فِي بَصَرِي، لاَ إِلَهَ إِلاَّ أَنْتَ.', 'count': 3},
        {'text': 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الكُفْرِ وَالفَقْرِ، وَأَعُوذُ بِكَ مِنْ عَذَابِ القَبْرِ، لاَ إِلَهَ إِلاَّ أَنْتَ.', 'count': 3},
        {'text': 'اللَّهُمَّ إِنِّي أَسْأَلُكَ العَافِيَةَ فِي الدُّنْيَا وَالآخِرَةِ، اللَّهُمَّ إِنِّي أَسْأَلُكَ العَفْوَ وَالعَافِيَةَ فِي دِينِي وَدُنْيَايَ وَأَهْلِي وَمَالِي.', 'count': 1},
        {'text': 'آية الكرسي (مرة واحدة)', 'count': 1},
        {'text': 'قُلْ هُوَ اللَّهُ أَحَدٌ (3 مرات)', 'count': 3},
        {'text': 'قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ (3 مرات)', 'count': 3},
        {'text': 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ (3 مرات)', 'count': 3},
        {'text': 'أَصْبَحْنَا عَلَى فِطْرَةِ الإِسْلاَمِ وَكَلِمَةِ الإِخْلاَصِ، وَدِينِ نَبِيِّنَا مُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ، وَمِلَّةِ أَبِينَا إِبْرَاهِيمَ حَنِيفاً مُسْلِماً وَمَا كَانَ مِنَ المُشْرِكِينَ.', 'count': 1},
        {'text': 'لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ المُلْكُ وَلَهُ الحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.', 'count': 10},
      ]
    },
    {
      'title': 'أذكار المساء',
      'icon': Icons.nights_stay_rounded,
      'color': Colors.indigo,
      'items': [
        {'text': 'أَمْسَيْنَا وَأَمْسَى المُلْكُ لِلَّهِ وَالحَمْدُ لِلَّهِ، لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ.', 'count': 1},
        {'text': 'اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ وَإِلَيْكَ المَصِيرُ.', 'count': 1},
        {'text': 'رَضِيتُ بِاللَّهِ رَبَّاً، وَبِالإِسْلاَمِ دِيناً، وَبِمُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ نَبِيّاً.', 'count': 3},
        {'text': 'بِسْمِ اللَّهِ الَّذِي لاَ يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الأَرْضِ وَلاَ فِي السَّمَاءِ وَهُوَ السَّمِيعُ العَلِيمُ.', 'count': 3},
        {'text': 'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ.', 'count': 3},
        {'text': 'حَسْبِيَ اللَّهُ لاَ إِلَهَ إِلاَّ هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ العَرْشِ العَظِيمِ.', 'count': 7},
        {'text': 'آية الكرسي (مرة واحدة)', 'count': 1},
        {'text': 'قُلْ هُوَ اللَّهُ أَحَدٌ (3 مرات)', 'count': 3},
        {'text': 'قُلْ أَعُوذُ بِرَبِّ الفَلَقِ (3 مرات)', 'count': 3},
        {'text': 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ (3 مرات)', 'count': 3},
        {'text': 'اللَّهُمَّ إِنِّي أَمْسَيْتُ أُشْهِدُكَ وَأُشْهِدُ حَمَلَةَ عَرْشِكَ وَمَلاَئِكَتَكَ وَجَمِيعَ خَلْقِكَ أَنَّكَ أَنْتَ اللَّهُ لاَ إِلَهَ إِلاَّ أَنْتَ وَحْدَكَ لاَ شَرِيكَ لَكَ، وَأَنَّ مُحَمَّداً عَبْدُكَ وَرَسُولُكَ.', 'count': 1},
        {'text': 'اللَّهُمَّ عَالِمَ الغَيْبِ وَالشَّهَادَةِ فَاطِرَ السَّمَاوَاتِ وَالأَرْضِ، رَبَّ كُلِّ شَيْءٍ وَمَلِيكَهُ، أَشْهَدُ أَنْ لاَ إِلَهَ إِلاَّ أَنْتَ، أَعُوذُ بِكَ مِنْ شَرِّ نَفْسِي وَشَرِّ الشَّيْطَانِ وَشِرْكِهِ.', 'count': 1},
        {'text': 'اللَّهُمَّ إِنِّي أَسْأَلُكَ العَافِيَةَ فِي الدُّنْيَا وَالآخِرَةِ.', 'count': 1},
      ]
    },
    {
      'title': 'أذكار النوم',
      'icon': Icons.bedtime_rounded,
      'color': Colors.deepPurple,
      'items': [
        {'text': 'بِاسْمِكَ رَبِّي وَضَعْتُ جَنْبِي، وَبِكَ أَرْفَعُهُ، فَإِنْ أَمْسَكْتَ نَفْسِي فَارْحَمْهَا، وَإِنْ أَرْسَلْتَهَا فَاحْفَظْهَا بِمَا تَحْفَظُ بِهِ عِبَادَكَ الصَّالِحِينَ.', 'count': 1},
        {'text': 'اللَّهُمَّ إِنَّكَ خَلَقْتَ نَفْسِي وَأَنْتَ تَتَوَفَّاهَا، لَكَ مَمَاتُهَا وَمَحْيَاهَا، إِنْ أَحْيَيْتَهَا فَاحْفَظْهَا، وَإِنْ أَمَتَّهَا فَاغْفِرْ لَهَا، اللَّهُمَّ إِنِّي أَسْأَلُكَ العَافِيَةَ.', 'count': 1},
        {'text': 'سُبْحَانَ اللَّهِ (33)، الحَمْدُ لِلَّهِ (33)، اللَّهُ أَكْبَرُ (34).', 'count': 100},
        {'text': 'اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ.', 'count': 1},
        {'text': 'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ، قُلْ هُوَ اللَّهُ أَحَدٌ... (المعوذات)', 'count': 3},
      ]
    },
    {
      'title': 'أذكار الاستيقاظ',
      'icon': Icons.wb_twilight_rounded,
      'color': Colors.orange,
      'items': [
        {'text': 'الحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ.', 'count': 1},
        {'text': 'لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ المُلْكُ وَلَهُ الحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، سُبْحَانَ اللَّهِ وَالحَمْدُ لِلَّهِ وَلاَ إِلَهَ إِلاَّ اللَّهُ وَاللَّهُ أَكْبَرُ، وَلاَ حَوْلَ وَلاَ قُوَّةَ إِلاَّ بِاللَّهِ العَلِيِّ العَظِيمِ.', 'count': 1},
        {'text': 'رَبِّ اغْفِرْ لِي.', 'count': 3},
      ]
    },
    {
      'title': 'أذكار بعد الصلاة',
      'icon': Icons.mosque_rounded,
      'color': Colors.teal,
      'items': [
        {'text': 'أَسْتَغْفِرُ اللَّهَ (ثَلاَثاً) اللَّهُمَّ أَنْتَ السَّلاَمُ وَمِنْكَ السَّلاَمُ، تَبَارَكْتَ يَا ذَا الجَلاَلِ وَالإِكْرَامِ.', 'count': 1},
        {'text': 'لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ المُلْكُ وَلَهُ الحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، اللَّهُمَّ لاَ مَانِعَ لِمَا أَعْطَيْتَ وَلاَ مُعْطِيَ لِمَا مَنَعْتَ وَلاَ يَنْفَعُ ذَا الجَدِّ مِنْكَ الجَدُّ.', 'count': 1},
        {'text': 'سُبْحَانَ اللَّهِ (33)، الحَمْدُ لِلَّهِ (33)، اللَّهُ أَكْبَرُ (33).', 'count': 99},
        {'text': 'آية الكرسي (مرة واحدة)', 'count': 1},
        {'text': 'قُلْ هُوَ اللَّهُ أَحَدٌ (مرة واحدة)', 'count': 1},
        {'text': 'قُلْ أَعُوذُ بِرَبِّ الفَلَقِ (مرة واحدة)', 'count': 1},
        {'text': 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ (مرة واحدة)', 'count': 1},
        {'text': 'اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ.', 'count': 1},
        {'text': 'لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ المُلْكُ وَلَهُ الحَمْدُ يُحْيِي وَيُمِيتُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.', 'count': 10},
      ]
    },
    {
      'title': 'أذكار المسجد',
      'icon': Icons.mosque_outlined,
      'color': Colors.brown,
      'items': [
        {'text': 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ.', 'count': 1},
        {'text': 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ.', 'count': 1},
        {'text': 'أَعُوذُ بِاللَّهِ العَظِيمِ وَبِوَجْهِهِ الكَرِيمِ وَسُلْطَانِهِ القَدِيمِ مِنَ الشَّيْطَانِ الرَّجِيمِ.', 'count': 1},
      ]
    },
    {
      'title': 'أدعية قرآنية',
      'icon': Icons.menu_book_rounded,
      'color': Colors.teal,
      'items': [
        {'text': 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ.', 'count': 1},
        {'text': 'رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي.', 'count': 1},
        {'text': 'رَبَّنَا لاَ تُزِغْ قُلُوبَنَا بَعْدَ إِذْ هَدَيْتَنَا وَهَبْ لَنَا مِنْ لَدُنْكَ رَحْمَةً إِنَّكَ أَنْتَ الوَهَّابُ.', 'count': 1},
        {'text': 'رَبِّ اجْعَلْنِي مُقِيمَ الصَّلاَةِ وَمِنْ ذُرِّيَّتِي رَبَّنَا وَتَقَبَّلْ دُعَاءِ.', 'count': 1},
        {'text': 'رَبِّ أَوْزِعْنِي أَنْ أَشْكُرَ نِعْمَتَكَ الَّتِي أَنْعَمْتَ عَلَيَّ وَعَلَى وَالِدَيَّ وَأَنْ أَعْمَلَ صَالِحاً تَرْضَاهُ وَأَدْخِلْنِي بِرَحْمَتِكَ فِي عِبَادِكَ الصَّالِحِينَ.', 'count': 1},
        {'text': 'رَبَّنَا اغْفِرْ لَنَا وَلإِخْوَانِنَا الَّذِينَ سَبَقُونَا بِالإِيمَانِ وَلاَ تَجْعَلْ فِي قُلُوبِنَا غِلاً لِّلَّذِينَ آمَنُوا.', 'count': 1},
      ]
    },
    {
      'title': 'أدعية الأنبياء',
      'icon': Icons.people_outline,
      'color': Colors.blueGrey,
      'items': [
        {'text': 'رَبِّ إِنِّي لِمَا أَنزَلْتَ إِلَيَّ مِنْ خَيْرٍ فَقِيرٌ (موسى عليه السلام)', 'count': 1},
        {'text': 'رَبِّ أَنِّي مَسَّنِيَ الضُّرُّ وَأَنتَ أَرْحَمُ الرَّاحِمِينَ (أيوب عليه السلام)', 'count': 1},
        {'text': 'لاَّ إِلَهَ إِلاَّ أَنتَ سُبْحَانَكَ إِنِّي كُنتُ مِنَ الظَّالِمِينَ (يونس عليه السلام)', 'count': 1},
        {'text': 'رَبِّ اغْفِرْ لِي وَهَبْ لِي مُلْكاً لاَّ يَنبَغِي لِأَحَدٍ مِّنْ بَعْدِي (سليمان عليه السلام)', 'count': 1},
        {'text': 'رَبَّنَا آمَنَّا فَاغْفِرْ لَنَا وَارْحَمْنَا وَأَنتَ خَيْرُ الرَّاحِمِينَ (نوح عليه السلام)', 'count': 1},
      ]
    },
    {
      'title': 'أذكار مطلقة',
      'icon': Icons.self_improvement,
      'color': Colors.pinkAccent,
      'items': [
        {'text': 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ.', 'count': 100},
        {'text': 'لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ المُلْكُ وَلَهُ الحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.', 'count': 100},
        {'text': 'أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ.', 'count': 100},
        {'text': 'اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ.', 'count': 10},
        {'text': 'لاَ حَوْلَ وَلاَ قُوَّةَ إِلاَّ بِاللَّهِ.', 'count': 100},
      ]
    },
    {
      'title': 'أدعية للمريض',
      'icon': Icons.healing_rounded,
      'color': Colors.redAccent,
      'items': [
        {'text': 'لاَ بَأْسَ طَهُورٌ إِنْ شَاءَ اللَّهُ.', 'count': 7},
        {'text': 'أَسْأَلُ اللَّهَ العَظِيمَ رَبَّ العَرْشِ العَظِيمِ أَنْ يَشْفِيَكَ.', 'count': 7},
        {'text': 'اللَّهُمَّ اشْفِ عَبْدَكَ يَنْكَأُ لَكَ عَدُوّاً أَوْ يَمْشِي لَكَ إِلَى صَلاَةٍ.', 'count': 1},
      ]
    },
    {
      'title': 'أدعية السفر',
      'icon': Icons.connecting_airports_rounded,
      'color': Colors.blue,
      'items': [
        {'text': 'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ.', 'count': 1},
        {'text': 'اللَّهُمَّ إِنَّا نَسْأَلُكَ فِي سَفَرِنَا هَذَا البِرَّ وَالتَّقْوَى، وَمِنَ العَمَلِ مَا تَرْضَى.', 'count': 1},
        {'text': 'اللَّهُمَّ هَوِّنْ عَلَيْنَا سَفَرَنَا هَذَا وَاطْوِ عَنَّا بُعْدَهُ.', 'count': 1},
      ]
    },
    {
      'title': 'أذكار الخلاء',
      'icon': Icons.wc,
      'color': Colors.grey,
      'items': [
        {'text': 'بِسْمِ اللَّهِ، اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الخُبُثِ وَالخَبَائِثِ.', 'count': 1},
        {'text': 'غُفْرَانَكَ (بعد الخروج).', 'count': 1},
      ]
    },
    {
      'title': 'أذكار المطر',
      'icon': Icons.water_drop,
      'color': Colors.lightBlue,
      'items': [
        {'text': 'اللَّهُمَّ صَيِّباً نَافِعاً.', 'count': 1},
        {'text': 'مُطِرْنَا بِفَضْلِ اللَّهِ وَرَحْمَتِهِ.', 'count': 1},
        {'text': 'اللَّهُمَّ حَوَالَيْنَا وَلاَ عَلَيْنَا.', 'count': 1},
      ]
    },
    {
      'title': 'أذكار الرياح',
      'icon': Icons.wind_power,
      'color': Colors.cyan,
      'items': [
        {'text': 'اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَهَا وَخَيْرَ مَا فِيهَا وَخَيْرَ مَا أُرْسِلَتْ بِهِ، وَأَعُوذُ بِكَ مِنْ شَرِّهَا وَشَرِّ مَا فِيهَا وَشَرِّ مَا أُرْسِلَتْ بِهِ.', 'count': 1},
      ]
    },
    {
      'title': 'أذكار الطعام',
      'icon': Icons.restaurant,
      'color': Colors.orangeAccent,
      'items': [
        {'text': 'اللَّهُمَّ بَارِكْ لَنَا فِيمَا رَزَقْتَنَا وَقِنَا عَذَابَ النَّارِ، بِسْمِ اللَّهِ.', 'count': 1},
        {'text': 'الحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِينَ.', 'count': 1},
      ]
    },
    {
      'title': 'أذكار الصيام',
      'icon': Icons.ramen_dining,
      'color': Colors.brown,
      'items': [
        {'text': 'ذَهَبَ الظَّمَأُ وَابْتَلَّتِ العُرُوقُ وَثَبَتَ الأَجْرُ إِنْ شَاءَ اللَّهُ.', 'count': 1},
        {'text': 'اللَّهُمَّ إِنِّي لَكَ صُمْتُ، وَعَلَى رِزْقِكَ أَفْطَرْتُ.', 'count': 1},
      ]
    },
  ];
}

// ===================== صفحة حصن المسلم الرئيسية =====================
class HisnElMuslimPage extends StatelessWidget {
  const HisnElMuslimPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const DigitalTasbihPage())),
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.touch_app, color: Colors.white),
        label: const Text('المسبحة', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2E7D32), // أخضر غامق
              Color(0xFF42A5F5), // أزرق
              Color(0xFFF5F5F5), // رمادي فاتح
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildHeader(),
              const SizedBox(height: 10),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
                  itemCount: AzkarData.categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.05,
                  ),
                  itemBuilder: (context, index) {
                    final cat = AzkarData.categories[index];
                    final Color catColor = cat['color'] as Color;
                    return _buildCategoryCard(context, cat, catColor);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
        ),
        child: const Column(
          children: [
            Text('أَلا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ',
                style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text('اختر التصنيف لقراءة الأذكار واستخدام العداد التفاعلي',
                style: TextStyle(color: Colors.black54, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Map<String, dynamic> cat, Color color) {
    return InkWell(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => AzkarDetailPage(
                title: cat['title'],
                items: List<Map<String, dynamic>>.from(cat['items']),
                themeColor: color,
              ))),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [BoxShadow(color: color.withOpacity(0.15), blurRadius: 8)],
          border: Border.all(color: color.withOpacity(0.2), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
                radius: 28,
                backgroundColor: color.withOpacity(0.1),
                child: Icon(cat['icon'], color: color, size: 28)),
            const SizedBox(height: 10),
            Text(cat['title'],
                style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('${(cat['items'] as List).length} أذكار',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

// ===================== صفحة تفاصيل الأذكار =====================
class AzkarDetailPage extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final Color themeColor;
  const AzkarDetailPage({Key? key, required this.title, required this.items, required this.themeColor}) : super(key: key);

  @override
  State<AzkarDetailPage> createState() => _AzkarDetailPageState();
}

class _AzkarDetailPageState extends State<AzkarDetailPage> {
  late List<int> _counters;

  @override
  void initState() {
    super.initState();
    _counters = widget.items.map((e) => e['count'] as int).toList();
  }

  void _decrement(int index) {
    if (_counters[index] > 0) {
      setState(() => _counters[index]--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2E7D32),
              Color(0xFF42A5F5),
              Color(0xFFF5F5F5),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                  itemCount: widget.items.length,
                  itemBuilder: (context, index) {
                    final item = widget.items[index];
                    final current = _counters[index];
                    final done = current == 0;
                    return _buildZikrCard(item['text'], done, current, index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(
              child: Text(widget.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildZikrCard(String text, bool done, int remaining, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: done ? Colors.grey.shade300 : widget.themeColor.withOpacity(0.4), width: 1.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(text,
              style: TextStyle(
                fontSize: 17,
                height: 1.8,
                color: done ? Colors.grey : Colors.black87,
                decoration: done ? TextDecoration.lineThrough : null,
              )),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.copy, color: Colors.grey),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: text));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم نسخ الذكر'), duration: Duration(seconds: 1)),
                  );
                },
              ),
              InkWell(
                onTap: () => _decrement(index),
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: done ? Colors.grey.shade200 : widget.themeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: done ? Colors.grey : widget.themeColor),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        done ? Icons.check_circle : Icons.touch_app,
                        color: done ? Colors.grey : widget.themeColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        done ? 'تم' : 'المتبقي: $remaining',
                        style: TextStyle(color: done ? Colors.grey : widget.themeColor, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ===================== صفحة المسبحة الإلكترونية =====================
class DigitalTasbihPage extends StatefulWidget {
  const DigitalTasbihPage({Key? key}) : super(key: key);

  @override
  State<DigitalTasbihPage> createState() => _DigitalTasbihPageState();
}

class _DigitalTasbihPageState extends State<DigitalTasbihPage> {
  int _count = 0;
  int _total = 0;
  final List<String> _phrases = ['سُبْحَانَ اللَّهِ', 'الحَمْدُ لِلَّهِ', 'اللَّهُ أَكْبَرُ', 'لاَ إِلَهَ إِلاَّ اللَّهُ'];
  late String _currentPhrase;

  @override
  void initState() {
    super.initState();
    _currentPhrase = _phrases[0];
  }

  void _increment() {
    setState(() {
      _count++;
      _total++;
    });
  }

  void _reset() {
    setState(() => _count = 0);
  }

  void _changePhrase(String phrase) {
    setState(() {
      _currentPhrase = phrase;
      _count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2E7D32),
              Color(0xFF42A5F5),
              Color(0xFFF5F5F5),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildAppBar(),
              const Spacer(flex: 1),
              // الدائرة الكبيرة للعداد
              GestureDetector(
                onTap: _increment,
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.teal.shade400, Colors.teal.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(color: Colors.teal.withOpacity(0.3), blurRadius: 25, spreadRadius: 5),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('$_count',
                            style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: Colors.white)),
                        Text(_currentPhrase,
                            style: const TextStyle(fontSize: 16, color: Colors.white70, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text('المجموع الكلي: $_total', style: const TextStyle(color: Colors.black54, fontSize: 14)),
              const SizedBox(height: 20),
              // أزرار اختيار الذكر
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: _phrases.map((phrase) {
                    final selected = phrase == _currentPhrase;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: ChoiceChip(
                        label: Text(phrase,
                            style: TextStyle(
                                color: selected ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.bold)),
                        selected: selected,
                        selectedColor: Colors.teal,
                        backgroundColor: Colors.grey.shade200,
                        onSelected: (_) => _changePhrase(phrase),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              TextButton.icon(
                onPressed: _reset,
                icon: const Icon(Icons.refresh, color: Colors.teal),
                label: const Text('إعادة العد', style: TextStyle(color: Colors.teal)),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
            const Expanded(
              child: Text('المسبحة الإلكترونية',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black87, fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }
}
