import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:listify/screens/forget_password_screen.dart';
import 'package:listify/screens/homepage_personal_screen.dart';
import 'package:listify/screens/register_screen.dart';
import 'package:listify/services/google_service.dart';

import '../models/user_model.dart';
import '../services/api_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();
  final GoogleService _googleService = GoogleService();

  String? _emailError;
  bool _obscurePassword = true;
  bool _isMinLength = false;
  bool _hasUpperCase = false;
  bool _hasLowerCase = false;
  bool _hasNumber = false;
  bool _hasSpecialCharacter = false;
  bool _isSignIn = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'SIGN IN',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(68, 64, 77, 1),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Welcome back you've been missed!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(68, 64, 77, 1),
                    ),
                  ),
                  const SizedBox(height: 50),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(51, 51, 51, 1),
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
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      onChanged: _checkPassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(51, 51, 51, 1),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const ForgetPasswordScreen()));
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: const Text(
                          'Forgot your password?',
                          style: TextStyle(
                            color: Color.fromRGBO(68, 64, 77, 1),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Password must meet the following criteria:",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  _buildPasswordCriteria(
                    text: "Min. 8 characters",
                    isValid: _isMinLength,
                  ),
                  _buildPasswordCriteria(
                    text: "Include uppercase letter",
                    isValid: _hasUpperCase,
                  ),
                  _buildPasswordCriteria(
                    text: "Include lowercase letter",
                    isValid: _hasLowerCase,
                  ),
                  _buildPasswordCriteria(
                    text: "Include number",
                    isValid: _hasNumber,
                  ),
                  _buildPasswordCriteria(
                    text: "Include a special character",
                    isValid: _hasSpecialCharacter,
                  ),
                  const SizedBox(height: 75),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _validateInputs,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(68, 64, 77, 1),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: _isSignIn
                          ? const CircularProgressIndicator()
                          : const Text(
                              'SIGN IN',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(245, 245, 245, 1),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const RegisterScreen()));
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: const Text(
                          'Create new account',
                          style: TextStyle(
                            color: Color.fromRGBO(68, 64, 77, 1),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    'Or continue with',
                    style: TextStyle(color: Color.fromRGBO(68, 64, 77, 1)),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      _onLoginGoogle();
                      _googleService.logout();
                    },
                    child: Image.asset(
                      'assets/icons/google.png',
                      height: 40,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isValidEmail(String email) {
    final RegExp emailRegex =
        RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  void _checkPassword(String password) {
    setState(() {
      _isMinLength = password.length >= 8;
      _hasUpperCase = password.contains(RegExp(r'[A-Z]'));
      _hasLowerCase = password.contains(RegExp(r'[a-z]'));
      _hasNumber = password.contains(RegExp(r'\d'));
      _hasSpecialCharacter =
          password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  void _validateInputs() async {
    setState(() {
      _isSignIn = true;
    });

    final email = _emailController.text;
    final password = _passwordController.text;

    setState(() {
      _emailError = null;

      if (email.isEmpty || !_isValidEmail(email)) {
        _emailError = 'Enter a valid email address';
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });

    // Validasi Password
    if (_emailError == null &&
        _isMinLength &&
        _hasUpperCase &&
        _hasLowerCase &&
        _hasNumber &&
        _hasSpecialCharacter) {
      final result = await _apiService.login(email, password);
      if (result['success'] == 'true') {
        User user = User(
            id: result['id'],
            username: result['username'],
            email: result['email']);

        setState(() {
          _isSignIn = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign In Successfully')));
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePagePersonal(user: user)),
          (route) => false,
        );
      } else {
        final errorMessage = result['error'];
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } else {
      print('Login Failed');
    }

    setState(() {
      _isSignIn = false;
    });
  }

  Widget _buildPasswordCriteria({required String text, required bool isValid}) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.cancel,
          color: isValid ? Colors.green : Colors.red,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: isValid ? Colors.green : Colors.red,
            fontSize: 14,
            fontWeight: isValid ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  void _onLoginGoogle() async {
    final result = await _googleService.login();
    if (result['success'] == 'true') {
      User user = User(
          id: result['id'],
          username: result['username'],
          email: result['email']);

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign In Successfully')));
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomePagePersonal(user: user)),
            (route) => false,
      );
    } else {
      final errorMessage = result['error'];
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }
}
