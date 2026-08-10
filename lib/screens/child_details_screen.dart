import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hijri_date/hijri.dart';

class ChildDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> child;

  const ChildDetailsScreen({
    super.key,
    required this.child,
  });

  @override
  State<ChildDetailsScreen> createState() =>
      _ChildDetailsScreenState();
}

class _ChildDetailsScreenState extends State<ChildDetailsScreen> {
  // ============================================================
  // الألوان الرسمية
  // ============================================================

  static const Color primaryGreen = Color(0xFF2E7D32);
  static const Color primaryBlue = Color(0xFF42A5F5);
  static const Color background = Color(0xFFF5F7FA);

  final TextEditingController _parentMessageController =
      TextEditingController();

  bool _sendingMessage = false;

  String? _adminId;
  bool _loadingAdmin = false;

  @override
  void initState() {
    super.initState();

    _loadAdmin();
  }

  @override
  void dispose() {
    _parentMessageController.dispose();
    super.dispose();
  }

  // ============================================================
  // جلب المدير
  // ============================================================

  Future<void> _loadAdmin() async {
    if (_loadingAdmin) return;

    setState(() {
      _loadingAdmin = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where(
            'role',
            isEqualTo: 'admin',
          )
          .limit(1)
          .get();

      if (snapshot.docs.isNotEmpty) {
        _adminId = snapshot.docs.first.id;
      }
    } catch (e) {
      debugPrint('Load Admin Error: $e');
    } finally {
      if (mounted) {
        setState(() {
          _loadingAdmin = false;
        });
      }
    }
  }

  // ============================================================
  // Build
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final String studentId =
        widget.child['id']?.toString() ?? '';

    final String studentName =
        widget.child['name']?.toString().trim().isNotEmpty == true
            ? widget.child['name'].toString().trim()
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
              crossAxisAlignment:
                  CrossAxisAlignment.start,
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
              Icons.admin_panel_settings_rounded,
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
              borderRadius:
                  BorderRadius.circular(19),
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

                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color:
                        primaryGreen.withOpacity(0.09),
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize:
                        MainAxisSize.min,
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
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color:
                  primaryBlue.withOpacity(0.08),
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
          borderRadius:
              BorderRadius.circular(16),
        ),
        indicatorSize:
            TabBarIndicatorSize.tab,
        indicatorPadding:
            const EdgeInsets.all(5),
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor:
            Colors.grey.shade600,
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
  // Daily
  // ============================================================

  Widget _buildDailyReport(
    String studentId,
  ) {
    final String today =
        DateTime.now()
            .toIso8601String()
            .split('T')[0];

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
            icon:
                Icons.error_outline_rounded,
            title:
                'تعذر تحميل البيانات',
            subtitle:
                'حدث خطأ أثناء جلب سجل الطالب.',
          );
        }

        if (!snapshot.hasData ||
            snapshot.data!.docs.isEmpty) {
          return _buildEmptyState(
            icon:
                Icons.event_available_rounded,
            title:
                'لا يوجد سجل اليوم',
            subtitle:
                'لم يتم تسجيل أي حالة للطالب بتاريخ\n$today',
          );
        }

        final List<DocumentSnapshot> docs =
            [...snapshot.data!.docs];

        _sortRecordsNewestFirst(docs);

        return _buildRecordList(docs);
      },
    );
  }

  // ============================================================
  // Monthly
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
            icon:
                Icons.error_outline_rounded,
            title:
                'تعذر تحميل السجل',
            subtitle:
                'حدث خطأ أثناء جلب البيانات.',
          );
        }

        if (!snapshot.hasData ||
            snapshot.data!.docs.isEmpty) {
          return _buildEmptyState(
            icon:
                Icons.history_rounded,
            title:
                'لا توجد سجلات سابقة',
            subtitle:
                'ستظهر هنا جميع حالات وإنجازات الطالب.',
          );
        }

        final List<DocumentSnapshot> docs =
            [...snapshot.data!.docs];

        _sortRecordsNewestFirst(docs);

        return _buildRecordList(docs);
      },
    );
  }

  // ============================================================
  // ترتيب الرصد
  // ============================================================

  void _sortRecordsNewestFirst(
    List<DocumentSnapshot> docs,
  ) {
    docs.sort((a, b) {
      final Map<String, dynamic> dataA =
          (a.data()
                  as Map<String, dynamic>?) ??
              {};

      final Map<String, dynamic> dataB =
          (b.data()
                  as Map<String, dynamic>?) ??
              {};

      final DateTime dateA =
          _recordDateTime(dataA);

      final DateTime dateB =
          _recordDateTime(dataB);

      return dateB.compareTo(dateA);
    });
  }

  DateTime _recordDateTime(
    Map<String, dynamic> data,
  ) {
    final dynamic createdAt =
        data['createdAt'];

    if (createdAt is Timestamp) {
      return createdAt.toDate();
    }

    final String date =
        data['date']?.toString() ?? '';

    final DateTime? parsed =
        DateTime.tryParse(date);

    return parsed ?? DateTime(1900);
  }

  // ============================================================
  // Records
  // ============================================================

  Widget _buildRecordList(
    List<DocumentSnapshot> docs,
  ) {
    return ListView.builder(
      physics:
          const BouncingScrollPhysics(),
      padding:
          const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        40,
      ),
      itemCount: docs.length,
      itemBuilder:
          (context, index) {
        final data =
            docs[index].data()
                as Map<String, dynamic>;

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
        data['status']?.toString() ??
            'حاضر';

    final bool isAbsent =
        status == 'غائب';

    final bool isVacation =
        status == 'إجازة';

    final bool isExcused =
        status == 'مستأذن';

    final bool isReviewStatus =
        status == 'مراجعة';

    final bool isSpecialStatus =
        isAbsent ||
        isVacation ||
        isExcused ||
        isReviewStatus;

    final String surah =
        data['surah']?.toString() ??
            'غير محددة';

    final String date =
        data['date']?.toString() ?? '';

    final String grade =
        data['grade']?.toString() ?? '';

    Color statusColor;
    IconData statusIcon;

    if (isAbsent) {
      statusColor = Colors.red;
      statusIcon =
          Icons.person_off_rounded;
    } else if (isVacation) {
      statusColor = Colors.orange;
      statusIcon =
          Icons.beach_access_rounded;
    } else if (isExcused) {
      statusColor =
          Colors.deepPurple;
      statusIcon =
          Icons.event_available_rounded;
    } else if (isReviewStatus) {
      statusColor = Colors.blue;
      statusIcon =
          Icons.fact_check_rounded;
    } else {
      statusColor = primaryGreen;
      statusIcon =
          Icons.menu_book_rounded;
    }

    return Container(
      margin:
          const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isSpecialStatus
            ? statusColor.withOpacity(0.035)
            : Colors.white,
        borderRadius:
            BorderRadius.circular(24),
        border: Border.all(
          color: isSpecialStatus
              ? statusColor.withOpacity(0.25)
              : Colors.white,
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(0.07),
            blurRadius: 18,
            offset:
                const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius:
            BorderRadius.circular(24),
        child: Column(
          children: [
            Container(
              height: 5,
              decoration:
                  BoxDecoration(
                gradient:
                    LinearGradient(
                  colors:
                      isSpecialStatus
                          ? [
                              statusColor,
                              statusColor
                                  .withOpacity(
                                      0.5),
                            ]
                          : const [
                              primaryGreen,
                              primaryBlue,
                            ],
                ),
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.all(17),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration:
                            BoxDecoration(
                          gradient:
                              LinearGradient(
                            colors:
                                isSpecialStatus
                                    ? [
                                        statusColor,
                                        statusColor
                                            .withOpacity(
                                                0.65),
                                      ]
                                    : const [
                                        primaryGreen,
                                        primaryBlue,
                                      ],
                          ),
                          borderRadius:
                              BorderRadius.circular(
                                  15),
                        ),
                        child: Icon(
                          statusIcon,
                          color:
                              Colors.white,
                          size: 26,
                        ),
                      ),

                      const SizedBox(
                          width: 13),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              isSpecialStatus
                                  ? 'حالة الطالب'
                                  : 'إنجاز القرآن الكريم',
                              style:
                                  TextStyle(
                                color: Colors
                                    .grey
                                    .shade600,
                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(
                                height: 4),

                            Text(
                              isSpecialStatus
                                  ? status
                                  : 'سورة $surah',
                              maxLines: 1,
                              overflow:
                                  TextOverflow
                                      .ellipsis,
                              style:
                                  TextStyle(
                                color:
                                    isSpecialStatus
                                        ? statusColor
                                        : Colors
                                            .black87,
                                fontSize: 18,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      _buildDateBadge(
                        date,
                      ),
                    ],
                  ),

                  if (isSpecialStatus) ...[
                    const SizedBox(
                        height: 18),
                    _buildStatusDescription(
                      status: status,
                      color: statusColor,
                      icon: statusIcon,
                    ),
                  ],

                  if (!isSpecialStatus) ...[
                    const SizedBox(
                        height: 18),

                    _buildHighlightCard(
                      icon: Icons
                          .format_list_numbered_rounded,
                      iconColor:
                          primaryGreen,
                      label:
                          'نطاق التسميع',
                      value:
                          'من الآية ${data['fromAyah'] ?? '0'} إلى الآية ${data['toAyah'] ?? '0'}',
                    ),

                    const SizedBox(
                        height: 17),

                    _buildEvaluationSection(
                      grade,
                    ),
                  ],

                  if (_hasText(
                    data['tomorrowRequirement'],
                  )) ...[
                    const SizedBox(
                        height: 15),
                    _buildHighlightCard(
                      icon: Icons
                          .auto_stories_rounded,
                      iconColor:
                          primaryBlue,
                      label:
                          'المطلوب غداً',
                      value: data[
                              'tomorrowRequirement']
                          .toString(),
                    ),
                  ],

                  if (_hasText(
                    data['notes'],
                  )) ...[
                    const SizedBox(
                        height: 11),
                    _buildHighlightCard(
                      icon: Icons
                          .edit_note_rounded,
                      iconColor:
                          primaryGreen,
                      label:
                          'ملاحظة المدرس',
                      value: data['notes']
                          .toString(),
                    ),
                  ],

                  const SizedBox(
                      height: 16),

                  Container(
                    height: 1,
                    color:
                        Colors.grey.shade200,
                  ),

                  const SizedBox(
                      height: 15),

                  _buildChatSection(
                    data,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // التاريخ
  // ============================================================

  Widget _buildDateBadge(
    String date,
  ) {
    final DateTime? gregorianDate =
        DateTime.tryParse(date);

    if (gregorianDate == null) {
      return Container(
        padding:
            const EdgeInsets.symmetric(
          horizontal: 9,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color:
              Colors.grey.shade100,
          borderRadius:
              BorderRadius.circular(10),
        ),
        child: Text(
          date,
          style: TextStyle(
            color:
                Colors.grey.shade600,
            fontSize: 10,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      );
    }

    final HijriDate hijri =
        HijriDate.fromDate(
      DateTime(
        gregorianDate.year,
        gregorianDate.month,
        gregorianDate.day,
      ),
    );

    final String hijriText =
        '${_toArabicNumber(hijri.hDay)} '
        '${_getHijriMonthName(hijri.hMonth)} '
        '${_toArabicNumber(hijri.hYear)} هـ';

    final String gregorianText =
        '${_toArabicNumber(gregorianDate.day)}/'
        '${_toArabicNumber(gregorianDate.month)}/'
        '${_toArabicNumber(gregorianDate.year)} م';

    return Container(
      constraints:
          const BoxConstraints(
        minWidth: 96,
      ),
      padding:
          const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color:
            primaryGreen.withOpacity(0.07),
        borderRadius:
            BorderRadius.circular(12),
        border: Border.all(
          color:
              primaryGreen.withOpacity(0.12),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.center,
        children: [
          Text(
            hijriText,
            textAlign:
                TextAlign.center,
            style: const TextStyle(
              color: primaryGreen,
              fontSize: 10,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            gregorianText,
            textAlign:
                TextAlign.center,
            style: TextStyle(
              color:
                  Colors.grey.shade600,
              fontSize: 9,
              fontWeight:
                  FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  String _getHijriMonthName(
    int month,
  ) {
    const months = [
      'محرم',
      'صفر',
      'ربيع الأول',
      'ربيع الآخر',
      'جمادى الأولى',
      'جمادى الآخرة',
      'رجب',
      'شعبان',
      'رمضان',
      'شوال',
      'ذو القعدة',
      'ذو الحجة',
    ];

    if (month < 1 || month > 12) {
      return '';
    }

    return months[month - 1];
  }

  String _toArabicNumber(
    dynamic value,
  ) {
    return value
        .toString()
        .replaceAll('0', '٠')
        .replaceAll('1', '١')
        .replaceAll('2', '٢')
        .replaceAll('3', '٣')
        .replaceAll('4', '٤')
        .replaceAll('5', '٥')
        .replaceAll('6', '٦')
        .replaceAll('7', '٧')
        .replaceAll('8', '٨')
        .replaceAll('9', '٩');
  }

  // ============================================================
  // Evaluation
  // ============================================================

  Widget _buildEvaluationSection(
    String grade,
  ) {
    final bool memorization =
        _gradeContains(
      grade,
      'حفظ',
    );

    final bool mastery =
        _gradeContains(
      grade,
      'إتقان',
    );

    final bool tajweed =
        _gradeContains(
      grade,
      'تجويد',
    );

    final bool review =
        _gradeContains(
      grade,
      'مراجعة',
    );

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(
          icon: Icons.star_rounded,
          title: 'التقييم',
        ),

        const SizedBox(height: 10),

        Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 14,
          ),
          decoration:
              BoxDecoration(
            color:
                Colors.grey.shade50,
            borderRadius:
                BorderRadius.circular(17),
            border: Border.all(
              color:
                  Colors.grey.shade200,
            ),
          ),
          child: Row(
            children: [
              _buildEvaluationTag(
                'حفظ',
                memorization,
                Icons.menu_book_rounded,
              ),
              _buildEvaluationTag(
                'إتقان',
                mastery,
                Icons.verified_rounded,
              ),
              _buildEvaluationTag(
                'تجويد',
                tajweed,
                Icons.record_voice_over_rounded,
              ),
              _buildEvaluationTag(
                'مراجعة',
                review,
                Icons.replay_rounded,
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool _gradeContains(
    String grade,
    String value,
  ) {
    return grade
        .split('-')
        .map(
          (e) => e.trim(),
        )
        .contains(value);
  }

  // ============================================================
  // 💬 محادثة ولي الأمر مع المدير
  // ============================================================

  Widget _buildChatSection(
    Map<String, dynamic> record,
  ) {
    final String studentId =
        widget.child['id']?.toString() ?? '';

    final String parentId =
        widget.child['parentId']?.toString() ??
            widget.child['parentUid']?.toString() ??
            widget.child['guardianId']?.toString() ??
            record['parentId']?.toString() ??
            '';

    final String halaqaId =
        record['halaqaId']?.toString() ??
            widget.child['halaqaId']?.toString() ??
            '';

    if (studentId.isEmpty ||
        parentId.isEmpty) {
      return _buildParentMessageFallback(
        record,
      );
    }

    if (_adminId == null) {
      return _buildAdminLoading();
    }

    return _buildMessagesSection(
      studentId: studentId,
      parentId: parentId,
      halaqaId: halaqaId,
    );
  }

  // ============================================================
  // Messages
  // ============================================================

  Widget _buildMessagesSection({
    required String studentId,
    required String parentId,
    required String halaqaId,
  }) {
    final Stream<QuerySnapshot> stream =
        FirebaseFirestore.instance
            .collection('messages')
            .where(
              'adminId',
              isEqualTo: _adminId,
            )
            .where(
              'parentId',
              isEqualTo: parentId,
            )
            .where(
              'studentId',
              isEqualTo: studentId,
            )
            .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildChatError();
        }

        if (snapshot.connectionState ==
                ConnectionState.waiting &&
            !snapshot.hasData) {
          return _buildChatLoading();
        }

        final List<DocumentSnapshot> docs =
            snapshot.data?.docs.toList() ?? [];

        docs.sort((a, b) {
          final dataA =
              a.data()
                  as Map<String, dynamic>;

          final dataB =
              b.data()
                  as Map<String, dynamic>;

          final Timestamp? timeA =
              dataA['createdAt']
                  as Timestamp?;

          final Timestamp? timeB =
              dataB['createdAt']
                  as Timestamp?;

          if (timeA == null &&
              timeB == null) {
            return 0;
          }

          if (timeA == null) {
            return -1;
          }

          if (timeB == null) {
            return 1;
          }

          return timeA.compareTo(timeB);
        });

        return Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration:
                      BoxDecoration(
                    color: primaryBlue
                        .withOpacity(0.10),
                    borderRadius:
                        BorderRadius.circular(
                            13),
                  ),
                  child: const Icon(
                    Icons.admin_panel_settings_rounded,
                    color:
                        primaryBlue,
                    size: 22,
                  ),
                ),

                const SizedBox(
                    width: 10),

                const Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'التواصل مع الإدارة',
                        style:
                            TextStyle(
                          color:
                              Colors.black87,
                          fontSize: 15,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                          height: 3),
                      Text(
                        'رسائل ولي الأمر والمدير',
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

                if (docs.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration:
                        BoxDecoration(
                      color: primaryGreen
                          .withOpacity(
                              0.09),
                      borderRadius:
                          BorderRadius
                              .circular(10),
                    ),
                    child: Text(
                      '${docs.length}',
                      style:
                          const TextStyle(
                        color:
                            primaryGreen,
                        fontSize: 11,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(
                height: 12),

            if (docs.isEmpty)
              _buildNoMessages()
            else
              Container(
                constraints:
                    const BoxConstraints(
                  maxHeight: 360,
                ),
                child:
                    ListView.builder(
                  shrinkWrap: true,
                  physics:
                      const BouncingScrollPhysics(),
                  itemCount:
                      docs.length,
                  itemBuilder:
                      (context, index) {
                    final data =
                        docs[index].data()
                            as Map<String,
                                dynamic>;

                    return _buildMessageBubble(
                      data,
                    );
                  },
                ),
              ),

            const SizedBox(
                height: 13),

            _buildSendMessageBox(
              studentId: studentId,
              parentId: parentId,
              halaqaId: halaqaId,
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // Message Bubble
  // ============================================================

  Widget _buildMessageBubble(
    Map<String, dynamic> data,
  ) {
    final String role =
        data['senderRole']
                ?.toString() ??
            'parent';

    final bool isAdmin =
        role == 'admin';

    final String text =
        data['text']?.toString() ?? '';

    final Timestamp? createdAt =
        data['createdAt']
            as Timestamp?;

    String timeText = '';

    if (createdAt != null) {
      final date =
          createdAt.toDate();

      timeText =
          '${date.hour.toString().padLeft(2, '0')}:'
          '${date.minute.toString().padLeft(2, '0')}';
    }

    return Align(
      alignment: isAdmin
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Container(
        constraints:
            const BoxConstraints(
          maxWidth: 310,
        ),
        margin:
            const EdgeInsets.only(
          bottom: 9,
        ),
        padding:
            const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isAdmin
              ? primaryGreen
                  .withOpacity(0.09)
              : primaryBlue
                  .withOpacity(0.09),
          borderRadius:
              BorderRadius.circular(16),
          border: Border.all(
            color: isAdmin
                ? primaryGreen
                    .withOpacity(0.16)
                : primaryBlue
                    .withOpacity(0.16),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Icon(
                  isAdmin
                      ? Icons.admin_panel_settings_rounded
                      : Icons.person_rounded,
                  color: isAdmin
                      ? primaryGreen
                      : primaryBlue,
                  size: 15,
                ),

                const SizedBox(
                    width: 5),

                Text(
                  isAdmin
                      ? 'المدير'
                      : 'ولي الأمر',
                  style: TextStyle(
                    color: isAdmin
                        ? primaryGreen
                        : primaryBlue,
                    fontSize: 10,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(
                height: 6),

            Text(
              text,
              textDirection:
                  TextDirection.rtl,
              textAlign:
                  TextAlign.right,
              style:
                  const TextStyle(
                color:
                    Colors.black87,
                fontSize: 13,
                height: 1.5,
              ),
            ),

            if (timeText.isNotEmpty) ...[
              const SizedBox(
                  height: 5),
              Text(
                timeText,
                style: TextStyle(
                  color:
                      Colors.grey.shade500,
                  fontSize: 9,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ============================================================
  // Send Message Box
  // ============================================================
Widget _buildSendMessageBox({
  required String studentId,
  required String parentId,
  required String halaqaId,
}) {
  return Container(
    padding: const EdgeInsets.all(11),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: Colors.grey.shade200,
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: TextField(
            controller: _parentMessageController,

            maxLines: 3,
            minLines: 1,

            textDirection: TextDirection.rtl,
            textAlign: TextAlign.right,

            // =====================================================
            // لون وحجم النص الذي يكتبه ولي الأمر
            // =====================================================
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),

            decoration: InputDecoration(
              hintText: 'اكتب رسالة للإدارة...',
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 12,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
          ),
        ),

        const SizedBox(width: 8),

        Container(
          width: 45,
          height: 45,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                primaryGreen,
                primaryBlue,
              ],
            ),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed: _sendingMessage
                ? null
                : () {
                    _sendMessage(
                      studentId: studentId,
                      parentId: parentId,
                      halaqaId: halaqaId,
                    );
                  },
            icon: _sendingMessage
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
          ),
        ),
      ],
    ),
  );
}

  // ============================================================
  // إرسال ولي الأمر -> المدير
  // ============================================================

  Future<void> _sendMessage({
    required String studentId,
    required String parentId,
    required String halaqaId,
  }) async {
    final String text =
        _parentMessageController
            .text
            .trim();

    if (text.isEmpty) {
      return;
    }

    if (_adminId == null) {
      await _loadAdmin();

      if (_adminId == null) {
        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'تعذر العثور على حساب المدير.',
            ),
            backgroundColor:
                Colors.redAccent,
          ),
        );

        return;
      }
    }

    setState(() {
      _sendingMessage = true;
    });

    try {
      final String studentName =
          widget.child['name']
                  ?.toString() ??
              'الطالب';

      final String parentName =
          widget.child['parentName']
                  ?.toString() ??
              widget.child['guardianName']
                  ?.toString() ??
              'ولي الأمر';

      final String halaqaName =
          widget.child['halaqaName']
                  ?.toString() ??
              '';

      final String currentParentId =
          parentId;

      final String conversationId =
          '${currentParentId}_$studentId';

      await FirebaseFirestore
          .instance
          .collection('messages')
          .add({
        // =====================================================
        // المحادثة
        // =====================================================

        'conversationId':
            conversationId,

        // =====================================================
        // الطالب
        // =====================================================

        'studentId':
            studentId,

        'studentName':
            studentName,

        // =====================================================
        // ولي الأمر
        // =====================================================

        'parentId':
            currentParentId,

        'parentName':
            parentName,

        // =====================================================
        // الحلقة
        // =====================================================

        'halaqaId':
            halaqaId,

        'halaqaName':
            halaqaName,

        // =====================================================
        // المدير
        // =====================================================

        'adminId':
            _adminId,

        // =====================================================
        // المرسل والمستقبل
        // =====================================================

        'senderId':
            currentParentId,

        'senderRole':
            'parent',

        'receiverId':
            _adminId,

        'receiverRole':
            'admin',

        // =====================================================
        // الرسالة
        // =====================================================

        'text':
            text,

        // =====================================================
        // الوقت
        // =====================================================

        'createdAt':
            FieldValue.serverTimestamp(),

        'updatedAt':
            FieldValue.serverTimestamp(),
      });

      _parentMessageController.clear();

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'تم إرسال الرسالة إلى الإدارة.',
          ),
          backgroundColor:
              primaryGreen,
          behavior:
              SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'تعذر إرسال الرسالة: $e',
          ),
          backgroundColor:
              Colors.redAccent,
          behavior:
              SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _sendingMessage = false;
        });
      }
    }
  }

  // ============================================================
  // Fallback
  // ============================================================

  Widget _buildParentMessageFallback(
    Map<String, dynamic> record,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:
            primaryBlue.withOpacity(0.05),
        borderRadius:
            BorderRadius.circular(16),
      ),
      child: const Text(
        'التواصل مع الإدارة غير متاح حالياً لعدم اكتمال ربط الطالب بولي الأمر.',
        textAlign:
            TextAlign.center,
        style: TextStyle(
          color: Colors.black54,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildNoMessages() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color:
            Colors.grey.shade50,
        borderRadius:
            BorderRadius.circular(15),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.chat_bubble_outline_rounded,
            color: Colors.grey,
            size: 30,
          ),
          SizedBox(height: 7),
          Text(
            'لا توجد رسائل بعد',
            style: TextStyle(
              color: Colors.black54,
              fontSize: 12,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatLoading() {
    return const Center(
      child: Padding(
        padding:
            EdgeInsets.all(15),
        child: SizedBox(
          width: 20,
          height: 20,
          child:
              CircularProgressIndicator(
            strokeWidth: 2,
            color: primaryBlue,
          ),
        ),
      ),
    );
  }

  Widget _buildAdminLoading() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color:
            primaryBlue.withOpacity(0.05),
        borderRadius:
            BorderRadius.circular(16),
      ),
      child: const Row(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child:
                CircularProgressIndicator(
              strokeWidth: 2,
              color:
                  primaryBlue,
            ),
          ),
          SizedBox(width: 10),
          Text(
            'جاري الاتصال بالإدارة...',
            style: TextStyle(
              fontSize: 12,
              color:
                  Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatError() {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:
            Colors.red.withOpacity(0.05),
        borderRadius:
            BorderRadius.circular(14),
      ),
      child: const Text(
        'تعذر تحميل المحادثة.',
        textAlign:
            TextAlign.center,
        style: TextStyle(
          color: Colors.red,
          fontSize: 12,
        ),
      ),
    );
  }

  // ============================================================
  // Status
  // ============================================================

  Widget _buildStatusDescription({
    required String status,
    required Color color,
    required IconData icon,
  }) {
    String description;

    switch (status) {
      case 'غائب':
        description =
            'لم يحضر الطالب إلى الحلقة في هذا اليوم.';
        break;

      case 'إجازة':
        description =
            'الطالب في إجازة ولا يوجد إنجاز مسجل لهذا اليوم.';
        break;

      case 'مستأذن':
        description =
            'الطالب مستأذن لهذا اليوم بعذر مسجل.';
        break;

      case 'مراجعة':
        description =
            'تم تخصيص هذا اليوم لمراجعة المحفوظ السابق.';
        break;

      default:
        description =
            'تم تسجيل حالة خاصة للطالب.';
    }

    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color:
            color.withOpacity(0.07),
        borderRadius:
            BorderRadius.circular(17),
        border: Border.all(
          color:
              color.withOpacity(0.16),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration:
                BoxDecoration(
              color:
                  color.withOpacity(0.12),
              shape:
                  BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
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
                  status,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                    height: 5),

                Text(
                  description,
                  style:
                      const TextStyle(
                    color:
                        Colors.black87,
                    fontSize: 13,
                    height: 1.5,
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
          style:
              const TextStyle(
            color: Colors.black87,
            fontSize: 14,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // Highlight
  // ============================================================

  Widget _buildHighlightCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color:
            iconColor.withOpacity(0.07),
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color:
              iconColor.withOpacity(0.18),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration:
                BoxDecoration(
              color:
                  iconColor.withOpacity(
                      0.13),
              borderRadius:
                  BorderRadius.circular(12),
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
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                    height: 5),

                Text(
                  value,
                  style:
                      const TextStyle(
                    color:
                        Colors.black87,
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
    IconData icon,
  ) {
    final Color color =
        isDone
            ? primaryGreen
            : Colors.grey;

    return Expanded(
      child: Column(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration:
                BoxDecoration(
              color: isDone
                  ? primaryGreen
                      .withOpacity(0.10)
                  : Colors.grey
                      .withOpacity(0.08),
              shape:
                  BoxShape.circle,
            ),
            child: Icon(
              isDone
                  ? icon
                  : Icons.remove_rounded,
              color: color,
              size: 19,
            ),
          ),

          const SizedBox(
              height: 6),

          Text(
            title,
            textAlign:
                TextAlign.center,
            style: TextStyle(
              color: isDone
                  ? Colors.black87
                  : Colors.grey,
              fontSize: 11,
              fontWeight: isDone
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),

          const SizedBox(
              height: 2),

          Text(
            isDone
                ? 'ممتاز'
                : 'لم يسجل',
            style: TextStyle(
              color: isDone
                  ? primaryGreen
                  : Colors.grey.shade400,
              fontSize: 8,
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
      child:
          CircularProgressIndicator(
        color: Colors.white,
        strokeWidth: 3,
      ),
    );
  }

  // ============================================================
  // Empty
  // ============================================================

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(30),
        child: Container(
          width: double.infinity,
          padding:
              const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withOpacity(0.08),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [
              Container(
                width: 75,
                height: 75,
                decoration:
                    BoxDecoration(
                  gradient:
                      LinearGradient(
                    colors: [
                      primaryGreen
                          .withOpacity(
                              0.12),
                      primaryBlue
                          .withOpacity(
                              0.12),
                    ],
                  ),
                  shape:
                      BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color:
                      primaryGreen,
                  size: 38,
                ),
              ),

              const SizedBox(
                  height: 18),

              Text(
                title,
                textAlign:
                    TextAlign.center,
                style:
                    const TextStyle(
                  color:
                      Colors.black87,
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(
                  height: 8),

              Text(
                subtitle,
                textAlign:
                    TextAlign.center,
                style: TextStyle(
                  color:
                      Colors.grey.shade600,
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

  Widget _buildErrorState() {
    return _buildEmptyState(
      icon:
          Icons.person_off_rounded,
      title:
          'تعذر العثور على الطالب',
      subtitle:
          'لم يتم العثور على معرف الطالب المطلوب.',
    );
  }

  bool _hasText(dynamic value) {
    return value != null &&
        value.toString().trim().isNotEmpty &&
        value.toString().trim() !=
            'لا يوجد';
  }
}
