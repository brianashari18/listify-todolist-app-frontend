import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
// import 'package:listify/screens/forgetPassword_Screen.dart';
// import 'package:listify/screens/homepagePersonal_screen.dart';
// import 'package:listify/screens/homepageWorkspace_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:listify/screens/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null); // Inisialisasi untuk Bahasa Indonesia
  await dotenv.load(fileName: ".env");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Listify',
        theme: ThemeData(
          cardColor: const Color(0xFF7B7794),
          primaryColorDark: const Color(0xFF44404D),
          primaryColorLight: const Color(0xFFF5F5F5),
          primaryColor: const Color(0xFF1E1E2A),
          primaryTextTheme: GoogleFonts.openSansTextTheme(),
          textTheme: GoogleFonts.nunitoTextTheme(),
          useMaterial3: true,
        ),
        home: SplashScreen());
  }
}
