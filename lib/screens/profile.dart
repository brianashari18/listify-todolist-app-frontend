import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: 438,
            height: 971,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0x3F000000),
                  blurRadius: 150,
                  offset: Offset(80, 80),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Color(0x59000000),
                  blurRadius: 50,
                  offset: Offset(20, 20),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    width: 442.53,
                    height: 971,
                  ),
                ),
                Positioned(
                  left: 10.19,
                  top: 16.98,
                  child: Container(
                    width: 418.76,
                    height: 930.26,
                    child: Stack(
                      children: [
                        Positioned(
                          left: -10.19,
                          top: -16.98,
                          child: Container(
                            width: 443,
                            height: 971,
                            decoration: BoxDecoration(color: Color(0xFF44404D)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 10.19,
                  top: 16.98,
                  child: Container(
                    width: 418.76,
                    height: 930.26,
                    child: Stack(
                      children: [
                        Positioned(
                          left: -10.19,
                          top: -16.98,
                          child: Container(
                            width: 443,
                            height: 971,
                            decoration: BoxDecoration(color: Color(0xFF44404D)),
                          ),
                        ),
                        Positioned(
                          left: 130.81,
                          top: 85.02,
                          child: ClipOval(
                            child: Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.grey[300], // Placeholder color
                                image: DecorationImage(
                                  image: AssetImage(
                                      'assets/default_profile.png'), // Default image placeholder
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  Icons
                                      .camera_alt, // Placeholder icon to indicate the photo can be uploaded
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 50.81,
                          top: 309.02,
                          child: GestureDetector(
                            onTap: () {
                              // Handle the username click here
                              print('Username clicked');
                            },
                            child: Container(
                              width: 312,
                              height: 56,
                              clipBehavior: Clip.antiAlias,
                              decoration: ShapeDecoration(
                                color: Color(0xFFF5F5F5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                shadows: [
                                  BoxShadow(
                                    color: Color(0x4C000000),
                                    blurRadius: 3,
                                    offset: Offset(0, 1),
                                    spreadRadius: 0,
                                  ),
                                  BoxShadow(
                                    color: Color(0x26000000),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Text(
                                      'Username',
                                      style: TextStyle(
                                        color: Color(0xFF1E1E2A),
                                        fontSize: 14,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w500,
                                        height: 0.10,
                                        letterSpacing: 0.10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 53.81,
                          top: 390.02,
                          child: GestureDetector(
                            onTap: () {
                              // Handle the Change Password click here
                              print('Change Password clicked');
                            },
                            child: Container(
                              width: 312,
                              height: 56,
                              clipBehavior: Clip.antiAlias,
                              decoration: ShapeDecoration(
                                color: Color(0xFFF5F5F5),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                shadows: [
                                  BoxShadow(
                                    color: Color(0x4C000000),
                                    blurRadius: 3,
                                    offset: Offset(0, 1),
                                    spreadRadius: 0,
                                  ),
                                  BoxShadow(
                                    color: Color(0x26000000),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Text(
                                      'Change Password',
                                      style: TextStyle(
                                        color: Color(0xFF1E1E2A),
                                        fontSize: 14,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w500,
                                        height: 0.10,
                                        letterSpacing: 0.10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 205.98,
                  top: 23.77,
                  child: Container(
                    width: 22.64,
                    height: 22.63,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
