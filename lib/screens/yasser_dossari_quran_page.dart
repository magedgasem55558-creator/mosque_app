import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class YasserDossariQuranPage extends StatefulWidget {
  const YasserDossariQuranPage({Key? key}) : super(key: key);

  @override
  State<YasserDossariQuranPage> createState() => _YasserDossariQuranPageState();
}

class _YasserDossariQuranPageState extends State<YasserDossariQuranPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final List<Reciter> _reciters = const [
    Reciter(
      id: 'yasser',
      name: 'ياسر الدوسري',
      serverUrl: 'https://server11.mp3quran.net/yasser',
    ),
    Reciter(
      id: 'basit',
      name: 'عبد الباسط عبد الصمد (مرتل)',
      serverUrl: 'https://server7.mp3quran.net/basit',
    ),
    Reciter(
      id: 'afs',
      name: 'مشاري العفاسي',
      serverUrl: 'https://server8.mp3quran.net/afs',
    ),
    Reciter(
      id: 'maher',
      name: 'ماهر المعيقلي',
      serverUrl: 'https://server12.mp3quran.net/maher',
    ),
    Reciter(
      id: 'shur',
      name: 'سعود الشريم',
      serverUrl: 'https://server7.mp3quran.net/shur',
    ),
  ];

  late Reciter _selectedReciter;

  bool _isPlaying = false;
  int? _currentSurahIndex;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  final Map<String, bool> _downloadedSurahs = {};
  final Map<String, double> _downloadProgress = {};

  final List<String> _surahNames = const [
    "الفاتحة", "البقرة", "آل عمران", "النساء", "المائدة", "الأنعام", "الأعراف", "الأنفال", "التوبة", "يونس",
    "هود", "يوسف", "الرعد", "إبراهيم", "الحجر", "النحل", "الإسراء", "الكهف", "مريم", "طه",
    "الأنبيـاء", "الحج", "المؤمنون", "النور", "الفرقان", "الشعراء", "النمل", "القصص", "العنكبوت", "الروم",
    "لقمان", "السجدة", "الأحزاب", "سبأ", "فاطر", "يس", "الصافات", "ص", "الزمر", "غافر",
    "فصلت", "الشورى", "الزخرف", "الدخان", "الجاثية", "الأحقاف", "محمد", "الفتح", "الحجرات", "ق",
    "الذاريات", "الطور", "النجم", "القمر", "الرحمن", "الواقعة", "الحديد", "المجادلة", "الحشر", "الممتحنة",
    "الصف", "الجمعة", "المنافقون", "التغابن", "الطلاق", "التحريم", "الملك", "القلم", "الحاقة", "المعارج",
    "نوح", "الجن", "المزمل", "المدثر", "القيامة", "الإنسان", "المرسلات", "النبأ", "النازعات", "عبس",
    "التكوير", "الانفطار", "المطففين", "الانشقاق", "البروج", "الطارق", "الأعلى", "الغاشية", "الفجر", "البلد",
    "الشمس", "الليل", "الضحى", "الشرح", "التين", "العلق", "القدر", "البينة", "الزلزلة", "العاديات",
    "القارعة", "التكاثر", "العصر", "الهمزة", "الفيل", "قريش", "المعون", "الكوثر", "الكافرون", "النصر",
    "المسد", "الإخلاص", "الفلق", "الناس"
  ];

  @override
  void initState() {
    super.initState();
    _selectedReciter = _reciters[0];
    _checkDownloadedFiles();
    _showFirstTimeTip();  // ← عرض الحوار الإرشادي عند أول فتح

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      if (mounted) {
        setState(() {
          _duration = newDuration;
        });
      }
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted) {
        setState(() {
          _position = newPosition;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // ---------- دالة عرض الحوار الإرشادي عند أول زيارة ----------
  Future<void> _showFirstTimeTip() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenTip = prefs.getBool('quran_first_tip_shown') ?? false;
    if (!hasSeenTip && mounted) {
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                const Icon(Icons.download_for_offline, color: Colors.teal),
                const SizedBox(width: 10),
                const Text("ميزة رائعة!", style: TextStyle(color: Colors.black87)),
              ],
            ),
            content: const Text(
              "يمكنك تنزيل أي سورة بصوت القارئ المفضل لديك، والاستماع إليها لاحقاً بدون الحاجة إلى الإنترنت.",
              style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.5),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  prefs.setBool('quran_first_tip_shown', true);
                },
                child: const Text("فهمت", style: TextStyle(color: Colors.teal)),
              ),
            ],
          ),
        );
      }
    }
  }

  String _getFileKey(Reciter reciter, int surahIndex) {
    return '${reciter.id}_${surahIndex + 1}';
  }

  String _getSurahUrl(Reciter reciter, int index) {
    String formattedIndex = (index + 1).toString().padLeft(3, '0');
    return '${reciter.serverUrl}/$formattedIndex.mp3';
  }

  Future<String> _getFilePath(Reciter reciter, int index) async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/surah_${_getFileKey(reciter, index)}.mp3';
  }

  Future<void> _checkDownloadedFiles() async {
    for (var reciter in _reciters) {
      for (int i = 0; i < _surahNames.length; i++) {
        String path = await _getFilePath(reciter, i);
        if (File(path).existsSync()) {
          _downloadedSurahs[_getFileKey(reciter, i)] = true;
        }
      }
    }
    if (mounted) setState(() {});
  }

  Future<void> _downloadSurah(int index) async {
    final fileKey = _getFileKey(_selectedReciter, index);
    String url = _getSurahUrl(_selectedReciter, index);
    String savePath = await _getFilePath(_selectedReciter, index);

    try {
      Dio dio = Dio();
      await dio.download(
        url,
        savePath,
        onReceiveProgress: (rec, total) {
          if (total != -1) {
            setState(() {
              _downloadProgress[fileKey] = rec / total;
            });
          }
        },
      );
      setState(() {
        _downloadedSurahs[fileKey] = true;
        _downloadProgress.remove(fileKey);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('تم تحميل سورة ${_surahNames[index]} بصوت ${_selectedReciter.name} بنجاح!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _downloadProgress.remove(fileKey);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('حدث خطأ أثناء التنزيل!'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _playSurah(int index) async {
    final fileKey = _getFileKey(_selectedReciter, index);

    if (_currentSurahIndex == index) {
      if (_isPlaying) {
        await _audioPlayer.pause();
      } else {
        await _audioPlayer.resume();
      }
      return;
    }

    await _audioPlayer.stop();
    _currentSurahIndex = index;
    String filePath = await _getFilePath(_selectedReciter, index);

    if (_downloadedSurahs[fileKey] == true && File(filePath).existsSync()) {
      await _audioPlayer.play(DeviceFileSource(filePath));
    } else {
      await _audioPlayer.play(UrlSource(_getSurahUrl(_selectedReciter, index)));
    }
  }

  void _seek(int seconds) {
    Duration newPosition = _position + Duration(seconds: seconds);
    if (newPosition < Duration.zero) newPosition = Duration.zero;
    if (newPosition > _duration) newPosition = _duration;
    _audioPlayer.seek(newPosition);
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  // ===================== واجهة المستخدم (التصميم الرسمي) =====================
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
              _buildReciterSelector(),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _surahNames.length,
                  itemBuilder: (context, index) => _buildSurahTile(index),
                ),
              ),
              if (_currentSurahIndex != null) _buildAudioPlayerPanel(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book, color: Colors.teal, size: 28),
            SizedBox(width: 10),
            Text(
              'المصحف الشريف',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.menu_book, color: Colors.teal, size: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildReciterSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
        ),
        child: Row(
          children: [
            const Icon(Icons.person, color: Colors.teal, size: 22),
            const SizedBox(width: 10),
            const Text(
              'اختر القارئ: ',
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            Expanded(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Reciter>(
                  value: _selectedReciter,
                  dropdownColor: Colors.white,
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.teal),
                  isExpanded: true,
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                  items: _reciters.map((Reciter reciter) {
                    return DropdownMenuItem<Reciter>(
                      value: reciter,
                      child: Text(
                        reciter.name,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    );
                  }).toList(),
                  onChanged: (Reciter? newReciter) async {
                    if (newReciter != null && newReciter != _selectedReciter) {
                      await _audioPlayer.stop();
                      setState(() {
                        _selectedReciter = newReciter;
                        _currentSurahIndex = null;
                        _isPlaying = false;
                      });
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSurahTile(int index) {
    final isCurrent = _currentSurahIndex == index;
    final fileKey = _getFileKey(_selectedReciter, index);
    final isDownloaded = _downloadedSurahs[fileKey] == true;
    final isDownloading = _downloadProgress.containsKey(fileKey);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: isCurrent ? Colors.teal.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCurrent ? Colors.teal.withOpacity(0.3) : Colors.grey.shade300,
          ),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4)],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _playSurah(index),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                // رقم السورة
                CircleAvatar(
                  radius: 20,
                  backgroundColor: isCurrent ? Colors.teal : Colors.grey.shade200,
                  child: Text(
                    '${index + 1}',
                    style: TextStyle(
                      color: isCurrent ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // اسم السورة
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'سورة ${_surahNames[index]}',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isDownloaded
                            ? 'محملة (بدون إنترنت)'
                            : 'القارئ: ${_selectedReciter.name}',
                        style: TextStyle(
                          color: isDownloaded ? Colors.green : Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // أزرار التحكم
                if (isDownloading)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2.5, color: Colors.teal),
                  )
                else if (!isDownloaded)
                  IconButton(
                    icon: const Icon(Icons.download_for_offline, color: Colors.teal),
                    onPressed: () => _downloadSurah(index),
                  )
                else
                  const Icon(Icons.check_circle, color: Colors.green, size: 24),
                const SizedBox(width: 4),
                IconButton(
                  icon: Icon(
                    (isCurrent && _isPlaying)
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: Colors.teal,
                    size: 36,
                  ),
                  onPressed: () => _playSurah(index),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAudioPlayerPanel() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.teal.withOpacity(0.1), blurRadius: 15),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'سورة ${_surahNames[_currentSurahIndex!]}',
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _selectedReciter.name,
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 10),
            SliderTheme(
              data: SliderThemeData(
                trackHeight: 3,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                thumbColor: Colors.teal,
                activeTrackColor: Colors.teal,
                inactiveTrackColor: Colors.grey.shade300,
                overlayShape: SliderComponentShape.noOverlay,
              ),
              child: Slider(
                min: 0.0,
                max: _duration.inSeconds.toDouble() > 0
                    ? _duration.inSeconds.toDouble()
                    : 1.0,
                value: _position.inSeconds
                    .toDouble()
                    .clamp(0.0,
                        _duration.inSeconds.toDouble() > 0 ? _duration.inSeconds.toDouble() : 1.0),
                onChanged: (value) {
                  _audioPlayer.seek(Duration(seconds: value.toInt()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatTime(_position), style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  Text(_formatTime(_duration), style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.replay_10, color: Colors.teal, size: 24),
                  ),
                  onPressed: () => _seek(-10),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () => _playSurah(_currentSurahIndex!),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.teal,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: Colors.teal.withOpacity(0.3), blurRadius: 10),
                      ],
                    ),
                    child: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.forward_10, color: Colors.teal, size: 24),
                  ),
                  onPressed: () => _seek(10),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
