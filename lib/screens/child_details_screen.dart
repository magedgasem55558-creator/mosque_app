import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class ChildDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> child;

  const ChildDetailsScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final String studentId = child['id'] ?? "";

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        // شريط علوي مخصص مع TabBar
        appBar: AppBar(
          title: Text(
            "متابعة ${child['name'] ?? 'الطالب'}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.black26,
          iconTheme: const IconThemeData(color: Colors.black87),
          bottom: TabBar(
            indicatorColor: Colors.teal,
            labelColor: Colors.teal,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: "إنجاز اليوم", icon: Icon(Icons.today)),
              Tab(text: "أعمال الشهر", icon: Icon(Icons.calendar_month)),
            ],
          ),
        ),
        body: Container(
          // الخلفية الرسمية
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
            child: studentId.isEmpty
                ? const Center(
                    child: Text("خطأ في معرف الطالب",
                        style: TextStyle(color: Colors.red)))
                : TabBarView(
                    children: [
                      _buildDailyReport(studentId),
                      _buildMonthlyReport(studentId),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildDailyReport(String studentId) {
    final String today = DateTime.now().toIso8601String().split('T')[0];
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('records')
          .where('studentId', isEqualTo: studentId)
          .where('date', isEqualTo: today)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator(color: Colors.teal));
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text("لا يوجد إنجاز مسجل لتاريخ اليوم\n($today)",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black54, fontSize: 16)),
          );
        }
        return _buildRecordList(snapshot.data!.docs);
      },
    );
  }

  Widget _buildMonthlyReport(String studentId) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('records')
          .where('studentId', isEqualTo: studentId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return const Center(child: CircularProgressIndicator(color: Colors.teal));
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
              child: Text("لا توجد سجلات سابقة",
                  style: TextStyle(color: Colors.black54)));
        }
        List<DocumentSnapshot> docs = snapshot.data!.docs;
        docs.sort(
            (a, b) => (b.get('date') ?? "").compareTo(a.get('date') ?? ""));
        return _buildRecordList(docs);
      },
    );
  }

  Widget _buildRecordList(List<DocumentSnapshot> docs) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final data = docs[index].data() as Map<String, dynamic>;
        String status = data['status'] ?? "حاضر";
        bool isSpecialStatus = status == "غائب" || status == "إجازة";
        String gradeText = data['grade'] ?? "";

        // تحديد لون البطاقة بناءً على الحالة
        Color cardColor;
        Color borderColor;
        if (status == "غائب") {
          cardColor = Colors.red.shade50;
          borderColor = Colors.red.shade200;
        } else if (status == "إجازة") {
          cardColor = Colors.blue.shade50;
          borderColor = Colors.blue.shade200;
        } else {
          cardColor = Colors.white;
          borderColor = Colors.grey.shade300;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 6,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العنوان والتاريخ
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      isSpecialStatus
                          ? "الحالة: $status"
                          : "سورة ${data['surah'] ?? 'غير محددة'}",
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  Text(
                    data['date'] ?? "",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
              if (!isSpecialStatus) ...[
                const SizedBox(height: 6),
                Text(
                  "من آية ${data['fromAyah'] ?? '0'} إلى ${data['toAyah'] ?? '0'}",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],

              // تقييم الأب
              if (!isSpecialStatus) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildEvaluationTag("إتقان", gradeText.contains("إتقان")),
                      _buildEvaluationTag("حفظ", gradeText.contains("حفظ")),
                      _buildEvaluationTag("تجويد", gradeText.contains("تجويد")),
                    ],
                  ),
                ),
              ],

              // المطلوب غداً
              if (data['tomorrowRequirement'] != null &&
                  data['tomorrowRequirement'].toString().trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: _buildHighlightCard(
                    icon: Icons.auto_stories,
                    iconColor: Colors.teal,
                    label: "المطلوب غداً",
                    value: data['tomorrowRequirement'],
                  ),
                ),

              // ملاحظة المدرس
              if (data['notes'] != null &&
                  data['notes'].toString().trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: _buildHighlightCard(
                    icon: Icons.edit_note,
                    iconColor: Colors.teal,
                    label: "ملاحظة المدرس",
                    value: data['notes'],
                  ),
                ),

              const SizedBox(height: 12),
              const Divider(color: Colors.grey),
              const SizedBox(height: 4),

              // زر واتساب
              Center(
                child: TextButton.icon(
                  onPressed: () => _openWhatsApp(
                    context,
                    data['teacherPhone'] ?? "967770000000",
                    data['surah'] ?? "التسميع",
                  ),
                  icon: const Icon(Icons.chat_bubble_outline, color: Colors.teal, size: 20),
                  label: const Text("تواصل مع المدرس",
                      style: TextStyle(
                          color: Colors.teal, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // بطاقة مميزة للملاحظات والمطلوب
  Widget _buildHighlightCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: iconColor.withOpacity(0.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: iconColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
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

  Widget _buildEvaluationTag(String title, bool isDone) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isDone ? Icons.check_circle : Icons.cancel,
          color: isDone ? Colors.green : Colors.red.shade300,
          size: 18,
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            color: isDone ? Colors.black87 : Colors.grey,
            fontSize: 13,
            fontWeight: isDone ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  void _openWhatsApp(BuildContext context, String phone, String subject) async {
    String cleanPhone = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanPhone.startsWith('00')) {
      cleanPhone = cleanPhone.substring(2);
    } else if (cleanPhone.startsWith('+')) {
      cleanPhone = cleanPhone.substring(1);
    }
    if (cleanPhone.startsWith('0') && cleanPhone.length > 10) {
      cleanPhone = cleanPhone.substring(1);
    }

    final message =
        "السلام عليكم.. أستفسر عن مستوى ابني في حلقة القرآن ($subject)";
    final url = Uri.parse(
        "https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}");

    try {
      final canLaunch = await canLaunchUrl(url);
      if (canLaunch) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("تعذر فتح واتساب."),
              backgroundColor: Colors.redAccent,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("حدث خطأ: $e"),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
}
