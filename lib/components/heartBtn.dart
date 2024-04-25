import 'package:flutter/material.dart';
import 'package:game/routes.dart';
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
    return GestureDetector(
      onTap: () {
           Get.toNamed(AppRoutes.selectMatrix);
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (_controller.value * 0.1),
            child: SizedBox(
      width: 220,
      height: 90,
      child: ElevatedButton(
        onPressed: (){
           Get.toNamed(AppRoutes.selectMatrix);
        },
        style: ElevatedButton.styleFrom(
          // backgroundColor: Colors.amber,

          shape: RoundedRectangleBorder(

            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Ink(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8), // Adjust border radius as needed
      gradient: LinearGradient(
        colors: [Colors.lightBlue, Colors.blue], // Adjust colors as needed
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0), // Adjust padding as needed
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/blue.png', // Path to the image asset
            width: 24, // Adjust the width of the image as needed
            height: 24, // Adjust the height of the image as needed
            fit: BoxFit.cover,
          ),
          SizedBox(width: 8), // Adjust spacing between image and text
          Text(
            'Play', // Text to display
            style: TextStyle(
              fontSize: 16, // Adjust the font size as needed
              color: Colors.white, // Adjust text color as needed
            ),
          ),
        ],
      ),
    ),
  ),
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

