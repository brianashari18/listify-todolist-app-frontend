import 'package:flutter/material.dart';


class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF393646), // Background color
      appBar: AppBar(
        backgroundColor: const Color(0xFF393646), // Same as background
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Action for back button
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "About",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: Center(
                child:
                Image.asset(
                  'assets/images/aboutt.png',
                  height: 300,
                ),
              ),
            ),
            const Expanded(
              flex: 3,
              child: SingleChildScrollView(
                child: Text(
                  'Listify is an AI-powered To-Do List application. Users of the software can create task lists, make changes to task lists, search and filter, add tasks, modify tasks, use user accounts, manage workspace access permissions, create workspaces with other users, and receive AI recommendations.\n\n'
                      'Listify is an AI-powered task management tool designed to simplify your life. With Listify, you can effortlessly create, organize, and prioritize your tasks. Our advanced AI provides intelligent recommendations, helping you stay focused on what matters most. Collaborate seamlessly with your team by creating shared workspaces, assigning tasks, and tracking progress in real-time. Whether you\'re a busy professional, a student, or simply someone looking to boost their productivity, Listify is the perfect solution. Experience the future of task management today.',
                  style: TextStyle(color: Colors.white, fontSize: 14),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
