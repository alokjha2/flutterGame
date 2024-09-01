import 'package:flutter/material.dart';
import 'package:game/gamescreen.dart';
import 'package:game/presentation/router/routes.dart';
import 'package:game/screens/matrixpage.dart';
import 'package:get/get.dart';

class BeatingHeartButton extends StatefulWidget {
  @override
  _BeatingHeartButtonState createState() => _BeatingHeartButtonState();
}

class _BeatingHeartButtonState extends State<BeatingHeartButton>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
      reverseDuration: Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_controller.value * 0.1),
            child: SizedBox(
      width: 200,
      height: 80,
      child: Container(
  width: 150, // Adjust width as needed
  height: 150, // Adjust height as needed
  decoration: BoxDecoration(
    shape: BoxShape.rectangle, // Circular shape
    borderRadius: BorderRadius.all(Radius.circular(20)),
    image: DecorationImage(
      image: AssetImage('assets/images/blue.png'), // Path to the image asset
      fit: BoxFit.cover, // Cover the entire container
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.3), // Shadow color
        spreadRadius: 2,
        blurRadius: 5,
        offset: Offset(0, 3), // Shadow position
      ),
    ],
  ),
  child: Material(
    color: Colors.transparent, // Makes sure the Material background is transparent
    borderRadius: BorderRadius.circular(150), // Circular border radius
    child: InkWell(
      onTap: () {
        Get.toNamed(AppRoutes.quiz);
      },
      borderRadius: BorderRadius.circular(150), // Circular border radius
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Adjust padding as needed
          child: Text(
            'Play', // Text to display
            style: TextStyle(
              fontSize: 18, // Font size
              fontWeight: FontWeight.bold, // Bold text
              color: Colors.white, // Text color
            ),
          ),
        ),
      ),
    ),
  ),
)


    )
          );
        },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

