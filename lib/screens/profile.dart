import 'package:flutter/material.dart';
import 'package:listify/screens/forget_password_screen.dart';
import 'package:listify/screens/start_screen.dart';
import 'package:listify/services/user_service.dart';

import '../models/user_model.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.user});

  final User user;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _usernameController = TextEditingController();
  final UserService _userService = UserService();

  @override
  void initState() {
    _usernameController.text = widget.user.username;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF44404D),
        // Using primary dark color from theme
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 16.0),
        decoration: const BoxDecoration(
          color: Color(0xFF44404D), // Using primary dark color from theme
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputField(
                  controller: _usernameController,
                  hintText: widget.user.username,
                  onChanged: (value) {
                    print('Auto-saving username: $value');
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildButton(
                      context,
                      label: 'Change Password',
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const ForgetPasswordScreen()));
                      },
                    ),
                    Spacer(),
                    _buildButton(
                      context,
                      label: 'Logout',
                      onPressed: () {
                        _userService.removeUser();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const StartScreen()));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    ValueChanged<String>? onChanged,
  }) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF7B7794), // Input background color
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                style: const TextStyle(
                  color: Color(0xFFF5F5F5),
                  // Light text color
                  fontSize: 16,
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
                onChanged: onChanged,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(
                    color: Color(0xFFF5F5F5),
                    // Light hint color
                    fontSize: 16,
                    fontFamily: 'Open Sans',
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  border: InputBorder.none, // Remove default border
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(BuildContext context,
      {required String label, required VoidCallback onPressed}) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor:
            WidgetStateProperty.all<Color>(const Color(0xFF7B7794)),
        foregroundColor:
            WidgetStateProperty.all<Color>(const Color(0xFFF5F5F5)),
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
      ),
      child: Text(label),
    );
  }
}
