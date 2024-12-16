import 'package:flutter/material.dart';
import 'package:listify/screens/FAQ_screen.dart';
import 'package:listify/screens/Feedback_screen.dart';
import 'package:listify/screens/about_screen.dart';
// import 'package:listify/screens/forgetPassword_Screen.dart';
import 'package:listify/screens/helpCenter_screen.dart';
// import 'package:listify/screens/homepagePersonal_screen.dart';
// import 'package:listify/screens/homepageWorkspace_screen.dart';
import 'package:listify/screens/login_screen.dart';
import 'package:listify/screens/register_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:listify/screens/search-filter.dart';
import 'package:listify/screens/setting_screen.dart';
import 'package:listify/screens/start_screen.dart';
import 'package:listify/screens/subtask_screen.dart';
// import 'package:listify/screens/subtask.dart';
import 'package:listify/screens/search-filter.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: SubTask(),
    );
  }
}


