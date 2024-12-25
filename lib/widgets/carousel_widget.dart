import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

final List<String> imagePaths = [
  'assets/images/login/login1.png',
  'assets/images/login/login2.png',
];

final List<String> descriptions = [
  'Manage your activities and\ncreate reminders',
  'Use workspace to\ncollaborations with others'
];

class CarouselWidget extends StatefulWidget {
  const CarouselWidget({super.key});

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  int _activeIndicator = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: imagePaths
              .map((e) => Center(
                    child: Image.asset(e),
                  ))
              .toList(),
          options: CarouselOptions(
              initialPage: 0,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              height: 350,
              enlargeCenterPage: true,
              viewportFraction: 1.0,
              onPageChanged: (value, _) {
                setState(() {
                  _activeIndicator = value;
                });
              }),
        ),
        buildCarouselIndicator(),
        const SizedBox(height: 10),
        Text(
          descriptions[_activeIndicator],
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Color.fromRGBO(245, 245, 245, 1),
          ),
        ),
      ],
    );
  }

  buildCarouselIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < imagePaths.length; i++)
          Container(
            height: i == _activeIndicator ? 3 : 8,
            width: i == _activeIndicator ? 20 : 8,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: const Color.fromRGBO(245, 245, 245, 1),
                shape: i == _activeIndicator
                    ? BoxShape.rectangle
                    : BoxShape.circle,
                borderRadius:
                    i == _activeIndicator ? BorderRadius.circular(2) : null),
          )
      ],
    );
  }
}
