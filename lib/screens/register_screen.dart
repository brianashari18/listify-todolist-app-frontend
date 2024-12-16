import 'package:flutter/material.dart';
import 'package:listify/screens/login_screen.dart';
<<<<<<< HEAD
import 'package:listify/services/api_service.dart';
// import 'package:listify/services/google_service.dart';
=======
import 'package:listify/services/auth_service.dart';
import 'package:listify/services/google_service.dart';
>>>>>>> f69d7969cbc75843704fd6d183e80b29594ca62e

import '../models/user_model.dart';
import 'homepage_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
<<<<<<< HEAD
  final ApiService _apiService = ApiService();
  // final GoogleService _googleService = GoogleService();
=======
  final AuthService _apiService = AuthService();
  final GoogleService _googleService = GoogleService();
>>>>>>> f69d7969cbc75843704fd6d183e80b29594ca62e

  String? _emailError;
  String? _usernameError;
  String? _passwordError;
  String? _confirmPasswordError;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isMinLength = false;
  bool _hasUpperCase = false;
  bool _hasLowerCase = false;
  bool _hasNumber = false;
  bool _hasSpecialCharacter = false;
  bool _isRegister = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
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
                    'SIGN UP',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(68, 64, 77, 1),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Create an account so you can manage your activities!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(68, 64, 77, 1),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(51, 51, 51, 1),
                        ),
                        errorText: _usernameError,
                        // Tampilkan pesan error jika ada
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
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
                  const SizedBox(height: 10),
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
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _confirmPassController,
                      // Use the controller for confirm password
                      obscureText: _obscureConfirmPassword,
                      // Use separate visibility for confirm password
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(51, 51, 51, 1),
                        ),
                        errorText: _confirmPasswordError,
                        // Display error message if passwords do not match
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.white,
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
                  const SizedBox(height: 20),
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
                      child: _isRegister
                          ? const CircularProgressIndicator()
                          : const Text(
                              'SIGN UP',
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromRGBO(245, 245, 245, 1),
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (builder) => const LoginScreen()));
                      },
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: const Text(
                          'Already have an account',
                          style: TextStyle(
                            color: Color.fromRGBO(68, 64, 77, 1),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Or continue with',
                    style: TextStyle(color: Color.fromRGBO(68, 64, 77, 1)),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      // _onLoginGoogle();
                      // _googleService.logout();
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
    _isRegister = true;

    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPassController.text;
    final username = _usernameController.text;

    setState(() {
      _emailError = null;
      _usernameError = null;
      _passwordError = null;
      _confirmPasswordError = null;

      if (email.isEmpty || !_isValidEmail(email)) {
        _emailError = 'Enter a valid email address';
        FocusScope.of(context).requestFocus(FocusNode());
      }

      if (username.isEmpty) {
        _usernameError = 'Username cannot be empty';
        FocusScope.of(context).requestFocus(FocusNode());
      } else if (username.length < 3) {
        _usernameError = "Username must be at least 3 characters";
        FocusScope.of(context).requestFocus(FocusNode());
      }
    });

    if (password != confirmPassword) {
      // Check if passwords match
      _confirmPasswordError = 'Passwords do not match';
      FocusScope.of(context).requestFocus(FocusNode());
    }

    // Validasi Password
    if (_emailError == null &&
        _usernameError == null &&
        _passwordError == null &&
        _confirmPasswordError == null &&
        _isMinLength &&
        _hasUpperCase &&
        _hasLowerCase &&
        _hasNumber &&
        _hasSpecialCharacter) {
      // Jika validasi berhasil, kirim data ke backend

      final result = await _apiService.register(
          email, username, password, confirmPassword);

      setState(() {
        _isRegister = false;
      });
      if (result['success'] == 'true') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sign Up Successfully')));
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      } else {
        final errorMessage = result['error'];
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } else {
      print('Registrasi Failed');
    }

    setState(() {
      _isRegister = false;
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

<<<<<<< HEAD
//   // void _onLoginGoogle() async {
//   //   final result = await _googleService.login();
//   //   if (result['success'] == 'true') {
//   //     User user = User(
//   //         id: result['id'],
//   //         username: result['username'],
//   //         email: result['email']);
//   //
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //         const SnackBar(content: Text('Sign In Successfully')));
//   //     Navigator.of(context).pushAndRemoveUntil(
//   //       MaterialPageRoute(builder: (context) => HomePagePersonal(user: user)),
//   //           (route) => false,
//   //     );
//     } else {
//       final errorMessage = result['error'];
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text(errorMessage)));
//     }
//   }
=======
  void _onLoginGoogle() async {
    final result = await _googleService.login();
    if (result['success'] == 'true') {
      User user = result['user'];
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign In Successfully')));
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomepageScreen(user: user)),
            (route) => false,
      );
    } else {
      final errorMessage = result['error'];
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }
>>>>>>> f69d7969cbc75843704fd6d183e80b29594ca62e
}
