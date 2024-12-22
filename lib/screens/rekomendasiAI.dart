import 'package:flutter/material.dart';

class RekomendasiAi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                  // Main background color
                  Positioned(
                    left: 2,
                    top: 6,
                    child: Container(
                      width: 443,
                      height: 971,
                      decoration: BoxDecoration(color: Color(0xFF44404D)),
                    ),
                  ),
                  // First section with image and text
                  Positioned(
                    left: 35,
                    top: 101,
                    child: Container(
                      width: 349.17,
                      height: 259.68,
                      child: Column(
                        children: [
                          // Circle Image container
                          Container(
                            width: 50,
                            height: 50,
                            decoration: ShapeDecoration(
                              color: Color(0xFF564F65),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        "https://via.placeholder.com/40x40"),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          // Title Text
                          Text(
                            'Revisi Laporan',
                            style: TextStyle(
                              color: Color(0xFFF5F5F5),
                              fontSize: 20,
                              fontFamily: 'Nunito Sans',
                              fontWeight: FontWeight.w600,
                              height: 0.06,
                              letterSpacing: 0.50,
                            ),
                          ),
                          SizedBox(height: 10),
                          // Status cards
                          _buildStatusCard('23.59 WIB'),
                          SizedBox(height: 10),
                          _buildStatusCard('30 Oktober 2024'),
                          SizedBox(height: 10),
                          _buildStatusCard('On Progress'),
                        ],
                      ),
                    ),
                  ),
                  // Additional background section for Recommendation part
                  Positioned(
                    left: 12,
                    top: 630,
                    child: Container(
                      width: 419,
                      height: 326,
                      decoration: ShapeDecoration(
                        color: Color(0xFF1E1E2A),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 54,
                    top: 664,
                    child: SizedBox(
                      width: 169,
                      height: 35,
                      child: Text(
                        'Recommendation',
                        style: TextStyle(
                          color: Color(0xFFF5F5F5),
                          fontSize: 20,
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w700,
                          height: 0.09,
                        ),
                      ),
                    ),
                  ),
                  // Last Edited Text (Empty string removed)
                  Positioned(
                    left: 217,
                    top: 369,
                    child: SizedBox(
                      width: 181,
                      child: Text(
                        '',
                        style: TextStyle(
                          color: Color(0x7FF5F5F5),
                          fontSize: 14,
                          fontFamily: 'Nunito Sans',
                          fontWeight: FontWeight.w600,
                          height: 0.12,
                          letterSpacing: 0.50,
                        ),
                      ),
                    ),
                  ),
                  // Links at the bottom with adjusted size to prevent overlap
                  Positioned(
                    left: 51,
                    top: 723,
                    child: SizedBox(
                      width: 336,
                      child: Text(
                        'https://www.gramedia.com/literasi/pengertian-laporan/',
                        style: TextStyle(
                          color: Color(0xFFF5F5F5),
                          fontSize: 14,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w400,
                          height: 0.12,
                          letterSpacing: 0.50,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 49,
                    top: 793,
                    child: SizedBox(
                      width: 336,
                      child: Text(
                        'https://piktochart.com/id/blog/cara-menulis-laporan/',
                        style: TextStyle(
                          color: Color(0xFFF5F5F5),
                          fontSize: 14,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w400,
                          height: 0.12,
                          letterSpacing: 0.50,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 49,
                    top: 863,
                    child: SizedBox(
                      width: 336,
                      child: Text(
                        'https://isi.ac.id/10-langkah-membuat-laporan-penelitian-yang-baik/',
                        style: TextStyle(
                          color: Color(0xFFF5F5F5),
                          fontSize: 14,
                          fontFamily: 'Open Sans',
                          fontWeight: FontWeight.w400,
                          height: 0.12,
                          letterSpacing: 0.50,
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
    );
  }

  // Helper method to build a status card
  Widget _buildStatusCard(String text) {
    return Container(
      width: 347.23,
      height: 36.90,
      decoration: ShapeDecoration(
        color: Color(0xFF7B7794),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 4,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Color(0xFFF5F5F5),
            fontSize: 12,
            fontFamily: 'Open Sans',
            fontWeight: FontWeight.w600,
            letterSpacing: 0.50,
          ),
        ),
      ),
    );
  }
}
