import 'package:flutter/material.dart';

import 'login_screen.dart';

class ResetSuccessScreen extends StatelessWidget {
  const ResetSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 438,
          height: 971,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color(0x59000000),
                blurRadius: 50,
                offset: Offset(20, 20),
                spreadRadius: 0,
              )
            ],
          ),
          child: Stack(
            children: [
              // Background Layer
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 418.76,
                  height: 930.26,
                  decoration: const BoxDecoration(
                    color: Color(0xFF44404D),
                  ),
                ),
              ),
              // Title
              const Positioned(
                left: 60,
                top: 97,
                child: Text(
                  'RESET SUCCESSFULL',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFF5F5F5),
                    fontSize: 32,
                    fontFamily: 'Nunito Sans',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.23,
                  ),
                ),
              ),

              // Description Text
              const Positioned(
                left: 53,
                top: 678,
                child: SizedBox(
                  width: 328,
                  child: Text(
                    'Please sign in to Listify again with your new password',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFF5F5F5),
                      fontSize: 20,
                      fontFamily: 'Open Sans',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.23,
                    ),
                  ),
                ),
              ),

              // Sign-In Button
              Positioned(
                left: 61,
                top: 776,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                            (route) => false);
                  },
                  child: Container(
                    width: 312,
                    height: 56,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF1E1E2A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      shadows: const [
                        BoxShadow(
                          color: Color(0x4C000000),
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                        BoxShadow(
                          color: Color(0x26000000),
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'SIGN IN',
                        style: TextStyle(
                          color: Color(0xFFF5F5F5),
                          fontSize: 14,
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.10,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Placeholder Image
              const Positioned(
                left: 25,
                top: 212,
                child: SizedBox(
                  width: 382,
                  height: 399,
                  child: Image(
                    image: AssetImage("assets/images/resetPass.png"),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
