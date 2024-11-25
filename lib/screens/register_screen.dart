import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:convert'; // Untuk mengubah data ke format JSON
import 'package:http/http.dart' as http;

class RegisterScreen extends StatefulWidget{
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    super.dispose();
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

    if (password != confirmPassword) {  // Check if passwords match
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
      try {
        final responseInput = await http.post(
          Uri.parse("http://localhost:8080/api/users/register"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "username": username,
            "email": email,
            "password": password
          }),
        );

        if (responseInput.statusCode == 200) {
          // Login berhasil
          final responseData = jsonDecode(responseInput.body);
          final message = responseData['message']?? 'Login successful';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Login Successful: $message")),
          );
          print("Response: ${responseInput.body}");
        } else {
          // Login gagal
          final responseData = jsonDecode(responseInput.body);
          final error = responseData['error']?? 'Unknown error';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Login Failed: $error")),
          );
          print("Error: ${responseInput.body}");
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("An error occurred. Please try again.")),
        );
        print("Exception: $e");
      }
    } else {
      print('Login Failed');
    }
  }

  Widget _buildPasswordCriteria({required String text, required bool isValid}) {
    return Row(
      children: [
        Icon(
          isValid? Icons.check_circle : Icons.cancel,
          color: isValid? Colors.green : Colors.red,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            color: isValid? Colors.green : Colors.red,
            fontSize: 14,
            fontWeight: isValid? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Future<void> _signUpWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // If the user cancels the login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Google Sign-In canceled")),
        );
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Get the tokens for backend or Firebase authentication
      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;

      final responseGoogle = await http.post(
        Uri.parse("http://localhost:8080/api/users/register"), // Use HTTPS for security
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": googleUser.displayName,
          "email": googleUser.email,
          "idToken": idToken,
          "accessToken": accessToken,
        }),
      );

      if (responseGoogle.statusCode == 200) {
        // If the login/registration was successful
        final responseData = jsonDecode(responseGoogle.body);
        final message = responseData['message'] ?? 'Registration successful';

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration Successful: $message")),
        );

        // Optionally, navigate to another screen or update UI here
        print("Response: ${responseGoogle.body}");
      } else {
        // Handle error if the backend response is not 200
        final responseData = jsonDecode(responseGoogle.body);
        final error = responseData['error'] ?? 'Unknown error occurred';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $error")),
        );
        print("Error: ${responseGoogle.body}");
      }
    } catch (error) {
      // Handle any exceptions (e.g., network errors or API failures)
      print("Google Sign-In failed: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Google Sign-In failed")),
      );
    }
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
                        errorText: _usernameError, // Tampilkan pesan error jika ada
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
                        errorText: _emailError, // Tampilkan pesan error jika ada
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
                      controller: _confirmPassController,  // Use the controller for confirm password
                      obscureText: _obscureConfirmPassword,    // Use separate visibility for confirm password
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          color: Color.fromRGBO(51, 51, 51, 1),
                        ),
                        errorText: _confirmPasswordError,  // Display error message if passwords do not match
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
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
                      child: const Text(
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
                        // Tambahkan aksi untuk pendaftaran akun baru
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
                  const SizedBox(height: 20),
                  const Text(
                    'Or continue with',
                    style: TextStyle(
                        color: Color.fromRGBO(68, 64, 77, 1)
                    ),
                  ),
                  const SizedBox(height: 15),
                  GestureDetector(
                    onTap: _signUpWithGoogle,
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
}