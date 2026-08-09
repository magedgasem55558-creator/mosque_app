import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DonateScreen extends StatelessWidget {
  const DonateScreen({super.key});

  // ============================================================
  // ألوان التطبيق الرسمية
  // ============================================================

  static const Color darkGreen = Color(0xFF2E7D32);
  static const Color blue = Color(0xFF42A5F5);
  static const Color lightBackground = Color(0xFFF5F5F5);

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
              darkGreen,
              blue,
              lightBackground,
            ],
            stops: [
              0.0,
              0.43,
              1.0,
            ],
          ),
        ),
        child: SafeArea(
          child: FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('settings')
                .doc('donation_info')
                .get(),
            builder: (context, snapshot) {
              String bankName = 'بنك الكريمي';
              String accountNumber =
                  'يمني 3155105932 - سعودي 3173113918';
              String transferName =
                  'عبر الكريمي - حامد المزجاجي';
              String phone = '779626069';

              String hadith =
                  'قال رسول الله ﷺ:\n'
                  '«مَنْ بَنَى مَسْجِدًا بَنَى اللَّهُ لَهُ '
                  'مِثْلَهُ فِي الْجَنَّةِ»';

              if (snapshot.hasData && snapshot.data!.exists) {
                final rawData = snapshot.data!.data();

                if (rawData is Map<String, dynamic>) {
                  bankName = rawData['bankName'] ?? bankName;
                  accountNumber =
                      rawData['accountNumber'] ?? accountNumber;
                  transferName =
                      rawData['transferName'] ?? transferName;
                  phone = rawData['phone'] ?? phone;
                  hadith = rawData['hadith'] ?? hadith;
                }
              }

              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          18,
                          14,
                          18,
                          30,
                        ),
                        child: Column(
                          children: [
                            // ==================================================
                            // العنوان
                            // ==================================================

                            _buildHeader(),

                            const SizedBox(height: 20),

                            // ==================================================
                            // البطاقة الرئيسية
                            // ==================================================

                            _buildDonationHero(),

                            const SizedBox(height: 18),

                            // ==================================================
                            // الحديث
                            // ==================================================

                            _buildHadithCard(hadith),

                            const SizedBox(height: 22),

                            // ==================================================
                            // عنوان طرق التبرع
                            // ==================================================

                            _buildSectionTitle(
                              icon: Icons.account_balance_wallet_rounded,
                              title: 'طرق التبرع',
                              subtitle:
                                  'اختر طريقة التحويل المناسبة لك',
                            ),

                            const SizedBox(height: 12),

                            // ==================================================
                            // البنك
                            // ==================================================

                            _buildDonationMethod(
                              context,
                              title: bankName,
                              subtitle: 'الحساب البنكي',
                              detail: accountNumber,
                              icon: Icons.account_balance_rounded,
                              color: darkGreen,
                            ),

                            const SizedBox(height: 12),

                            // ==================================================
                            // الحوالات
                            // ==================================================

                            _buildDonationMethod(
                              context,
                              title: 'الموحدة للحوالات',
                              subtitle: 'بيانات التحويل',
                              detail: transferName,
                              icon: Icons.swap_horiz_rounded,
                              color: blue,
                            ),

                            const SizedBox(height: 22),

                            // ==================================================
                            // تنبيه
                            // ==================================================

                            _buildImportantNotice(),

                            const SizedBox(height: 18),

                            // ==================================================
                            // التواصل
                            // ==================================================

                            _buildContactCard(
                              context,
                              phone,
                            ),

                            const SizedBox(height: 18),

                            // ==================================================
                            // دعاء
                            // ==================================================

                            _buildBottomMessage(),

                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Header
  // ============================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  darkGreen,
                  blue,
                ],
              ),
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: darkGreen.withOpacity(0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.volunteer_activism_rounded,
              color: Colors.white,
              size: 27,
            ),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ساهم في بناء الخير',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'صدقة جارية وأجر مستمر بإذن الله',
                  style: TextStyle(
                    color: Colors.black54,
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

  // ============================================================
  // Hero
  // ============================================================

  Widget _buildDonationHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        22,
        24,
        22,
        22,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF1B5E20),
            darkGreen,
            blue,
          ],
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: darkGreen.withOpacity(0.30),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // الدائرة
          Container(
            width: 82,
            height: 82,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.16),
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.35),
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.mosque_rounded,
              color: Colors.white,
              size: 45,
            ),
          ),

          const SizedBox(height: 16),

          const Text(
            'ساهم معنا في خدمة بيت الله',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'تبرعك مهما كان بسيطًا قد يكون سببًا في '
            'استمرار الخير ونفع المسلمين.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.90),
              fontSize: 14,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 18),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 9,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withOpacity(0.25),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.favorite_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                SizedBox(width: 7),
                Text(
                  'جزاكم الله خيرًا',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
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
  // Hadith Card
  // ============================================================

  Widget _buildHadithCard(String hadith) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: darkGreen.withOpacity(0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: darkGreen.withOpacity(0.09),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.format_quote_rounded,
              color: darkGreen,
              size: 28,
            ),
          ),

          const SizedBox(height: 12),

          const Text(
            'فضل بناء المساجد',
            style: TextStyle(
              color: darkGreen,
              fontSize: 14,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            hadith,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
              height: 1.8,
              fontWeight: FontWeight.w600,
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
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 43,
          height: 43,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.95),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Icon(
            icon,
            color: darkGreen,
            size: 24,
          ),
        ),

        const SizedBox(width: 11),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ============================================================
  // Donation Method
  // ============================================================

  Widget _buildDonationMethod(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String detail,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: color.withOpacity(0.14),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 13,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // الأيقونة
          Container(
            width: 53,
            height: 53,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.18),
                  color.withOpacity(0.07),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),

          const SizedBox(width: 13),

          // البيانات
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.black45,
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  detail,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    height: 1.45,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 5),

          // زر النسخ
          Material(
            color: color.withOpacity(0.10),
            borderRadius: BorderRadius.circular(13),
            child: InkWell(
              borderRadius: BorderRadius.circular(13),
              onTap: () {
                Clipboard.setData(
                  ClipboardData(text: detail),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'تم نسخ بيانات التحويل',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: darkGreen,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    margin: const EdgeInsets.all(16),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(11),
                child: Icon(
                  Icons.copy_rounded,
                  color: color,
                  size: 21,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Important Notice
  // ============================================================

  Widget _buildImportantNotice() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.amber.shade200,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.info_outline_rounded,
              color: Colors.amber.shade800,
              size: 21,
            ),
          ),

          const SizedBox(width: 11),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تنبيه',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'يرجى التأكد من بيانات التحويل قبل إرسال المبلغ، '
                  'والاحتفاظ بإيصال التحويل عند الحاجة.',
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
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
  // Contact
  // ============================================================

  Widget _buildContactCard(
    BuildContext context,
    String phone,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 14,
            offset: const Offset(0, 5),
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
                  blue,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.phone_in_talk_rounded,
              color: Colors.white,
              size: 25,
            ),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'للاستفسار والتواصل',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'لجنة المسجد • $phone',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          Material(
            color: darkGreen.withOpacity(0.10),
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Clipboard.setData(
                  ClipboardData(text: phone),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'تم نسخ رقم التواصل',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: darkGreen,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.copy_rounded,
                  color: darkGreen,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Bottom Message
  // ============================================================

  Widget _buildBottomMessage() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.30),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_rounded,
            color: Colors.white,
            size: 18,
          ),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              'تقبل الله منكم وجعلها صدقة جارية',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
