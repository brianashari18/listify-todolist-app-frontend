import 'package:flutter/material.dart';

class settingPage extends StatefulWidget {
  const settingPage({super.key});

  @override
  _settingPageState createState() => _settingPageState();
}

class _settingPageState extends State<settingPage> {
  bool moveCheckedItems = false;
  bool moveImportantItems = false;
  bool enableAI = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF393646), // Warna background
      appBar: AppBar(
        backgroundColor: const Color(0xFF393646),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        toolbarHeight: 90,
        title: const Text(
          "Settings",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          const SizedBox(height: 20),

          // Display Options Section
          const Text(
            "Display Options",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 28),
          SwitchListTile(
            title: const Text(
              "Move checked items to bottom",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            value: moveCheckedItems,
            onChanged: (bool value) {
              setState(() {
                moveCheckedItems = value;
              });
            },
            activeColor: const Color(0x007b7794),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFF393646),
          ),
          SwitchListTile(
            title: const Text(
              "Move important items to the top",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            value: moveImportantItems,
            onChanged: (bool value) {
              setState(() {
                moveImportantItems = value;
              });
            },
            activeColor: const Color(0x007b7794),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFF393646),
          ),

          const SizedBox(height: 50),

          // AI Options Section
          const Text(
            "AI Options",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          SwitchListTile(
            title: const Text(
              "Enable AI",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            value: enableAI,
            onChanged: (bool value) {
              setState(() {
                enableAI = value; // Update the state when toggle is changed
              });
            },
            activeColor: const Color(0x007b7794),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: const Color(0xFF393646),
          ),
        ],
      ),
    );
  }
}
