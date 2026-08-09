import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/notification_service.dart';


// ============================================================================
// FCM Background Handler
// ============================================================================

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp();

    await NotificationService.init();

    await NotificationService
        .showLocalNotificationFromMessage(message);
  } catch (e) {
    debugPrint(
      'خطأ في معالجة إشعار FCM بالخلفية: $e',
    );
  }
}


// ============================================================================
// MAIN
// ============================================================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ==========================================================================
  // تشغيل الصوت في الخلفية
  // ==========================================================================

  try {
    await JustAudioBackground.init(
      androidNotificationChannelId:
          'com.mosque.system.channel.audio',
      androidNotificationChannelName:
          'تشغيل القرآن الكريم',
      androidNotificationOngoing: true,
    );
  } catch (e) {
    debugPrint(
      'تحذير تشغيل الصوت بالخلفية: $e',
    );
  }

  // ==========================================================================
  // Firebase
  // ==========================================================================

  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint(
      'خطأ تهيئة Firebase: $e',
    );
  }

  // ==========================================================================
  // Firestore Cache
  // ==========================================================================

  try {
    FirebaseFirestore.instance.settings =
        const Settings(
      persistenceEnabled: true,
      cacheSizeBytes:
          Settings.CACHE_SIZE_UNLIMITED,
    );
  } catch (e) {
    debugPrint(
      'خطأ إعداد Firestore Cache: $e',
    );
  }

  // ==========================================================================
  // FCM Background Messages
  // ==========================================================================

  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );

  // ==========================================================================
  // تشغيل التطبيق
  // ==========================================================================

  runApp(const MosqueApp());
}


// ============================================================================
// APP
// ============================================================================

class MosqueApp extends StatefulWidget {
  const MosqueApp({
    super.key,
  });

  @override
  State<MosqueApp> createState() =>
      _MosqueAppState();
}


// ============================================================================
// APP STATE
// ============================================================================

class _MosqueAppState
    extends State<MosqueApp> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      _initializeNotifications();
    });
  }

  // ==========================================================================
  // تهيئة الإشعارات
  // ==========================================================================

  Future<void>
      _initializeNotifications() async {
    try {
      await NotificationService.init();

      // جدولة الأذكار.
      await NotificationService.scheduleDhikr();

      // تشغيل مراقبة ولي الأمر الحالي.
      final user =
          FirebaseAuth.instance.currentUser;

      if (user != null) {
        NotificationService
            .startListeningToChildrenGrades(
          user.uid,
        );
      }
    } catch (e) {
      debugPrint(
        'خطأ إعداد الإشعارات: $e',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'مسجدنا الذكي',

      builder: (context, child) {
        return Directionality(
          textDirection:
              TextDirection.rtl,
          child:
              child ??
                  const SizedBox.shrink(),
        );
      },

      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed:
            Colors.tealAccent,
        fontFamily: 'Cairo',

        appBarTheme:
            const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
      ),

      // ======================================================================
      // مراقبة حالة تسجيل الدخول
      // ======================================================================

      home: StreamBuilder<User?>(
        stream: FirebaseAuth
            .instance
            .authStateChanges(),

        builder:
            (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child:
                    CircularProgressIndicator(
                  color:
                      Colors.tealAccent,
                ),
              ),
            );
          }

          // ==================================================================
          // ولي الأمر مسجل دخول
          // ==================================================================

          if (snapshot.hasData) {
            final user =
                snapshot.data!;

            WidgetsBinding
                .instance
                .addPostFrameCallback(
              (_) {
                NotificationService
                    .startListeningToChildrenGrades(
                  user.uid,
                );
              },
            );
          }

          // ==================================================================
          // تسجيل الخروج
          // ==================================================================

          else {
            WidgetsBinding
                .instance
                .addPostFrameCallback(
              (_) {
                NotificationService
                    .stopListeningToChildrenGrades();
              },
            );
          }

          // ==================================================================
          // الصفحة الرئيسية
          // ==================================================================

          return const HomeScreen();
        },
      ),

      routes: {
        '/login': (context) =>
            const LoginScreen(),

        '/home': (context) =>
            const HomeScreen(),
      },
    );
  }

  @override
  void dispose() {
    NotificationService.dispose();
    super.dispose();
  }
}
