import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../services/api_service.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key, required this.email});

  final String email;

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController _textEditingController1 = TextEditingController();
  final TextEditingController _textEditingController2 = TextEditingController();
  final TextEditingController _textEditingController3 = TextEditingController();
  final TextEditingController _textEditingController4 = TextEditingController();

  void _onVerify(String otp) async {
    try {
      final requestBody = <String, dynamic>{
        "otp": otp,
      };

      final response = await ApiService.validateOTP(
          "/api/users/validate-otp", requestBody);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        print("Response: $responseBody");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseBody["message"])));

      //   Navigate to Reset Password
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("OTP is invalid")),
        );
        print("Error: ${response.body}");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e.")),
      );
      print("Exception: $e");
    }
  }


  void _resendCode() async {
    try {
      final requestBody = <String, dynamic>{
        "email": widget.email,
      };

      final response = await ApiService.forgotPassword(
          "/api/users/forgot-password", requestBody);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        print("Response: $responseBody");
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseBody["message"])));
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
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;
    final fontSize = (deviceHeight * 0.05).clamp(24.0, 28.0);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(245, 245, 245, 1),
      body: SingleChildScrollView(
        child: Container(
          height: deviceHeight,
          padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(children: [
                Text(
                  'VERIFICATION CODE',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromRGBO(30, 30, 42, 1),
                  ),
                ),
                const SizedBox(height: 40,),
                Text(
                  'We have send a code to\n${widget.email}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(30, 30, 42, 1),
                  ),
                ),
                const SizedBox(height: 40,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 68,
                      width: 64,
                      child: TextField(
                        controller: _textEditingController1,
                        style: Theme.of(context).textTheme.headlineMedium,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 18),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 68,
                      width: 64,
                      child: TextField(
                        controller: _textEditingController2,
                        style: Theme.of(context).textTheme.headlineMedium,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 18),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 68,
                      width: 64,
                      child: TextField(
                        controller: _textEditingController3,
                        style: Theme.of(context).textTheme.headlineMedium,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 18),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 68,
                      width: 64,
                      child: TextField(
                        controller: _textEditingController4,
                        style: Theme.of(context).textTheme.headlineMedium,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(1),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(vertical: 18),
                        ),
                      ),
                    ),
                  ],
                )

              ]),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 32.0, vertical: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          () {};
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(68, 64, 77, 1),
                          // Background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'VERIFY',
                          style: TextStyle(
                            color: Color.fromRGBO(245, 245, 245, 1),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Didn't you receive any code?"),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: _resendCode,
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 3, vertical: 6),
                              child: const Text(
                                'Resend Code',
                                style: TextStyle(
                                    color: Color.fromRGBO(68, 64, 77, 1),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
