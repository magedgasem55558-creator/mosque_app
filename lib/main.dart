import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'services/notification_service.dart';

/// معالج إشعارات Firebase Messaging عندما يكون التطبيق في الخلفية.
///
/// يجب أن تكون هذه الدالة Top-Level Function
/// ويجب إبقاء @pragma حتى لا يتم حذفها أثناء Release Build.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(
  RemoteMessage message,
) async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة timezone داخل Background Isolate
  // لأنها قد تكون مطلوبة بواسطة نظام الإشعارات.
  tz.initializeTimeZones();

  // تهيئة Firebase داخل Background Isolate
  await Firebase.initializeApp();

  try {
    // تهيئة الإشعارات المحلية وإنشاء Notification Channels
    await NotificationService.init();

    // تحويل رسالة FCM إلى إشعار محلي
    await NotificationService.showLocalNotificationFromMessage(message);
  } catch (e, stackTrace) {
    debugPrint(
      'خطأ في معالجة إشعار FCM في الخلفية: $e',
    );
    debugPrint('$stackTrace');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // تهيئة المناطق الزمنية قبل جدولة الإشعارات
  tz.initializeTimeZones();

  // تهيئة Firebase
  //
  // لا نضعها داخل try/catch هنا حتى لا يبدأ التطبيق
  // إذا فشلت تهيئة Firebase.
  await Firebase.initializeApp();

  // تسجيل معالج FCM الخاص بالخلفية
  FirebaseMessaging.onBackgroundMessage(
    _firebaseMessagingBackgroundHandler,
  );

  // تشغيل التطبيق
  runApp(const MosqueApp());
}

class MosqueApp extends StatefulWidget {
  const MosqueApp({super.key});

  @override
  State<MosqueApp> createState() => _MosqueAppState();
}

class _MosqueAppState extends State<MosqueApp> {
  /// آخر مستخدم تم تشغيل مستمع درجات الأبناء له.
  ///
  /// يمنع تسجيل Listener جديد في كل عملية Build.
  String? _activeUserId;

  @override
  void initState() {
    super.initState();

    // ننتظر حتى تصبح واجهة التطبيق جاهزة
    // ثم نبدأ إعداد الإشعارات.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _setupNotifications();
      }
    });
  }

  /// إعداد نظام الإشعارات.
  Future<void> _setupNotifications() async {
    try {
      // طلب صلاحية الإشعارات
      await FirebaseMessaging.instance.requestPermission();

      // تهيئة flutter_local_notifications
      await NotificationService.init();

      // جدولة أذكار/إشعارات التطبيق
      await NotificationService.scheduleDhikr();
    } catch (e, stackTrace) {
      debugPrint(
        'خطأ في تهيئة الإشعارات: $e',
      );
      debugPrint('$stackTrace');
    }
  }

  /// تشغيل أو إيقاف مستمع درجات الأبناء حسب المستخدم الحالي.
  void _syncChildrenGradesListener(User? user) {
    if (user != null) {
      // لا نعيد تسجيل المستمع إذا كان نفس المستخدم
      if (_activeUserId != user.uid) {
        _activeUserId = user.uid;

        NotificationService.startListeningToChildrenGrades(
          user.uid,
        );
      }
    } else {
      // المستخدم سجل الخروج
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

      // دعم اللغة العربية واتجاه RTL
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },

      // إعداد التصميم
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

      // الصفحة الرئيسية حسب حالة تسجيل الدخول
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),

        builder: (context, snapshot) {
          // أثناء التحقق من حالة تسجيل الدخول
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(
                  color: Colors.tealAccent,
                ),
              ),
            );
          }

          final user = snapshot.data;

          // تحديث مستمع درجات الأبناء بعد انتهاء عملية Build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _syncChildrenGradesListener(user);
            }
          });

          // المستخدم مسجل الدخول
          if (user != null) {
            return const HomeScreen();
          }

          // المستخدم غير مسجل الدخول
          return const LoginScreen();
        },
      ),

      // المسارات
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
