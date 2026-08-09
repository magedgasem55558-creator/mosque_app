import 'dart:ui';
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
        appBar: AppBar(
          title: Text("متابعة ${child['name'] ?? 'الطالب'}",
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          bottom: const TabBar(
            indicatorColor: Colors.tealAccent,
            labelColor: Colors.tealAccent,
            unselectedLabelColor: Colors.white60,
            tabs: [
              Tab(text: "إنجاز اليوم", icon: Icon(Icons.today)),
              Tab(text: "أعمال الشهر", icon: Icon(Icons.calendar_month)),
            ],
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage('https://images.unsplash.com/photo-1542834759-429337586071?q=80&w=2070'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(color: Colors.black.withOpacity(0.7)),
            ),
            if (studentId.isEmpty)
              const Center(child: Text("خطأ في معرف الطالب", style: TextStyle(color: Colors.red)))
            else
              TabBarView(
                children: [
                  _buildDailyReport(studentId),
                  _buildMonthlyReport(studentId),
                ],
              ),
          ],
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
          return const Center(child: CircularProgressIndicator(color: Colors.tealAccent));
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text("لا يوجد إنجاز مسجل لتاريخ اليوم\n($today)",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white60, fontSize: 16)),
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
          return const Center(child: CircularProgressIndicator(color: Colors.tealAccent));
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
              child: Text("لا توجد سجلات سابقة", style: TextStyle(color: Colors.white60)));
        }
        List<DocumentSnapshot> docs = snapshot.data!.docs;
        docs.sort((a, b) => (b.get('date') ?? "").compareTo(a.get('date') ?? ""));
        return _buildRecordList(docs);
      },
    );
  }

  Widget _buildRecordList(List<DocumentSnapshot> docs) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 180, left: 20, right: 20, bottom: 20),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final data = docs[index].data() as Map<String, dynamic>;
        String status = data['status'] ?? "حاضر";
        bool isSpecialStatus = status == "غائب" || status == "إجازة";
        String gradeText = data['grade'] ?? "";

        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            color: status == "غائب"
                ? Colors.red.withOpacity(0.15)
                : status == "إجازة"
                    ? Colors.blue.withOpacity(0.15)
                    : Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            children: [
              ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                title: Text(
                  isSpecialStatus ? "الحالة: $status" : "سورة ${data['surah'] ?? 'غير محددة'}",
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: isSpecialStatus
                    ? null
                    : Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                            "من آية ${data['fromAyah'] ?? '0'} إلى ${data['toAyah'] ?? '0'}",
                            style: const TextStyle(color: Colors.white60)),
                      ),
                trailing:
                    Text(data['date'] ?? "", style: const TextStyle(color: Colors.white38, fontSize: 11)),
              ),

              // تقييم الأب
              if (!isSpecialStatus)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black26,
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
                ),

              // المطلوب غداً - بتصميم فاخر
              if (data['tomorrowRequirement'] != null && data['tomorrowRequirement'].toString().trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                  child: _buildHighlightCard(
                    icon: Icons.auto_stories,
                    iconColor: Colors.amberAccent,
                    label: "المطلوب غداً",
                    value: data['tomorrowRequirement'],
                    bgColor: Colors.amberAccent.withOpacity(0.08),
                    borderColor: Colors.amberAccent.withOpacity(0.25),
                  ),
                ),

              // ملاحظة المدرس - بنفس التصميم
              if (data['notes'] != null && data['notes'].toString().trim().isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                  child: _buildHighlightCard(
                    icon: Icons.edit_note,
                    iconColor: Colors.tealAccent,
                    label: "ملاحظة المدرس",
                    value: data['notes'],
                    bgColor: Colors.tealAccent.withOpacity(0.08),
                    borderColor: Colors.tealAccent.withOpacity(0.25),
                  ),
                ),

              const Divider(color: Colors.white10, height: 1),

              // زر واتساب
              TextButton.icon(
                onPressed: () => _openWhatsApp(context, data['teacherPhone'] ?? "967770000000",
                    data['surah'] ?? "التسميع"),
                icon: const Icon(Icons.chat_bubble_outline, color: Colors.greenAccent, size: 20),
                label: const Text("تواصل مع المدرس",
                    style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 5),
            ],
          ),
        );
      },
    );
  }

  // ويدجت موحد لبطاقات المطلوب والملاحظة
  Widget _buildHighlightCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required Color bgColor,
    required Color borderColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      padding: const EdgeInsets.all(15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 14),
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
                const SizedBox(height: 6),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
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
          color: isDone ? Colors.greenAccent : Colors.redAccent.withOpacity(0.4),
          size: 18,
        ),
        const SizedBox(width: 6),
        Text(
          title,
          style: TextStyle(
            color: isDone ? Colors.white : Colors.white38,
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

    final message = "السلام عليكم.. أستفسر عن مستوى ابني في حلقة القرآن ($subject)";
    final url = Uri.parse("https://wa.me/$cleanPhone?text=${Uri.encodeComponent(message)}");

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