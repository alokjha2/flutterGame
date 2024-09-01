import 'package:flutter/material.dart';
import 'package:game/utils/constants.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:game/presentation/games/quiz/widgets/question_controller.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuestionController>(
      builder: (controller) {
        // Determine the color based on time remaining
        Color progressColor;
        if (controller.timerValue.value <= 10) {
          progressColor = Colors.red.shade400; // Change to red if time is <= 10 seconds
        } else {
          progressColor = Colors.green.shade400; // Default color
        }

        return Container(
          width: double.infinity,
          height: 35,
          decoration: BoxDecoration(
            border: Border.all(color: Color(0xFF3F4768), width: 3),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Stack(
            children: [
              // LayoutBuilder to calculate the width dynamically
              LayoutBuilder(
                builder: (context, constraints) {
                  double progressWidth = constraints.maxWidth * (controller.timerValue.value / 60);

                  return Container(
                    width: progressWidth,
                    decoration: BoxDecoration(
                      color: progressColor, // Set progress bar color
                      borderRadius: BorderRadius.circular(50),
                    ),
                  );
                },
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${controller.timerValue.value} sec", style: TextStyle(color: Colors.white)),
                      SvgPicture.asset("assets/icons/clock.svg", color: Colors.white),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
