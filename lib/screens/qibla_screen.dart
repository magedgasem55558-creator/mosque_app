import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 👈 استيراد مكتبة التحكم بالاهتزاز
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({Key? key}) : super(key: key);

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  bool _hasPermission = false;
  bool _isLoading = true;
  String _statusMessage = 'جاري طلب صلاحيات الموقع...';
  
  // متغيرة لتفادي تكرار الاهتزاز باستمرار أثناء الثبات على القبلة
  bool _hasVibrated = false;

  // ألوان الواجهة الرسمية
  static const Color darkBg = Color(0xFF0F172A);
  static const Color cardBg = Color(0xFF1E293B);
  static const Color goldAccent = Color(0xFFD4AF37);
  static const Color greenAccent = Color(0xFF10B981);

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.denied) {
      setState(() {
        _isLoading = false;
        _hasPermission = false;
        _statusMessage = 'يتطلب تحديد القبلة السماح بصلاحية الوصول للموقع.';
      });
      return;
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _isLoading = false;
        _hasPermission = false;
        _statusMessage = 'يرجى تفعيل خدمة الموقع (GPS) لتحديد الاتجاه.';
      });
      return;
    }

    setState(() {
      _hasPermission = true;
      _isLoading = false;
    });
  }

  // دالة التعامل مع الاهتزاز
  void _triggerHapticFeedback(bool isFacingQiblah) {
    if (isFacingQiblah) {
      if (!_hasVibrated) {
        HapticFeedback.mediumImpact(); // اهتزاز متوسط عند المحاذاة
        _hasVibrated = true;
      }
    } else {
      _hasVibrated = false; // إعادة الضبط عند الابتعاد عن القبلة
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        title: const Text(
          'اتجاه القبلة',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: goldAccent))
          : !_hasPermission
              ? _buildPermissionView()
              : StreamBuilder<QiblahDirection>(
                  stream: FlutterQiblah.qiblahStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return _buildStatusText('حدث خطأ أثناء قراءة الحساسات');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(color: goldAccent));
                    }

                    final qiblahDirection = snapshot.data;
                    if (qiblahDirection == null) {
                      return _buildStatusText('جهازك لا يدعم حساس البوصلة');
                    }

                    // 1. حساب زاوية القبلة
                    double qiblahAngle = qiblahDirection.qiblah;

                    // 2. حساب الانحراف الفعلي عن الاتجاه الصحيح
                    double diff = (qiblahAngle % 360);
                    if (diff > 180) diff -= 360;

                    // هامش قبول الاتجاه الصائب (5 درجات)
                    bool isFacingQiblah = diff.abs() < 5.0;

                    // 3. تشغيل الاهتزاز عند محاذاة القبلة
                    _triggerHapticFeedback(isFacingQiblah);

                    Color activeColor =
                        isFacingQiblah ? greenAccent : goldAccent;

                    return SafeArea(
                      child: Column(
                        children: [
                          const Spacer(),
                          // بطاقة التنبيه الرسمية
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: activeColor.withOpacity(0.4),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: activeColor.withOpacity(0.15),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  isFacingQiblah
                                      ? Icons.check_circle_rounded
                                      : Icons.explore_rounded,
                                  color: activeColor,
                                  size: 22,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  isFacingQiblah
                                      ? 'أنت تتجه نحو القبلة تماماً'
                                      : 'قم بتدوير الهاتف باتجاه المؤشر',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.95),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          // البوصلة الفخمة
                          Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // الإطار الخارجي المتوهج
                                Container(
                                  width: 300,
                                  height: 300,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: cardBg,
                                    boxShadow: [
                                      BoxShadow(
                                        color: activeColor.withOpacity(0.1),
                                        blurRadius: 30,
                                        spreadRadius: 10,
                                      ),
                                    ],
                                  ),
                                ),
                                // حلقة التدريج الدائرية
                                Container(
                                  width: 270,
                                  height: 270,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.1),
                                      width: 2,
                                    ),
                                  ),
                                ),
                                // حركة مؤشر البوصلة والسهم
                                Transform.rotate(
                                  angle: (qiblahAngle * (math.pi / 180)),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      // سهم الاتجاه العلوي
                                      SizedBox(
                                        width: 260,
                                        height: 260,
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.navigation_rounded,
                                              size: 48,
                                              color: activeColor,
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                      ),
                                      // خط البوصلة الشفاف
                                      Container(
                                        width: 2,
                                        height: 200,
                                        color: activeColor.withOpacity(0.2),
                                      ),
                                    ],
                                  ),
                                ),
                                // رمز الكعبة المشرفة في المركز
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF000000),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: goldAccent,
                                      width: 2,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: goldAccent.withOpacity(0.3),
                                        blurRadius: 12,
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.mosque_rounded,
                                      color: goldAccent,
                                      size: 26,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          // قراءة درجة الانحراف
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: cardBg.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'درجة الانحراف: ${diff.abs().toStringAsFixed(1)}°',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Widget _buildStatusText(String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 16),
      ),
    );
  }

  Widget _buildPermissionView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off_rounded,
                size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              _statusMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: goldAccent,
                foregroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _checkLocationPermission,
              child: const Text(
                'إعادة المحاولة',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
