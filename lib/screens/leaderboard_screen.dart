import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  // ============================================================
  // الألوان الأساسية للتطبيق
  // ============================================================

  static const Color primaryBlue = Color(0xFF1A237E);
  static const Color blue = Color(0xFF1565C0);
  static const Color lightBlue = Color(0xFF42A5F5);

  static const Color gold = Color(0xFFFFB300);
  static const Color silver = Color(0xFF78909C);
  static const Color bronze = Color(0xFFEF6C00);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),

            const SizedBox(height: 8),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('students')
                    .orderBy(
                      'totalPoints',
                      descending: true,
                    )
                    .limit(3)
                    .snapshots(),
                builder: (context, snapshot) {
                  // ------------------------------------------------
                  // خطأ
                  // ------------------------------------------------

                  if (snapshot.hasError) {
                    return _buildErrorState();
                  }

                  // ------------------------------------------------
                  // تحميل
                  // ------------------------------------------------

                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return _buildLoadingState();
                  }

                  // ------------------------------------------------
                  // البيانات
                  // ------------------------------------------------

                  final students =
                      snapshot.data?.docs ?? [];

                  if (students.isEmpty) {
                    return _buildEmptyState();
                  }

                  return _buildLeaderboard(students);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // Header
  // ============================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        8,
      ),
      child: Column(
        children: [
          // أيقونة الكأس
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primaryBlue,
                  blue,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryBlue.withOpacity(0.22),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: Colors.white,
              size: 34,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'الطلاب المتصدرون',
            style: TextStyle(
              color: primaryBlue,
              fontSize: 25,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.3,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            'أفضل 3 طلاب لهذا اليوم',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 16),

          // خط زخرفي
          Container(
            width: 55,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [
                  lightBlue,
                  primaryBlue,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Leaderboard
  // ============================================================

  Widget _buildLeaderboard(
    List<QueryDocumentSnapshot> students,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            12,
            10,
            12,
            30,
          ),
          child: Column(
            children: [
              const SizedBox(height: 18),

              // --------------------------------------------------
              // منصة المتصدرين
              // --------------------------------------------------

              SizedBox(
                height: 510,
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.end,
                  children: [
                    // المركز الثاني
                    if (students.length > 1)
                      Expanded(
                        child: _buildPodiumItem(
                          doc: students[1],
                          rank: 2,
                          color: silver,
                          podiumHeight: 145,
                        ),
                      )
                    else
                      const Expanded(
                        child: SizedBox(),
                      ),

                    // المركز الأول
                    Expanded(
                      child: _buildPodiumItem(
                        doc: students[0],
                        rank: 1,
                        color: gold,
                        podiumHeight: 190,
                        isWinner: true,
                      ),
                    ),

                    // المركز الثالث
                    if (students.length > 2)
                      Expanded(
                        child: _buildPodiumItem(
                          doc: students[2],
                          rank: 3,
                          color: bronze,
                          podiumHeight: 115,
                        ),
                      )
                    else
                      const Expanded(
                        child: SizedBox(),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // --------------------------------------------------
              // رسالة تشجيعية
              // --------------------------------------------------

              _buildMotivationCard(),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // Podium item
  // ============================================================

  Widget _buildPodiumItem({
    required QueryDocumentSnapshot doc,
    required int rank,
    required Color color,
    required double podiumHeight,
    bool isWinner = false,
  }) {
    final data =
        doc.data() as Map<String, dynamic>;

    final String name =
        (data['name'] ?? 'طالب').toString();

    final dynamic rawPoints =
        data['totalPoints'] ?? 0;

    final int points =
        rawPoints is num
            ? rawPoints.toInt()
            : int.tryParse(
                  rawPoints.toString(),
                ) ??
                0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // ========================================================
        // التاج للمركز الأول
        // ========================================================

        if (isWinner)
          const Padding(
            padding: EdgeInsets.only(bottom: 3),
            child: Icon(
              Icons.workspace_premium_rounded,
              color: gold,
              size: 38,
            ),
          ),

        if (!isWinner)
          const SizedBox(height: 38),

        // ========================================================
        // دائرة المركز
        // ========================================================

        Container(
          width: isWinner ? 88 : 76,
          height: isWinner ? 88 : 76,
          decoration: BoxDecoration(
            shape: BoxShape.circle,

            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color,
                color.withOpacity(0.72),
              ],
            ),

            border: Border.all(
              color: Colors.white,
              width: 4,
            ),

            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.35),
                blurRadius: isWinner ? 22 : 14,
                offset: const Offset(0, 7),
              ),
            ],
          ),

          child: Center(
            child: Text(
              '$rank',
              style: TextStyle(
                color: Colors.white,
                fontSize: isWinner ? 32 : 27,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),

        const SizedBox(height: 12),

        // ========================================================
        // بطاقة اسم الطالب
        // ========================================================

        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(
            horizontal: 3,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: color.withOpacity(0.22),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.055),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // الاسم
              Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: primaryBlue,
                  fontSize: isWinner ? 16 : 14,
                  fontWeight: FontWeight.w900,
                  height: 1.25,
                ),
              ),

              const SizedBox(height: 5),

              // النقاط
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.stars_rounded,
                    color: color,
                    size: 18,
                  ),
                  const SizedBox(width: 3),
                  Flexible(
                    child: Text(
                      '$points نقطة',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // ========================================================
        // المنصة
        // ========================================================

        Container(
          height: podiumHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(18),
            ),

            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                color.withOpacity(0.30),
                color.withOpacity(0.08),
              ],
            ),

            border: Border.all(
              color: color.withOpacity(0.12),
            ),

            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),

          child: Column(
            children: [
              const SizedBox(height: 15),

              // رقم المركز على المنصة
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.18),
                ),
                alignment: Alignment.center,
                child: Text(
                  '$rank',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ============================================================
  // Motivation card
  // ============================================================

  Widget _buildMotivationCard() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            primaryBlue.withOpacity(0.96),
            blue.withOpacity(0.92),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.14),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: Colors.white,
              size: 25,
            ),
          ),

          const SizedBox(width: 13),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'واصل التقدم!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'اجتهد اليوم لتكون من المتصدرين غدًا 🌟',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Loading
  // ============================================================

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: primaryBlue,
              ),
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'جاري تحميل المتصدرين...',
            style: TextStyle(
              color: primaryBlue,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Empty
  // ============================================================

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.emoji_events_outlined,
                size: 45,
                color: primaryBlue,
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'لا يوجد متصدرون حتى الآن',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primaryBlue,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'ابدأ بجمع النقاط لتظهر في قائمة المتصدرين.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // Error
  // ============================================================

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_off_rounded,
              size: 65,
              color: primaryBlue,
            ),

            const SizedBox(height: 16),

            const Text(
              'تعذر تحميل قائمة المتصدرين',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: primaryBlue,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'تحقق من اتصال الإنترنت وحاول مرة أخرى.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
