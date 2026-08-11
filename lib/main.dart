import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_options.dart';
import 'firebase_messaging_handler.dart';
import 'services/notification_service.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ============================================================
  // Firebase
  // ============================================================

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ============================================================
  // FCM Background Handler
  // ============================================================

  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  // ============================================================
  // Firestore
  // ============================================================

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  // ============================================================
  // تشغيل التطبيق أولاً
  // ============================================================

  runApp(const MosqueApp());

  // ============================================================
  // تهيئة الإشعارات بعد تشغيل التطبيق
  //
  // مهم:
  // لا نستخدم await هنا حتى لا تتجمد شاشة البداية
  // ============================================================

  NotificationService.init().catchError((error) {
    debugPrint(
      'خطأ في تهيئة NotificationService: $error',
    );
  });
}

class MosqueApp extends StatelessWidget {
  const MosqueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'مسجدنا الذكي',

      // ==========================================================
      // RTL
      // ==========================================================

      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },

      // ==========================================================
      // Theme
      // ==========================================================

      theme: ThemeData(
        useMaterial3: true,

        brightness: Brightness.dark,

        colorSchemeSeed: Colors.tealAccent,

        fontFamily: 'Cairo',

        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),

      // ==========================================================
      // الصفحة الرئيسية
      // ==========================================================

      home: const HomeScreen(),

      // ==========================================================
      // Routes
      // ==========================================================

      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
