import 'dart:math';

import 'package:flutter/material.dart';

class Circles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (int i = 0; i < 50; i++)
          Positioned(
            top: Random().nextDouble() * 800,
            left: Random().nextDouble() * 500,
            right: Random().nextDouble() * 500,
            child: Circle(
              height: Random().nextDouble() * 50,
              width: Random().nextDouble() * 50,
              color: Colors.transparent,
              shadowColor: Colors.indigo.shade300,
            ),
          ),
      ],
    );
  }
}

class Circle extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  final Color shadowColor;

  const Circle({
    required this.height,
    required this.width,
    required this.color,
    required this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 5.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
    );
  }
}
