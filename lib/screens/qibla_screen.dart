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
  // إحداثيات الكعبة المشرفة
  static const double _kaabaLat = 21.422487;
  static const double _kaabaLng = 39.826206;

  bool _hasPermission = false;
  bool _isLoading = true;

  String _statusMessage = 'جاري تحديد موقعك...';

  Position? _currentPosition;

  /// Bearing القبلة الحقيقي من موقع المستخدم
  double? _qiblaBearing;

  /// اتجاه الهاتف بالنسبة للشمال
  double? _heading;

  /// اتجاه الهاتف بعد التنعيم
  double? _smoothedHeading;

  bool _hasVibrated = false;

  // Low Pass Filter
  static const double _filterAlpha = 0.15;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  // ============================================================
  // التهيئة
  // ============================================================

  Future<void> _initialize() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _hasPermission = false;
      _statusMessage = 'جاري طلب صلاحية الموقع...';
    });

    try {
      // التحقق من خدمة الموقع
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (!mounted) return;

        setState(() {
          _isLoading = false;
          _statusMessage =
              'خدمة الموقع غير مفعلة.\nيرجى تشغيل GPS ثم المحاولة مرة أخرى.';
        });

        return;
      }

      // التحقق من الصلاحيات
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        if (!mounted) return;

        setState(() {
          _isLoading = false;
          _statusMessage =
              'لا يمكن تحديد القبلة بدون السماح بالوصول إلى الموقع.';
        });

        return;
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;

        setState(() {
          _isLoading = false;
          _statusMessage =
              'صلاحية الموقع مرفوضة نهائيًا.\n'
              'افتح إعدادات التطبيق واسمح بالوصول إلى الموقع.';
        });

        return;
      }

      // الحصول على الموقع
      if (!mounted) return;

      setState(() {
        _statusMessage = 'جاري الحصول على موقعك بدقة...';
      });

      Position? position;

      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 0,
          ),
          timeLimit: const Duration(seconds: 15),
        );
      } catch (_) {
        // استخدام آخر موقع معروف إذا فشل GPS
        position = await Geolocator.getLastKnownPosition();
      }

      if (position == null) {
        if (!mounted) return;

        setState(() {
          _isLoading = false;
          _statusMessage =
              'تعذر الحصول على موقعك.\n'
              'تأكد من تشغيل GPS وأنك في مكان مفتوح.';
        });

        return;
      }

      // حساب اتجاه القبلة من موقع المستخدم
      final qiblaBearing = _calculateQiblaBearing(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      setState(() {
        _currentPosition = position;
        _qiblaBearing = qiblaBearing;
        _hasPermission = true;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _statusMessage =
            'حدث خطأ أثناء تحديد الموقع.\n'
            'يرجى المحاولة مرة أخرى.';
      });
    }
  }

  // ============================================================
  // حساب Bearing القبلة
  // ============================================================

  double _calculateQiblaBearing(
    double userLat,
    double userLng,
  ) {
    final lat1 = _degreesToRadians(userLat);
    final lat2 = _degreesToRadians(_kaabaLat);

    final deltaLng =
        _degreesToRadians(_kaabaLng - userLng);

    final y = math.sin(deltaLng) * math.cos(lat2);

    final x =
        math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) *
            math.cos(lat2) *
            math.cos(deltaLng);

    final bearing =
        math.atan2(y, x) * 180.0 / math.pi;

    return _normalizeAngle(bearing);
  }

  double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180.0;
  }

  // ============================================================
  // تطبيع الزاوية إلى 0 - 360
  // ============================================================

  double _normalizeAngle(double angle) {
    final normalized = angle % 360.0;

    if (normalized < 0) {
      return normalized + 360.0;
    }

    return normalized;
  }

  // ============================================================
  // حساب أقصر فرق زاوي بين الهاتف والقبلة
  //
  // النتيجة من -180 إلى +180
  // ============================================================

  double _angleDifference(
    double target,
    double current,
  ) {
    double difference = target - current;

    while (difference > 180) {
      difference -= 360;
    }

    while (difference < -180) {
      difference += 360;
    }

    return difference;
  }

  // ============================================================
  // تنعيم اتجاه الهاتف
  //
  // مهم:
  // نقوم بتنعيم Heading الهاتف وليس Bearing القبلة.
  // ============================================================

  double _smoothHeading(double newHeading) {
    newHeading = _normalizeAngle(newHeading);

    if (_smoothedHeading == null) {
      _smoothedHeading = newHeading;
      return newHeading;
    }

    final difference = _angleDifference(
      newHeading,
      _smoothedHeading!,
    );

    _smoothedHeading = _normalizeAngle(
      _smoothedHeading! + (_filterAlpha * difference),
    );

    return _smoothedHeading!;
  }

  // ============================================================
  // الاهتزاز عند الوصول للقبلة
  // ============================================================

  void _handleHaptic(bool facingQibla) {
    if (facingQibla) {
      if (!_hasVibrated) {
        HapticFeedback.mediumImpact();
        _hasVibrated = true;
      }
    } else {
      _hasVibrated = false;
    }
  }

  // ============================================================
  // اتجاه السهم
  //
  // نريد أن يشير السهم دائمًا من مركز الشاشة إلى القبلة.
  //
  // إذا كان الهاتف متجهًا شمالًا:
  // القبلة تظهر حسب Bearing القبلة.
  //
  // إذا تحرك الهاتف:
  // نطرح Heading الهاتف من Bearing القبلة.
  // ============================================================

  double _getArrowRotation(
    double qiblaBearing,
    double heading,
  ) {
    final difference = _angleDifference(
      qiblaBearing,
      heading,
    );

    return _degreesToRadians(difference);
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2E7D32),
              Color(0xFF42A5F5),
              Color(0xFFF5F5F5),
            ],
            stops: [
              0.0,
              0.5,
              1.0,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),

              Expanded(
                child: _isLoading
                    ? _buildLoading()
                    : !_hasPermission
                        ? _buildPermissionView()
                        : _buildQiblaCompass(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Header
  // ============================================================

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black87,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
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
    );
  }

  // ============================================================
  // Loading
  // ============================================================

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: Colors.teal,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Text(
              _statusMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Compass
  // ============================================================

  Widget _buildQiblaCompass() {
    return StreamBuilder<QiblahDirection>(
      stream: FlutterQiblah.qiblahStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _buildStatusText(
            'تعذر قراءة حساس البوصلة.\n'
            'تأكد من أن جهازك يحتوي على Magnetometer.',
          );
        }

        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.teal,
            ),
          );
        }

        final data = snapshot.data;

        if (data == null) {
          return _buildStatusText(
            'لم تصل قراءة من حساس البوصلة.',
          );
        }

        if (_qiblaBearing == null) {
          return _buildStatusText(
            'لم يتم حساب اتجاه القبلة بعد.',
          );
        }

        // --------------------------------------------------------
        // قراءة اتجاه الهاتف من الحساس
        //
        // flutter_qiblah يوفر اتجاه الجهاز.
        // لا نستخدم qiblahDirection.qiblah هنا.
        // --------------------------------------------------------

        final rawHeading = _normalizeAngle(
          data.direction,
        );

        final heading = _smoothHeading(rawHeading);

        _heading = heading;

        // --------------------------------------------------------
        // حساب الفرق الحقيقي بين الهاتف والقبلة
        // --------------------------------------------------------

        final difference = _angleDifference(
          _qiblaBearing!,
          heading,
        );

        final absoluteDifference =
            difference.abs();

        // أقل من 5 درجات = مواجهة القبلة
        final isFacingQibla =
            absoluteDifference <= 5.0;

        _handleHaptic(isFacingQibla);

        final activeColor = isFacingQibla
            ? Colors.green
            : Colors.teal;

        // --------------------------------------------------------
        // دوران السهم
        // --------------------------------------------------------

        final arrowRotation =
            _getArrowRotation(
          _qiblaBearing!,
          heading,
        );

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 10),

              _buildCalibrationWarning(),

              const SizedBox(height: 18),

              _buildQiblaStatus(
                isFacingQibla,
                activeColor,
              ),

              const SizedBox(height: 28),

              _buildCompass(
                arrowRotation,
                activeColor,
              ),

              const SizedBox(height: 28),

              _buildDataCard(
                difference,
                absoluteDifference,
                activeColor,
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // ============================================================
  // Calibration warning
  // ============================================================

  Widget _buildCalibrationWarning() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.amber.shade300,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.explore_rounded,
            color: Colors.amber.shade900,
            size: 22,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'للدقة الأفضل، أبعد الهاتف عن المعادن '
              'والسيارات والأجهزة الإلكترونية. '
              'وإذا كانت البوصلة غير مستقرة حرّك الهاتف '
              'بحركة رقم 8 لمعايرة الحساس.',
              style: TextStyle(
                color: Colors.amber.shade900,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Qibla status
  // ============================================================

  Widget _buildQiblaStatus(
    bool isFacingQibla,
    Color activeColor,
  ) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 250,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: activeColor.withOpacity(0.5),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: activeColor.withOpacity(0.12),
            blurRadius: 14,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isFacingQibla
                ? Icons.check_circle_rounded
                : Icons.navigation_rounded,
            color: activeColor,
            size: 23,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              isFacingQibla
                  ? 'أنت تواجه القبلة 🕋'
                  : 'وجّه الهاتف باتجاه السهم',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Compass UI
  // ============================================================

  Widget _buildCompass(
    double arrowRotation,
    Color activeColor,
  ) {
    return SizedBox(
      width: 320,
      height: 320,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // الدائرة الخارجية
          Container(
            width: 310,
            height: 310,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: activeColor.withOpacity(0.12),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),

          // الدائرة الداخلية
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.grey.shade300,
                width: 2,
              ),
            ),
          ),

          // علامات الاتجاهات
          _buildDirectionLabels(),

          // سهم القبلة
          AnimatedRotation(
            turns: arrowRotation / (2 * math.pi),
            duration: const Duration(
              milliseconds: 180,
            ),
            curve: Curves.easeOutCubic,
            child: SizedBox(
              width: 270,
              height: 270,
              child: Column(
                children: [
                  const SizedBox(height: 15),

                  Icon(
                    Icons.navigation_rounded,
                    size: 62,
                    color: activeColor,
                  ),

                  Expanded(
                    child: Container(
                      width: 3,
                      margin: const EdgeInsets.only(
                        bottom: 15,
                      ),
                      decoration: BoxDecoration(
                        color:
                            activeColor.withOpacity(0.35),
                        borderRadius:
                            BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // المركز
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.teal,
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color:
                      Colors.teal.withOpacity(0.35),
                  blurRadius: 12,
                ),
              ],
            ),
            child: const Icon(
              Icons.mosque_rounded,
              color: Colors.teal,
              size: 30,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Direction labels
  // ============================================================

  Widget _buildDirectionLabels() {
    return SizedBox(
      width: 275,
      height: 275,
      child: Stack(
        children: [
          const Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'N',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          ),

          const Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 8),
              child: Text(
                'E',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
          ),

          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Text(
                'S',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
          ),

          const Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(
                'W',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // Data card
  // ============================================================

  Widget _buildDataCard(
    double difference,
    double absoluteDifference,
    Color activeColor,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDataRow(
            'زاوية القبلة',
            '${_qiblaBearing?.toStringAsFixed(1) ?? '--'}°',
          ),

          const Divider(height: 22),

          _buildDataRow(
            'اتجاه الهاتف',
            '${_heading?.toStringAsFixed(1) ?? '--'}°',
          ),

          const Divider(height: 22),

          _buildDataRow(
            'الانحراف عن القبلة',
            '${absoluteDifference.toStringAsFixed(1)}°',
            valueColor: activeColor,
          ),

          const SizedBox(height: 10),

          _buildDirectionHint(difference),
        ],
      ),
    );
  }

  Widget _buildDataRow(
    String title,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 13,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.black87,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // اتجاه الدوران المطلوب
  // ============================================================

  Widget _buildDirectionHint(double difference) {
    if (difference.abs() <= 5) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: Colors.green.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          'القبلة أمامك مباشرة 🕋',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.green.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    final direction =
        difference > 0 ? 'يمين' : 'يسار';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'حرّك الهاتف $direction '
        '${difference.abs().toStringAsFixed(1)}°',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.teal.shade800,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // ============================================================
  // Status
  // ============================================================

  Widget _buildStatusText(String text) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.grey.shade800,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // Permission screen
  // ============================================================

  Widget _buildPermissionView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_off_rounded,
              size: 70,
              color: Colors.redAccent,
            ),

            const SizedBox(height: 18),

            Text(
              _statusMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 26),

            ElevatedButton.icon(
              onPressed: _initialize,
              icon: const Icon(Icons.refresh),
              label: const Text(
                'إعادة المحاولة',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
