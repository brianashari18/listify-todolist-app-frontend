import 'package:flutter/material.dart';

class VerticalSlider extends StatefulWidget {
  const VerticalSlider({super.key});

  @override
  _VerticalSliderState createState() => _VerticalSliderState();
}

class _VerticalSliderState extends State<VerticalSlider> {
  final PageController _controller = PageController();

  final List<String> imagePath = [
    'assets/images/login/login1.jpg'
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // Set height for the carousel
      width: 200, // Set width for the carousel
      child: PageView.builder(
        controller: _controller,
        scrollDirection: Axis.vertical,
        itemCount: imagePath.length, // Total number of items
        itemBuilder: (context, index) {
          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  imagePath[index],
                  fit: BoxFit.cover,
                )
              )
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}