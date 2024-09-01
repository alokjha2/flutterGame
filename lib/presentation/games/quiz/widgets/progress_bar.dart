import 'package:flutter/material.dart';
import 'package:game/presentation/games/quiz/widgets/question_controller.dart';
import 'package:game/utils/constants.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:quiz_app/controllers/question_controller.dart'; // Update with your path

class ProgressBar extends StatelessWidget {
  const ProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 35,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF3F4768), width: 3),
        borderRadius: BorderRadius.circular(50),
      ),
      child: GetBuilder<QuestionController>(
        builder: (controller) {
          return Stack(
            children: [
              // LayoutBuilder provide us the available space for the container
              LayoutBuilder(
                builder: (context, constraints) => Container(
                  // width: constraints.maxWidth * (controller!..value),
                  decoration: BoxDecoration(
                    gradient: kPrimaryGradient, // Use your gradient
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${controller.timerValue.value} sec"),
                      SvgPicture.asset("assets/icons/clock.svg"),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
