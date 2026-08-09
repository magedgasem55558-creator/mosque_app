import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white, // خلفية بيضاء كما في الصورة
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'الطلاب المتصدرون لهذا اليوم',
                style: TextStyle(
                  color: Color(0xFF1a237e), // أزرق غامق
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('students')
                      .orderBy('totalPoints', descending: true)
                      .limit(3)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final students = snapshot.data!.docs;
                    if (students.isEmpty) {
                      return const Center(child: Text('لا يوجد بيانات'));
                    }

                    // ترتيب المراكز (0: المركز الأول، 1: الثاني، 2: الثالث)
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end, // لمحاكاة المنصة
                      children: [
                        // المركز الثاني
                        if (students.length > 1) _buildPodiumItem(students[1], 2, Colors.pinkAccent, 140),
                        // المركز الأول (في المنتصف)
                        _buildPodiumItem(students[0], 1, Colors.amber.shade700, 180),
                        // المركز الثالث
                        if (students.length > 2) _buildPodiumItem(students[2], 3, Colors.cyan, 120),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPodiumItem(QueryDocumentSnapshot doc, int rank, Color color, double height) {
    final data = doc.data() as Map<String, dynamic>;
    final name = data['name'] ?? 'طالب';
    final points = data['totalPoints'] ?? 0;

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // الدائرة الملونة
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
            ),
            alignment: Alignment.center,
            child: Text(
              '$rank',
              style: const TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          // الاسم
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          // النقاط
          Text(
            '$points نقطة',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 20),
          // قاعدة المنصة
          Container(
            height: height,
            color: color.withOpacity(0.3),
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}
