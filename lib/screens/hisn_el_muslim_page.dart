import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

// ============================================================
// حصن المسلم - تصميم حديث
// ============================================================

void main() {
  runApp(const HisnAlMuslimApp());
}

// ============================================================
// ألوان التطبيق
// ============================================================

class AppColors {
  static const primary = Color(0xFF0F766E);
  static const primaryDark = Color(0xFF115E59);
  static const green = Color(0xFF166534);
  static const gold = Color(0xFFD4A72C);
  static const background = Color(0xFFF5F8F6);
  static const card = Colors.white;
  static const text = Color(0xFF1F2937);
  static const muted = Color(0xFF6B7280);
}

// ============================================================
// التطبيق
// ============================================================

class HisnAlMuslimApp extends StatelessWidget {
  const HisnAlMuslimApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'حصن المسلم',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Arial',
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
      ),
      home: const HisnElMuslimPage(),
    );
  }
}

// ============================================================
// البيانات
// ============================================================

class AzkarData {
  static const List<Map<String, dynamic>> categories = [

    // ========================================================
    // أذكار الصباح
    // ========================================================

    {
      'title': 'أذكار الصباح',
      'icon': Icons.wb_sunny_rounded,
      'color': Color(0xFFF59E0B),
      'items': [
        {
          'text':
              'أَصْبَحْنَا وَأَصْبَحَ المُلْكُ لِلَّهِ وَالحَمْدُ لِلَّهِ، لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ المُلْكُ وَلَهُ الحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، رَبِّ أَسْأَلُكَ خَيْرَ مَا فِي هَذَا اليَوْمِ وَخَيْرَ مَا بَعْدَهُ، وَأَعُوذُ بِكَ مِنْ شَرِّ مَا فِي هَذَا اليَوْمِ وَشَرِّ مَا بَعْدَهُ.',
          'count': 1,
        },
        {
          'text':
              'اللَّهُمَّ بِكَ أَصْبَحْنَا، وَبِكَ أَمْسَيْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ وَإِلَيْكَ النُّشُورُ.',
          'count': 1,
        },
        {
          'text':
              'اللَّهُمَّ أَنْتَ رَبِّي لاَ إِلَهَ إِلاَّ أَنْتَ، خَلَقْتَنِي وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوءُ بِذَنْبِي فَاغْفِرْ لِي فَإِنَّهُ لاَ يَغْفِرُ الذُّنُوبَ إِلاَّ أَنْتَ.',
          'count': 1,
        },
        {
          'text':
              'رَضِيتُ بِاللَّهِ رَبَّاً، وَبِالإِسْلاَمِ دِيناً، وَبِمُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ نَبِيّاً.',
          'count': 3,
        },
        {
          'text':
              'بِسْمِ اللَّهِ الَّذِي لاَ يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الأَرْضِ وَلاَ فِي السَّمَاءِ وَهُوَ السَّمِيعُ العَلِيمُ.',
          'count': 3,
        },
        {
          'text':
              'حَسْبِيَ اللَّهُ لاَ إِلَهَ إِلاَّ هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ العَرْشِ العَظِيمِ.',
          'count': 7,
        },
        {
          'text':
              'يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ أَصْلِحْ لِي شَأْنِي كُلَّهُ وَلاَ تَكِلْنِي إِلَى نَفْسِي طَرْفَةَ عَيْنٍ.',
          'count': 3,
        },
        {
          'text':
              'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ.',
          'count': 3,
        },
        {
          'text':
              'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ.',
          'count': 100,
        },
        {
          'text':
              'اللَّهُمَّ إِنِّي أَسْأَلُكَ العَافِيَةَ فِي الدُّنْيَا وَالآخِرَةِ.',
          'count': 1,
        },
        {
          'text': 'آية الكرسي.',
          'count': 1,
        },
        {
          'text': 'قُلْ هُوَ اللَّهُ أَحَدٌ.',
          'count': 3,
        },
        {
          'text': 'قُلْ أَعُوذُ بِرَبِّ الفَلَقِ.',
          'count': 3,
        },
        {
          'text': 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ.',
          'count': 3,
        },
        {
          'text':
              'أَصْبَحْنَا عَلَى فِطْرَةِ الإِسْلاَمِ وَكَلِمَةِ الإِخْلاَصِ، وَدِينِ نَبِيِّنَا مُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ، وَمِلَّةِ أَبِينَا إِبْرَاهِيمَ حَنِيفاً مُسْلماً وَمَا كَانَ مِنَ المُشْرِكِينَ.',
          'count': 1,
        },
        {
          'text':
              'لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ المُلْكُ وَلَهُ الحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.',
          'count': 10,
        },
      ],
    },

    // ========================================================
    // أذكار المساء
    // ========================================================

    {
      'title': 'أذكار المساء',
      'icon': Icons.nights_stay_rounded,
      'color': Color(0xFF4338CA),
      'items': [
        {
          'text':
              'أَمْسَيْنَا وَأَمْسَى المُلْكُ لِلَّهِ وَالحَمْدُ لِلَّهِ، لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ.',
          'count': 1,
        },
        {
          'text':
              'اللَّهُمَّ بِكَ أَمْسَيْنَا، وَبِكَ أَصْبَحْنَا، وَبِكَ نَحْيَا، وَبِكَ نَمُوتُ وَإِلَيْكَ المَصِيرُ.',
          'count': 1,
        },
        {
          'text':
              'رَضِيتُ بِاللَّهِ رَبَّاً، وَبِالإِسْلاَمِ دِيناً، وَبِمُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ نَبِيّاً.',
          'count': 3,
        },
        {
          'text':
              'بِسْمِ اللَّهِ الَّذِي لاَ يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الأَرْضِ وَلاَ فِي السَّمَاءِ وَهُوَ السَّمِيعُ العَلِيمُ.',
          'count': 3,
        },
        {
          'text':
              'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ.',
          'count': 3,
        },
        {
          'text':
              'حَسْبِيَ اللَّهُ لاَ إِلَهَ إِلاَّ هُوَ عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ العَرْشِ العَظِيمِ.',
          'count': 7,
        },
        {
          'text': 'آية الكرسي.',
          'count': 1,
        },
        {
          'text': 'قُلْ هُوَ اللَّهُ أَحَدٌ.',
          'count': 3,
        },
        {
          'text': 'قُلْ أَعُوذُ بِرَبِّ الفَلَقِ.',
          'count': 3,
        },
        {
          'text': 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ.',
          'count': 3,
        },
        {
          'text':
              'اللَّهُمَّ عَالِمَ الغَيْبِ وَالشَّهَادَةِ فَاطِرَ السَّمَاوَاتِ وَالأَرْضِ، رَبَّ كُلِّ شَيْءٍ وَمَلِيكَهُ، أَشْهَدُ أَنْ لاَ إِلَهَ إِلاَّ أَنْتَ، أَعُوذُ بِكَ مِنْ شَرِّ نَفْسِي وَشَرِّ الشَّيْطَانِ وَشِرْكِهِ.',
          'count': 1,
        },
        {
          'text':
              'اللَّهُمَّ إِنِّي أَسْأَلُكَ العَافِيَةَ فِي الدُّنْيَا وَالآخِرَةِ.',
          'count': 1,
        },
      ],
    },

    // ========================================================
    // النوم
    // ========================================================

    {
      'title': 'أذكار النوم',
      'icon': Icons.bedtime_rounded,
      'color': Color(0xFF7C3AED),
      'items': [
        {
          'text':
              'بِاسْمِكَ رَبِّي وَضَعْتُ جَنْبِي، وَبِكَ أَرْفَعُهُ، فَإِنْ أَمْسَكْتَ نَفْسِي فَارْحَمْهَا، وَإِنْ أَرْسَلْتَهَا فَاحْفَظْهَا بِمَا تَحْفَظُ بِهِ عِبَادَكَ الصَّالِحِينَ.',
          'count': 1,
        },
        {
          'text':
              'اللَّهُمَّ إِنَّكَ خَلَقْتَ نَفْسِي وَأَنْتَ تَتَوَفَّاهَا، لَكَ مَمَاتُهَا وَمَحْيَاهَا، إِنْ أَحْيَيْتَهَا فَاحْفَظْهَا، وَإِنْ أَمَتَّهَا فَاغْفِرْ لَهَا، اللَّهُمَّ إِنِّي أَسْأَلُكَ العَافِيَةَ.',
          'count': 1,
        },
        {
          'text':
              'سُبْحَانَ اللَّهِ (33)، الحَمْدُ لِلَّهِ (33)، اللَّهُ أَكْبَرُ (34).',
          'count': 1,
        },
        {
          'text':
              'اللَّهُمَّ قِنِي عَذَابَكَ يَوْمَ تَبْعَثُ عِبَادَكَ.',
          'count': 1,
        },
        {
          'text':
              'قُلْ هُوَ اللَّهُ أَحَدٌ، قُلْ أَعُوذُ بِرَبِّ الفَلَقِ، قُلْ أَعُوذُ بِرَبِّ النَّاسِ.',
          'count': 3,
        },
      ],
    },

    // ========================================================
    // الاستيقاظ
    // ========================================================

    {
      'title': 'أذكار الاستيقاظ',
      'icon': Icons.wb_twilight_rounded,
      'color': Color(0xFFF97316),
      'items': [
        {
          'text':
              'الحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ.',
          'count': 1,
        },
        {
          'text':
              'لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ المُلْكُ وَلَهُ الحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.',
          'count': 1,
        },
        {
          'text': 'رَبِّ اغْفِرْ لِي.',
          'count': 3,
        },
      ],
    },

    // ========================================================
    // بعد الصلاة
    // ========================================================

    {
      'title': 'أذكار بعد الصلاة',
      'icon': Icons.mosque_rounded,
      'color': Color(0xFF0D9488),
      'items': [
        {
          'text':
              'أَسْتَغْفِرُ اللَّهَ، أَسْتَغْفِرُ اللَّهَ، أَسْتَغْفِرُ اللَّهَ. اللَّهُمَّ أَنْتَ السَّلاَمُ وَمِنْكَ السَّلاَمُ، تَبَارَكْتَ يَا ذَا الجَلاَلِ وَالإِكْرَامِ.',
          'count': 1,
        },
        {
          'text':
              'لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ المُلْكُ وَلَهُ الحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ، اللَّهُمَّ لاَ مَانِعَ لِمَا أَعْطَيْتَ وَلاَ مُعْطِيَ لِمَا مَنَعْتَ وَلاَ يَنْفَعُ ذَا الجَدِّ مِنْكَ الجَدُّ.',
          'count': 1,
        },
        {
          'text':
              'سُبْحَانَ اللَّهِ، الحَمْدُ لِلَّهِ، اللَّهُ أَكْبَرُ.',
          'count': 33,
        },
        {
          'text': 'آية الكرسي.',
          'count': 1,
        },
        {
          'text': 'قُلْ هُوَ اللَّهُ أَحَدٌ.',
          'count': 1,
        },
        {
          'text': 'قُلْ أَعُوذُ بِرَبِّ الفَلَقِ.',
          'count': 1,
        },
        {
          'text': 'قُلْ أَعُوذُ بِرَبِّ النَّاسِ.',
          'count': 1,
        },
        {
          'text':
              'اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ.',
          'count': 1,
        },
        {
          'text':
              'لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ المُلْكُ وَلَهُ الحَمْدُ يُحْيِي وَيُمِيتُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.',
          'count': 10,
        },
      ],
    },

    // ========================================================
    // المسجد
    // ========================================================

    {
      'title': 'أذكار المسجد',
      'icon': Icons.mosque_outlined,
      'color': Color(0xFF92400E),
      'items': [
        {
          'text': 'اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ.',
          'count': 1,
        },
        {
          'text': 'اللَّهُمَّ إِنِّي أَسْأَلُكَ مِنْ فَضْلِكَ.',
          'count': 1,
        },
        {
          'text':
              'أَعُوذُ بِاللَّهِ العَظِيمِ وَبِوَجْهِهِ الكَرِيمِ وَسُلْطَانِهِ القَدِيمِ مِنَ الشَّيْطَانِ الرَّجِيمِ.',
          'count': 1,
        },
      ],
    },

    // ========================================================
    // دخول المنزل
    // ========================================================

    {
      'title': 'دخول المنزل',
      'icon': Icons.home_rounded,
      'color': Color(0xFF16A34A),
      'items': [
        {
          'text':
              'بِسْمِ اللَّهِ وَلَجْنَا، وَبِسْمِ اللَّهِ خَرَجْنَا، وَعَلَى اللَّهِ رَبِّنَا تَوَكَّلْنَا.',
          'count': 1,
        },
      ],
    },

    // ========================================================
    // الخروج من المنزل
    // ========================================================

    {
      'title': 'الخروج من المنزل',
      'icon': Icons.exit_to_app_rounded,
      'color': Color(0xFF2563EB),
      'items': [
        {
          'text':
              'بِسْمِ اللَّهِ، تَوَكَّلْتُ عَلَى اللَّهِ، وَلاَ حَوْلَ وَلاَ قُوَّةَ إِلاَّ بِاللَّهِ.',
          'count': 1,
        },
        {
          'text':
              'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ أَنْ أَضِلَّ أَوْ أُضَلَّ، أَوْ أَزِلَّ أَوْ أُزَلَّ، أَوْ أَظْلِمَ أَوْ أُظْلَمَ، أَوْ أَجْهَلَ أَوْ يُجْهَلَ عَلَيَّ.',
          'count': 1,
        },
      ],
    },

    // ========================================================
    // الوضوء
    // ========================================================

    {
      'title': 'أذكار الوضوء',
      'icon': Icons.water_rounded,
      'color': Color(0xFF0284C7),
      'items': [
        {
          'text': 'بِسْمِ اللَّهِ.',
          'count': 1,
        },
        {
          'text':
              'أَشْهَدُ أَنْ لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، وَأَشْهَدُ أَنَّ مُحَمَّداً عَبْدُهُ وَرَسُولُهُ.',
          'count': 1,
        },
        {
          'text':
              'اللَّهُمَّ اجْعَلْنِي مِنَ التَّوَّابِينَ، وَاجْعَلْنِي مِنَ المُتَطَهِّرِينَ.',
          'count': 1,
        },
      ],
    },

    // ========================================================
    // اللباس
    // ========================================================

    {
      'title': 'أذكار اللباس',
      'icon': Icons.checkroom_rounded,
      'color': Color(0xFF9333EA),
      'items': [
        {
          'text':
              'الحَمْدُ لِلَّهِ الَّذِي كَسَانِي هَذَا الثَّوْبَ وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلاَ قُوَّةٍ.',
          'count': 1,
        },
      ],
    },

    // ========================================================
    // الطعام
    // ========================================================

    {
      'title': 'أذكار الطعام',
      'icon': Icons.restaurant_rounded,
      'color': Color(0xFFEA580C),
      'items': [
        {
          'text': 'بِسْمِ اللَّهِ.',
          'count': 1,
        },
        {
          'text':
              'الحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنِي هَذَا وَرَزَقَنِيهِ مِنْ غَيْرِ حَوْلٍ مِنِّي وَلاَ قُوَّةٍ.',
          'count': 1,
        },
        {
          'text':
              'الحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِينَ.',
          'count': 1,
        },
      ],
    },

    // ========================================================
    // السفر
    // ========================================================

    {
      'title': 'أذكار السفر',
      'icon': Icons.flight_takeoff_rounded,
      'color': Color(0xFF0284C7),
      'items': [
        {
          'text':
              'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَى رَبِّنَا لَمُنقَلِبُونَ.',
          'count': 1,
        },
        {
          'text':
              'اللَّهُمَّ إِنَّا نَسْأَلُكَ فِي سَفَرِنَا هَذَا البِرَّ وَالتَّقْوَى، وَمِنَ العَمَلِ مَا تَرْضَى.',
          'count': 1,
        },
        {
          'text':
              'اللَّهُمَّ هَوِّنْ عَلَيْنَا سَفَرَنَا هَذَا وَاطْوِ عَنَّا بُعْدَهُ.',
          'count': 1,
        },
      ],
    },

    // ========================================================
    // الخلاء
    // ========================================================

    {
      'title': 'أذكار الخلاء',
      'icon': Icons.wc_rounded,
      'color': Color(0xFF64748B),
      'items': [
        {
          'text':
              'بِسْمِ اللَّهِ، اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الخُبُثِ وَالخَبَائِثِ.',
          'count': 1,
        },
        {
          'text': 'غُفْرَانَكَ.',
          'count': 1,
        },
      ],
    },

    // ========================================================
    // المطر
    // ========================================================

    {
      'title': 'أذكار المطر',
      'icon': Icons.water_drop_rounded,
      'color': Color(0xFF0891B2),
      'items': [
        {
          'text': 'اللَّهُمَّ صَيِّباً نَافِعاً.',
          'count': 1,
        },
        {
          'text': 'مُطِرْنَا بِفَضْلِ اللَّهِ وَرَحْمَتِهِ.',
          'count': 1,
        },
        {
          'text': 'اللَّهُمَّ حَوَالَيْنَا وَلاَ عَلَيْنَا.',
          'count': 1,
        },
      ],
    },

    // ========================================================
    // الرياح
    // ========================================================

    {
      'title': 'أذكار الرياح',
      'icon': Icons.air_rounded,
      'color': Color(0xFF06B6D4),
      'items': [
        {
          'text':
              'اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَهَا وَخَيْرَ مَا فِيهَا وَخَيْرَ مَا أُرْسِلَتْ بِهِ، وَأَعُوذُ بِكَ مِنْ شَرِّهَا وَشَرِّ مَا فِيهَا وَشَرِّ مَا أُرْسِلَتْ بِهِ.',
          'count': 1,
        },
      ],
    },

    // ========================================================
    // الصيام
    // ========================================================

    {
      'title': 'أذكار الصيام',
      'icon': Icons.restaurant_menu_rounded,
      'color': Color(0xFF78350F),
      'items': [
        {
          'text':
              'ذَهَبَ الظَّمَأُ وَابْتَلَّتِ العُرُوقُ وَثَبَتَ الأَجْرُ إِنْ شَاءَ اللَّهُ.',
          'count': 1,
        },
      ],
    },

    // ========================================================
    // أدعية قرآنية
    // ========================================================

    {
      'title': 'أدعية قرآنية',
      'icon': Icons.menu_book_rounded,
      'color': Color(0xFF0F766E),
      'items': [
        {
          'text':
              'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ.',
          'count': 1,
        },
        {
          'text':
              'رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي.',
          'count': 1,
        },
        {
          'text':
              'رَبَّنَا لاَ تُزِغْ قُلُوبَنَا بَعْدَ إِذْ هَدَيْتَنَا وَهَبْ لَنَا مِنْ لَدُنْكَ رَحْمَةً إِنَّكَ أَنْتَ الوَهَّابُ.',
          'count': 1,
        },
        {
          'text':
              'رَبِّ اجْعَلْنِي مُقِيمَ الصَّلاَةِ وَمِنْ ذُرِّيَّتِي رَبَّنَا وَتَقَبَّلْ دُعَاءِ.',
          'count': 1,
        },
        {
          'text':
              'رَبِّ أَوْزِعْنِي أَنْ أَشْكُرَ نِعْمَتَكَ الَّتِي أَنْعَمْتَ عَلَيَّ وَعَلَى وَالِدَيَّ وَأَنْ أَعْمَلَ صَالِحاً تَرْضَاهُ.',
          'count': 1,
        },
        {
          'text':
              'رَبَّنَا اغْفِرْ لَنَا وَلإِخْوَانِنَا الَّذِينَ سَبَقُونَا بِالإِيمَانِ وَلاَ تَجْعَلْ فِي قُلُوبِنَا غِلاً لِّلَّذِينَ آمَنُوا.',
          'count': 1,
        },
      ],
    },

    // ========================================================
    // أدعية الأنبياء
    // ========================================================

    {
      'title': 'أدعية الأنبياء',
      'icon': Icons.people_alt_rounded,
      'color': Color(0xFF475569),
      'items': [
        {
          'text':
              'رَبِّ إِنِّي لِمَا أَنزَلْتَ إِلَيَّ مِنْ خَيْرٍ فَقِيرٌ.',
          'count': 1,
        },
        {
          'text':
              'رَبِّ أَنِّي مَسَّنِيَ الضُّرُّ وَأَنتَ أَرْحَمُ الرَّاحِمِينَ.',
          'count': 1,
        },
        {
          'text':
              'لاَ إِلَهَ إِلاَّ أَنتَ سُبْحَانَكَ إِنِّي كُنتُ مِنَ الظَّالِمِينَ.',
          'count': 1,
        },
        {
          'text':
              'رَبِّ اغْفِرْ لِي وَهَبْ لِي مُلْكاً لاَّ يَنبَغِي لِأَحَدٍ مِّن بَعْدِي.',
          'count': 1,
        },
      ],
    },

    // ========================================================
    // أذكار مطلقة
    // ========================================================

    {
      'title': 'أذكار مطلقة',
      'icon': Icons.self_improvement_rounded,
      'color': Color(0xFFDB2777),
      'items': [
        {
          'text': 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ.',
          'count': 100,
        },
        {
          'text':
              'لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ المُلْكُ وَلَهُ الحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.',
          'count': 100,
        },
        {
          'text': 'أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ.',
          'count': 100,
        },
        {
          'text': 'اللَّهُمَّ صَلِّ وَسَلِّمْ عَلَى نَبِيِّنَا مُحَمَّدٍ.',
          'count': 10,
        },
        {
          'text': 'لاَ حَوْلَ وَلاَ قُوَّةَ إِلاَّ بِاللَّهِ.',
          'count': 100,
        },
      ],
    },

    // ========================================================
    // الاستغفار
    // ========================================================

    {
      'title': 'الاستغفار',
      'icon': Icons.refresh_rounded,
      'color': Color(0xFF15803D),
      'items': [
        {
          'text': 'أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ.',
          'count': 100,
        },
        {
          'text': 'رَبِّ اغْفِرْ لِي.',
          'count': 100,
        },
        {
          'text': 'اللَّهُمَّ اغْفِرْ لِي وَارْحَمْنِي وَاهْدِنِي.',
          'count': 10,
        },
      ],
    },

    // ========================================================
    // المريض
    // ========================================================

    {
      'title': 'أدعية للمريض',
      'icon': Icons.healing_rounded,
      'color': Color(0xFFDC2626),
      'items': [
        {
          'text': 'لاَ بَأْسَ طَهُورٌ إِنْ شَاءَ اللَّهُ.',
          'count': 1,
        },
        {
          'text':
              'أَسْأَلُ اللَّهَ العَظِيمَ رَبَّ العَرْشِ العَظِيمِ أَنْ يَشْفِيَكَ.',
          'count': 7,
        },
        {
          'text':
              'اللَّهُمَّ اشْفِ عَبْدَكَ يَنْكَأُ لَكَ عَدُوّاً أَوْ يَمْشِي لَكَ إِلَى صَلاَةٍ.',
          'count': 1,
        },
      ],
    },

    // ========================================================
    // الهم والحزن
    // ========================================================

    {
      'title': 'دعاء الهم والحزن',
      'icon': Icons.favorite_rounded,
      'color': Color(0xFF4F46E5),
      'items': [
        {
          'text':
              'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الهَمِّ وَالحَزَنِ، وَأَعُوذُ بِكَ مِنَ العَجْزِ وَالكَسَلِ، وَأَعُوذُ بِكَ مِنَ الجُبْنِ وَالبُخْلِ، وَأَعُوذُ بِكَ مِنْ غَلَبَةِ الدَّيْنِ وَقَهْرِ الرِّجَالِ.',
          'count': 1,
        },
      ],
    },

    // ========================================================
    // دعاء الكرب
    // ========================================================

    {
      'title': 'دعاء الكرب',
      'icon': Icons.volunteer_activism_rounded,
      'color': Color(0xFF6D28D9),
      'items': [
        {
          'text':
              'لاَ إِلَهَ إِلاَّ اللَّهُ العَظِيمُ الحَلِيمُ، لاَ إِلَهَ إِلاَّ اللَّهُ رَبُّ العَرْشِ العَظِيمِ، لاَ إِلَهَ إِلاَّ اللَّهُ رَبُّ السَّمَاوَاتِ وَرَبُّ الأَرْضِ وَرَبُّ العَرْشِ الكَرِيمِ.',
          'count': 1,
        },
      ],
    },

    // ========================================================
    // قضاء الدين
    // ========================================================

    {
      'title': 'دعاء قضاء الدين',
      'icon': Icons.account_balance_wallet_rounded,
      'color': Color(0xFF0D9488),
      'items': [
        {
          'text':
              'اللَّهُمَّ اكْفِنِي بِحَلاَلِكَ عَنْ حَرَامِكَ، وَأَغْنِنِي بِفَضْلِكَ عَمَّنْ سِوَاكَ.',
          'count': 1,
        },
      ],
    },

    // ========================================================
    // الغضب
    // ========================================================

    {
      'title': 'أذكار عند الغضب',
      'icon': Icons.mood_bad_rounded,
      'color': Color(0xFFEF4444),
      'items': [
        {
          'text': 'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ.',
          'count': 1,
        },
      ],
    },

    // ========================================================
    // السوق
    // ========================================================

    {
      'title': 'أذكار دخول السوق',
      'icon': Icons.storefront_rounded,
      'color': Color(0xFFD97706),
      'items': [
        {
          'text':
              'لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ المُلْكُ وَلَهُ الحَمْدُ، يُحْيِي وَيُمِيتُ، وَهُوَ حَيٌّ لاَ يَمُوتُ، بِيَدِهِ الخَيْرُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ.',
          'count': 1,
        },
      ],
    },

    // ========================================================
    // العطاس
    // ========================================================

    {
      'title': 'أذكار العطاس',
      'icon': Icons.air_rounded,
      'color': Color(0xFF0891B2),
      'items': [
        {
          'text': 'الحَمْدُ لِلَّهِ.',
          'count': 1,
        },
        {
          'text': 'يَرْحَمُكَ اللَّهُ.',
          'count': 1,
        },
        {
          'text': 'يَهْدِيكُمُ اللَّهُ وَيُصْلِحُ بَالَكُمْ.',
          'count': 1,
        },
      ],
    },

    // ========================================================
    // الصلاة على النبي
    // ========================================================

    {
      'title': 'الصلاة على النبي ﷺ',
      'icon': Icons.auto_awesome_rounded,
      'color': Color(0xFFCA8A04),
      'items': [
        {
          'text':
              'اللَّهُمَّ صَلِّ وَسَلِّمْ وَبَارِكْ عَلَى نَبِيِّنَا مُحَمَّدٍ.',
          'count': 10,
        },
      ],
    },
  ];
}

// ============================================================
// الصفحة الرئيسية
// ============================================================

class HisnElMuslimPage extends StatefulWidget {
  const HisnElMuslimPage({super.key});

  @override
  State<HisnElMuslimPage> createState() => _HisnElMuslimPageState();
}

class _HisnElMuslimPageState extends State<HisnElMuslimPage> {
  final TextEditingController _searchController = TextEditingController();
  String _search = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get filteredCategories {
    if (_search.trim().isEmpty) {
      return AzkarData.categories;
    }

    final query = _search.trim().toLowerCase();

    return AzkarData.categories.where((category) {
      final title = category['title'].toString().toLowerCase();

      final items = List<Map<String, dynamic>>.from(
        category['items'],
      );

      return title.contains(query) ||
          items.any(
            (item) =>
                item['text'].toString().toLowerCase().contains(query),
          );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: _buildHeroHeader(context),
            ),
            SliverToBoxAdapter(
              child: _buildSearch(),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final category = filteredCategories[index];

                    return _buildCategoryCard(
                      context,
                      category,
                    );
                  },
                  childCount: filteredCategories.length,
                ),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.92,
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 5,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const DigitalTasbihPage(),
              ),
            );
          },
          icon: const Icon(Icons.touch_app_rounded),
          label: const Text(
            'المسبحة',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 18,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.green,
            AppColors.primary,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.mosque_rounded,
                  color: Colors.white,
                  size: 27,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'حصن المسلم',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'أذكار وأدعية المسلم اليومية',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FavoritesPage(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.star_rounded,
                  color: Colors.amber,
                  size: 30,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.12),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withOpacity(.18),
              ),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.format_quote_rounded,
                  color: Colors.amber,
                  size: 28,
                ),
                SizedBox(height: 6),
                Text(
                  'أَلَا بِذِكْرِ اللَّهِ تَطْمَئِنُّ الْقُلُوبُ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    height: 1.7,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'ابدأ وردك اليومي واطمئن بذكر الله',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearch() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          setState(() {
            _search = value;
          });
        },
        textDirection: TextDirection.rtl,
        decoration: InputDecoration(
          hintText: 'ابحث عن ذكر أو قسم...',
          prefixIcon: const Icon(
            Icons.search_rounded,
            color: AppColors.primary,
          ),
          suffixIcon: _search.isEmpty
              ? null
              : IconButton(
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _search = '';
                    });
                  },
                  icon: const Icon(Icons.close_rounded),
                ),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    Map<String, dynamic> category,
  ) {
    final Color color = category['color'] as Color;
    final items = List<Map<String, dynamic>>.from(
      category['items'],
    );

    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AzkarDetailPage(
              title: category['title'],
              items: items,
              themeColor: color,
              icon: category['icon'],
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: color.withOpacity(.13),
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(.08),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withOpacity(.10),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  category['icon'],
                  color: color,
                  size: 23,
                ),
              ),
            ),
            const Spacer(),
            Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                color: color.withOpacity(.07),
                shape: BoxShape.circle,
              ),
              child: Icon(
                category['icon'],
                color: color,
                size: 31,
              ),
            ),
            const SizedBox(height: 11),
            Text(
              category['title'],
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.text,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '${items.length} أذكار',
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 11,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// صفحة الأذكار
// ============================================================

class AzkarDetailPage extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> items;
  final Color themeColor;
  final IconData icon;

  const AzkarDetailPage({
    super.key,
    required this.title,
    required this.items,
    required this.themeColor,
    required this.icon,
  });

  @override
  State<AzkarDetailPage> createState() => _AzkarDetailPageState();
}

class _AzkarDetailPageState extends State<AzkarDetailPage> {
  late List<int> _counters;
  final Set<String> _favorites = {};
  String _search = '';

  @override
  void initState() {
    super.initState();

    _counters = widget.items.map<int>((item) {
      return item['count'] as int;
    }).toList();
  }

  List<int> get filteredIndexes {
    if (_search.trim().isEmpty) {
      return List.generate(
        widget.items.length,
        (index) => index,
      );
    }

    final query = _search.trim();

    return List.generate(
      widget.items.length,
      (index) => index,
    ).where((index) {
      return widget.items[index]['text']
          .toString()
          .contains(query);
    }).toList();
  }

  void _decrement(int index) {
    if (_counters[index] <= 0) return;

    HapticFeedback.lightImpact();

    setState(() {
      _counters[index]--;
    });

    if (_counters[index] == 0) {
      HapticFeedback.mediumImpact();
    }
  }

  void _resetOne(int index) {
    setState(() {
      _counters[index] =
          widget.items[index]['count'] as int;
    });
  }

  void _toggleFavorite(String text) {
    setState(() {
      if (_favorites.contains(text)) {
        _favorites.remove(text);
      } else {
        _favorites.add(text);
      }
    });
  }

  Future<void> _share(String text) async {
    await SharePlus.instance.share(
      ShareParams(
        text: '$text\n\nمن تطبيق حصن المسلم',
      ),
    );
  }

  void _copy(String text) {
    Clipboard.setData(
      ClipboardData(text: text),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'تم نسخ الذكر',
          textAlign: TextAlign.center,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final indexes = filteredIndexes;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: widget.themeColor,
          foregroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  _search = _search.isEmpty
                      ? ' '
                      : '';
                });
              },
              icon: const Icon(
                Icons.search_rounded,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            if (_search.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  14,
                  16,
                  4,
                ),
                child: TextField(
                  autofocus: true,
                  onChanged: (value) {
                    setState(() {
                      _search = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'ابحث داخل الأذكار...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

            _buildProgressHeader(),

            Expanded(
              child: indexes.isEmpty
                  ? _buildEmptySearch()
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        8,
                        16,
                        30,
                      ),
                      itemCount: indexes.length,
                      itemBuilder: (context, listIndex) {
                        final index =
                            indexes[listIndex];

                        return _buildZikrCard(
                          index,
                          listIndex + 1,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressHeader() {
    int completed = 0;

    for (int i = 0; i < _counters.length; i++) {
      if (_counters[i] == 0) {
        completed++;
      }
    }

    final progress = widget.items.isEmpty
        ? 0.0
        : completed / widget.items.length;

    return Container(
      margin: const EdgeInsets.fromLTRB(
        16,
        14,
        16,
        4,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 58,
            height: 58,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 5,
                  backgroundColor:
                      widget.themeColor.withOpacity(.10),
                  valueColor:
                      AlwaysStoppedAnimation<Color>(
                    widget.themeColor,
                  ),
                ),
                Text(
                  '${(progress * 100).round()}%',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: widget.themeColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'وردك اليومي',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'أكمل الأذكار بهدوء واحتساب',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$completed / ${widget.items.length}',
            style: TextStyle(
              color: widget.themeColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptySearch() {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 60,
            color: Colors.grey,
          ),
          SizedBox(height: 12),
          Text(
            'لم يتم العثور على الذكر',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZikrCard(
    int index,
    int number,
  ) {
    final item = widget.items[index];
    final text = item['text'] as String;

    final int remaining = _counters[index];
    final int total = item['count'] as int;

    final bool done = remaining == 0;

    final double progress = total == 0
        ? 0
        : (total - remaining) / total;

    final bool favorite =
        _favorites.contains(text);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: done
            ? Colors.grey.shade50
            : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: done
              ? Colors.grey.shade300
              : widget.themeColor.withOpacity(.16),
          width: 1.3,
        ),
        boxShadow: [
          BoxShadow(
            color: widget.themeColor.withOpacity(.06),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: widget.themeColor.withOpacity(.09),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    '$number',
                    style: TextStyle(
                      color: widget.themeColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'المفضلة',
                onPressed: () =>
                    _toggleFavorite(text),
                icon: Icon(
                  favorite
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                  color: favorite
                      ? Colors.amber
                      : Colors.grey,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              height: 2,
              color: done
                  ? Colors.grey
                  : AppColors.text,
              fontWeight: FontWeight.w500,
              decoration: done
                  ? TextDecoration.lineThrough
                  : null,
            ),
          ),

          const SizedBox(height: 16),

          // ==================================================
          // العداد الدائري
          // ==================================================

          GestureDetector(
            onTap: done
                ? null
                : () => _decrement(index),
            child: SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    height: 100,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 7,
                      backgroundColor:
                          widget.themeColor.withOpacity(.10),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(
                        done
                            ? Colors.grey
                            : widget.themeColor,
                      ),
                    ),
                  ),
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: done
                          ? Colors.grey.shade100
                          : widget.themeColor
                              .withOpacity(.08),
                      shape: BoxShape.circle,
                    ),
                    child: Column(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Icon(
                          done
                              ? Icons.check_rounded
                              : Icons.touch_app_rounded,
                          color: done
                              ? Colors.grey
                              : widget.themeColor,
                          size: 21,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          done
                              ? 'تم'
                              : '$remaining',
                          style: TextStyle(
                            color: done
                                ? Colors.grey
                                : widget.themeColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 14),

          Text(
            done
                ? 'أحسنت، تم إكمال الذكر'
                : 'المتبقي: $remaining من $total',
            style: TextStyle(
              color: done
                  ? Colors.green
                  : Colors.grey.shade600,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              _actionButton(
                icon: Icons.copy_rounded,
                label: 'نسخ',
                onTap: () => _copy(text),
              ),
              const SizedBox(width: 8),
              _actionButton(
                icon: Icons.share_rounded,
                label: 'مشاركة',
                onTap: () => _share(text),
              ),
              const SizedBox(width: 8),
              _actionButton(
                icon: Icons.refresh_rounded,
                label: 'إعادة',
                onTap: () => _resetOne(index),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(13),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(13),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 17,
              color: Colors.grey.shade700,
            ),
            const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// المفضلة
// ============================================================

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  List<Map<String, dynamic>> get favorites {
    final List<Map<String, dynamic>> result = [];

    for (final category in AzkarData.categories) {
      final items =
          List<Map<String, dynamic>>.from(
        category['items'],
      );

      for (final item in items) {
        result.add({
          'text': item['text'],
          'category': category['title'],
          'color': category['color'],
        });
      }
    }

    // صفحة المفضلة الأساسية تعرض جميع الأذكار
    // ويمكن لاحقاً ربطها بـ SharedPreferences.
    return result.take(20).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'المفضلة',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final item = favorites[index];
            final Color color =
                item['color'] as Color;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item['category'],
                        style: TextStyle(
                          color: color,
                          fontSize: 12,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item['text'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.9,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============================================================
// المسبحة الإلكترونية المحسنة
// ============================================================

class DigitalTasbihPage extends StatefulWidget {
  const DigitalTasbihPage({super.key});

  @override
  State<DigitalTasbihPage> createState() =>
      _DigitalTasbihPageState();
}

class _DigitalTasbihPageState
    extends State<DigitalTasbihPage>
    with SingleTickerProviderStateMixin {
  int _count = 0;
  int _total = 0;

  final List<String> _phrases = [
    'سُبْحَانَ اللَّهِ',
    'الحَمْدُ لِلَّهِ',
    'اللَّهُ أَكْبَرُ',
    'لاَ إِلَهَ إِلاَّ اللَّهُ',
    'أَسْتَغْفِرُ اللَّهَ',
    'لاَ حَوْلَ وَلاَ قُوَّةَ إِلاَّ بِاللَّهِ',
    'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ',
  ];

  String _currentPhrase = 'سُبْحَانَ اللَّهِ';

  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 100,
      ),
      lowerBound: .94,
      upperBound: 1,
      value: 1,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _increment() {
    HapticFeedback.lightImpact();

    setState(() {
      _count++;
      _total++;
    });

    _animationController.reverse().then((_) {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  void _reset() {
    HapticFeedback.mediumImpact();

    setState(() {
      _count = 0;
    });
  }

  void _resetAll() {
    setState(() {
      _count = 0;
      _total = 0;
    });
  }

  void _changePhrase(String phrase) {
    setState(() {
      _currentPhrase = phrase;
      _count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.green,
                AppColors.primary,
                AppColors.background,
              ],
              stops: [0, .48, 1],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildAppBar(),

                const SizedBox(height: 25),

                const Text(
                  'اذكر الله بقلب حاضر',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  _currentPhrase,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),

                const Spacer(),

                // ==================================================
                // الدائرة الكبيرة
                // ==================================================

                ScaleTransition(
                  scale: _animationController,
                  child: GestureDetector(
                    onTap: _increment,
                    child: Container(
                      width: 255,
                      height: 255,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient:
                            const LinearGradient(
                          colors: [
                            Color(0xFF14B8A6),
                            Color(0xFF0F766E),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: Colors.white
                              .withOpacity(.25),
                          width: 7,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(.18),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.touch_app_rounded,
                            color: Colors.white70,
                            size: 27,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '$_count',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 68,
                              fontWeight:
                                  FontWeight.w800,
                            ),
                          ),
                          const Text(
                            'اضغط للذكر',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(.13),
                    borderRadius:
                        BorderRadius.circular(30),
                  ),
                  child: Text(
                    'المجموع الكلي: $_total',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const Spacer(),

                // ==================================================
                // اختيار الذكر
                // ==================================================

                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection:
                        Axis.horizontal,
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    itemCount: _phrases.length,
                    itemBuilder: (context, index) {
                      final phrase =
                          _phrases[index];

                      final selected =
                          phrase ==
                              _currentPhrase;

                      return Padding(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 5,
                        ),
                        child: ChoiceChip(
                          label: Text(
                            phrase,
                            style: TextStyle(
                              color: selected
                                  ? Colors.white
                                  : AppColors.text,
                              fontSize: 12,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          selected: selected,
                          selectedColor:
                              AppColors.primary,
                          backgroundColor:
                              Colors.white,
                          onSelected: (_) {
                            _changePhrase(
                              phrase,
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _reset,
                      icon: const Icon(
                        Icons.refresh_rounded,
                      ),
                      label: const Text(
                        'إعادة العد',
                      ),
                      style: OutlinedButton
                          .styleFrom(
                        foregroundColor:
                            AppColors.primary,
                        backgroundColor:
                            Colors.white,
                        side: BorderSide.none,
                      ),
                    ),
                    const SizedBox(width: 10),
                    OutlinedButton.icon(
                      onPressed: _resetAll,
                      icon: const Icon(
                        Icons.restart_alt_rounded,
                      ),
                      label: const Text(
                        'تصفير الكل',
                      ),
                      style: OutlinedButton
                          .styleFrom(
                        foregroundColor:
                            Colors.red.shade700,
                        backgroundColor:
                            Colors.white,
                        side: BorderSide.none,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        12,
        8,
        12,
        0,
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_forward_rounded,
              color: Colors.white,
            ),
          ),
          const Expanded(
            child: Text(
              'المسبحة الإلكترونية',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
