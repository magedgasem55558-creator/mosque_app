import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ============================================================================
// النماذج
// ============================================================================

class Reciter {
  final String id;
  final String name;
  final String serverUrl;

  const Reciter({
    required this.id,
    required this.name,
    required this.serverUrl,
  });
}

class QuranSurah {
  final int number;
  final String name;

  const QuranSurah({
    required this.number,
    required this.name,
  });
}

class DownloadedQuran {
  final String reciterId;
  final String reciterName;
  final int surahNumber;
  final String surahName;
  final String filePath;

  const DownloadedQuran({
    required this.reciterId,
    required this.reciterName,
    required this.surahNumber,
    required this.surahName,
    required this.filePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'reciterId': reciterId,
      'reciterName': reciterName,
      'surahNumber': surahNumber,
      'surahName': surahName,
      'filePath': filePath,
    };
  }

  factory DownloadedQuran.fromJson(
    Map<String, dynamic> json,
  ) {
    return DownloadedQuran(
      reciterId: json['reciterId']?.toString() ?? '',
      reciterName: json['reciterName']?.toString() ?? '',
      surahNumber: json['surahNumber'] is int
          ? json['surahNumber']
          : int.tryParse(
                json['surahNumber']?.toString() ?? '',
              ) ??
              0,
      surahName: json['surahName']?.toString() ?? '',
      filePath: json['filePath']?.toString() ?? '',
    );
  }
}

// ============================================================================
// بيانات القرآن
// ============================================================================

class QuranData {
  static const List<String> surahNames = [
    "الفاتحة",
    "البقرة",
    "آل عمران",
    "النساء",
    "المائدة",
    "الأنعام",
    "الأعراف",
    "الأنفال",
    "التوبة",
    "يونس",
    "هود",
    "يوسف",
    "الرعد",
    "إبراهيم",
    "الحجر",
    "النحل",
    "الإسراء",
    "الكهف",
    "مريم",
    "طه",
    "الأنبياء",
    "الحج",
    "المؤمنون",
    "النور",
    "الفرقان",
    "الشعراء",
    "النمل",
    "القصص",
    "العنكبوت",
    "الروم",
    "لقمان",
    "السجدة",
    "الأحزاب",
    "سبأ",
    "فاطر",
    "يس",
    "الصافات",
    "ص",
    "الزمر",
    "غافر",
    "فصلت",
    "الشورى",
    "الزخرف",
    "الدخان",
    "الجاثية",
    "الأحقاف",
    "محمد",
    "الفتح",
    "الحجرات",
    "ق",
    "الذاريات",
    "الطور",
    "النجم",
    "القمر",
    "الرحمن",
    "الواقعة",
    "الحديد",
    "المجادلة",
    "الحشر",
    "الممتحنة",
    "الصف",
    "الجمعة",
    "المنافقون",
    "التغابن",
    "الطلاق",
    "التحريم",
    "الملك",
    "القلم",
    "الحاقة",
    "المعارج",
    "نوح",
    "الجن",
    "المزمل",
    "المدثر",
    "القيامة",
    "الإنسان",
    "المرسلات",
    "النبأ",
    "النازعات",
    "عبس",
    "التكوير",
    "الانفطار",
    "المطففين",
    "الانشقاق",
    "البروج",
    "الطارق",
    "الأعلى",
    "الغاشية",
    "الفجر",
    "البلد",
    "الشمس",
    "الليل",
    "الضحى",
    "الشرح",
    "التين",
    "العلق",
    "القدر",
    "البينة",
    "الزلزلة",
    "العاديات",
    "القارعة",
    "التكاثر",
    "العصر",
    "الهمزة",
    "الفيل",
    "قريش",
    "الماعون",
    "الكوثر",
    "الكافرون",
    "النصر",
    "المسد",
    "الإخلاص",
    "الفلق",
    "الناس",
  ];

  static List<QuranSurah> get surahs {
    return List.generate(
      surahNames.length,
      (index) => QuranSurah(
        number: index + 1,
        name: surahNames[index],
      ),
    );
  }
}

// ============================================================================
// الألوان
// ============================================================================

class QuranTheme {
  static const Color darkGreen = Color(0xFF063B32);
  static const Color green = Color(0xFF0B6B57);
  static const Color emerald = Color(0xFF0F8B70);
  static const Color gold = Color(0xFFC9A646);
  static const Color cream = Color(0xFFF8F4E9);
  static const Color background = Color(0xFFF4F7F5);
  static const Color text = Color(0xFF17221F);
}

// ============================================================================
// الصفحة
// ============================================================================

class YasserDossariQuranPage extends StatefulWidget {
  const YasserDossariQuranPage({super.key});

  @override
  State<YasserDossariQuranPage> createState() =>
      _YasserDossariQuranPageState();
}

class _YasserDossariQuranPageState
    extends State<YasserDossariQuranPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Dio _dio = Dio();

  // ==========================================================================
  // القراء
  // ==========================================================================

  final List<Reciter> _fallbackReciters = const [
    Reciter(
      id: 'yasser',
      name: 'ياسر الدوسري',
      serverUrl: 'https://server11.mp3quran.net/yasser/',
    ),
    Reciter(
      id: 'basit',
      name: 'عبد الباسط عبد الصمد',
      serverUrl: 'https://server7.mp3quran.net/basit/',
    ),
    Reciter(
      id: 'afs',
      name: 'مشاري العفاسي',
      serverUrl: 'https://server8.mp3quran.net/afs/',
    ),
    Reciter(
      id: 'maher',
      name: 'ماهر المعيقلي',
      serverUrl: 'https://server12.mp3quran.net/maher/',
    ),
    Reciter(
      id: 'shur',
      name: 'سعود الشريم',
      serverUrl: 'https://server7.mp3quran.net/shur/',
    ),
    Reciter(
      id: 'sds',
      name: 'عبد الرحمن السديس',
      serverUrl: 'https://server11.mp3quran.net/sds/',
    ),
    Reciter(
      id: 'shatri',
      name: 'أبو بكر الشاطري',
      serverUrl: 'https://server11.mp3quran.net/shatri/',
    ),
    Reciter(
      id: 'hudhaify',
      name: 'علي الحذيفي',
      serverUrl: 'https://server9.mp3quran.net/hudhaify/',
    ),
    Reciter(
      id: 'minsh',
      name: 'محمد صديق المنشاوي',
      serverUrl: 'https://server10.mp3quran.net/minsh/',
    ),
    Reciter(
      id: 'hussary',
      name: 'محمود خليل الحصري',
      serverUrl: 'https://server13.mp3quran.net/husr/',
    ),
  ];

  List<Reciter> _reciters = [];

  late Reciter _selectedReciter;

  bool _loadingReciters = true;

  // ==========================================================================
  // الصوت
  // ==========================================================================

  bool _isPlaying = false;

  int? _currentSurahIndex;

  String? _currentReciterId;

  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  // ==========================================================================
  // التنزيلات
  // ==========================================================================

  final Map<String, bool> _downloadedSurahs = {};
  final Map<String, double> _downloadProgress = {};

  final List<DownloadedQuran> _downloadedQuran = [];

  // ==========================================================================
  // المفضلة والبحث
  // ==========================================================================

  final Set<int> _favorites = {};

  String _searchQuery = '';

  // 0 = السور
  // 1 = التنزيلات
  // 2 = الصفحات
  // 3 = القراء
  int _selectedTab = 0;

  // ==========================================================================
  // الصفحات
  // ==========================================================================

  int _currentPage = 1;

  List<dynamic> _pageAyahs = [];

  bool _loadingPage = false;

  // ==========================================================================
  // INIT
  // ==========================================================================

  @override
  void initState() {
    super.initState();

    _reciters = List.from(_fallbackReciters);
    _selectedReciter = _reciters.first;

    _listenToAudio();
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadPreferences();

    await _loadDownloadedQuran();

    await _checkDownloadedFiles();

    await _loadRecitersFromApi();

    await _loadSavedPage();

    if (mounted) {
      setState(() {});
    }

    // تظهر الرسالة بعد تجهيز الصفحة.
    await _showFirstTimeTip();
  }

  // ==========================================================================
  // رسالة أول مرة
  // ==========================================================================

  Future<void> _showFirstTimeTip() async {
    final prefs = await SharedPreferences.getInstance();

    final hasSeenTip =
        prefs.getBool('quran_first_tip_shown') ?? false;

    if (hasSeenTip || !mounted) return;

    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    if (!mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          titlePadding: const EdgeInsets.fromLTRB(
            24,
            24,
            24,
            8,
          ),
          contentPadding: const EdgeInsets.fromLTRB(
            24,
            8,
            24,
            10,
          ),
          actionsPadding: const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            16,
          ),
          title: Column(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.download_for_offline_rounded,
                  color: Colors.teal,
                  size: 34,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'استمع للقرآن بدون إنترنت',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'ميزة رائعة للاستماع في أي وقت',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.teal.shade700,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Text(
                'يمكنك تنزيل أي سورة بصوت القارئ '
                'المفضل لديك، ثم الاستماع إليها لاحقًا '
                'في أي وقت حتى بدون اتصال بالإنترنت.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade700,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 18),
              _buildTipItem(
                icon: Icons.download_rounded,
                title: 'حمّل السورة',
                subtitle:
                    'اختر السورة والقارئ ثم اضغط على زر التحميل.',
              ),
              const SizedBox(height: 10),
              _buildTipItem(
                icon: Icons.wifi_off_rounded,
                title: 'استمع بدون إنترنت',
                subtitle:
                    'بعد اكتمال التحميل يمكنك الاستماع إليها في أي وقت.',
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.teal.withOpacity(.06),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.teal.withOpacity(.12),
                  ),
                ),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: Colors.teal.shade600,
                      size: 19,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'يمكنك العثور على جميع السور '
                        'التي تم تنزيلها من قسم التنزيلات، '
                        'مع معرفة اسم القارئ لكل سورة.',
                        style: TextStyle(
                          color: Colors.teal.shade800,
                          fontSize: 12.5,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () async {
                  await prefs.setBool(
                    'quran_first_tip_shown',
                    true,
                  );

                  if (ctx.mounted) {
                    Navigator.pop(ctx);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'فهمت، ابدأ الآن',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTipItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.teal,
              size: 22,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // الصوت
  // ==========================================================================

  void _listenToAudio() {
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;

      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    _audioPlayer.onDurationChanged.listen((duration) {
      if (!mounted) return;

      setState(() {
        _duration = duration;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      if (!mounted) return;

      setState(() {
        _position = position;
      });
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      if (!mounted) return;

      setState(() {
        _isPlaying = false;
      });
    });
  }

  // ==========================================================================
  // القراء API
  // ==========================================================================

  Future<void> _loadRecitersFromApi() async {
    try {
      final response = await _dio.get(
        'https://www.mp3quran.net/api/v3/reciters?language=ar',
      );

      final data = response.data;

      if (data is Map && data['reciters'] is List) {
        final List<Reciter> result = [];

        for (final reciter in data['reciters']) {
          final name = reciter['name'];
          final moshaf = reciter['moshaf'];

          if (name == null ||
              moshaf is! List ||
              moshaf.isEmpty) {
            continue;
          }

          final firstMoshaf = moshaf.first;
          final server = firstMoshaf['server'];

          if (server == null) continue;

          result.add(
            Reciter(
              id: '${reciter['id']}',
              name: name.toString(),
              serverUrl: server.toString(),
            ),
          );
        }

        if (result.isNotEmpty && mounted) {
          setState(() {
            _reciters = result;
            _loadingReciters = false;

            final match = result.where(
              (e) => e.id == _selectedReciter.id,
            );

            if (match.isNotEmpty) {
              _selectedReciter = match.first;
            }
          });

          return;
        }
      }
    } catch (e) {
      debugPrint('Reciters API error: $e');
    }

    if (mounted) {
      setState(() {
        _loadingReciters = false;
      });
    }
  }

  // ==========================================================================
  // SharedPreferences
  // ==========================================================================

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    final favorites =
        prefs.getStringList('quran_favorites') ?? [];

    _favorites.clear();

    for (final value in favorites) {
      final number = int.tryParse(value);

      if (number != null) {
        _favorites.add(number);
      }
    }
  }

  Future<void> _toggleFavorite(int surahNumber) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      if (_favorites.contains(surahNumber)) {
        _favorites.remove(surahNumber);
      } else {
        _favorites.add(surahNumber);
      }
    });

    await prefs.setStringList(
      'quran_favorites',
      _favorites.map((e) => e.toString()).toList(),
    );
  }

  // ==========================================================================
  // حفظ التنزيلات
  // ==========================================================================

  Future<void> _loadDownloadedQuran() async {
    final prefs = await SharedPreferences.getInstance();

    final raw =
        prefs.getStringList('quran_downloaded_items') ?? [];

    _downloadedQuran.clear();

    for (final item in raw) {
      try {
        final decoded =
            jsonDecode(item);

        if (decoded is Map<String, dynamic>) {
          final download =
              DownloadedQuran.fromJson(decoded);

          if (File(download.filePath).existsSync()) {
            _downloadedQuran.add(download);
          }
        }
      } catch (_) {}
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _saveDownloadedQuran() async {
    final prefs = await SharedPreferences.getInstance();

    final data = _downloadedQuran
        .map(
          (item) => jsonEncode(item.toJson()),
        )
        .toList();

    await prefs.setStringList(
      'quran_downloaded_items',
      data,
    );
  }

  Future<void> _addDownloadedQuran(
    DownloadedQuran item,
  ) async {
    _downloadedQuran.removeWhere(
      (old) =>
          old.reciterId == item.reciterId &&
          old.surahNumber == item.surahNumber,
    );

    _downloadedQuran.insert(0, item);

    await _saveDownloadedQuran();

    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _removeDownloadedQuran(
    DownloadedQuran item,
  ) async {
    try {
      final file = File(item.filePath);

      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {}

    _downloadedQuran.removeWhere(
      (old) =>
          old.reciterId == item.reciterId &&
          old.surahNumber == item.surahNumber,
    );

    final key =
        '${item.reciterId}_${item.surahNumber}';

    _downloadedSurahs.remove(key);

    await _saveDownloadedQuran();

    if (mounted) {
      setState(() {});
    }
  }

  // ==========================================================================
  // الملفات
  // ==========================================================================

  String _getFileKey(
    Reciter reciter,
    int surahIndex,
  ) {
    return '${reciter.id}_${surahIndex + 1}';
  }

  String _getFileKeyFromValues(
    String reciterId,
    int surahNumber,
  ) {
    return '${reciterId}_$surahNumber';
  }

  String _getSurahUrl(
    Reciter reciter,
    int index,
  ) {
    final number =
        (index + 1).toString().padLeft(3, '0');

    String base = reciter.serverUrl;

    if (!base.endsWith('/')) {
      base += '/';
    }

    return '$base$number.mp3';
  }

  Future<String> _getFilePath(
    Reciter reciter,
    int index,
  ) async {
    final directory =
        await getApplicationDocumentsDirectory();

    return '${directory.path}/quran_${_getFileKey(reciter, index)}.mp3';
  }

  Future<void> _checkDownloadedFiles() async {
    for (final reciter in _reciters) {
      for (
        int i = 0;
        i < QuranData.surahNames.length;
        i++
      ) {
        final path =
            await _getFilePath(reciter, i);

        if (File(path).existsSync()) {
          final key =
              _getFileKey(reciter, i);

          _downloadedSurahs[key] = true;

          final exists =
              _downloadedQuran.any(
            (item) =>
                item.reciterId == reciter.id &&
                item.surahNumber == i + 1,
          );

          if (!exists) {
            await _addDownloadedQuran(
              DownloadedQuran(
                reciterId: reciter.id,
                reciterName: reciter.name,
                surahNumber: i + 1,
                surahName:
                    QuranData.surahNames[i],
                filePath: path,
              ),
            );
          }
        }
      }
    }

    if (mounted) {
      setState(() {});
    }
  }

  // ==========================================================================
  // تحميل السورة
  // ==========================================================================

  Future<void> _downloadSurah(int index) async {
    final reciter = _selectedReciter;

    final fileKey =
        _getFileKey(reciter, index);

    final url =
        _getSurahUrl(reciter, index);

    final savePath =
        await _getFilePath(reciter, index);

    try {
      setState(() {
        _downloadProgress[fileKey] = 0;
      });

      await _dio.download(
        url,
        savePath,
        deleteOnError: true,
        onReceiveProgress: (received, total) {
          if (!mounted) return;

          if (total > 0) {
            setState(() {
              _downloadProgress[fileKey] =
                  received / total;
            });
          }
        },
      );

      final item = DownloadedQuran(
        reciterId: reciter.id,
        reciterName: reciter.name,
        surahNumber: index + 1,
        surahName:
            QuranData.surahNames[index],
        filePath: savePath,
      );

      await _addDownloadedQuran(item);

      if (!mounted) return;

      setState(() {
        _downloadedSurahs[fileKey] = true;
        _downloadProgress.remove(fileKey);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: QuranTheme.darkGreen,
          behavior: SnackBarBehavior.floating,
          content: Text(
            'تم تنزيل سورة ${QuranData.surahNames[index]} بصوت ${reciter.name}',
          ),
          action: SnackBarAction(
            label: 'التنزيلات',
            textColor: QuranTheme.gold,
            onPressed: () {
              setState(() {
                _selectedTab = 1;
              });
            },
          ),
        ),
      );
    } catch (e) {
      debugPrint('Download error: $e');

      if (!mounted) return;

      setState(() {
        _downloadProgress.remove(fileKey);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            'تعذر تحميل السورة، تحقق من اتصال الإنترنت',
          ),
        ),
      );
    }
  }

  // ==========================================================================
  // تشغيل السورة الحالية
  // ==========================================================================

  Future<void> _playSurah(int index) async {
    final reciter = _selectedReciter;

    final fileKey =
        _getFileKey(reciter, index);

    final downloaded =
        _downloadedSurahs[fileKey] == true;

    if (_currentSurahIndex == index &&
        _currentReciterId == reciter.id) {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.resume();
      }

      return;
    }

    await _audioPlayer.stop();

    setState(() {
      _currentSurahIndex = index;
      _currentReciterId = reciter.id;
      _position = Duration.zero;
      _duration = Duration.zero;
      _isPlaying = false;
    });

    final path =
        await _getFilePath(reciter, index);

    if (downloaded &&
        File(path).existsSync()) {
      await _audioPlayer.play(
        DeviceFileSource(path),
      );
    } else {
      await _audioPlayer.play(
        UrlSource(
          _getSurahUrl(
            reciter,
            index,
          ),
        ),
      );
    }
  }

  // ==========================================================================
  // تشغيل تنزيل محدد - بدون إنترنت
  // ==========================================================================

  Future<void> _playDownloaded(
    DownloadedQuran item,
  ) async {
    final file = File(item.filePath);

    if (!await file.exists()) {
      await _removeDownloadedQuran(item);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'ملف السورة غير موجود، تمت إزالته من التنزيلات',
            ),
          ),
        );
      }

      return;
    }

    await _audioPlayer.stop();

    final surahIndex =
        item.surahNumber - 1;

    setState(() {
      _currentSurahIndex = surahIndex;
      _currentReciterId = item.reciterId;
      _position = Duration.zero;
      _duration = Duration.zero;
      _isPlaying = false;
    });

    await _audioPlayer.play(
      DeviceFileSource(item.filePath),
    );
  }

  // ==========================================================================
  // حذف تنزيل
  // ==========================================================================

  Future<void> _confirmDeleteDownload(
    DownloadedQuran item,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'حذف السورة؟',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: QuranTheme.darkGreen,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'هل تريد حذف سورة ${item.surahName} '
            'بصوت ${item.reciterName} من الجهاز؟',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx, false);
              },
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('حذف'),
            ),
          ],
        );
      },
    );

    if (result == true) {
      await _removeDownloadedQuran(item);
    }
  }

  // ==========================================================================
  // تغيير القارئ
  // ==========================================================================

  Future<void> _changeReciter(
    Reciter reciter,
  ) async {
    await _audioPlayer.stop();

    setState(() {
      _selectedReciter = reciter;
      _currentSurahIndex = null;
      _currentReciterId = null;
      _isPlaying = false;
      _position = Duration.zero;
      _duration = Duration.zero;
    });
  }

  // ==========================================================================
  // الصفحات
  // ==========================================================================

  Future<void> _loadSavedPage() async {
    final prefs =
        await SharedPreferences.getInstance();

    final page =
        prefs.getInt('last_quran_page') ?? 1;

    _currentPage =
        page.clamp(1, 604);

    await _loadQuranPage(_currentPage);
  }

  Future<void> _savePage(int page) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setInt(
      'last_quran_page',
      page,
    );
  }

  Future<void> _loadQuranPage(
    int page,
  ) async {
    if (page < 1 || page > 604) return;

    if (mounted) {
      setState(() {
        _loadingPage = true;
        _currentPage = page;
      });
    }

    try {
      final response = await _dio.get(
        'https://api.alquran.cloud/v1/page/$page/quran-uthmani',
      );

      final data = response.data;

      if (data is Map &&
          data['data'] != null &&
          data['data']['ayahs'] is List) {
        _pageAyahs = data['data']['ayahs'];

        await _savePage(page);
      }
    } catch (e) {
      debugPrint('Quran page error: $e');
      _pageAyahs = [];
    }

    if (mounted) {
      setState(() {
        _loadingPage = false;
      });
    }
  }

  void _nextPage() {
    if (_currentPage < 604) {
      _loadQuranPage(
        _currentPage + 1,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 1) {
      _loadQuranPage(
        _currentPage - 1,
      );
    }
  }

  // ==========================================================================
  // البحث
  // ==========================================================================

  List<QuranSurah> get _filteredSurahs {
    if (_searchQuery.trim().isEmpty) {
      return QuranData.surahs;
    }

    final query =
        _searchQuery.trim();

    return QuranData.surahs.where(
      (surah) {
        return surah.name.contains(query) ||
            surah.number.toString() ==
                query;
      },
    ).toList();
  }

  List<Reciter> get _filteredReciters {
    if (_searchQuery.trim().isEmpty) {
      return _reciters;
    }

    final query =
        _searchQuery.trim();

    return _reciters.where(
      (reciter) {
        return reciter.name.contains(query);
      },
    ).toList();
  }

  List<DownloadedQuran> get _filteredDownloads {
    if (_searchQuery.trim().isEmpty) {
      return _downloadedQuran;
    }

    final query =
        _searchQuery.trim();

    return _downloadedQuran.where(
      (item) {
        return item.surahName.contains(query) ||
            item.reciterName.contains(query) ||
            item.surahNumber.toString() ==
                query;
      },
    ).toList();
  }

  // ==========================================================================
  // الأدوات
  // ==========================================================================

  String _formatTime(Duration duration) {
    String twoDigits(int number) =>
        number.toString().padLeft(2, '0');

    final minutes =
        twoDigits(
      duration.inMinutes.remainder(60),
    );

    final seconds =
        twoDigits(
      duration.inSeconds.remainder(60),
    );

    return '$minutes:$seconds';
  }

  void _seek(int seconds) {
    var position =
        _position +
        Duration(seconds: seconds);

    if (position < Duration.zero) {
      position = Duration.zero;
    }

    if (position > _duration) {
      position = _duration;
    }

    _audioPlayer.seek(position);
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor:
            QuranTheme.background,
        body: Stack(
          children: [
            _buildBackground(),

            SafeArea(
              child: Column(
                children: [
                  _buildTopHeader(),

                  _buildSearchBar(),

                  _buildMainTabs(),

                  Expanded(
                    child: AnimatedSwitcher(
                      duration:
                          const Duration(
                        milliseconds: 300,
                      ),
                      child:
                          _selectedTab == 0
                              ? _buildSurahTab()
                              : _selectedTab == 1
                                  ? _buildDownloadsTab()
                                  : _selectedTab == 2
                                      ? _buildPagesTab()
                                      : _buildRecitersTab(),
                    ),
                  ),

                  if (_currentSurahIndex != null)
                    _buildAudioPlayer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // الخلفية
  // ==========================================================================

  Widget _buildBackground() {
    return Container(
      decoration:
          const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF063B32),
            Color(0xFF0B6B57),
            Color(0xFFF4F7F5),
          ],
          stops: [
            0,
            .32,
            .70,
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // الهيدر
  // ==========================================================================

  Widget _buildTopHeader() {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        8,
      ),
      child: Container(
        padding:
            const EdgeInsets.all(18),
        decoration:
            BoxDecoration(
          color:
              Colors.white.withOpacity(.96),
          borderRadius:
              BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withOpacity(.14),
              blurRadius: 25,
              offset:
                  const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration:
                  BoxDecoration(
                gradient:
                    const LinearGradient(
                  colors: [
                    QuranTheme.gold,
                    Color(0xFFE6C76B),
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(
                  18,
                ),
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                color:
                    QuranTheme.darkGreen,
                size: 30,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'القرآن الكريم',
                    style: TextStyle(
                      color:
                          QuranTheme.darkGreen,
                      fontSize: 22,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'تلاوة • تدبر • استماع',
                    style: TextStyle(
                      color:
                          Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration:
                  BoxDecoration(
                color:
                    QuranTheme.cream,
                borderRadius:
                    BorderRadius.circular(
                  15,
                ),
              ),
              child: IconButton(
                tooltip:
                    'الصفحة الأخيرة',
                onPressed: () {
                  setState(() {
                    _selectedTab = 2;
                  });

                  _loadQuranPage(
                    _currentPage,
                  );
                },
                icon: const Icon(
                  Icons.bookmark_rounded,
                  color:
                      QuranTheme.gold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // البحث
  // ==========================================================================

  Widget _buildSearchBar() {
    String hint = 'ابحث عن سورة أو قارئ...';

    if (_selectedTab == 1) {
      hint = 'ابحث في التنزيلات...';
    }

    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Container(
        decoration:
            BoxDecoration(
          color:
              Colors.white.withOpacity(.96),
          borderRadius:
              BorderRadius.circular(20),
        ),
        child: TextField(
          textDirection:
              TextDirection.rtl,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration:
              InputDecoration(
            hintText: hint,
            hintStyle:
                TextStyle(
              color:
                  Colors.grey.shade500,
              fontSize: 13,
            ),
            prefixIcon:
                const Icon(
              Icons.search_rounded,
              color:
                  QuranTheme.green,
            ),
            suffixIcon:
                _searchQuery.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          setState(() {
                            _searchQuery =
                                '';
                          });
                        },
                        icon:
                            const Icon(
                          Icons
                              .close_rounded,
                        ),
                      )
                    : null,
            border:
                InputBorder.none,
            contentPadding:
                const EdgeInsets
                    .symmetric(
              horizontal: 18,
              vertical: 15,
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // التبويبات
  // ==========================================================================

  Widget _buildMainTabs() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      child: Container(
        padding:
            const EdgeInsets.all(5),
        decoration:
            BoxDecoration(
          color:
              Colors.white.withOpacity(.90),
          borderRadius:
              BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            _tabButton(
              0,
              Icons.list_alt_rounded,
              'السور',
            ),
            _tabButton(
              1,
              Icons.download_done_rounded,
              'التنزيلات',
            ),
            _tabButton(
              2,
              Icons.auto_stories_rounded,
              'الصفحات',
            ),
            _tabButton(
              3,
              Icons.record_voice_over_rounded,
              'القراء',
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabButton(
    int index,
    IconData icon,
    String title,
  ) {
    final selected =
        _selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
          });

          if (index == 2 &&
              _pageAyahs.isEmpty) {
            _loadQuranPage(
              _currentPage,
            );
          }
        },
        child: AnimatedContainer(
          duration:
              const Duration(
            milliseconds: 250,
          ),
          padding:
              const EdgeInsets.symmetric(
            vertical: 11,
          ),
          decoration:
              BoxDecoration(
            gradient: selected
                ? const LinearGradient(
                    colors: [
                      QuranTheme.darkGreen,
                      QuranTheme.green,
                    ],
                  )
                : null,
            borderRadius:
                BorderRadius.circular(
              14,
            ),
          ),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 17,
                color: selected
                    ? Colors.white
                    : Colors.grey.shade600,
              ),
              const SizedBox(height: 3),
              Text(
                title,
                style: TextStyle(
                  color: selected
                      ? Colors.white
                      : Colors.grey.shade700,
                  fontWeight:
                      selected
                          ? FontWeight.bold
                          : FontWeight.w500,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // السور
  // ==========================================================================

  Widget _buildSurahTab() {
    final surahs =
        _filteredSurahs;

    if (surahs.isEmpty) {
      return _emptyState(
        Icons.search_off_rounded,
        'لا توجد نتائج',
      );
    }

    return ListView.builder(
      key:
          const ValueKey('surahs'),
      padding:
          const EdgeInsets.fromLTRB(
        16,
        10,
        16,
        20,
      ),
      itemCount:
          surahs.length,
      itemBuilder:
          (context, index) {
        return _buildSurahCard(
          surahs[index],
        );
      },
    );
  }

  Widget _buildSurahCard(
    QuranSurah surah,
  ) {
    final index =
        surah.number - 1;

    final isCurrent =
        _currentSurahIndex ==
                index &&
            _currentReciterId ==
                _selectedReciter.id;

    final key =
        _getFileKey(
      _selectedReciter,
      index,
    );

    final downloaded =
        _downloadedSurahs[key] ==
            true;

    final downloading =
        _downloadProgress
            .containsKey(key);

    final favorite =
        _favorites
            .contains(
          surah.number,
        );

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 10,
      ),
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(22),
        border: Border.all(
          color: isCurrent
              ? QuranTheme.gold
              : Colors.grey.shade200,
          width:
              isCurrent ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(.045),
            blurRadius: 15,
            offset:
                const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        onTap: () =>
            _playSurah(index),
        child: Padding(
          padding:
              const EdgeInsets.all(
            12,
          ),
          child: Row(
            children: [
              _buildSurahNumber(
                surah.number,
                isCurrent,
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'سورة ${surah.name}',
                      style:
                          const TextStyle(
                        color:
                            QuranTheme.text,
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      downloaded
                          ? 'متاحة بدون إنترنت • ${_selectedReciter.name}'
                          : 'استماع مباشر • ${_selectedReciter.name}',
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                      style:
                          TextStyle(
                        color: downloaded
                            ? QuranTheme.green
                            : Colors.grey.shade500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip:
                    'مفضلة',
                onPressed: () =>
                    _toggleFavorite(
                  surah.number,
                ),
                icon: Icon(
                  favorite
                      ? Icons
                          .favorite_rounded
                      : Icons
                          .favorite_border_rounded,
                  color: favorite
                      ? Colors.redAccent
                      : Colors.grey.shade400,
                ),
              ),
              if (downloading)
                SizedBox(
                  width: 26,
                  height: 26,
                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2.5,
                    value:
                        _downloadProgress[
                            key],
                    color:
                        QuranTheme.green,
                  ),
                )
              else if (!downloaded)
                IconButton(
                  tooltip:
                      'تحميل',
                  onPressed: () =>
                      _downloadSurah(
                    index,
                  ),
                  icon:
                      const Icon(
                    Icons
                        .download_for_offline_rounded,
                    color:
                        QuranTheme.green,
                  ),
                )
              else
                const Icon(
                  Icons
                      .offline_pin_rounded,
                  color:
                      QuranTheme.green,
                  size: 25,
                ),
              const SizedBox(
                width: 3,
              ),
              Container(
                width: 46,
                height: 46,
                decoration:
                    BoxDecoration(
                  gradient:
                      const LinearGradient(
                    colors: [
                      QuranTheme.darkGreen,
                      QuranTheme.green,
                    ],
                  ),
                  shape:
                      BoxShape.circle,
                ),
                child: Icon(
                  isCurrent &&
                          _isPlaying
                      ? Icons
                          .pause_rounded
                      : Icons
                          .play_arrow_rounded,
                  color:
                      Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSurahNumber(
    int number,
    bool current,
  ) {
    return Container(
      width: 48,
      height: 48,
      decoration:
          BoxDecoration(
        color: current
            ? QuranTheme.gold
            : QuranTheme.cream,
        shape:
            BoxShape.circle,
        border:
            Border.all(
          color:
              QuranTheme.gold
                  .withOpacity(.45),
        ),
      ),
      child: Center(
        child: Text(
          '$number',
          style:
              TextStyle(
            color: current
                ? QuranTheme.darkGreen
                : QuranTheme.green,
            fontWeight:
                FontWeight.w900,
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // قسم التنزيلات
  // ==========================================================================

  Widget _buildDownloadsTab() {
    final downloads =
        _filteredDownloads;

    if (downloads.isEmpty) {
      return _buildEmptyDownloads();
    }

    return Column(
      key: const ValueKey(
        'downloads',
      ),
      children: [
        _buildDownloadsHeader(
          downloads.length,
        ),
        Expanded(
          child:
              ListView.builder(
            padding:
                const EdgeInsets.fromLTRB(
              16,
              8,
              16,
              20,
            ),
            itemCount:
                downloads.length,
            itemBuilder:
                (context, index) {
              return _buildDownloadedCard(
                downloads[index],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDownloadsHeader(
    int count,
  ) {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
        16,
        10,
        16,
        4,
      ),
      child: Container(
        padding:
            const EdgeInsets.all(
          15,
        ),
        decoration:
            BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(
            18,
          ),
          border: Border.all(
            color:
                QuranTheme.gold
                    .withOpacity(.30),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 45,
              height: 45,
              decoration:
                  BoxDecoration(
                color:
                    QuranTheme.cream,
                borderRadius:
                    BorderRadius.circular(
                  14,
                ),
              ),
              child:
                  const Icon(
                Icons
                    .download_done_rounded,
                color:
                    QuranTheme.green,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            const Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    'السور المحملة',
                    style:
                        TextStyle(
                      color:
                          QuranTheme.darkGreen,
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'استمع إليها بدون اتصال بالإنترنت',
                    style:
                        TextStyle(
                      color:
                          Colors.black54,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 7,
              ),
              decoration:
                  BoxDecoration(
                color:
                    QuranTheme.cream,
                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),
              child: Text(
                '$count',
                style:
                    const TextStyle(
                  color:
                      QuranTheme.green,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadedCard(
    DownloadedQuran item,
  ) {
    final isCurrent =
        _currentSurahIndex ==
                item.surahNumber - 1 &&
            _currentReciterId ==
                item.reciterId;

    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 10,
      ),
      decoration:
          BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        border: Border.all(
          color: isCurrent
              ? QuranTheme.gold
              : Colors.grey.shade200,
          width:
              isCurrent ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(.045),
            blurRadius: 15,
            offset:
                const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        onTap: () =>
            _playDownloaded(item),
        child: Padding(
          padding:
              const EdgeInsets.all(
            12,
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration:
                    BoxDecoration(
                  color:
                      QuranTheme.cream,
                  shape:
                      BoxShape.circle,
                  border:
                      Border.all(
                    color:
                        QuranTheme.gold
                            .withOpacity(
                          .5,
                        ),
                  ),
                ),
                child: Center(
                  child: Text(
                    '${item.surahNumber}',
                    style:
                        const TextStyle(
                      color:
                          QuranTheme.green,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'سورة ${item.surahName}',
                      style:
                          const TextStyle(
                        color:
                            QuranTheme.text,
                        fontSize: 15,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons
                              .record_voice_over_rounded,
                          size: 14,
                          color:
                              QuranTheme.green,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            item.reciterName,
                            maxLines: 1,
                            overflow:
                                TextOverflow
                                    .ellipsis,
                            style:
                                TextStyle(
                              color: Colors
                                  .grey
                                  .shade600,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const Row(
                      children: [
                        Icon(
                          Icons
                              .wifi_off_rounded,
                          size: 13,
                          color:
                              QuranTheme.green,
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Text(
                          'متاحة بدون إنترنت',
                          style:
                              TextStyle(
                            color:
                                QuranTheme.green,
                            fontSize: 10,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip:
                    'حذف',
                onPressed: () =>
                    _confirmDeleteDownload(
                  item,
                ),
                icon:
                    const Icon(
                  Icons
                      .delete_outline_rounded,
                  color:
                      Colors.redAccent,
                ),
              ),
              Container(
                width: 46,
                height: 46,
                decoration:
                    BoxDecoration(
                  gradient:
                      const LinearGradient(
                    colors: [
                      QuranTheme.darkGreen,
                      QuranTheme.green,
                    ],
                  ),
                  shape:
                      BoxShape.circle,
                ),
                child: Icon(
                  isCurrent &&
                          _isPlaying
                      ? Icons
                          .pause_rounded
                      : Icons
                          .play_arrow_rounded,
                  color:
                      Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyDownloads() {
    return Center(
      key: const ValueKey(
        'empty_downloads',
      ),
      child: Padding(
        padding:
            const EdgeInsets.all(
          30,
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration:
                  BoxDecoration(
                color:
                    Colors.white,
                shape:
                    BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black
                        .withOpacity(
                      .07,
                    ),
                    blurRadius: 20,
                  ),
                ],
              ),
              child:
                  const Icon(
                Icons
                    .download_for_offline_rounded,
                size: 46,
                color:
                    QuranTheme.green,
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            const Text(
              'لا توجد سور محملة',
              style:
                  TextStyle(
                color:
                    QuranTheme.darkGreen,
                fontSize: 18,
                fontWeight:
                    FontWeight.w900,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'قم بتحميل أي سورة من قسم السور، '
              'وستظهر هنا لتستمع إليها لاحقًا '
              'بدون إنترنت.',
              textAlign:
                  TextAlign.center,
              style:
                  TextStyle(
                color:
                    Colors.grey.shade600,
                fontSize: 13,
                height: 1.6,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _selectedTab = 0;
                  _searchQuery = '';
                });
              },
              icon: const Icon(
                Icons.menu_book_rounded,
              ),
              label:
                  const Text(
                'تصفح السور',
              ),
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    QuranTheme.darkGreen,
                foregroundColor:
                    Colors.white,
                elevation: 0,
                padding:
                    const EdgeInsets
                        .symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================================
  // الصفحات
  // ==========================================================================

  Widget _buildPagesTab() {
    return Column(
      key:
          const ValueKey('pages'),
      children: [
        _buildPageHeader(),
        Expanded(
          child: _loadingPage
              ? const Center(
                  child:
                      CircularProgressIndicator(
                    color:
                        QuranTheme.gold,
                  ),
                )
              : _pageAyahs.isEmpty
                  ? _emptyState(
                      Icons
                          .menu_book_rounded,
                      'تعذر تحميل الصفحة',
                    )
                  : _buildQuranPage(),
        ),
        _buildPageNavigation(),
      ],
    );
  }

  Widget _buildPageHeader() {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
        16,
        10,
        16,
        6,
      ),
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        decoration:
            BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(
            18,
          ),
          border: Border.all(
            color:
                QuranTheme.gold
                    .withOpacity(.35),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons
                  .auto_stories_rounded,
              color:
                  QuranTheme.gold,
            ),
            const SizedBox(
              width: 9,
            ),
            const Expanded(
              child: Text(
                'صفحات المصحف الشريف',
                style:
                    TextStyle(
                  color:
                      QuranTheme.darkGreen,
                  fontSize: 15,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
            ),
            Container(
              padding:
                  const EdgeInsets
                      .symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              decoration:
                  BoxDecoration(
                color:
                    QuranTheme.cream,
                borderRadius:
                    BorderRadius.circular(
                  12,
                ),
              ),
              child: Text(
                '$_currentPage / 604',
                style:
                    const TextStyle(
                  color:
                      QuranTheme.green,
                  fontWeight:
                      FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuranPage() {
    return Container(
      margin:
          const EdgeInsets.fromLTRB(
        16,
        5,
        16,
        8,
      ),
      decoration:
          BoxDecoration(
        color:
            const Color(0xFFFFFCF2),
        borderRadius:
            BorderRadius.circular(
          18,
        ),
        border: Border.all(
          color:
              QuranTheme.gold
                  .withOpacity(.45),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(.08),
            blurRadius: 18,
            offset:
                const Offset(0, 5),
          ),
        ],
      ),
      child:
          SingleChildScrollView(
        padding:
            const EdgeInsets.fromLTRB(
          20,
          25,
          20,
          25,
        ),
        child: Column(
          children: [
            Container(
              width:
                  double.infinity,
              height: 3,
              decoration:
                  BoxDecoration(
                gradient:
                    const LinearGradient(
                  colors: [
                    Colors.transparent,
                    QuranTheme.gold,
                    Colors.transparent,
                  ],
                ),
                borderRadius:
                    BorderRadius.circular(
                  5,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'الصفحة $_currentPage',
              style:
                  const TextStyle(
                color:
                    QuranTheme.gold,
                fontSize: 13,
                fontWeight:
                    FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            ..._pageAyahs.map(
              (ayah) {
                final text =
                    ayah['text']
                            ?.toString() ??
                        '';

                final number =
                    ayah['numberInSurah']
                            ?.toString() ??
                        '';

                return Padding(
                  padding:
                      const EdgeInsets
                          .only(
                    bottom: 14,
                  ),
                  child:
                      RichText(
                    textAlign:
                        TextAlign.center,
                    text:
                        TextSpan(
                      children: [
                        TextSpan(
                          text:
                              '$text ',
                          style:
                              const TextStyle(
                            color:
                                Color(
                              0xFF20231F,
                            ),
                            fontSize:
                                21,
                            height:
                                2.05,
                            fontWeight:
                                FontWeight.w500,
                          ),
                        ),
                        WidgetSpan(
                          alignment:
                              PlaceholderAlignment
                                  .middle,
                          child:
                              Container(
                            margin:
                                const EdgeInsets
                                    .symmetric(
                              horizontal:
                                  3,
                            ),
                            width: 27,
                            height: 27,
                            decoration:
                                BoxDecoration(
                              shape:
                                  BoxShape.circle,
                              border:
                                  Border.all(
                                color:
                                    QuranTheme.gold,
                              ),
                            ),
                            child:
                                Center(
                              child:
                                  Text(
                                number,
                                style:
                                    const TextStyle(
                                  color:
                                      QuranTheme.green,
                                  fontSize:
                                      9,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              width:
                  double.infinity,
              height: 3,
              decoration:
                  const BoxDecoration(
                gradient:
                    LinearGradient(
                  colors: [
                    Colors.transparent,
                    QuranTheme.gold,
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageNavigation() {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(
        16,
        4,
        16,
        12,
      ),
      child: Row(
        children: [
          Expanded(
            child:
                _pageButton(
              icon:
                  Icons.chevron_right_rounded,
              title:
                  'الصفحة السابقة',
              enabled:
                  _currentPage > 1,
              onPressed:
                  _previousPage,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child:
                _pageButton(
              icon:
                  Icons.chevron_left_rounded,
              title:
                  'الصفحة التالية',
              enabled:
                  _currentPage < 604,
              onPressed:
                  _nextPage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pageButton({
    required IconData icon,
    required String title,
    required bool enabled,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed:
          enabled
              ? onPressed
              : null,
      icon:
          Icon(icon),
      label:
          Text(title),
      style:
          ElevatedButton.styleFrom(
        backgroundColor:
            QuranTheme.darkGreen,
        foregroundColor:
            Colors.white,
        disabledBackgroundColor:
            Colors.grey.shade300,
        disabledForegroundColor:
            Colors.grey.shade500,
        elevation: 0,
        padding:
            const EdgeInsets
                .symmetric(
          vertical: 12,
        ),
        shape:
            RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
            15,
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // القراء
  // ==========================================================================

  Widget _buildRecitersTab() {
    final reciters =
        _filteredReciters;

    if (_loadingReciters) {
      return const Center(
        child:
            CircularProgressIndicator(
          color:
              QuranTheme.gold,
        ),
      );
    }

    if (reciters.isEmpty) {
      return _emptyState(
        Icons
            .person_off_rounded,
        'لا يوجد قارئ مطابق للبحث',
      );
    }

    return ListView.builder(
      key:
          const ValueKey(
        'reciters',
      ),
      padding:
          const EdgeInsets.fromLTRB(
        16,
        10,
        16,
        20,
      ),
      itemCount:
          reciters.length,
      itemBuilder:
          (context, index) {
        final reciter =
            reciters[index];

        final selected =
            reciter.id ==
                _selectedReciter.id;

        return _buildReciterCard(
          reciter,
          selected,
        );
      },
    );
  }

  Widget _buildReciterCard(
    Reciter reciter,
    bool selected,
  ) {
    return Container(
      margin:
          const EdgeInsets.only(
        bottom: 10,
      ),
      decoration:
          BoxDecoration(
        color:
            Colors.white,
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        border: Border.all(
          color: selected
              ? QuranTheme.gold
              : Colors.grey.shade200,
          width:
              selected ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(.04),
            blurRadius: 15,
          ),
        ],
      ),
      child: InkWell(
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        onTap: () async {
          await _changeReciter(
            reciter,
          );

          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(
              SnackBar(
                behavior:
                    SnackBarBehavior
                        .floating,
                backgroundColor:
                    QuranTheme
                        .darkGreen,
                content:
                    Text(
                  'تم اختيار القارئ ${reciter.name}',
                ),
              ),
            );
          }
        },
        child: Padding(
          padding:
              const EdgeInsets.all(
            14,
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration:
                    BoxDecoration(
                  gradient:
                      selected
                          ? const LinearGradient(
                              colors: [
                                QuranTheme
                                    .gold,
                                Color(
                                  0xFFE6C76B,
                                ),
                              ],
                            )
                          : const LinearGradient(
                              colors: [
                                QuranTheme
                                    .darkGreen,
                                QuranTheme
                                    .green,
                              ],
                            ),
                  shape:
                      BoxShape.circle,
                ),
                child: Icon(
                  Icons
                      .record_voice_over_rounded,
                  color: selected
                      ? QuranTheme
                          .darkGreen
                      : Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(
                width: 13,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      reciter.name,
                      style:
                          const TextStyle(
                        color:
                            QuranTheme.text,
                        fontSize: 15,
                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    const Text(
                      'تلاوة القرآن الكريم',
                      style:
                          TextStyle(
                        color:
                            Colors.black45,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              if (selected)
                Container(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration:
                      BoxDecoration(
                    color:
                        QuranTheme.cream,
                    borderRadius:
                        BorderRadius.circular(
                      12,
                    ),
                  ),
                  child:
                      const Text(
                    'مختار',
                    style:
                        TextStyle(
                      color:
                          QuranTheme.green,
                      fontSize: 11,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                )
              else
                const Icon(
                  Icons
                      .arrow_back_ios_new_rounded,
                  size: 16,
                  color:
                      Colors.grey,
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ==========================================================================
  // مشغل الصوت
  // ==========================================================================

  Widget _buildAudioPlayer() {
    final index =
        _currentSurahIndex!;

    final isDownloaded =
        _downloadedQuran.any(
      (item) =>
          item.surahNumber ==
              index + 1 &&
          item.reciterId ==
              _currentReciterId,
    );

    String reciterName =
        _selectedReciter.name;

    final downloadedMatch =
        _downloadedQuran.where(
      (item) =>
          item.surahNumber ==
              index + 1 &&
          item.reciterId ==
              _currentReciterId,
    );

    if (downloadedMatch.isNotEmpty) {
      reciterName =
          downloadedMatch.first.reciterName;
    }

    return Container(
      margin:
          const EdgeInsets.fromLTRB(
        12,
        0,
        12,
        10,
      ),
      padding:
          const EdgeInsets.all(
        16,
      ),
      decoration:
          BoxDecoration(
        gradient:
            const LinearGradient(
          begin:
              Alignment.topRight,
          end:
              Alignment.bottomLeft,
          colors: [
            QuranTheme.darkGreen,
            QuranTheme.green,
          ],
        ),
        borderRadius:
            BorderRadius.circular(
          26,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withOpacity(.18),
            blurRadius: 20,
            offset:
                const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration:
                    BoxDecoration(
                  color: Colors.white
                      .withOpacity(.12),
                  borderRadius:
                      BorderRadius.circular(
                    14,
                  ),
                ),
                child:
                    const Icon(
                  Icons
                      .graphic_eq_rounded,
                  color:
                      QuranTheme.gold,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child:
                    Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                  children: [
                    Text(
                      'سورة ${QuranData.surahNames[index]}',
                      style:
                          const TextStyle(
                        color:
                            Colors.white,
                        fontSize: 15,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child:
                              Text(
                            reciterName,
                            maxLines: 1,
                            overflow:
                                TextOverflow
                                    .ellipsis,
                            style:
                                const TextStyle(
                              color:
                                  Colors.white70,
                              fontSize:
                                  11,
                            ),
                          ),
                        ),
                        if (isDownloaded) ...[
                          const SizedBox(
                            width: 6,
                          ),
                          const Icon(
                            Icons
                                .wifi_off_rounded,
                            color:
                                QuranTheme.gold,
                            size: 13,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed:
                    () async {
                  await _audioPlayer
                      .stop();

                  if (mounted) {
                    setState(() {
                      _currentSurahIndex =
                          null;
                      _currentReciterId =
                          null;
                      _isPlaying =
                          false;
                    });
                  }
                },
                icon:
                    const Icon(
                  Icons.close_rounded,
                  color:
                      Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          SliderTheme(
            data:
                SliderTheme.of(
              context,
            ).copyWith(
              activeTrackColor:
                  QuranTheme.gold,
              inactiveTrackColor:
                  Colors.white24,
              thumbColor:
                  QuranTheme.gold,
              overlayColor:
                  QuranTheme.gold
                      .withOpacity(.15),
              trackHeight: 4,
            ),
            child: Slider(
              min: 0,
              max:
                  _duration
                              .inMilliseconds >
                          0
                      ? _duration
                          .inMilliseconds
                          .toDouble()
                      : 1,
              value:
                  _position
                      .inMilliseconds
                      .toDouble()
                      .clamp(
                        0,
                        _duration
                                    .inMilliseconds >
                                0
                            ? _duration
                                .inMilliseconds
                                .toDouble()
                            : 1,
                      ),
              onChanged:
                  (value) {
                _audioPlayer.seek(
                  Duration(
                    milliseconds:
                        value.toInt(),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets
                    .symmetric(
              horizontal: 6,
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
              children: [
                Text(
                  _formatTime(
                    _position,
                  ),
                  style:
                      const TextStyle(
                    color:
                        Colors.white60,
                    fontSize: 11,
                  ),
                ),
                Text(
                  _formatTime(
                    _duration,
                  ),
                  style:
                      const TextStyle(
                    color:
                        Colors.white60,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment:
                MainAxisAlignment
                    .center,
            children: [
              _playerCircleButton(
                Icons
                    .replay_10_rounded,
                () => _seek(-10),
              ),
              const SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () async {
                  if (_isPlaying) {
                    await _audioPlayer
                        .pause();
                  } else {
                    await _audioPlayer
                        .resume();
                  }
                },
                child:
                    Container(
                  width: 62,
                  height: 62,
                  decoration:
                      BoxDecoration(
                    color:
                        QuranTheme.gold,
                    shape:
                        BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: QuranTheme
                            .gold
                            .withOpacity(
                          .30,
                        ),
                        blurRadius: 15,
                      ),
                    ],
                  ),
                  child:
                      Icon(
                    _isPlaying
                        ? Icons
                            .pause_rounded
                        : Icons
                            .play_arrow_rounded,
                    color:
                        QuranTheme.darkGreen,
                    size: 35,
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              _playerCircleButton(
                Icons
                    .forward_10_rounded,
                () => _seek(10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _playerCircleButton(
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child:
          Container(
        width: 45,
        height: 45,
        decoration:
            BoxDecoration(
          color: Colors.white
              .withOpacity(.10),
          shape:
              BoxShape.circle,
        ),
        child:
            Icon(
          icon,
          color:
              Colors.white,
          size: 24,
        ),
      ),
    );
  }

  // ==========================================================================
  // Empty
  // ==========================================================================

  Widget _emptyState(
    IconData icon,
    String text,
  ) {
    return Center(
      child:
          Column(
        mainAxisAlignment:
            MainAxisAlignment
                .center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration:
                BoxDecoration(
              color:
                  Colors.white,
              shape:
                  BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withOpacity(
                    .06,
                  ),
                  blurRadius:
                      15,
                ),
              ],
            ),
            child:
                Icon(
              icon,
              size: 38,
              color:
                  QuranTheme.green,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Text(
            text,
            style:
                const TextStyle(
              color:
                  QuranTheme.text,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // DISPOSE
  // ==========================================================================

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
