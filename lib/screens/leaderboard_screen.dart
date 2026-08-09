import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        // نفس التدرج الرسمي: أخضر ← أزرق ← رمادي فاتح
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2E7D32), // أخضر غامق (أعلى)
              Color(0xFF42A5F5), // أزرق متوسط
              Color(0xFFF5F5F5), // رمادي فاتح جداً (أسفل)
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // شريط عنوان شفاف (اختياري)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'لوحة المتصدرين',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('students')
                      .orderBy('totalPoints', descending: true)
                      .limit(3) // عرض أول ٣ فقط
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator(color: Colors.teal));
                    }
                    final students = snapshot.data!.docs;
                    if (students.isEmpty) {
                      return const Center(
                        child: Text('لا يوجد طلاب بعد', style: TextStyle(color: Colors.black54, fontSize: 16)),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final data = students[index].data() as Map<String, dynamic>;
                        final rank = index + 1;
                        final name = data['name'] ?? 'طالب';
                        final points = data['totalPoints'] ?? 0;
                        return _buildLeaderCard(rank, name, points);
                      },
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

  Widget _buildLeaderCard(int rank, String name, int points) {
    // ألوان مميزة حسب المركز
    Color medalColor;
    IconData medalIcon;
    switch (rank) {
      case 1:
        medalColor = Colors.amber;
        medalIcon = Icons.emoji_events;
        break;
      case 2:
        medalColor = Colors.grey.shade400;
        medalIcon = Icons.emoji_events;
        break;
      case 3:
        medalColor = Colors.brown.shade300;
        medalIcon = Icons.emoji_events;
        break;
      default:
        medalColor = Colors.teal;
        medalIcon = Icons.star;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: medalColor.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: medalColor.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: medalColor.withOpacity(0.1),
            child: Icon(medalIcon, color: medalColor, size: 30),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'المركز $rank',
                  style: TextStyle(
                    color: medalColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$points نقطة',
            style: TextStyle(
              color: Colors.teal.shade700,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
