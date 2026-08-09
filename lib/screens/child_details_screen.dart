import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class ChildDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> child;

  const ChildDetailsScreen({
    super.key,
    required this.child,
  });

  // ============================================================
  // الألوان الرسمية للتطبيق
  // ============================================================

  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color primaryBlue = Color(0xFF42A5F5);
  static const Color background = Color(0xFFF5F7FA);

  @override
  Widget build(BuildContext context) {
    final String studentId = child['id']?.toString() ?? '';
    final String studentName =
        child['name']?.toString().trim().isNotEmpty == true
            ? child['name'].toString()
            : 'الطالب';

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: background,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                primaryGreen,
                primaryBlue,
                background,
              ],
              stops: [
                0.0,
                0.30,
                0.65,
              ],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                _buildTopHeader(
                  context,
                  studentName,
                ),

                const SizedBox(height: 12),

                _buildStudentCard(
                  studentName,
                ),

                const SizedBox(height: 16),

                _buildTabs(),

                const SizedBox(height: 8),

                Expanded(
                  child: studentId.isEmpty
                      ? _buildErrorState()
                      : TabBarView(
                          children: [
                            _buildDailyReport(studentId),
                            _buildMonthlyReport(studentId),
                          ],
                        ),
                ),
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

  Widget _buildTopHeader(
    BuildContext context,
    String studentName,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        0,
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
              ),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'متابعة الطالب',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  studentName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
              ),
            ),
            child: const Icon(
              Icons.menu_book_rounded,
              color: Colors.white,
              size: 23,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Student Card
  // ============================================================

  Widget _buildStudentCard(
    String studentName,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // صورة / أيقونة الطالب
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  primaryGreen,
                  primaryBlue,
                ],
              ),
              borderRadius: BorderRadius.circular(19),
              boxShadow: [
                BoxShadow(
                  color: primaryGreen.withOpacity(0.25),
                  blurRadius: 12,
                ),
              ],
            ),
            child: const Icon(
              Icons.person_rounded,
              color: Colors.white,
              size: 34,
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  'الطالب',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  studentName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 7),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 9,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: primaryGreen.withOpacity(0.09),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_stories_rounded,
                            color: primaryGreen,
                            size: 15,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'حلقة القرآن',
                            style: TextStyle(
                              color: primaryGreen,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_rounded,
              color: primaryBlue,
              size: 25,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Tabs
  // ============================================================

  Widget _buildTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TabBar(
        indicator: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              primaryGreen,
              primaryBlue,
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        indicatorPadding: const EdgeInsets.all(5),
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey.shade600,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
        tabs: const [
          Tab(
            icon: Icon(
              Icons.today_rounded,
              size: 21,
            ),
            text: 'إنجاز اليوم',
          ),
          Tab(
            icon: Icon(
              Icons.calendar_month_rounded,
              size: 21,
            ),
            text: 'السجل الكامل',
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Daily Report
  // ============================================================

  Widget _buildDailyReport(
    String studentId,
  ) {
    final String today =
        DateTime.now().toIso8601String().split('T')[0];

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('records')
          .where(
            'studentId',
            isEqualTo: studentId,
          )
          .where(
            'date',
            isEqualTo: today,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return _buildLoading();
        }

        if (snapshot.hasError) {
          return _buildEmptyState(
            icon: Icons.error_outline_rounded,
            title: 'تعذر تحميل البيانات',
            subtitle:
                'حدث خطأ أثناء جلب سجل الطالب.',
          );
        }

        if (!snapshot.hasData ||
            snapshot.data!.docs.isEmpty) {
          return _buildEmptyState(
            icon: Icons.event_available_rounded,
            title: 'لا يوجد إنجاز اليوم',
            subtitle:
                'لم يتم تسجيل أي إنجاز للطالب بتاريخ\n$today',
          );
        }

        return _buildRecordList(
          snapshot.data!.docs,
        );
      },
    );
  }

  // ============================================================
  // Monthly / All Reports
  // ============================================================

  Widget _buildMonthlyReport(
    String studentId,
  ) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('records')
          .where(
            'studentId',
            isEqualTo: studentId,
          )
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return _buildLoading();
        }

        if (snapshot.hasError) {
          return _buildEmptyState(
            icon: Icons.error_outline_rounded,
            title: 'تعذر تحميل السجل',
            subtitle:
                'حدث خطأ أثناء جلب البيانات.',
          );
        }

        if (!snapshot.hasData ||
            snapshot.data!.docs.isEmpty) {
          return _buildEmptyState(
            icon: Icons.history_rounded,
            title: 'لا توجد سجلات سابقة',
            subtitle:
                'ستظهر هنا جميع إنجازات الطالب المسجلة.',
          );
        }

        final List<DocumentSnapshot> docs =
            [...snapshot.data!.docs];

        docs.sort(
          (a, b) {
            final String dateA =
                (a.data() as Map<String, dynamic>)['date']
                        ?.toString() ??
                    '';

            final String dateB =
                (b.data() as Map<String, dynamic>)['date']
                        ?.toString() ??
                    '';

            return dateB.compareTo(dateA);
          },
        );

        return _buildRecordList(docs);
      },
    );
  }

  // ============================================================
  // Records List
  // ============================================================

  Widget _buildRecordList(
    List<DocumentSnapshot> docs,
  ) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        30,
      ),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final data =
            docs[index].data() as Map<String, dynamic>;

        return _buildRecordCard(
          context,
          data,
        );
      },
    );
  }

  // ============================================================
  // Record Card
  // ============================================================

  Widget _buildRecordCard(
    BuildContext context,
    Map<String, dynamic> data,
  ) {
    final String status =
        data['status']?.toString() ?? 'حاضر';

    final bool isAbsent =
        status == 'غائب';

    final bool isVacation =
        status == 'إجازة';

    final bool isSpecialStatus =
        isAbsent || isVacation;

    final String surah =
        data['surah']?.toString() ??
            'غير محددة';

    final String date =
        data['date']?.toString() ?? '';

    final String grade =
        data['grade']?.toString() ?? '';

    final Color statusColor =
        isAbsent
            ? Colors.red
            : isVacation
                ? Colors.orange
                : primaryGreen;

    final Color statusBackground =
        isAbsent
            ? Colors.red.shade50
            : isVacation
                ? Colors.orange.shade50
                : Colors.white;

    return Container(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: statusBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSpecialStatus
              ? statusColor.withOpacity(0.25)
              : Colors.white,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: [
            // ----------------------------------------------------
            // Top accent
            // ----------------------------------------------------

            Container(
              height: 5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isSpecialStatus
                      ? [
                          statusColor,
                          statusColor.withOpacity(0.5),
                        ]
                      : const [
                          primaryGreen,
                          primaryBlue,
                        ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(17),
              child: Column(
                children: [
                  // ------------------------------------------------
                  // Header
                  // ------------------------------------------------

                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isSpecialStatus
                                ? [
                                    statusColor,
                                    statusColor
                                        .withOpacity(0.65),
                                  ]
                                : const [
                                    primaryGreen,
                                    primaryBlue,
                                  ],
                          ),
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                        child: Icon(
                          isAbsent
                              ? Icons.person_off_rounded
                              : isVacation
                                  ? Icons.beach_access_rounded
                                  : Icons.menu_book_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),

                      const SizedBox(width: 13),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Text(
                              isSpecialStatus
                                  ? 'حالة الطالب'
                                  : 'إنجاز القرآن الكريم',
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                                fontWeight:
                                    FontWeight.w500,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              isSpecialStatus
                                  ? status
                                  : 'سورة $surah',
                              maxLines: 1,
                              overflow:
                                  TextOverflow.ellipsis,
                              style: TextStyle(
                                color: statusColor ==
                                        primaryGreen
                                    ? Colors.black87
                                    : statusColor,
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      _buildDateBadge(date),
                    ],
                  ),

                  // ------------------------------------------------
                  // Ayahs
                  // ------------------------------------------------

                  if (!isSpecialStatus) ...[
                    const SizedBox(height: 18),

                    Container(
                      width: double.infinity,
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        color:
                            primaryGreen.withOpacity(0.06),
                        borderRadius:
                            BorderRadius.circular(15),
                        border: Border.all(
                          color: primaryGreen
                              .withOpacity(0.12),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding:
                                const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: primaryGreen
                                  .withOpacity(0.12),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.format_list_numbered_rounded,
                              color: primaryGreen,
                              size: 19,
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              'من الآية ${data['fromAyah'] ?? '0'} '
                              'إلى الآية ${data['toAyah'] ?? '0'}',
                              style: const TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),

                          const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: primaryGreen,
                            size: 15,
                          ),
                        ],
                      ),
                    ),
                  ],

                  // ------------------------------------------------
                  // Evaluation
                  // ------------------------------------------------

                  if (!isSpecialStatus) ...[
                    const SizedBox(height: 17),

                    _buildSectionTitle(
                      icon: Icons.star_rounded,
                      title: 'التقييم',
                    ),

                    const SizedBox(height: 10),

                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                        children: [
                          _buildEvaluationTag(
                            'إتقان',
                            grade.contains('إتقان'),
                          ),
                          _buildEvaluationTag(
                            'حفظ',
                            grade.contains('حفظ'),
                          ),
                          _buildEvaluationTag(
                            'تجويد',
                            grade.contains('تجويد'),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // ------------------------------------------------
                  // Tomorrow
                  // ------------------------------------------------

                  if (_hasText(
                    data['tomorrowRequirement'],
                  )) ...[
                    const SizedBox(height: 15),

                    _buildHighlightCard(
                      icon: Icons.auto_stories_rounded,
                      iconColor: primaryBlue,
                      label: 'المطلوب غداً',
                      value: data[
                        'tomorrowRequirement'
                      ].toString(),
                    ),
                  ],

                  // ------------------------------------------------
                  // Notes
                  // ------------------------------------------------

                  if (_hasText(
                    data['notes'],
                  )) ...[
                    const SizedBox(height: 11),

                    _buildHighlightCard(
                      icon: Icons.edit_note_rounded,
                      iconColor: primaryGreen,
                      label: 'ملاحظة المدرس',
                      value: data['notes'].toString(),
                    ),
                  ],

                  // ------------------------------------------------
                  // WhatsApp
                  // ------------------------------------------------

                  if (!isSpecialStatus) ...[
                    const SizedBox(height: 16),

                    Container(
                      height: 1,
                      color: Colors.grey.shade200,
                    ),

                    const SizedBox(height: 13),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _openWhatsApp(
                            context,
                            data['teacherPhone']
                                    ?.toString() ??
                                '967770000000',
                            surah,
                          );
                        },
                        icon: const Icon(
                          Icons.chat_rounded,
                          size: 20,
                        ),
                        label: const Text(
                          'التواصل مع المدرس',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              primaryGreen,
                          foregroundColor:
                              Colors.white,
                          elevation: 0,
                          padding:
                              const EdgeInsets.symmetric(
                            vertical: 13,
                          ),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // Date Badge
  // ============================================================

  Widget _buildDateBadge(
    String date,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        date,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ============================================================
  // Section Title
  // ============================================================

  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: primaryGreen,
          size: 20,
        ),
        const SizedBox(width: 7),
        Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // Highlight Card
  // ============================================================

  Widget _buildHighlightCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.07),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: iconColor.withOpacity(0.18),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.13),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 21,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: iconColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    height: 1.55,
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
  // Evaluation Tag
  // ============================================================

  Widget _buildEvaluationTag(
    String title,
    bool isDone,
  ) {
    final Color color =
        isDone ? primaryGreen : Colors.grey;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isDone
                  ? primaryGreen.withOpacity(0.10)
                  : Colors.grey.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isDone
                  ? Icons.check_rounded
                  : Icons.remove_rounded,
              color: color,
              size: 21,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color:
                  isDone ? Colors.black87 : Colors.grey,
              fontSize: 12,
              fontWeight:
                  isDone
                      ? FontWeight.bold
                      : FontWeight.normal,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            isDone ? 'ممتاز' : 'لم يسجل',
            style: TextStyle(
              color: isDone
                  ? primaryGreen
                  : Colors.grey.shade400,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Loading
  // ============================================================

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 3,
      ),
    );
  }

  // ============================================================
  // Empty State
  // ============================================================

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      primaryGreen.withOpacity(0.12),
                      primaryBlue.withOpacity(0.12),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: primaryGreen,
                  size: 38,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Error
  // ============================================================

  Widget _buildErrorState() {
    return _buildEmptyState(
      icon: Icons.person_off_rounded,
      title: 'تعذر العثور على الطالب',
      subtitle:
          'لم يتم العثور على معرف الطالب المطلوب.',
    );
  }

  // ============================================================
  // Check Text
  // ============================================================

  bool _hasText(dynamic value) {
    return value != null &&
        value.toString().trim().isNotEmpty;
  }

  // ============================================================
  // WhatsApp
  // ============================================================

  Future<void> _openWhatsApp(
    BuildContext context,
    String phone,
    String subject,
  ) async {
    String cleanPhone =
        phone.replaceAll(RegExp(r'[^\d]'), '');

    if (cleanPhone.startsWith('00')) {
      cleanPhone =
          cleanPhone.substring(2);
    }

    final String message =
        'السلام عليكم، أستفسر عن مستوى ابني في حلقة القرآن الكريم '
        'بخصوص $subject.';

    final Uri url = Uri.parse(
      'https://wa.me/$cleanPhone'
      '?text=${Uri.encodeComponent(message)}',
    );

    try {
      final bool canLaunch =
          await canLaunchUrl(url);

      if (canLaunch) {
        await launchUrl(
          url,
          mode: LaunchMode.externalApplication,
        );
      } else {
        if (!context.mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'تعذر فتح واتساب.',
            ),
            backgroundColor: Colors.redAccent,
            behavior:
                SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'حدث خطأ أثناء فتح واتساب.',
          ),
          backgroundColor:
              Colors.redAccent,
          behavior:
              SnackBarBehavior.floating,
        ),
      );
    }
  }
}
