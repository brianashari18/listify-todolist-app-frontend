import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:listify/screens/verification_screen.dart';

import '../services/api_service.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  String? _emailError;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String email) {
    final RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  void _handleContinue() async {
    final email = _emailController.text.trim();
    if (_isValidEmail(email)) {
      setState(() {
        _emailError = null;
      });
      try {
        final requestBody = <String, dynamic>{
          "email": email,
        };

        final response = await ApiService.forgotPassword(
            "/api/users/forgot-password", requestBody);

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseBody = jsonDecode(response.body);
          print("Response: $responseBody");
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(responseBody["message"])));

          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => VerificationScreen(
                    email: email,
                  )));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Email is not exists")),
          );
          print("Error: ${response.body}");
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$e.")),
        );
        print("Exception: $e");
      }
    } else {
      setState(() {
        _emailError = 'Please enter a valid email address';
        FocusScope.of(context).requestFocus(FocusNode());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final fontSize = (deviceHeight * 0.05).clamp(24.0, 28.0);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: deviceHeight,
          padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'FORGET PASSWORD',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromRGBO(245, 245, 245, 1),
                ),
              ),
              const Text(
                'Enter your email account to\nreset password!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color.fromRGBO(245, 245, 245, 1),
                ),
              ),
              Image.asset(
                'assets/images/forgetPass.png',
                height: 350,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 16.0),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle: const TextStyle(
                            fontSize: 14,
                            color: Colors.black45,
                          ),
                          errorStyle: const TextStyle(
                            color: Colors.red,
                            shadows: [
                              Shadow(
                                offset: Offset(0.3, 0.3),
                                blurRadius: 2.0,
                                color: Colors.red,
                              ),
                            ],
                          ),
                          errorText: _emailError,
                          // Tampilkan pesan error jika ada
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _handleContinue();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(30, 30, 42, 1),
                          // Background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'CONTINUE',
                          style: TextStyle(
                            color: Color.fromRGBO(245, 245, 245, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color.fromRGBO(68, 64, 77, 1),
    );
  }
}
