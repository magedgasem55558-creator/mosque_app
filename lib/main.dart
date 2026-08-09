import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/data/latest_all.dart' as tz; // 👈 استيراد تهيئة التوقيت
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. تهيئة المناطق الزمنية الضرورية لجدولة الإشعارات
  tz.initializeTimeZones();

  // 2. تهيئة Firebase تلقائياً اعتماداً على ملف google-services.json لنظام الأندرويد
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('خطأ في تهيئة Firebase: $e');
  }

  // طلب إذن الإشعارات
  try {
    await FirebaseMessaging.instance.requestPermission();
  } catch (e) {
    debugPrint('لم يتم منح إذن الإشعارات: $e');
  }

  runApp(const MosqueApp());
}

class MosqueApp extends StatefulWidget {
  const MosqueApp({super.key});

  @override
  State<MosqueApp> createState() => _MosqueAppState();
}

class _MosqueAppState extends State<MosqueApp> {
  @override
  void initState() {
    super.initState();
    // نبدأ الإشعارات والأذكار بعد أن يصبح التطبيق جاهزاً
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initNotifications();
    });
  }

  Future<void> _initNotifications() async {
    try {
      await NotificationService.init();
      await NotificationService.scheduleDhikr();
    } catch (e) {
      debugPrint('تحذير: فشلت بعض إعدادات الإشعارات: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'مسجدنا الذكي',
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.tealAccent,
        fontFamily: 'Cairo',
        appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator(color: Colors.tealAccent)),
            );
          }

          // تفعيل أو إيقاف إشعارات الأبناء
          if (snapshot.hasData) {
            final user = snapshot.data!;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              NotificationService.startListeningToChildrenGrades(user.uid);
            });
          } else {
            NotificationService.stopListeningToChildrenGrades();
          }

          return const HomeScreen();
        },
      ),
      routes: {'/login': (context) => const LoginScreen()},
    );
  }
}
