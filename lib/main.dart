import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/notification_service.dart';

// 1. معالج الخلفية لإشعارات FCM (يجب أن يكون دائماً Top-Level Function)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  NotificationService.showLocalNotificationFromMessage(message);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة المنطقة الزمنية
  tz.initializeTimeZones();

  // تهيئة Firebase والمعالج في الخلفية
  try {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    debugPrint('خطأ في تهيئة Firebase: $e');
  }

  runApp(const MosqueApp());
}

class MosqueApp extends StatefulWidget {
  const MosqueApp({super.key});

  @override
  State<MosqueApp> createState() => _MosqueAppState();
}

class _MosqueAppState extends State<MosqueApp> {
  String? _activeUserId;

  @override
  void initState() {
    super.initState();
    _setupNotifications();
  }

  Future<void> _setupNotifications() async {
    try {
      await FirebaseMessaging.instance.requestPermission();
      await NotificationService.init();
      await NotificationService.scheduleDhikr();
    } catch (e) {
      debugPrint('تحذير: فشلت تهيئة الإشعارات: $e');
    }
  }

  // إدارة الاستماع لدرجات الأبناء لمنع إعادة التسجيل عند كل Build
  void _syncChildrenGradesListener(User? user) {
    if (user != null) {
      if (_activeUserId != user.uid) {
        _activeUserId = user.uid;
        NotificationService.startListeningToChildrenGrades(user.uid);
      }
    } else {
      if (_activeUserId != null) {
        _activeUserId = null;
        NotificationService.stopListeningToChildrenGrades();
      }
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
              body: Center(
                child: CircularProgressIndicator(color: Colors.tealAccent),
              ),
            );
          }

          final user = snapshot.data;

          // تحديث حالة المستمع بأمان بعد اكتمال رسم الشاشة
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _syncChildrenGradesListener(user);
          });

          // التوجيه الصحيح بناءً على حالة تسجيل الدخول
          if (user != null) {
            return const HomeScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
