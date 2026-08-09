import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  bool hasPermission = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text("اتجاه القبلة", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: !hasPermission
          ? Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.location_searching),
                label: const Text("تفعيل الصلاحية"),
                onPressed: _checkPermission,
              ),
            )
          : StreamBuilder<QiblahDirection>(
              stream: FlutterQiblah.qiblahStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.tealAccent),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text("خطأ في تحديد الاتجاه",
                        style: TextStyle(color: Colors.red)),
                  );
                }

                final qiblahData = snapshot.data!;
                final qiblaAngle = qiblahData.qiblah; // درجة القبلة من الشمال
                final deviceHeading = qiblahData.direction; // اتجاه الهاتف الحالي
                
                // الزاوية التي يجب تدوير السهم بها (بالدرجات) ليواجه القبلة
                final rotationAngle = (qiblaAngle - deviceHeading) % 360;
                final rotationInRadians = rotationAngle * (pi / 180);

                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${qiblaAngle.toInt()}°",
                        style: const TextStyle(
                          color: Colors.tealAccent,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 300,
                        height: 300,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 280,
                              height: 280,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white24, width: 2),
                              ),
                            ),
                            const Positioned(
                              top: 10,
                              child: Text(
                                'N',
                                style: TextStyle(color: Colors.white54, fontSize: 18),
                              ),
                            ),
                            Transform.rotate(
                              angle: rotationInRadians,
                              child: const Icon(
                                Icons.navigation,
                                size: 120,
                                color: Colors.tealAccent,
                              ),
                            ),
                            const CircleAvatar(
                              radius: 5,
                              backgroundColor: Colors.tealAccent,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "السهم يشير إلى القبلة (${qiblaAngle.toInt()}°)",
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "وجه هاتفك نحو الشمال، السهم سيتجه للقبلة",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
