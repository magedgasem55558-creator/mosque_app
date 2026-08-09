import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MosqueApp());
}

class MosqueApp extends StatelessWidget {
  const MosqueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مسجدنا الذكي',
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            'التطبيق يعمل على Android',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ),
      ),
    );
  }
}
