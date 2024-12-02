import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listify/widgets/verification_field_widget.dart';

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
  final ApiService _apiService = ApiService();
  bool _isVerify = false;
  bool _isResend = false;

  @override
  void dispose() {
    _textEditingController1.dispose();
    _textEditingController2.dispose();
    _textEditingController3.dispose();
    _textEditingController4.dispose();
    super.dispose();
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
                const SizedBox(
                  height: 40,
                ),
                Text(
                  'We have send a code to\n${widget.email}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(30, 30, 42, 1),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    VerificationFieldWidget(
                        controller: _textEditingController1),
                    VerificationFieldWidget(
                        controller: _textEditingController2),
                    VerificationFieldWidget(
                        controller: _textEditingController3),
                    VerificationFieldWidget(
                        controller: _textEditingController4),
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
                        onPressed: _onVerify,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(68, 64, 77, 1),
                          // Background color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isVerify
                            ? const CircularProgressIndicator()
                            : const Text(
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
                              child: _isResend
                                  ? const SizedBox(
                                      height: 10,
                                      width: 10,
                                      child: CircularProgressIndicator())
                                  : const Text(
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

  void _onVerify() async {
    setState(() {
      _isVerify = true;
    });

    final otp =
        '${_textEditingController1.text}${_textEditingController2.text}${_textEditingController3.text}${_textEditingController4.text}';

    if (otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter the full code')));

      setState(() {
        _isVerify = false;
      });
      return;
    }

    final result = await _apiService.validateOTP(int.parse(otp));

    setState(() {
      _isVerify = false;
    });

    if (result['success'] == 'true') {
      final message = result['message'];
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } else {
      final errorMessage = result['error'];
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }

    _textEditingController1.clear();
    _textEditingController2.clear();
    _textEditingController3.clear();
    _textEditingController4.clear();
  }

  void _resendCode() async {
    setState(() {
      _isResend = true;
    });
    final result = await _apiService.forgotPassword(widget.email);

    setState(() {
      _isResend = false;
    });
    if (result['success'] == 'true') {
      final message = result['message'];
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } else {
      final errorMessage = result['error'];
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorMessage)));
    }
  }
}
