import 'dart:math';

import 'package:flutter/material.dart';

import 'big_button.dart';

class Circle extends StatelessWidget {
  final double? size;

  const Circle({super.key, this.size});

  Color _getRandomColor() {
    Random random = Random();
    // Generate a random number for r, g, b values (0 - 255)
    int r = random.nextInt(256);
    int g = random.nextInt(256);
    int b = random.nextInt(256);

    // Create a color from the random RGB values
    return Color.fromRGBO(r, g, b,
        1); // The last parameter is the opacity, which is set to 1 for full opacity
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size ?? 65,
      width: size ?? 65,
      child: CustomPaint(
        painter: MiRadialProgress(
          value: 100,
          primaryColor: _getRandomColor(),
          strokeWidth: 4,
        ),
      ),
    );
  }
}
