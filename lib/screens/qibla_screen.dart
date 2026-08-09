import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  bool hasPermission = false;
  // قائمة لتخزين آخر 5 زوايا لتصفية التذبذب
  final List<double> _angleHistory = [];
  static const int _historyLength = 5;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Geolocator.openLocationSettings();
      return;
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }

    if (permission == LocationPermission.deniedForever) {
      Geolocator.openAppSettings();
      return;
    }

    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      if (mounted) setState(() => hasPermission = true);
    }
  }

  /// تطبيق مرشح متوسط متحرك على الزوايا
  double _smoothAngle(double newAngle) {
    _angleHistory.add(newAngle);
    if (_angleHistory.length > _historyLength) {
      _angleHistory.removeAt(0);
    }
    // حساب المتوسط مع مراعاة الطبيعة الدائرية للزوايا (لتفادي القفزات بين 359 و 0)
    double sumSin = 0.0, sumCos = 0.0;
    for (var angle in _angleHistory) {
      final rad = angle * pi / 180;
      sumSin += sin(rad);
      sumCos += cos(rad);
    }
    final avgRad = atan2(sumSin, sumCos);
    return (avgRad * 180 / pi) % 360;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topCenter,
            radius: 1.2,
            colors: [
              Color(0xFF0A0E27),
              Color(0xFF1A1F3D),
              Color(0xFF05070F),
            ],
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: !hasPermission
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_off, size: 80, color: Colors.grey[600]),
                    const SizedBox(height: 16),
                    Text(
                      'تفعيل صلاحية الموقع',
                      style: GoogleFonts.cairo(
                        color: Colors.white70,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.location_searching, color: Colors.white),
                      label: const Text('منح الصلاحية'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.tealAccent[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: _checkPermission,
                    ),
                  ],
                ),
              )
            : StreamBuilder<QiblahDirection>(
                stream: FlutterQiblah.qiblahStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFE6C87C),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'حدث خطأ: ${snapshot.error}',
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    );
                  }

                  final qiblahData = snapshot.data!;
                  // زاوية القبلة الخام من الشمال
                  final rawQiblaAngle = qiblahData.qiblah;
                  // اتجاه الهاتف الحالي
                  final deviceHeading = qiblahData.direction;
                  // دقة المستشعر (قد تكون null)
                  final accuracy = qiblahData.accuracy;

                  // حساب الزاوية المطلوبة لتدوير السهم
                  double rawRotation = (rawQiblaAngle - deviceHeading) % 360;
                  if (rawRotation < 0) rawRotation += 360;

                  // تطبيق التصفية للحصول على زاوية ناعمة
                  final smoothRotation = _smoothAngle(rawRotation);

                  // زاوية القبلة الفعلية (نعرضها بدقة)
                  final displayQibla = rawQiblaAngle;

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // العنوان
                        Text(
                          'اتجاه القبلة',
                          style: GoogleFonts.cairo(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFE6C87C),
                            shadows: const [
                              Shadow(
                                blurRadius: 15,
                                color: Color(0xFFE6C87C),
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        // حالة الدقة
                        if (accuracy != null)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                accuracy >= 5
                                    ? Icons.wifi_off
                                    : Icons.wifi_find,
                                color: accuracy >= 5 ? Colors.orange : Colors.green,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                accuracy >= 5
                                    ? 'دقة منخفضة – حرك الهاتف بشكل ∞'
                                    : 'دقة عالية',
                                style: TextStyle(
                                  color: accuracy >= 5
                                      ? Colors.orangeAccent
                                      : Colors.greenAccent,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 20),

                        // البوصلة المزخرفة
                        SizedBox(
                          width: 280,
                          height: 280,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // الخلفية الدائرية المتدرجة
                              Container(
                                width: 280,
                                height: 280,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const RadialGradient(
                                    colors: [
                                      Color(0xFF2A2F4A),
                                      Color(0xFF12152A),
                                    ],
                                    radius: 0.8,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFE6C87C)
                                          .withOpacity(0.2),
                                      blurRadius: 40,
                                      spreadRadius: 10,
                                    ),
                                  ],
                                ),
                              ),
                              // دوائر متحدة المركز
                              ...List.generate(3, (index) {
                                final radius = 60 + index * 50;
                                return Container(
                                  width: radius * 2,
                                  height: radius * 2,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFFE6C87C)
                                          .withOpacity(0.15),
                                      width: 1,
                                    ),
                                  ),
                                );
                              }),
                              // علامات الاتجاهات
                              const Positioned(
                                top: 10,
                                child: Text(
                                  'شمال',
                                  style: TextStyle(
                                    color: Color(0xFFE6C87C),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                child: Text(
                                  'جنوب',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 10,
                                child: Text(
                                  'غرب',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 10,
                                child: Text(
                                  'شرق',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.5),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              // السهم الدوار مع تأثير التوهج
                              Transform.rotate(
                                angle: smoothRotation * pi / 180,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // وهج خلف السهم
                                    Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFFE6C87C)
                                                .withOpacity(0.35),
                                            blurRadius: 40,
                                            spreadRadius: 15,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.navigation,
                                      size: 80,
                                      color: Color(0xFFE6C87C),
                                    ),
                                  ],
                                ),
                              ),
                              // نقطة المركز
                              Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE6C87C),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFFE6C87C),
                                      blurRadius: 12,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // بطاقة المعلومات
                        Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 24,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF1E2340),
                                Color(0xFF0F1228),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: const Color(0xFFE6C87C).withOpacity(0.3),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFE6C87C).withOpacity(0.05),
                                blurRadius: 15,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(
                                '${displayQibla.toStringAsFixed(1)}°',
                                style: GoogleFonts.cairo(
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFFE6C87C),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'درجة القبلة (من الشمال)',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildInfoChip(
                                    icon: Icons.compass_calibration,
                                    label: 'اتجاه الهاتف',
                                    value: '${deviceHeading.toStringAsFixed(1)}°',
                                  ),
                                  _buildInfoChip(
                                    icon: Icons.location_pin,
                                    label: 'زاوية الانحراف',
                                    value: '${smoothRotation.toStringAsFixed(1)}°',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                        Text(
                          'أدر هاتفك حتى يتجه السهم نحو القبلة',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFE6C87C), size: 18),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 11,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
