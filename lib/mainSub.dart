import 'package:flutter/material.dart';
import 'package:listify/screens/subtask.dart'; // Import file subtask.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SubTask(), // Panggil kelas SubTask dari file subtask.dart
    );
  }
}
