

import 'dart:math';

import 'package:flutter/material.dart';

class RainAnimation extends StatelessWidget {
  final Size screenSize;

  const RainAnimation({Key? key, required this.screenSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (int index = 0; index < 10; index++)
          _RainDrop(
            screenHeight: screenSize.height,
            screenWidth: screenSize.width,
          ),
      ],
    );
  }
}

class _RainDrop extends StatefulWidget {
  final double screenHeight, screenWidth;

  const _RainDrop({
    Key? key,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);

  @override
  State<_RainDrop> createState() => _RainDropState();
}

class _RainDropState extends State<_RainDrop> with SingleTickerProviderStateMixin {
  late double dx, dy, length, z, vy;

  final random = Random();

  @override
  void initState() {
    super.initState();
    randomizeValues();
    final _ticker = createTicker((elapsed) {
      dy += vy;
      if (dy >= widget.screenHeight + 100) {
        randomizeValues();
      }
      setState(() {});
    });
    _ticker.start();
  }

  @override
  void dispose() {
    super.dispose();
  }

  randomizeValues() {
    dx = random.nextDouble() * widget.screenWidth;
    dy = -500 - (random.nextDouble() * -500);
    z = random.nextDouble() * 20;
    length = rangeMap(z, 0, 20, 10, 20);
    vy = rangeMap(z, 0, 20, 15, 5);
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(dx, dy),
      child: Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  // decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                   image: DecorationImage(
                          image: AssetImage("assets/images/card.jpg"),
                          fit: BoxFit.cover,
                        ),
                
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      spreadRadius: 4,
                      blurRadius: 9,
                      offset: Offset(-10, 20),
                    ),
                  ],
                ),
              ),
    );
  }
}

double rangeMap(
    double x, double inMin, double inMax, double outMin, double outMax) {
  return (x - inMin) * (outMax - outMin) / (inMax - inMin) + outMin;
}
