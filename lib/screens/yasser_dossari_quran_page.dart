import 'dart:io';
import 'dart:ui'; // ← تمت إضافتها هنا
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

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
            backgroundColor: Colors.greenAccent.shade700,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(color: const Color(0xFF1A002D)),
          Container(color: Colors.black.withOpacity(0.5)),
          SafeArea(
            child: Column(
              children: [
                _buildGlassAppBar(),
                _buildReciterSelector(),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _surahNames.length,
                    itemBuilder: (context, index) {
                      return _buildSurahTile(index);
                    },
                  ),
                ),
                if (_currentSurahIndex != null) _buildAudioPlayerPanel(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlassAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.amberAccent.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.menu_book, color: Colors.amberAccent, size: 24),
                ),
                const SizedBox(width: 12),
                const Text(
                  'المصحف الشريف',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.amberAccent.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.menu_book, color: Colors.amberAccent, size: 24),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReciterSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.12)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.amberAccent.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: Colors.amberAccent, size: 20),
                ),
                const SizedBox(width: 12),
                const Text(
                  'اختر القارئ: ',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Reciter>(
                      value: _selectedReciter,
                      dropdownColor: const Color(0xFF2E1040),
                      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.amberAccent),
                      isExpanded: true,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      items: _reciters.map((Reciter reciter) {
                        return DropdownMenuItem<Reciter>(
                          value: reciter,
                          child: Text(
                            reciter.name,
                            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Material(
            color: (isCurrent
                    ? Colors.amberAccent.withOpacity(0.08)
                    : Colors.white.withOpacity(0.04)),
            borderRadius: BorderRadius.circular(18),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => _playSurah(index),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? Colors.amberAccent.withOpacity(0.25)
                            : Colors.amberAccent.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: isCurrent ? Colors.amberAccent : Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'سورة ${_surahNames[index]}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isDownloaded
                                ? 'مُحملة (بدون إنترنت)'
                                : 'القارئ: ${_selectedReciter.name}',
                            style: TextStyle(
                              color: isDownloaded ? Colors.greenAccent : Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isDownloading)
                      SizedBox(
                        width: 28,
                        height: 28,
                        child: CircularProgressIndicator(
                          value: _downloadProgress[fileKey],
                          strokeWidth: 2.5,
                          color: Colors.amberAccent,
                          backgroundColor: Colors.white12,
                        ),
                      )
                    else if (!isDownloaded)
                      IconButton(
                        icon: Icon(Icons.download_for_offline_outlined, color: Colors.amberAccent.withOpacity(0.8)),
                        onPressed: () => _downloadSurah(index),
                      )
                    else
                      const Icon(Icons.check_circle, color: Colors.greenAccent, size: 24),
                    const SizedBox(width: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: (isCurrent && _isPlaying)
                            ? Colors.amberAccent
                            : Colors.amberAccent.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          (isCurrent && _isPlaying)
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                          color: (isCurrent && _isPlaying) ? Colors.black : Colors.amberAccent,
                          size: 28,
                        ),
                        onPressed: () => _playSurah(index),
                      ),
                    ),
                  ],
                ),
              ),
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
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.amberAccent.withOpacity(0.3), width: 1.2),
        color: const Color(0xFF1A002D).withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.amberAccent.withOpacity(0.08),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'سورة ${_surahNames[_currentSurahIndex!]}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _selectedReciter.name,
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
                const SizedBox(height: 10),
                SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 3,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                    thumbColor: Colors.amberAccent,
                    activeTrackColor: Colors.amberAccent,
                    inactiveTrackColor: Colors.white24,
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
                      Text(_formatTime(_position),
                          style: const TextStyle(color: Colors.white54, fontSize: 12)),
                      Text(_formatTime(_duration),
                          style: const TextStyle(color: Colors.white54, fontSize: 12)),
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
                          color: Colors.white.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.replay_10, color: Colors.amberAccent, size: 24),
                      ),
                      onPressed: () => _seek(-10),
                    ),
                    const SizedBox(width: 20),
                    GestureDetector(
                      onTap: () => _playSurah(_currentSurahIndex!),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.amberAccent,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.amberAccent.withOpacity(0.4),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(
                          _isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.black,
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.08),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.forward_10, color: Colors.amberAccent, size: 24),
                      ),
                      onPressed: () => _seek(10),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}