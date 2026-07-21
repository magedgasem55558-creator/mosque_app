import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/notification_service.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // 1. تهيئة Audio
    try {
      await JustAudioBackground.init(
        androidNotificationChannelId: 'com.u.audio.channel',
        androidNotificationChannelName: 'تشغيل القرآن الكريم',
        androidNotificationOngoing: true,
      );
    } catch (e) {
      debugPrint('Audio service init warning: $e');
    }

    // 2. تهيئة Firebase
    try {
      await Firebase.initializeApp();
    } catch (e) {
      debugPrint('Firebase init error: $e');
    }

    // 3. طلب إذن الإشعارات
    try {
      await FirebaseMessaging.instance.requestPermission();
    } catch (e) {
      debugPrint('Firebase messaging permission error: $e');
    }

    runApp(const MosqueApp());
  }, (error, stackTrace) {
    // إمساك أي خطأ يسبب الانهيار وعرضه داخل التطبيق بدلاً من إغلاقه
    runApp(MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Text(
                'CRASH PREVENTED!\n\nError:\n$error\n\nStack:\n$stackTrace',
                style: const TextStyle(color: Colors.redAccent, fontSize: 14),
              ),
            ),
          ),
        ),
      ),
    ));
  });
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

          if (snapshot.hasData) {
            final user = snapshot.data!;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              try {
                NotificationService.startListeningToChildrenGrades(user.uid);
              } catch (_) {}
            });
          } else {
            try {
              NotificationService.stopListeningToChildrenGrades();
            } catch (_) {}
          }

          return const HomeScreen();
        },
      ),
      routes: {'/login': (context) => const LoginScreen()},
    );
  }
}
