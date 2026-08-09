import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _hasVibrated = false;

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

  void _triggerHapticFeedback(bool isFacingQiblah) {
    if (isFacingQiblah) {
      if (!_hasVibrated) {
        HapticFeedback.mediumImpact();
        _hasVibrated = true;
      }
    } else {
      _hasVibrated = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        // الخلفية الموحدة
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2E7D32),
              Color(0xFF42A5F5),
              Color(0xFFF5F5F5),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // شريط عنوان أبيض مع سهم الرجوع
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
                    ],
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.black87),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Expanded(
                        child: Text(
                          'اتجاه القبلة',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
              ),
              // المحتوى
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.teal))
                    : !_hasPermission
                        ? _buildPermissionView()
                        : _buildQiblahCompass(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQiblahCompass() {
    return StreamBuilder<QiblahDirection>(
      stream: FlutterQiblah.qiblahStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildStatusText('حدث خطأ أثناء قراءة الحساسات');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.teal));
        }

        final qiblahDirection = snapshot.data;
        if (qiblahDirection == null) {
          return _buildStatusText('جهازك لا يدعم حساس البوصلة');
        }

        double qiblahAngle = qiblahDirection.qiblah;
        double diff = (qiblahAngle % 360);
        if (diff > 180) diff -= 360;

        bool isFacingQiblah = diff.abs() < 5.0;
        _triggerHapticFeedback(isFacingQiblah);

        Color activeColor = isFacingQiblah ? Colors.green : Colors.teal;

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // بطاقة تنبيه
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: activeColor.withOpacity(0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: activeColor.withOpacity(0.1),
                      blurRadius: 12,
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
                    Flexible(
                      child: Text(
                        isFacingQiblah
                            ? 'أنت تتجه نحو القبلة تماماً'
                            : 'قم بتدوير الهاتف باتجاه المؤشر',
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // البوصلة
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: activeColor.withOpacity(0.08),
                          blurRadius: 25,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 270,
                    height: 270,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                  ),
                  Transform.rotate(
                    angle: (qiblahAngle * (math.pi / 180)),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
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
                        Container(
                          width: 2,
                          height: 200,
                          color: activeColor.withOpacity(0.25),
                        ),
                      ],
                    ),
                  ),
                  // رمز الكعبة
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.teal, width: 2),
                      boxShadow: [
                        BoxShadow(color: Colors.teal.withOpacity(0.3), blurRadius: 10),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.mosque_rounded,
                        color: Colors.teal,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // درجة الانحراف
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
                  ],
                ),
                child: Text(
                  'درجة الانحراف: ${diff.abs().toStringAsFixed(1)}°',
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusText(String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
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
            const Icon(Icons.location_off_rounded, size: 64, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text(
              _statusMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
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
