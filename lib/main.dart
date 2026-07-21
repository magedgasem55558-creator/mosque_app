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
    // إمساك أي خطأ يسبب الانهيار وعرضه داخل التطبيق
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
