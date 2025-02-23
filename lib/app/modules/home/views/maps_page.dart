import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tes1/app/modules/home/controllers/maps_controller.dart';

class MapsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mapscontroller = Get.put(MapsController()); // Inisialisasi Controller

    return Scaffold(
      appBar: AppBar(
        title: Text('Location & Navigation'),
        backgroundColor: Colors.black, // Warna background AppBar hitam
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.red.shade700, Colors.black45],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Background dengan garis lembut dan ekspresif
            CustomPaint(
              painter: _ExpressivePainter(),
              child: Container(),
            ),
            // Menempatkan child widget di tengah
            Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Explore Bioskop Locations',
                      style: TextStyle(
                        fontSize: 32,
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        mapscontroller
                            .openStoreLocation(); // Lokasi tetap bioskop
                      },
                      child: Text("Show Bioskop Location"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 236, 22,
                            18), // Tombol dengan warna merah halus
                        foregroundColor:
                            Colors.white, // Mengubah warna teks menjadi putih
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20), // Tombol dengan sudut melengkung
                        ),
                        textStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        try {
                          // Mendapatkan lokasi saat ini
                          await mapscontroller.getCurrentLocation();

                          // Menampilkan lokasi saat ini menggunakan snackbar
                          Get.snackbar(
                            "Current Location",
                            "Latitude: ${mapscontroller.currentLocation.value?.latitude}, "
                                "Longitude: ${mapscontroller.currentLocation.value?.longitude}",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.black.withOpacity(0.7),
                            colorText: Colors.white,
                            snackStyle: SnackStyle.GROUNDED,
                          );

                          // Navigasi ke bioskop
                          mapscontroller.navigateToStore();
                        } catch (e) {
                          // Menampilkan error jika gagal mengambil lokasi
                          Get.snackbar("Error", e.toString(),
                              snackPosition: SnackPosition.BOTTOM);
                        }
                      },
                      child: Text("Navigate to Bioskop"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 236, 22, 18),
                        foregroundColor:
                            Colors.white, // Tombol dengan warna merah halus
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              20), // Tombol dengan sudut melengkung
                        ),
                        textStyle: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// CustomPainter untuk background dengan garis lembut dan ekspresif
class _ExpressivePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color.fromARGB(255, 58, 57, 57)
          .withOpacity(0.3) // Warna merah lembut dengan transparansi
      ..style = PaintingStyle.fill;

    // Membuat pola garis lembut dan ekspresif
    for (double i = 0; i < size.width; i += 80) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(size.width - i, size.height),
        paint,
      );
    }

    // Garis diagonal lembut dengan sedikit transparansi
    final Paint diagonalPaint = Paint()
      ..color = Colors.red.shade500.withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..strokeWidth = 2;

    for (double i = 0; i < size.width; i += 100) {
      canvas.drawLine(
        Offset(i, size.height - i),
        Offset(size.width - i, i),
        diagonalPaint,
      );
    }

    // Gambar tambahan garis tipis dengan efek transparansi
    final Paint softLinePaint = Paint()
      ..color = Colors.red.shade600.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    for (double i = 0; i < size.height; i += 120) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        softLinePaint,
      );
    }

    // Menambahkan gradient halus untuk memperkaya latar belakang
    final Gradient gradient = LinearGradient(
      colors: [
        const Color.fromARGB(255, 231, 28, 25).withOpacity(0.4),
        const Color.fromARGB(255, 28, 27, 27).withOpacity(0.4)
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Paint gradientPaint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, gradientPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
