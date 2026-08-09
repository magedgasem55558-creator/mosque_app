import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static StreamSubscription<RemoteMessage>? _foregroundMessageSub;
  static StreamSubscription<String>? _tokenRefreshSub;
  static StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      _childrenSub;

  static bool _initialized = false;

  // ==========================================================================
  // الأذكار
  // ==========================================================================

  static const List<String> dhikrList = [
    'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، سُبْحَانَ اللَّهِ الْعَظِيمِ',

    'لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ',

    'سُبْحَانَ اللَّهِ، وَالْحَمْدُ لِلَّهِ، وَلَا إِلَهَ إِلَّا اللَّهُ، وَاللَّهُ أَكْبَرُ',

    'أَسْتَغْفِرُ اللَّهَ الَّذِي لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ وَأَتُوبُ إِلَيْهِ',

    'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ',

    'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',

    'رَبِّ اغْفِرْ لِي وَتُبْ عَلَيَّ إِنَّكَ أَنْتَ التَّوَّابُ الرَّحِيمُ',

    'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ عَدَدَ خَلْقِهِ، وَرِضَا نَفْسِهِ، وَزِنَةَ عَرْشِهِ، وَمِدَادَ كَلِمَاتِهِ',

    'اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا، وَرِزْقًا طَيِّبًا، وَعَمَلًا مُتَقَبَّلًا',

    'اللَّهُمَّ أَجِرْنِي مِنَ النَّارِ',

    'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ مِائَةَ مَرَّةٍ',

    'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',

    'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ شَرِّ مَا عَمِلْتُ، وَمِنْ شَرِّ مَا لَمْ أَعْمَلْ',

    'رَضِيتُ بِاللَّهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، وَبِمُحَمَّدٍ نَبِيًّا وَرَسُولًا',

    'يَا حَيُّ يَا قَيُّومُ، بِرَحْمَتِكَ أَسْتَغِيثُ',

    'سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ وَلَا إِلَهَ إِلَّا اللَّهُ وَاللَّهُ أَكْبَرُ',

    'أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ',

    'اللَّهُمَّ اغْفِرْ لِي وَارْحَمْنِي وَاهْدِنِي وَعَافِنِي وَارْزُقْنِي',

    'اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ',

    'اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي',

    'رَبِّ زِدْنِي عِلْمًا',

    'رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي',

    'حَسْبِيَ اللَّهُ لَا إِلَهَ إِلَّا هُوَ، عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ',

    'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْجَنَّةَ وَأَعُوذُ بِكَ مِنَ النَّارِ',

    'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ',

    'اللَّهُمَّ اهْدِنِي وَسَدِّدْنِي',

    'اللَّهُمَّ ارْزُقْنِي قَلْبًا خَاشِعًا وَلِسَانًا ذَاكِرًا',

    'اللَّهُمَّ بَارِكْ لِي فِي وَقْتِي وَعَمَلِي وَرِزْقِي',

    'اللَّهُمَّ اكْفِنِي بِحَلَالِكَ عَنْ حَرَامِكَ وَأَغْنِنِي بِفَضْلِكَ عَمَّنْ سِوَاكَ',

    'اللَّهُمَّ أَصْلِحْ لِي دِينِي وَدُنْيَايَ وَآخِرَتِي',

    'رَبِّ أَعُوذُ بِكَ مِنْ هَمَزَاتِ الشَّيَاطِينِ وَأَعُوذُ بِكَ رَبِّ أَنْ يَحْضُرُونِ',

    'اللَّهُمَّ اجْعَلْ الْقُرْآنَ رَبِيعَ قَلْبِي وَنُورَ صَدْرِي',

    'اللَّهُمَّ اجْعَلْنِي مِنَ التَّوَّابِينَ وَاجْعَلْنِي مِنَ الْمُتَطَهِّرِينَ',

    'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، عَدَدَ مَا خَلَقَ، وَرِضَا نَفْسِهِ، وَزِنَةَ عَرْشِهِ، وَمِدَادَ كَلِمَاتِهِ',

    'اللَّهُمَّ صَلِّ وَسَلِّمْ وَبَارِكْ عَلَى نَبِيِّنَا مُحَمَّدٍ',

    'اللَّهُمَّ إِنِّي أَسْأَلُكَ حُبَّكَ وَحُبَّ مَنْ يُحِبُّكَ وَحُبَّ عَمَلٍ يُقَرِّبُنِي إِلَى حُبِّكَ',

    'يَا رَبِّ لَا تَذَرْ لِي ذَنْبًا إِلَّا غَفَرْتَهُ، وَلَا هَمًّا إِلَّا فَرَّجْتَهُ',

    'اللَّهُمَّ اجْعَلْنَا مِنْ أَهْلِ الْقُرْآنِ الَّذِينَ هُمْ أَهْلُكَ وَخَاصَّتُكَ',

    'اللَّهُمَّ اخْتِمْ لَنَا بِخَيْرٍ',

    'اللَّهُمَّ ثَبِّتْ قُلُوبَنَا عَلَى دِينِكَ',

    'اللَّهُمَّ ارْحَمْ وَالِدَيْنَا وَاغْفِرْ لَهُمَا',

    'اللَّهُمَّ اشْفِ مَرْضَانَا وَارْحَمْ مَوْتَانَا',

    'اللَّهُمَّ احْفَظْنَا وَأَهْلَنَا مِنْ كُلِّ سُوءٍ',

    'اللَّهُمَّ اجْعَلْ أَيَّامَنَا عَامِرَةً بِذِكْرِكَ',

    'اللَّهُمَّ لَا تَحْرِمْنَا فَضْلَكَ وَرَحْمَتَكَ',

    'اللَّهُمَّ اجْعَلْنَا مِمَّنْ يَسْمَعُونَ الْقَوْلَ فَيَتَّبِعُونَ أَحْسَنَهُ',
  ];

  // ==========================================================================
  // تهيئة الخدمة
  // ==========================================================================

  static Future<void> init() async {
    if (_initialized) {
      return;
    }

    try {
      // timezone
      tz.initializeTimeZones();

      try {
        tz.setLocalLocation(tz.getLocation('Asia/Riyadh'));
      } catch (_) {
        // إذا لم يتم العثور على المنطقة الزمنية
        // سيتم استخدام المنطقة الافتراضية.
      }

      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );

      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      await _plugin.initialize(
        const InitializationSettings(
          android: androidSettings,
          iOS: iosSettings,
        ),
      );

      await _createNotificationChannels();

      await _requestPermissions();

      _initialized = true;

      await _initFCM();

      debugPrint('تم تهيئة NotificationService بنجاح');
    } catch (e, stackTrace) {
      debugPrint('خطأ في تهيئة NotificationService: $e');
      debugPrint('$stackTrace');
    }
  }

  // ==========================================================================
  // قنوات Android
  // ==========================================================================

  static Future<void> _createNotificationChannels() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) {
      return;
    }

    const dhikrChannel = AndroidNotificationChannel(
      'dhikr_channel',
      'أذكار وتذكير',
      description: 'إشعارات الأذكار والتذكير بذكر الله',
      importance: Importance.max,
      playSound: true,
    );

    const mosqueChannel = AndroidNotificationChannel(
      'mosque_channel',
      'إشعارات المسجد',
      description: 'الإشعارات العامة لتطبيق مسجدنا الذكي',
      importance: Importance.max,
      playSound: true,
    );

    const gradesChannel = AndroidNotificationChannel(
      'grades_channel',
      'رصد الدرجات',
      description: 'إشعارات تحديث درجات ونقاط الأبناء',
      importance: Importance.max,
      playSound: true,
    );

    await androidPlugin.createNotificationChannel(dhikrChannel);
    await androidPlugin.createNotificationChannel(mosqueChannel);
    await androidPlugin.createNotificationChannel(gradesChannel);
  }

  // ==========================================================================
  // الصلاحيات
  // ==========================================================================

  static Future<void> _requestPermissions() async {
    try {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        await androidPlugin.requestNotificationsPermission();

        try {
          await androidPlugin.requestExactAlarmsPermission();
        } catch (e) {
          debugPrint('تعذر طلب إذن المنبهات الدقيقة: $e');
        }
      }

      await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
    } catch (e) {
      debugPrint('خطأ أثناء طلب صلاحيات الإشعارات: $e');
    }
  }

  // ==========================================================================
  // Firebase Cloud Messaging
  // ==========================================================================

  static Future<void> _initFCM() async {
    try {
      final messaging = FirebaseMessaging.instance;

      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus !=
              AuthorizationStatus.authorized &&
          settings.authorizationStatus !=
              AuthorizationStatus.provisional) {
        debugPrint('لم يتم السماح بإشعارات FCM');
        return;
      }

      final token = await messaging.getToken();

      debugPrint('FCM Token: $token');

      await _saveTokenToFirestore(token);

      // مهم:
      // onTokenRefresh يرجع String وليس RemoteMessage
      await _tokenRefreshSub?.cancel();

      _tokenRefreshSub = messaging.onTokenRefresh.listen(
        (newToken) async {
          debugPrint('تم تحديث FCM Token');

          await _saveTokenToFirestore(newToken);
        },
      );

      await _foregroundMessageSub?.cancel();

      _foregroundMessageSub = FirebaseMessaging.onMessage.listen(
        _showFCMNotification,
      );
    } catch (e) {
      debugPrint('فشل إعداد FCM: $e');
    }
  }

  // ==========================================================================
  // حفظ FCM Token
  // ==========================================================================

  static Future<void> saveCurrentToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();

      await _saveTokenToFirestore(token);
    } catch (e) {
      debugPrint('فشل حفظ FCM Token: $e');
    }
  }

  static Future<void> _saveTokenToFirestore(String? token) async {
    if (token == null || token.isEmpty) {
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        debugPrint(
          'لم يتم حفظ FCM Token لأن المستخدم غير مسجل الدخول',
        );
        return;
      }

      await FirebaseFirestore.instance
          .collection('parents')
          .doc(user.uid)
          .set(
        {
          'fcmToken': token,
          'lastUpdated': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      debugPrint('تم حفظ FCM Token للمستخدم ${user.uid}');
    } catch (e) {
      debugPrint('فشل حفظ FCM Token في Firestore: $e');
    }
  }

  // ==========================================================================
  // استقبال FCM أثناء فتح التطبيق
  // ==========================================================================

  static Future<void> _showFCMNotification(
    RemoteMessage message,
  ) async {
    try {
      final notification = message.notification;

      final title =
          notification?.title ??
          message.data['title']?.toString() ??
          'مسجدنا الذكي';

      final body =
          notification?.body ??
          message.data['body']?.toString() ??
          'لديك إشعار جديد';

      await _plugin.show(
        notification.hashCode,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'mosque_channel',
            'إشعارات المسجد',
            channelDescription:
                'إشعارات تطبيق المسجد العامة',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
    } catch (e) {
      debugPrint('فشل عرض إشعار FCM: $e');
    }
  }

  // ==========================================================================
  // يستخدم مع Background Handler
  // ==========================================================================

  static Future<void> showLocalNotificationFromMessage(
    RemoteMessage message,
  ) async {
    try {
      await _showFCMNotification(message);
    } catch (e) {
      debugPrint(
        'فشل عرض إشعار الرسالة في الخلفية: $e',
      );
    }
  }

  // ==========================================================================
  // جدولة الأذكار
  // ==========================================================================

  static Future<void> scheduleDhikr() async {
    try {
      if (!_initialized) {
        await init();
      }

      final now = tz.TZDateTime.now(tz.local);

      // من 8 صباحًا إلى 10 مساءً
      // كل نصف ساعة
      for (
        int totalMinutes = 8 * 60;
        totalMinutes <= 22 * 60;
        totalMinutes += 30
      ) {
        final hour = totalMinutes ~/ 60;
        final minute = totalMinutes % 60;

        var scheduledDate = tz.TZDateTime(
          tz.local,
          now.year,
          now.month,
          now.day,
          hour,
          minute,
        );

        // إذا مر الوقت اليوم،
        // جدوله لليوم التالي.
        if (!scheduledDate.isAfter(now)) {
          scheduledDate = scheduledDate.add(
            const Duration(days: 1),
          );
        }

        final index =
            (totalMinutes ~/ 30) % dhikrList.length;

        final notificationId = totalMinutes;

        // منع تكرار نفس الإشعار
        await _plugin.cancel(notificationId);

        await _plugin.zonedSchedule(
          notificationId,
          'ذكر الله',
          dhikrList[index],
          scheduledDate,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'dhikr_channel',
              'أذكار وتذكير',
              channelDescription:
                  'تذكير دوري بذكر الله',
              importance: Importance.max,
              priority: Priority.high,
              playSound: true,
              icon: '@mipmap/ic_launcher',
            ),
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          androidScheduleMode:
              AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          matchDateTimeComponents:
              DateTimeComponents.time,
        );
      }

      debugPrint('تمت جدولة الأذكار بنجاح');
    } catch (e) {
      debugPrint('فشل جدولة الأذكار: $e');
    }
  }

  // ==========================================================================
  // إلغاء جميع الأذكار
  // ==========================================================================

  static Future<void> cancelDhikr() async {
    try {
      for (
        int totalMinutes = 8 * 60;
        totalMinutes <= 22 * 60;
        totalMinutes += 30
      ) {
        await _plugin.cancel(totalMinutes);
      }

      debugPrint('تم إلغاء إشعارات الأذكار');
    } catch (e) {
      debugPrint('فشل إلغاء الأذكار: $e');
    }
  }

  // ==========================================================================
  // إشعار اختباري
  // ==========================================================================

  static Future<void> showTestNotification() async {
    try {
      await _plugin.show(
        999999,
        'مسجدنا الذكي',
        'تم إرسال الإشعار بنجاح! 🔔',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'mosque_channel',
            'إشعارات المسجد',
            channelDescription:
                'إشعارات تطبيق المسجد العامة',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
    } catch (e) {
      debugPrint('فشل الإشعار الاختباري: $e');
    }
  }

  // ==========================================================================
  // رصد درجات الأبناء
  // ==========================================================================

  static void startListeningToChildrenGrades(
    String parentId,
  ) {
    try {
      _childrenSub?.cancel();

      _childrenSub = FirebaseFirestore.instance
          .collection('children')
          .where(
            'parentId',
            isEqualTo: parentId,
          )
          .snapshots()
          .listen(
        (snapshot) {
          for (final change in snapshot.docChanges) {
            // إشعار عند تعديل بيانات الابن
            if (change.type !=
                DocumentChangeType.modified) {
              continue;
            }

            final data = change.doc.data();

            if (data == null) {
              continue;
            }

            final childName =
                data['name']?.toString() ??
                'الابن';

            final pointsValue =
                data['totalPoints'];

            double totalPoints = 0;

            if (pointsValue is num) {
              totalPoints = pointsValue.toDouble();
            } else {
              totalPoints =
                  double.tryParse(
                    pointsValue?.toString() ?? '',
                  ) ??
                  0;
            }

            _showGradeNotification(
              childName,
              totalPoints,
            );
          }
        },
        onError: (error) {
          debugPrint(
            'خطأ في مراقبة درجات الأبناء: $error',
          );
        },
      );

      debugPrint(
        'بدأت مراقبة درجات الأبناء للمستخدم: $parentId',
      );
    } catch (e) {
      debugPrint(
        'فشل تشغيل مراقبة درجات الأبناء: $e',
      );
    }
  }

  // ==========================================================================
  // إيقاف مراقبة درجات الأبناء
  // ==========================================================================

  static Future<void> stopListeningToChildrenGrades() async {
    await _childrenSub?.cancel();
    _childrenSub = null;

    debugPrint(
      'تم إيقاف مراقبة درجات الأبناء',
    );
  }

  // ==========================================================================
  // إشعار الدرجات
  // ==========================================================================

  static Future<void> _showGradeNotification(
    String childName,
    double totalPoints,
  ) async {
    try {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin != null) {
        const channel = AndroidNotificationChannel(
          'grades_channel',
          'رصد الدرجات',
          description:
              'إشعارات تحديث درجات ونقاط الأبناء',
          importance: Importance.max,
          playSound: true,
        );

        await androidPlugin.createNotificationChannel(
          channel,
        );
      }

      final notificationId =
          DateTime.now().millisecondsSinceEpoch.remainder(
                2147483647,
              );

      await _plugin.show(
        notificationId,
        '📊 تحديث في درجات الابن',
        'مجموع نقاط $childName الحالي هو ${_formatPoints(totalPoints)} نقطة',
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'grades_channel',
            'رصد الدرجات',
            channelDescription:
                'إشعارات تحديث درجات ونقاط الأبناء',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
    } catch (e) {
      debugPrint(
        'فشل إرسال إشعار الدرجات: $e',
      );
    }
  }

  static String _formatPoints(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(1);
  }

  // ==========================================================================
  // إلغاء إشعار معين
  // ==========================================================================

  static Future<void> cancel(int id) async {
    try {
      await _plugin.cancel(id);
    } catch (e) {
      debugPrint('فشل إلغاء الإشعار: $e');
    }
  }

  // ==========================================================================
  // إلغاء جميع الإشعارات
  // ==========================================================================

  static Future<void> cancelAll() async {
    try {
      await _plugin.cancelAll();
    } catch (e) {
      debugPrint('فشل إلغاء جميع الإشعارات: $e');
    }
  }

  // ==========================================================================
  // تنظيف الموارد
  // ==========================================================================

  static Future<void> dispose() async {
    await _foregroundMessageSub?.cancel();
    await _tokenRefreshSub?.cancel();
    await _childrenSub?.cancel();

    _foregroundMessageSub = null;
    _tokenRefreshSub = null;
    _childrenSub = null;

    debugPrint(
      'تم تنظيف NotificationService',
    );
  }
}
