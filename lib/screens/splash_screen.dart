import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listify/screens/homepage_screen.dart';
import 'package:listify/screens/start_screen.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(authProvider);

    return Scaffold(
      body: userAsyncValue.when(
        data: (user) {
          Future.delayed(const Duration(seconds: 3), () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => user == null
                    ? const StartScreen()
                    : HomepageScreen(user: user),
              ),
                  (route) => false,
            );
          });

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo Image
                Container(
                  width: 256,
                  height: 232,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/logo.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Text Description
                const SizedBox(
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
                const SizedBox(height: 40),
                // Loading Indicator
                const CircularProgressIndicator(),
              ],
            ),
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stackTrace) {
          return Center(child: Text('Error: $error'));
        },
      ),
    );
  }
}
