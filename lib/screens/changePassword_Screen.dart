import 'package:flutter/material.dart';
import 'package:listify/screens/verification_screen.dart';

import '../services/auth_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _apiService = AuthService();
  bool _isContinue = false;

  String? _emailError;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
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
                'CHANGE PASSWORD',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromRGBO(245, 245, 245, 1),
                ),
              ),
              const Text(
                'Enter your email account to\nchange password!',
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
                        child: _isContinue
                            ? const CircularProgressIndicator()
                            : const Text(
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

  bool _isValidEmail(String email) {
    final RegExp emailRegex =
    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  void _handleContinue() async {
    setState(() {
      _isContinue = true;
    });

    final email = _emailController.text.trim();
    if (_isValidEmail(email)) {
      setState(() {
        _emailError = null;
      });

      final result = await _apiService.forgotPassword(email);

      setState(() {
        _isContinue = false;
      });

      if (result['success'] == 'true') {
        final message = result['message'];
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => VerificationScreen(email: email)),
        );
      } else {
        final errorMessage = result['error'];
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } else {
      setState(() {
        _isContinue = false;
        _emailError = 'Please enter a valid email address';
        FocusScope.of(context).requestFocus(FocusNode());
      });
    }
  }
}