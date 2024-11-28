import 'package:flutter/material.dart';
import 'package:listify/screens/FAQ_screen.dart';
import 'package:listify/screens/Feedback_screen.dart';

class HelpCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF393646), // Warna background
      appBar: AppBar(
        backgroundColor: const Color(0xFF393646), // Sama dengan warna background
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        toolbarHeight: 90,
        title: const Text(
          "Help Center",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),

      body: ListView(
        children: [
          Expanded(
            flex: 3,
            child: Center(
              child:
              Image.asset(
                'assets/images/help.png',
                height: 300,
              ),

            ),
          ),
          const SizedBox(height: 40),
          // Item Feedback
          ListTile(
            leading: Image.asset(
              'assets/images/feedback.png', // Path gambar di folder assets
              width: 50, // Lebar gambar
              height: 50, // Tinggi gambar
              color: Colors.white, // Opsional: Memberikan warna overlay (jika mendukung)
            ),

            title: const Text(
              "Feedback",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 15),
            contentPadding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0), // Atur padding
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FeedbackPage(),
                ),
              );
            },
          ),

          // Item FAQ
          ListTile(
            leading: Image.asset(
              'assets/images/faq.png', // Path gambar di folder assets
              width: 50, // Lebar gambar
              height: 50, // Tinggi gambar
              color: Colors.white, // Opsional: Memberikan warna overlay (jika mendukung)
            ),
            title: const Text(
              "FAQ",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 15),
            contentPadding: const EdgeInsets.symmetric(horizontal: 50.0), // Atur padding
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FAQPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

