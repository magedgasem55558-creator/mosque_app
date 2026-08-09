import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static StreamSubscription<RemoteMessage>? _fcmMessageSubscription;
  static StreamSubscription<RemoteMessage>? _fcmTokenSubscription;
  static StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
      _childrenSub;

  static bool _initialized = false;

  // ================================================================
  // قنوات الإشعارات
  // ================================================================

  static const String dhikrChannelId = 'dhikr_channel';
  static const String generalChannelId = 'mosque_channel';
  static const String gradesChannelId = 'grades_channel';

  // ================================================================
  // الأذكار
  // ================================================================

  static const List<String> dhikrList = [
    'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ، سُبْحَانَ اللَّهِ الْعَظِيمِ',

    'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، '
        'لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ',

    'أَسْتَغْفِرُ اللَّهَ وَأَتُوبُ إِلَيْهِ',

    'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',

    'سُبْحَانَ اللَّهِ، وَالْحَمْدُ لِلَّهِ، '
        'وَلَا إِلَهَ إِلَّا اللَّهُ، وَاللَّهُ أَكْبَرُ',

    'اللَّهُمَّ صَلِّ وَسَلِّمْ وَبَارِكْ عَلَى نَبِيِّنَا مُحَمَّدٍ',

    'رَبِّ اغْفِرْ لِي وَتُبْ عَلَيَّ، إِنَّكَ أَنْتَ التَّوَّابُ الرَّحِيمُ',

    'رَضِيتُ بِاللَّهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، '
        'وَبِمُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ نَبِيًّا',

    'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ',

    'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ، '
        'وَأَعُوذُ بِكَ مِنَ الْعَجْزِ وَالْكَسَلِ',

    'حَسْبِيَ اللَّهُ لَا إِلَهَ إِلَّا هُوَ، '
        'عَلَيْهِ تَوَكَّلْتُ وَهُوَ رَبُّ الْعَرْشِ الْعَظِيمِ',

    'اللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ',

    'يَا حَيُّ يَا قَيُّومُ، بِرَحْمَتِكَ أَسْتَغِيثُ',

    'اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا، '
        'وَرِزْقًا طَيِّبًا، وَعَمَلًا مُتَقَبَّلًا',

    'اللَّهُمَّ أَجِرْنِي مِنَ النَّارِ',

    'اللَّهُمَّ إِنِّي أَسْأَلُكَ الْجَنَّةَ وَأَعُوذُ بِكَ مِنَ النَّارِ',

    'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ عَدَدَ خَلْقِهِ، '
        'وَرِضَا نَفْسِهِ، وَزِنَةَ عَرْشِهِ، وَمِدَادَ كَلِمَاتِهِ',

    'اللَّهُمَّ اغْفِرْ لِي ذَنْبِي كُلَّهُ، '
        'دِقَّهُ وَجِلَّهُ، أَوَّلَهُ وَآخِرَهُ',

    'اللَّهُمَّ اهْدِنِي وَسَدِّدْنِي',

    'اللَّهُمَّ بَارِكْ لِي فِي وَقْتِي وَعَمَلِي وَرِزْقِي',

    'رَبِّ زِدْنِي عِلْمًا',

    'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً، '
        'وَفِي الْآخِرَةِ حَسَنَةً، وَقِنَا عَذَابَ النَّارِ',

    'رَبَّنَا لَا تُزِغْ قُلُوبَنَا بَعْدَ إِذْ هَدَيْتَنَا، '
        'وَهَبْ لَنَا مِنْ لَدُنْكَ رَحْمَةً',

    'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ شَرِّ مَا عَمِلْتُ، '
        'وَمِنْ شَرِّ مَا لَمْ أَعْمَلْ',

    'اللَّهُمَّ ارْحَمْنِي وَاغْفِرْ لِي وَاهْدِنِي وَعَافِنِي وَارْزُقْنِي',

    'اللَّهُمَّ اكْفِنِي بِحَلَالِكَ عَنْ حَرَامِكَ، '
        'وَأَغْنِنِي بِفَضْلِكَ عَمَّنْ سِوَاكَ',

    'الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ',

    'اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ، اللَّهُ أَكْبَرُ',

    'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',

    'سُبْحَانَ اللَّهِ الْعَظِيمِ',

    'أَسْتَغْفِرُ اللَّهَ الَّذِي لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ وَأَتُوبُ إِلَيْهِ',

    'اللَّهُمَّ صَلِّ عَلَى مُحَمَّدٍ وَعَلَى آلِ مُحَمَّدٍ',

    'لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ',

    'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْكُفْرِ وَالْفَقْرِ وَعَذَابِ الْقَبْرِ',

    'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنْ زَوَالِ نِعْمَتِكَ، '
        'وَتَحَوُّلِ عَافِيَتِكَ، وَفُجَاءَةِ نِقْمَتِكَ، وَجَمِيعِ سَخَطِكَ',

    'اللَّهُمَّ أَصْلِحْ لِي شَأْنِي كُلَّهُ، وَلَا تَكِلْنِي إِلَى نَفْسِي طَرْفَةَ عَيْنٍ',

    'اللَّهُمَّ رَبَّ النَّاسِ أَذْهِبِ الْبَأْسَ، '
        'اشْفِ أَنْتَ الشَّافِي، لَا شِفَاءَ إِلَّا شِفَاؤُكَ',

    'اللَّهُمَّ اجْعَلْنِي مِنَ التَّوَّابِينَ، وَاجْعَلْنِي مِنَ الْمُتَطَهِّرِينَ',

    'اللَّهُمَّ حَسِّنْ خُلُقِي كَمَا حَسَّنْتَ خَلْقِي',

    'اللَّهُمَّ اخْتِمْ لَنَا بِخَيْرٍ',

    'اللَّهُمَّ بَلِّغْنَا رِضْوَانَكَ وَجَنَّتَكَ',

    'اللَّهُمَّ اجْعَلِ الْقُرْآنَ رَبِيعَ قَلْبِي وَنُورَ صَدْرِي',

    'اللَّهُمَّ اجْعَلْنَا مِنْ أَهْلِ الْقُرْآنِ',

    'اللَّهُمَّ ارْزُقْنَا حُسْنَ الْخَاتِمَةِ',

    'اللَّهُمَّ اغْفِرْ لَنَا وَلِوَالِدِينَا وَلِجَمِيعِ الْمُسْلِمِينَ',

    'اللَّهُمَّ اجْعَلْ أَيَّامَنَا طَاعَةً وَعِبَادَةً وَقُرْبًا مِنْكَ',
  ];

  // ================================================================
  // التهيئة الرئيسية
  // ================================================================

  static Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    // اليمن توقيته UTC+3، ونستخدم صنعاء كمرجع.
    try {
      tz.setLocalLocation(tz.getLocation('Asia/Aden'));
    } catch (_) {
      try {
        tz.setLocalLocation(tz.getLocation('Asia/Riyadh'));
      } catch (_) {}
    }

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

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

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();

      // قد لا تكون متاحة في بعض إصدارات Android.
      try {
        await androidPlugin.requestExactAlarmsPermission();
      } catch (e) {
        debugPrint('Exact alarm permission: $e');
      }

      await _createNotificationChannels(androidPlugin);
    }

    _initialized = true;

    await _initFCM();
  }

  // ================================================================
  // إنشاء قنوات الإشعارات
  // ================================================================

  static Future<void> _createNotificationChannels(
    AndroidFlutterLocalNotificationsPlugin androidPlugin,
  ) async {
    const dhikrChannel = AndroidNotificationChannel(
      dhikrChannelId,
      'الأذكار والتذكير',
      description: 'تذكيرات الأذكار الدورية',
      importance: Importance.max,
      playSound: true,
    );

    const generalChannel = AndroidNotificationChannel(
      generalChannelId,
      'إشعارات المسجد',
      description: 'الإشعارات العامة لتطبيق مسجدنا الذكي',
      importance: Importance.max,
      playSound: true,
    );

    const gradesChannel = AndroidNotificationChannel(
      gradesChannelId,
      'درجات الأبناء',
      description: 'إشعارات تحديث درجات ونقاط الأبناء',
      importance: Importance.max,
      playSound: true,
    );

    await androidPlugin.createNotificationChannel(dhikrChannel);
    await androidPlugin.createNotificationChannel(generalChannel);
    await androidPlugin.createNotificationChannel(gradesChannel);
  }

  // ================================================================
  // Firebase Cloud Messaging
  // ================================================================

  static Future<void> _initFCM() async {
    try {
      final messaging = FirebaseMessaging.instance;

      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      debugPrint(
        'FCM Permission: ${settings.authorizationStatus}',
      );

      if (settings.authorizationStatus ==
          AuthorizationStatus.denied) {
        return;
      }

      final token = await messaging.getToken();

      debugPrint('FCM Token: $token');

      await _saveTokenToFirestore(token);

      await _fcmMessageSubscription?.cancel();

      _fcmMessageSubscription =
          FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) async {
          await showLocalNotificationFromMessage(message);
        },
      );

      await _fcmTokenSubscription?.cancel();

      _fcmTokenSubscription =
          messaging.onTokenRefresh.listen((newToken) async {
        debugPrint('FCM Token refreshed: $newToken');

        await _saveTokenToFirestore(newToken);
      });
    } catch (e) {
      debugPrint('فشل إعداد FCM: $e');
    }
  }

  // ================================================================
  // حفظ FCM Token
  // ================================================================

  static Future<void> _saveTokenToFirestore(
    String? token,
  ) async {
    if (token == null || token.isEmpty) return;

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

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
    } catch (e) {
      debugPrint('فشل حفظ FCM Token: $e');
    }
  }

  // ================================================================
  // إشعار FCM عندما يكون التطبيق مفتوحًا
  // ================================================================

  static Future<void> showLocalNotificationFromMessage(
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
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            generalChannelId,
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
      debugPrint(
        'فشل عرض إشعار FCM: $e',
      );
    }
  }

  // ================================================================
  // جدولة الأذكار
  // ================================================================

  static Future<void> scheduleDhikr() async {
    try {
      if (!_initialized) {
        await init();
      }

      // إلغاء الجدول السابق حتى لا تتكرر الإشعارات.
      for (int totalMinutes = 8 * 60;
          totalMinutes <= 22 * 60;
          totalMinutes += 30) {
        await _plugin.cancel(totalMinutes);
      }

      final now = tz.TZDateTime.now(tz.local);

      int dhikrIndex = 0;

      // من 8 صباحاً حتى 10 مساءً كل 30 دقيقة.
      for (int totalMinutes = 8 * 60;
          totalMinutes <= 22 * 60;
          totalMinutes += 30) {
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

        if (!scheduledDate.isAfter(now)) {
          scheduledDate = scheduledDate.add(
            const Duration(days: 1),
          );
        }

        final dhikr =
            dhikrList[dhikrIndex % dhikrList.length];

        dhikrIndex++;

        await _plugin.zonedSchedule(
          totalMinutes,
          'ذكر الله 🌿',
          dhikr,
          scheduledDate,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              dhikrChannelId,
              'الأذكار والتذكير',
              channelDescription:
                  'تذكيرات الأذكار الدورية',
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
              UILocalNotificationDateInterpretation
                  .absoluteTime,
          matchDateTimeComponents:
              DateTimeComponents.time,
        );
      }

      debugPrint('تمت جدولة الأذكار بنجاح');
    } catch (e) {
      debugPrint(
        'فشل جدولة الأذكار: $e',
      );
    }
  }

  // ================================================================
  // إلغاء جميع أوقات الأذكار
  // ================================================================

  static Future<void> cancelDhikr() async {
    for (int totalMinutes = 8 * 60;
        totalMinutes <= 22 * 60;
        totalMinutes += 30) {
      await _plugin.cancel(totalMinutes);
    }
  }

  // ================================================================
  // إشعار اختباري
  // ================================================================

  static Future<void> showTestNotification() async {
    await _plugin.show(
      999999,
      'مسجدنا الذكي 🌙',
      'تم تفعيل الإشعارات بنجاح',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          generalChannelId,
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
  }

  // ================================================================
  // مراقبة درجات الأبناء
  // ================================================================

  static void startListeningToChildrenGrades(
    String parentId,
  ) {
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
          if (change.type !=
              DocumentChangeType.modified) {
            continue;
          }

          final data = change.doc.data();

          if (data == null) continue;

          final childName =
              data['name']?.toString() ?? 'الابن';

          final totalPointsValue =
              data['totalPoints'];

          final totalPoints =
              totalPointsValue is num
                  ? totalPointsValue.toDouble()
                  : double.tryParse(
                        totalPointsValue
                                ?.toString() ??
                           
