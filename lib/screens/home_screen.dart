import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adhan/adhan.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';
import 'my_children_screen.dart';
import 'leaderboard_screen.dart';
import 'donate_screen.dart';
import 'qibla_screen.dart';
import 'yasser_dossari_quran_page.dart';
import 'hisn_el_muslim_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const Color darkGreen = Color(0xFF2E7D32);
  static const Color blue = Color(0xFF42A5F5);
  static const Color lightBg = Color(0xFFF5F7FA);
  static const Color teal = Color(0xFF00897B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBg,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              darkGreen,
              blue,
              lightBg,
            ],
            stops: [0.0, 0.38, 0.72],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              18,
              12,
              18,
              30,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),

                const SizedBox(height: 18),

                const AutoPrayerCountdownGlass(),

                const SizedBox(height: 14),

                const RemembranceCarousel(),

                const SizedBox(height: 18),

                _buildUpcomingEvent(),

                const SizedBox(height: 12),

                _buildUpcomingLecture(),

                const SizedBox(height: 28),

                _buildSectionTitle(
                  'خدمات المسجد',
                  'كل ما تحتاجه في مكان واحد',
                  Icons.apps_rounded,
                ),

                const SizedBox(height: 14),

                _buildServicesGrid(context),

                const SizedBox(height: 25),

                _buildLogoutButton(context),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Header
  // ============================================================

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        18,
        16,
        18,
        16,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.97),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  darkGreen,
                  teal,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(17),
              boxShadow: [
                BoxShadow(
                  color: darkGreen.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.mosque_rounded,
              color: Colors.white,
              size: 29,
            ),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'مرحباً بك 👋',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'في مسجدنا',
                  style: TextStyle(
                    color: darkGreen,
                    fontSize: 21,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: blue.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: darkGreen,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Section title
  // ============================================================

  Widget _buildSectionTitle(
    String title,
    String subtitle,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
              ),
            ],
          ),
          child: Icon(
            icon,
            color: darkGreen,
            size: 23,
          ),
        ),

        const SizedBox(width: 11),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // Services grid
  // ============================================================

  Widget _buildServicesGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 13,
      crossAxisSpacing: 13,
      childAspectRatio: 1.18,
      children: [
        _buildGridItem(
          context,
          'المتصدرون',
          'أفضل الطلاب',
          Icons.emoji_events_rounded,
          const Color(0xFFFFB300),
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const LeaderboardScreen(),
              ),
            );
          },
        ),

        StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _buildGridItem(
                context,
                'أبنائي',
                'متابعة الإنجاز',
                Icons.family_restroom_rounded,
                teal,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const MyChildrenScreen(),
                    ),
                  );
                },
              );
            }

            return _buildGridItem(
              context,
              'دخول الآباء',
              'متابعة الأبناء',
              Icons.lock_outline_rounded,
              blue,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                );
              },
            );
          },
        ),

        _buildGridItem(
          context,
          'تبرع للمسجد',
          'ساهم في الخير',
          Icons.favorite_rounded,
          const Color(0xFFE91E63),
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const DonateScreen(),
              ),
            );
          },
        ),

        _buildGridItem(
          context,
          'القبلة',
          'حدد اتجاه القبلة',
          Icons.explore_rounded,
          const Color(0xFFEF5350),
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const QiblaScreen(),
              ),
            );
          },
        ),

        _buildGridItem(
          context,
          'القرآن الكريم',
          'استمع وتدبر',
          Icons.menu_book_rounded,
          darkGreen,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const YasserDossariQuranPage(),
              ),
            );
          },
        ),

        _buildGridItem(
          context,
          'الأذكار',
          'حصن المسلم',
          Icons.auto_awesome_rounded,
          teal,
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const HisnElMuslimPage(),
              ),
            );
          },
        ),
      ],
    );
  }

  // ============================================================
  // Grid item
  // ============================================================

  Widget _buildGridItem(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(23),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(23),
            border: Border.all(
              color: Colors.white.withOpacity(0.8),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.13),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Container(
                  width: 75,
                  height: 75,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.055),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            color.withOpacity(0.18),
                            color.withOpacity(0.07),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(17),
                      ),
                      child: Icon(
                        icon,
                        color: color,
                        size: 28,
                      ),
                    ),

                    const Spacer(),

                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.black45,
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                left: 12,
                bottom: 13,
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: color.withOpacity(0.45),
                  size: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Upcoming Event
  // ============================================================

  Widget _buildUpcomingEvent() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('settings')
          .doc('next_event')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
        }

        if (snapshot.hasError ||
            !snapshot.hasData ||
            !snapshot.data!.exists) {
          return const SizedBox.shrink();
        }

        final data =
            snapshot.data!.data() as Map<String, dynamic>?;

        if (data == null) {
          return const SizedBox.shrink();
        }

        final title = data['title'] as String? ?? '';

        if (title.trim().isEmpty) {
          return const SizedBox.shrink();
        }

        return _buildEventCard(data);
      },
    );
  }

  // ============================================================
  // Event card
  // ============================================================

  Widget _buildEventCard(
    Map<String, dynamic> event,
  ) {
    final title = event['title'] ?? 'فعالية';
    final location = event['location'] ?? '';

    String? timeStr = event['time'] as String?;

    if (timeStr == null || timeStr.isEmpty) {
      timeStr = event['date'] as String?;
    }

    String dateStr = '';

    if (timeStr != null && timeStr.isNotEmpty) {
      dateStr = _formatLectureTime(timeStr);
    } else {
      final lastUpdated =
          event['lastUpdated'] as Timestamp?;

      if (lastUpdated != null) {
        final dt = lastUpdated.toDate();

        dateStr =
            '${dt.year}/'
            '${dt.month.toString().padLeft(2, '0')}/'
            '${dt.day.toString().padLeft(2, '0')}';
      }
    }

    return _buildGlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _buildSmallIcon(
              Icons.event_rounded,
              Colors.orange,
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    'فعالية قادمة',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  if (location.isNotEmpty)
                    Text(
                      'المكان: $location',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 11,
                      ),
                    ),

                  if (dateStr.isNotEmpty)
                    Text(
                      dateStr,
                      style: const TextStyle(
                        color: Colors.black45,
                        fontSize: 11,
                      ),
                    ),
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.black26,
              size: 14,
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // Upcoming lecture
  // ============================================================

  Widget _buildUpcomingLecture() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('lectures')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
                ConnectionState.waiting ||
            !snapshot.hasData ||
            snapshot.data!.docs.isEmpty) {
          return const SizedBox.shrink();
        }

        if (snapshot.hasError) {
          debugPrint(
            'خطأ في جلب المحاضرات: ${snapshot.error}',
          );
          return const SizedBox.shrink();
        }

        final now = DateTime.now();

        final List<Map<String, dynamic>> upcoming = [];

        for (final doc in snapshot.data!.docs) {
          final data =
              doc.data() as Map<String, dynamic>;

          final timeStr = data['time'] as String?;

          if (timeStr != null) {
            final time = DateTime.tryParse(timeStr);

            if (time != null && time.isAfter(now)) {
              final copy =
                  Map<String, dynamic>.from(data);

              copy['id'] = doc.id;
              upcoming.add(copy);
            }
          }
        }

        if (upcoming.isEmpty) {
          return const SizedBox.shrink();
        }

        upcoming.sort(
          (a, b) => DateTime.parse(a['time'])
              .compareTo(
                DateTime.parse(b['time']),
              ),
        );

        final lecture = upcoming.first;

        return _buildGlassCard(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildSmallIcon(
                  Icons.menu_book_rounded,
                  const Color(0xFF7E57C2),
                ),

                const SizedBox(width: 13),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'محاضرة قادمة',
                        style: TextStyle(
                          color: Color(0xFF7E57C2),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        lecture['title'] ?? 'محاضرة',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),

                      if (lecture['speaker'] != null &&
                          (lecture['speaker'] as String)
                              .isNotEmpty)
                        Text(
                          'المحاضر: ${lecture['speaker']}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.black54,
                            fontSize: 11,
                          ),
                        ),

                      const SizedBox(height: 3),

                      Text(
                        _formatLectureTime(
                          lecture['time'],
                        ),
                        style: const TextStyle(
                          color: Colors.black45,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.black26,
                  size: 14,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // Small icon
  // ============================================================

  Widget _buildSmallIcon(
    IconData icon,
    Color color,
  ) {
    return Container(
      width: 51,
      height: 51,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.18),
            color.withOpacity(0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Icon(
        icon,
        color: color,
        size: 27,
      ),
    );
  }

  // ============================================================
  // Glass card
  // ============================================================

  Widget _buildGlassCard({
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.97),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  // ============================================================
  // Logout
  // ============================================================

  Widget _buildLogoutButton(
    BuildContext context,
  ) {
    return Column(
      children: [
        StreamBuilder<User?>(
          stream:
              FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox.shrink();
            }

            return Center(
              child: TextButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
                icon: const Icon(
                  Icons.logout_rounded,
                  color: Colors.black45,
                  size: 19,
                ),
                label: const Text(
                  'تسجيل الخروج',
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 8),

        Center(
          child: TextButton.icon(
            onPressed: () {
              _showDeveloperContactDialog(context);
            },
            icon: const Icon(
              Icons.support_agent_rounded,
              color: darkGreen,
              size: 21,
            ),
            label: const Text(
              'انقر هنا لطلب نسخة لمسجدك أو للتواصل مع المطور',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: darkGreen,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // Developer contact dialog
  // ============================================================

  void _showDeveloperContactDialog(
    BuildContext context,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding:
              const EdgeInsets.symmetric(horizontal: 28),
          child: Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 25,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        darkGreen,
                        teal,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius:
                        BorderRadius.circular(19),
                  ),
                  child: const Icon(
                    Icons.support_agent_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  'طلب نسخة لمسجدك',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 7),

                const Text(
                  'للتواصل مع المطور أو طلب نسخة خاصة لمسجدك',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    height: 1.5,
                  ),
                ),

                const SizedBox(height: 18),

                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FA),
                    borderRadius:
                        BorderRadius.circular(16),
                    border: Border.all(
                      color: darkGreen.withOpacity(0.12),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding:
                            const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color:
                              darkGreen.withOpacity(0.10),
                          borderRadius:
                              BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.phone_rounded,
                          color: darkGreen,
                          size: 21,
                        ),
                      ),

                      const SizedBox(width: 11),

                      const Expanded(
                        child: Text(
                          '776503890',
                          textDirection:
                              TextDirection.ltr,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ),

                      IconButton(
                        tooltip: 'نسخ الرقم',
                        onPressed: () async {
                          await Clipboard.setData(
                            const ClipboardData(
                              text: '776503890',
                            ),
                          );

                          if (dialogContext.mounted) {
                            ScaffoldMessenger.of(
                              dialogContext,
                            ).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'تم نسخ رقم التواصل',
                                  textAlign:
                                      TextAlign.center,
                                ),
                                behavior:
                                    SnackBarBehavior.floating,
                                duration:
                                    Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.copy_rounded,
                          color: darkGreen,
                          size: 21,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: darkGreen,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding:
                          const EdgeInsets.symmetric(
                        vertical: 13,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'إغلاق',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // Format lecture time
  // ============================================================

  String _formatLectureTime(String? isoTime) {
    if (isoTime == null) {
      return '';
    }

    final dt = DateTime.tryParse(isoTime);

    if (dt == null) {
      return isoTime;
    }

    return '${dt.year}/'
        '${dt.month.toString().padLeft(2, '0')}/'
        '${dt.day.toString().padLeft(2, '0')}  '
        '${dt.hour.toString().padLeft(2, '0')}:'
        '${dt.minute.toString().padLeft(2, '0')}';
  }
}

// ================================================================
// REMEMBRANCE CAROUSEL
// ================================================================

class RemembranceCarousel extends StatefulWidget {
  const RemembranceCarousel({super.key});

  @override
  State<RemembranceCarousel> createState() =>
      _RemembranceCarouselState();
}

class _RemembranceCarouselState
    extends State<RemembranceCarousel> {
  int _currentIndex = 0;

  Timer? _timer;

  final List<String> _remembrances = [
    "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، سُبْحَانَ اللَّهِ الْعَظِيمِ",
    "لاَ إِلَهَ إِلاَّ أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ",
    "سُبْحَانَ اللَّهِ، وَالْحَمْدُ لِلَّهِ، وَلاَ إِلَهَ إِلاَّ اللَّهُ، وَاللَّهُ أَكْبَرُ",
    "أَسْتَغْفِرُ اللَّهَ الَّذِي لاَ إِلَهَ إِلاَّ هُوَ الْحَيُّ الْقَيُّومُ وَأَتُوبُ إِلَيْهِ",
    "اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ",
    "لاَ حَوْلَ وَلاَ قُوَّةَ إِلاَّ بِاللَّهِ",
    "رَبِّ اغْفِرْ لِي وَتُبْ عَلَيَّ إِنَّكَ أَنْتَ التَّوَّابُ الرَّحِيمُ",
    "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ عَدَدَ خَلْقِهِ وَرِضَا نَفْسِهِ وَزِنَةَ عَرْشِهِ وَمِدَادَ كَلِمَاتِهِ",
    "اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا، وَرِزْقًا طَيِّبًا، وَعَمَلاً مُتَقَبَّلاً",
    "اللَّهُمَّ أَجِرْنِي مِنَ النَّارِ",
    "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ (مائة مرة)",
    "الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ",
    "اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ شَرِّ مَا عَمِلْتُ، وَمِنْ شَرِّ مَا لَمْ أَعْمَلْ",
    "رَضِيتُ بِاللَّهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، وَبِمُحَمَّدٍ نَبِيًّا وَرَسُولاً",
    "يَا حَيُّ يَا قَيُّومُ، بِرَحْمَتِكَ أَسْتَغِيثُ",
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) {
        if (!mounted) return;

        setState(() {
          _currentIndex =
              (_currentIndex + 1) %
                  _remembrances.length;
        });
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.97),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _quoteIcon(),

          const SizedBox(width: 10),

          Expanded(
            child: AnimatedSwitcher(
              duration:
                  const Duration(milliseconds: 700),
              transitionBuilder:
                  (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: Text(
                _remembrances[_currentIndex],
                key: ValueKey(_currentIndex),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                  height: 1.55,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          _quoteIcon(),
        ],
      ),
    );
  }

  Widget _quoteIcon() {
    return Container(
      padding: const EdgeInsets.all(7),
      decoration: BoxDecoration(
        color:
            HomeScreen.darkGreen.withOpacity(0.09),
        borderRadius: BorderRadius.circular(11),
      ),
      child: const Icon(
        Icons.format_quote_rounded,
        color: HomeScreen.darkGreen,
        size: 19,
      ),
    );
  }
}

// ================================================================
// PRAYER COUNTDOWN
// ================================================================

class AutoPrayerCountdownGlass
    extends StatefulWidget {
  const AutoPrayerCountdownGlass({super.key});

  @override
  State<AutoPrayerCountdownGlass> createState() =>
      _AutoPrayerCountdownGlassState();
}

class _AutoPrayerCountdownGlassState
    extends State<AutoPrayerCountdownGlass>
    with WidgetsBindingObserver {

  static const String _locationRequestKey =
      'location_request_already_shown';

  String _nextPrayerName = "جاري الحساب...";

  Duration _timeLeft = Duration.zero;

  Timer? _timer;

  bool _loading = true;

  bool _locationDialogShowing = false;

  Coordinates? _coordinates;

  CalculationParameters? _params;

  // ------------------------------------------------------------
  // هل تم طلب الموقع من قبل؟
  // ------------------------------------------------------------

  Future<bool> _wasLocationRequestShown() async {
    final prefs =
        await SharedPreferences.getInstance();

    return prefs.getBool(_locationRequestKey) ?? false;
  }

  // ------------------------------------------------------------
  // حفظ أن طلب الموقع ظهر للمستخدم
  // ------------------------------------------------------------

  Future<void> _markLocationRequestShown() async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
      _locationRequestKey,
      true,
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _initPrayerLogic();
  }

  // ============================================================
  // عند العودة للتطبيق
  // ============================================================

  @override
  void didChangeAppLifecycleState(
    AppLifecycleState state,
  ) {
    if (state == AppLifecycleState.resumed) {
      _checkLocationAgain();
    }
  }

  // ============================================================
  // بدء النظام
  // ============================================================

  Future<void> _initPrayerLogic() async {
    await _checkLocationAndStart(
      allowRequestDialog: true,
    );
  }

  // ============================================================
  // فحص الموقع
  // ============================================================

  Future<void> _checkLocationAndStart({
    bool allowRequestDialog = false,
  }) async {
    try {
      // --------------------------------------------------------
      // 1. هل خدمة الموقع مفعلة؟
      // --------------------------------------------------------

      final serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (mounted) {
          setState(() {
            _loading = false;
            _nextPrayerName =
                "يجب تفعيل الموقع";
          });
        }

        // ======================================================
        // مهم:
        // نعرض نافذة التفعيل مرة واحدة فقط.
        // ======================================================

        if (allowRequestDialog) {
          final alreadyShown =
              await _wasLocationRequestShown();

          if (!alreadyShown) {
            await _markLocationRequestShown();

            await _showEnableLocationDialog();
          }
        }

        return;
      }

      // --------------------------------------------------------
      // 2. فحص الصلاحية
      // --------------------------------------------------------

      LocationPermission permission =
          await Geolocator.checkPermission();

      // --------------------------------------------------------
      // طلب إذن الموقع من النظام مرة واحدة فقط
      // --------------------------------------------------------

      if (permission == LocationPermission.denied) {
        final alreadyShown =
            await _wasLocationRequestShown();

        if (!alreadyShown) {
          await _markLocationRequestShown();

          permission =
              await Geolocator.requestPermission();
        }
      }

      // --------------------------------------------------------
      // المستخدم رفض
      // --------------------------------------------------------

      if (permission == LocationPermission.denied) {
        if (mounted) {
          setState(() {
            _loading = false;
            _nextPrayerName =
                "تم رفض إذن الموقع";
          });
        }

        return;
      }

      // --------------------------------------------------------
      // المستخدم منع نهائياً
      // --------------------------------------------------------

      if (permission ==
          LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            _loading = false;
            _nextPrayerName =
                "السماح بالموقع مطلوب";
          });
        }

        // نعرض إعدادات التطبيق مرة واحدة فقط
        if (allowRequestDialog) {
          final alreadyShown =
              await _wasLocationRequestShown();

          if (!alreadyShown) {
            await _markLocationRequestShown();

            await _showPermissionSettingsDialog();
          }
        }

        return;
      }

      // --------------------------------------------------------
      // 3. الحصول على الموقع
      // --------------------------------------------------------

      final position =
          await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _coordinates = Coordinates(
        position.latitude,
        position.longitude,
      );

      _params =
          CalculationMethod.umm_al_qura
              .getParameters();

      _params!.madhab = Madhab.shafi;

      // --------------------------------------------------------
      // تحديث مباشر
      // --------------------------------------------------------

      _updatePrayer();

      // --------------------------------------------------------
      // منع وجود Timer قديم
      // --------------------------------------------------------

      _timer?.cancel();

      // --------------------------------------------------------
      // تحديث العداد كل ثانية
      // --------------------------------------------------------

      _timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) {
          _updatePrayer();
        },
      );
    } catch (e) {
      debugPrint(
        'خطأ في تحديد الموقع: $e',
      );

      if (mounted) {
        setState(() {
          _loading = false;
          _nextPrayerName =
              "تعذر تحديد الموقع";
        });
      }
    }
  }

  // ============================================================
  // إعادة فحص الموقع عند العودة
  //
  // هنا لا نطلب الموقع مرة أخرى.
  // فقط نفحص هل أصبح متاحاً أم لا.
  // ============================================================

  Future<void> _checkLocationAgain() async {
    if (!mounted) return;

    try {
      final enabled =
          await Geolocator.isLocationServiceEnabled();

      if (!enabled) {
        _timer?.cancel();
        _timer = null;

        if (mounted) {
          setState(() {
            _loading = false;
            _nextPrayerName =
                "يجب تفعيل الموقع";
          });
        }

        // ======================================================
        // لا يوجد Dialog هنا أبداً
        // لأن الطلب تم التعامل معه سابقاً.
        // ======================================================

        return;
      }

      final permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied ||
          permission ==
              LocationPermission.deniedForever) {

        if (mounted) {
          setState(() {
            _loading = false;
            _nextPrayerName =
                permission ==
                        LocationPermission.deniedForever
                    ? "السماح بالموقع مطلوب"
                    : "تم رفض إذن الموقع";
          });
        }

        // لا نعيد requestPermission
        return;
      }

      // ======================================================
      // الموقع متاح والصلاحية موجودة
      // ======================================================

      if (_coordinates == null) {
        await _checkLocationAndStart(
          allowRequestDialog: false,
        );
      }
    } catch (e) {
      debugPrint(
        'خطأ في إعادة فحص الموقع: $e',
      );
    }
  }

  // ============================================================
  // Dialog تفعيل الموقع
  // يظهر مرة واحدة فقط
  // ============================================================

  Future<void> _showEnableLocationDialog() async {
    if (!mounted || _locationDialogShowing) {
      return;
    }

    _locationDialogShowing = true;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                color: HomeScreen.teal,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'تفعيل الموقع',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          content: const Text(
            'يحتاج التطبيق إلى تشغيل خدمة الموقع لحساب أوقات الصلاة حسب موقعك الحالي.',
            style: TextStyle(
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          actionsPadding:
              const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            16,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'لاحقاً',
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.pop(dialogContext);

                await Geolocator.openLocationSettings();
              },
              icon: const Icon(
                Icons.settings_rounded,
                size: 19,
              ),
              label: const Text(
                'تفعيل الموقع',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    HomeScreen.darkGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        );
      },
    );

    _locationDialogShowing = false;

    // ==========================================================
    // لا نستدعي _checkLocationAndStart مع Dialog
    //
    // فقط نفحص هل المستخدم فعّل الموقع.
    // ==========================================================

    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    if (mounted) {
      await _checkLocationAgain();
    }
  }

  // ============================================================
  // Dialog الصلاحية المرفوضة نهائياً
  // يظهر مرة واحدة فقط
  // ============================================================

  Future<void> _showPermissionSettingsDialog() async {
    if (!mounted || _locationDialogShowing) {
      return;
    }

    _locationDialogShowing = true;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.location_disabled_rounded,
                color: Colors.orange,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'السماح بالموقع',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          content: const Text(
            'تم منع إذن الموقع. افتح إعدادات التطبيق واسمح للتطبيق باستخدام الموقع حتى تعمل أوقات الصلاة بشكل صحيح.',
            style: TextStyle(
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          actionsPadding:
              const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            16,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'لاحقاً',
                style: TextStyle(
                  color: Colors.black54,
                ),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                Navigator.pop(dialogContext);

                await Geolocator.openAppSettings();
              },
              icon: const Icon(
                Icons.settings_rounded,
                size: 19,
              ),
              label: const Text(
                'فتح الإعدادات',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    HomeScreen.darkGreen,
                foregroundColor: Colors.white,
                elevation: 0,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        );
      },
    );

    _locationDialogShowing = false;

    // ==========================================================
    // فقط فحص جديد بدون أي طلب أو Dialog
    // ==========================================================

    await Future.delayed(
      const Duration(milliseconds: 300),
    );

    if (mounted) {
      await _checkLocationAgain();
    }
  }

  // ============================================================
  // تحديث الصلاة
  // ============================================================

  void _updatePrayer() {
    if (!mounted ||
        _coordinates == null ||
        _params == null) {
      return;
    }

    try {
      final prayerTimes = PrayerTimes.today(
        _coordinates!,
        _params!,
      );

      final next = prayerTimes.nextPrayer();

      if (next != Prayer.none) {
        final prayerTime =
            prayerTimes.timeForPrayer(next);

        if (prayerTime == null) {
          return;
        }

        final difference =
            prayerTime.difference(
          DateTime.now(),
        );

        setState(() {
          _nextPrayerName =
              _translatePrayer(next);

          _timeLeft = difference.isNegative
              ? Duration.zero
              : difference;

          _loading = false;
        });

        return;
      }

      // ========================================================
      // انتهت صلوات اليوم → الفجر غداً
      // ========================================================

      final tomorrow =
          DateTime.now().add(
        const Duration(days: 1),
      );

      final tomorrowDate =
          DateComponents.from(tomorrow);

      final tomorrowTimes = PrayerTimes(
        _coordinates!,
        tomorrowDate,
        _params!,
      );

      final difference =
          tomorrowTimes.fajr.difference(
        DateTime.now(),
      );

      setState(() {
        _nextPrayerName = "الفجر";

        _timeLeft = difference.isNegative
            ? Duration.zero
            : difference;

        _loading = false;
      });
    } catch (e) {
      debugPrint(
        'خطأ أثناء حساب الصلاة: $e',
      );

      if (mounted) {
        setState(() {
          _loading = false;
          _nextPrayerName =
              "تعذر حساب الصلاة";
        });
      }
    }
  }

  // ============================================================
  // ترجمة الصلاة
  // ============================================================

  String _translatePrayer(
    Prayer prayer,
  ) {
    switch (prayer) {
      case Prayer.fajr:
        return "الفجر";

      case Prayer.dhuhr:
        return "الظهر";

      case Prayer.asr:
        return "العصر";

      case Prayer.maghrib:
        return "المغرب";

      case Prayer.isha:
        return "العشاء";

      default:
        return "الصلاة";
    }
  }

  // ============================================================
  // Dispose
  // ============================================================

  @override
  void dispose() {
    WidgetsBinding.instance
        .removeObserver(this);

    _timer?.cancel();

    super.dispose();
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Container(
        height: 105,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.97),
          borderRadius:
              BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: CircularProgressIndicator(
            color: HomeScreen.teal,
          ),
        ),
      );
    }

    // ==========================================================
    // الموقع غير مفعل
    // ==========================================================

    if (_nextPrayerName ==
            "يجب تفعيل الموقع" ||
        _nextPrayerName ==
            "تم رفض إذن الموقع" ||
        _nextPrayerName ==
            "السماح بالموقع مطلوب") {
      return _buildLocationRequiredCard();
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(
        15,
        13,
        15,
        14,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.98),
        borderRadius:
            BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: HomeScreen.teal
                .withOpacity(0.10),
            blurRadius: 13,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: HomeScreen.teal
                      .withOpacity(0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.access_time_rounded,
                  color: HomeScreen.teal,
                  size: 17,
                ),
              ),

              const SizedBox(width: 7),

              Text(
                'المتبقي لصلاة $_nextPrayerName',
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 9),

          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              _timePart(
                _timeLeft.inHours
                    .toString()
                    .padLeft(2, '0'),
                "ساعة",
              ),

              _buildDivider(),

              _timePart(
                (_timeLeft.inMinutes % 60)
                    .toString()
                    .padLeft(2, '0'),
                "دقيقة",
              ),

              _buildDivider(),

              _timePart(
                (_timeLeft.inSeconds % 60)
                    .toString()
                    .padLeft(2, '0'),
                "ثانية",
              ),
            ],
          ),

          const SizedBox(height: 8),

          Container(
            height: 3,
            width: 65,
            decoration: BoxDecoration(
              gradient:
                  const LinearGradient(
                colors: [
                  HomeScreen.darkGreen,
                  HomeScreen.blue,
                ],
              ),
              borderRadius:
                  BorderRadius.circular(10),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // بطاقة الموقع
  // ============================================================

  Widget _buildLocationRequiredCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.98),
        borderRadius:
            BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.orange
                .withOpacity(0.10),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: Colors.orange
                  .withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.location_off_rounded,
              color: Colors.orange,
              size: 25,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            _nextPrayerName ==
                    "السماح بالموقع مطلوب"
                ? 'السماح بالموقع مطلوب'
                : _nextPrayerName ==
                        "تم رفض إذن الموقع"
                    ? 'تم رفض إذن الموقع'
                    : 'الموقع غير مفعل',
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 4),

          const Text(
            'فعّل الموقع لحساب أوقات الصلاة حسب موقعك الحالي',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 11,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 10),

          ElevatedButton.icon(
            onPressed: () async {
              if (_nextPrayerName ==
                  "السماح بالموقع مطلوب") {
                await Geolocator.openAppSettings();
              } else {
                await Geolocator.openLocationSettings();
              }

              await Future.delayed(
                const Duration(milliseconds: 300),
              );

              if (mounted) {
                await _checkLocationAgain();
              }
            },
            icon: const Icon(
              Icons.location_on_rounded,
              size: 17,
            ),
            label: const Text(
              'تفعيل الموقع',
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  HomeScreen.darkGreen,
              foregroundColor: Colors.white,
              elevation: 0,
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 9,
              ),
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Time part
  // ============================================================

  Widget _timePart(
    String value,
    String label,
  ) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 26,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 0),

        Text(
          label,
          style: const TextStyle(
            color: HomeScreen.teal,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // Divider
  // ============================================================

  Widget _buildDivider() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 8,
      ).copyWith(bottom: 12),
      child: const Text(
        ':',
        style: TextStyle(
          color: HomeScreen.teal,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
