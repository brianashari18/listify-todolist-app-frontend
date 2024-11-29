import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Menambahkan delay 3 detik untuk tampilan splash screen
    Future.delayed(const Duration(seconds: 3), () {
      // Setelah 3 detik, navigasikan ke layar berikutnya (misalnya HomeScreen)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                HomeScreen()), // Ganti dengan screen yang sesuai
      );
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5), // Warna latar belakang utama
        ),
        child: Stack(
          children: [
            // Background Color Layer
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F5F5),
                ),
              ),
            ),

            // Image Placeholder
            Positioned(
              left: 97,
              top: 279,
              child: Container(
                width: 256,
                height: 232,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage("https://via.placeholder.com/256x232"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            // Text Description
            const Positioned(
              left: 22,
              top: 529,
              child: SizedBox(
                width: 396,
                child: Text(
                  'Let’s make your to-dos easier to manage and more fun to complete!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF44404D),
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Contoh HomeScreen yang akan tampil setelah splashscreen
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Center(child: const Text('Welcome to the Home Screen!')),
    );
  }
}
