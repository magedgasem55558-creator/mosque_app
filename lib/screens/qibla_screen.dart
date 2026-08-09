import 'package:flutter/material.dart';
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
        _statusMessage = 'يتطلب تحديد القبلة السماح لصلاحية الموقع.';
      });
      return;
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _isLoading = false;
        _hasPermission = false;
        _statusMessage = 'يرجى تفعيل خدمة الموقع (GPS) في الهاتف.';
      });
      return;
    }

    setState(() {
      _hasPermission = true;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('اتجاه القبلة'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : !_hasPermission
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _statusMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 16, color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                          onPressed: _checkLocationPermission,
                          child: const Text('إعادة المحاولة',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                )
              : StreamBuilder<QiblahDirection>(
                  stream: FlutterQiblah.qiblahStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                          child: Text('حدث خطأ أثناء قراءة الحساسات'));
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(color: Colors.teal));
                    }

                    final qiblahDirection = snapshot.data;
                    if (qiblahDirection == null) {
                      return const Center(
                          child: Text('جهازك لا يحتوي على حساس البوصلة'));
                    }

                    // حساب الزاوية المطلوبة لتدوير الإبرة نحو القبلة
                    double qiblahAngle = qiblahDirection.qiblah;
                    bool isFacingQiblah = (qiblahDirection.offset.abs() < 3.0);

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isFacingQiblah
                              ? 'أنت تتجه نحو القبلة تماماً 🕋'
                              : 'قم بتدوير الهاتف نحو السهم',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isFacingQiblah
                                ? Colors.green.shade700
                                : Colors.teal,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 280,
                                height: 280,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.teal.withOpacity(0.05),
                                  border: Border.all(
                                    color: isFacingQiblah
                                        ? Colors.green
                                        : Colors.teal,
                                    width: 4,
                                  ),
                                ),
                              ),
                              Transform.rotate(
                                angle: (qiblahAngle * (3.141592653589793 / 180)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.navigation_rounded,
                                      size: 100,
                                      color: isFacingQiblah
                                          ? Colors.green.shade700
                                          : Colors.teal,
                                    ),
                                    const SizedBox(height: 10),
                                    const Icon(
                                      Icons.mosque_rounded,
                                      size: 32,
                                      color: Colors.amber,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          'زاوية القبلة: ${qiblahDirection.offset.toStringAsFixed(1)}°',
                          style: TextStyle(
                              color: Colors.grey.shade700, fontSize: 15),
                        ),
                      ],
                    );
                  },
                ),
    );
  }
}
