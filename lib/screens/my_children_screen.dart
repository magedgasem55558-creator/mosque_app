import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firebase_service.dart';
import 'child_details_screen.dart';

class MyChildrenScreen extends StatefulWidget {
  const MyChildrenScreen({super.key});

  @override
  State<MyChildrenScreen> createState() => _MyChildrenScreenState();
}

class _MyChildrenScreenState extends State<MyChildrenScreen> {
  final service = FirebaseService();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Scaffold(body: Center(child: Text("يرجى تسجيل الدخول")));

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        // نفس التدرج الرسمي
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
          child: Column(
            children: [
              // شريط عنوان مخصص مع زر تسجيل الخروج
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black87),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          "أبنائي في المسجد",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.redAccent),
                        onPressed: () => FirebaseAuth.instance.signOut(),
                      ),
                    ],
                  ),
                ),
              ),

              // قائمة الأبناء
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: service.streamMyChildren(user.uid),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.teal));
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("خطأ: ${snapshot.error}",
                            style: const TextStyle(color: Colors.red)),
                      );
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text("لا يوجد أبناء مسجلين",
                            style: TextStyle(color: Colors.black54, fontSize: 16)),
                      );
                    }
                    final children = snapshot.data!;
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      itemCount: children.length,
                      itemBuilder: (context, index) {
                        return _buildChildCard(context, children[index]);
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

  // --- بناء بطاقة الطفل ---
  Widget _buildChildCard(BuildContext context, Map<String, dynamic> child) {
    dynamic halaqaField = child['halaqaId'];
    String? halaqaId;
    if (halaqaField is DocumentReference) {
      halaqaId = halaqaField.id;
    } else if (halaqaField is String) {
      halaqaId = halaqaField;
    }

    if (halaqaId == null || halaqaId.isEmpty) {
      return _buildCardLayout(child, 'غير محددة');
    }

    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('halaqat').doc(halaqaId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildCardLayout(child, 'جاري التحميل...');
        }
        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          return _buildCardLayout(child, 'حلقة غير معروفة');
        }
        final halaqaData = snapshot.data!.data() as Map<String, dynamic>;
        final halaqaName = halaqaData['name'] as String? ?? 'غير محدد';
        return _buildCardLayout(child, halaqaName);
      },
    );
  }

  // --- تنسيق البطاقة بشكل موحد ---
  Widget _buildCardLayout(Map<String, dynamic> child, String halaqaName) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChildDetailsScreen(child: child),
            ),
          );
        },
        child: Row(
          children: [
            // أيقونة الطفل
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.teal.withOpacity(0.15),
              child: Text(
                (child['name'] != null && child['name'].isNotEmpty)
                    ? child['name']![0].toUpperCase()
                    : "?",
                style: const TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // بيانات الطفل
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    child['name'] ?? "اسم غير معروف",
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber.shade700, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        "${child['totalPoints'] ?? 0} نقطة",
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.grid_view_rounded, color: Colors.grey.shade600, size: 16),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "الحلقة: $halaqaName",
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "انضم: ${child['joinDate'] != null ? (child['joinDate'] as Timestamp).toDate().toString().split(' ')[0] : 'غير معروف'}",
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: child['isActive'] == true
                              ? Colors.green.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          child['isActive'] == true ? "نشط" : "متوقف",
                          style: TextStyle(
                            color: child['isActive'] == true
                                ? Colors.green.shade700
                                : Colors.red.shade700,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
          ],
        ),
      ),
    );
  }
}
