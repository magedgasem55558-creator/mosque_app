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

    await NotificationService.showLocalNotificationFromMessage(
      message,
    );
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
  // Firebase
  // ==========================================================================

  try {
    await Firebase.initializeApp();

    debugPrint('Firebase تم تشغيله بنجاح');
  } catch (e) {
    debugPrint(
      'خطأ في تهيئة Firebase: $e',
    );
  }


  // ==========================================================================
  // FCM Background Handler
  // ==========================================================================

  FirebaseMessaging.onBackgroundMessage(
    firebaseMessagingBackgroundHandler,
  );


  // ==========================================================================
  // Firestore Cache
  // ==========================================================================

  try {
    FirebaseFirestore.instance.settings =
        const Settings(
      persistenceEnabled: true,
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );

    debugPrint(
      'تم تفعيل Firestore Cache',
    );
  } catch (e) {
    debugPrint(
      'خطأ إعداد Firestore Cache: $e',
    );
  }


  // ==========================================================================
  // Just Audio Background
  // ==========================================================================

  try {
    await JustAudioBackground.init(
      androidNotificationChannelId:
          'com.mosque.system.channel.audio',

      androidNotificationChannelName:
          'تشغيل القرآن الكريم',

      androidNotificationOngoing: true,
    );

    debugPrint(
      'تم تشغيل خدمة الصوت في الخلفية',
    );
  } catch (e) {
    debugPrint(
      'تحذير تشغيل الصوت بالخلفية: $e',
    );
  }


  // ==========================================================================
  // تشغيل التطبيق
  // ==========================================================================

  runApp(
    const MosqueApp(),
  );
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

    // ننتظر حتى يتم بناء التطبيق
    // ثم نبدأ تهيئة الإشعارات.
    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      _initializeNotifications();
    });
  }


  // ==========================================================================
  // تهيئة نظام الإشعارات
  // ==========================================================================

  Future<void>
      _initializeNotifications() async {

    try {

      // ----------------------------------------------------------------------
      // تهيئة NotificationService
      // ----------------------------------------------------------------------

      await NotificationService.init();


      // ----------------------------------------------------------------------
      // جدولة أذكار التذكير
      // ----------------------------------------------------------------------

      await NotificationService.scheduleDhikr();


      // ----------------------------------------------------------------------
      // المستخدم الحالي
      // ----------------------------------------------------------------------

      final user =
          FirebaseAuth.instance.currentUser;


      // ----------------------------------------------------------------------
      // إذا كان ولي الأمر مسجل الدخول
      // ----------------------------------------------------------------------

      if (user != null) {

        debugPrint(
          'ولي الأمر مسجل الدخول: ${user.uid}',
        );


        // --------------------------------------------------------------------
        // الحصول على FCM Token وحفظه في Firestore
        // --------------------------------------------------------------------

        await NotificationService
            .saveCurrentToken();


        debugPrint(
          'تم حفظ FCM Token لولي الأمر',
        );
      }


      // ----------------------------------------------------------------------
      // مراقبة تغيير FCM Token
      // يتم التعامل معها داخل NotificationService
      // ----------------------------------------------------------------------

      debugPrint(
        'تم تشغيل نظام الإشعارات بنجاح',
      );

    } catch (e) {

      debugPrint(
        'خطأ في تهيئة الإشعارات: $e',
      );
    }
  }


  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(
    BuildContext context,
  ) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      title: 'مسجدنا الذكي',


      // ======================================================================
      // RTL
      // ======================================================================

      builder: (
        context,
        child,
      ) {

        return Directionality(

          textDirection:
              TextDirection.rtl,

          child:
              child ??
                  const SizedBox.shrink(),
        );
      },


      // ======================================================================
      // THEME
      // ======================================================================

      theme: ThemeData(

        useMaterial3: true,

        brightness:
            Brightness.dark,

        colorSchemeSeed:
            Colors.tealAccent,

        fontFamily:
            'Cairo',

        appBarTheme:
            const AppBarTheme(

          centerTitle: true,

          elevation: 0,
        ),
      ),


      // ======================================================================
      // Authentication
      // ======================================================================

      home: StreamBuilder<User?>(

        stream:
            FirebaseAuth
                .instance
                .authStateChanges(),


        builder: (
          context,
          snapshot,
        ) {

          // ------------------------------------------------------------------
          // انتظار Firebase Auth
          // ------------------------------------------------------------------

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


          // ------------------------------------------------------------------
          // المستخدم مسجل الدخول
          // ------------------------------------------------------------------

          if (snapshot.hasData) {

            return const HomeScreen();
          }


          // ------------------------------------------------------------------
          // المستخدم غير مسجل الدخول
          // ------------------------------------------------------------------

          return const LoginScreen();
        },
      ),


      // ======================================================================
      // ROUTES
      // ======================================================================

      routes: {

        '/login': (
          context,
        ) =>
            const LoginScreen(),

        '/home': (
          context,
        ) =>
            const HomeScreen(),
      },
    );
  }


  // ==========================================================================
  // DISPOSE
  // ==========================================================================

  @override
  void dispose() {

    NotificationService.dispose();

    super.dispose();
  }
}
