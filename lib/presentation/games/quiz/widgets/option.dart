import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:game/presentation/games/quiz/widgets/question_controller.dart';
import 'package:game/utils/constants.dart';

class Option extends StatelessWidget {
  const Option({
    Key? key,
    this.text,
    this.index,
    this.press,
  }) : super(key: key);

  final String? text;
  final int? index;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final QuestionController qnController = Get.find<QuestionController>();

      Color getTheRightColor() {
        if (qnController.isAnswered.value) {
          if (text == qnController.correctAnswer.value) {
            return kGreenColor;
          } else if (text == qnController.selectedAnswer.value) {
            return kRedColor;
          }
        }
        return kGrayColor;
      }

      IconData getTheRightIcon() {
        return getTheRightColor() == kRedColor ? Icons.close : Icons.done;
      }

      return InkWell(
        onTap: press,
        child: Container(
          margin: EdgeInsets.only(top: kDefaultPadding),
          padding: EdgeInsets.all(kDefaultPadding),
          decoration: BoxDecoration(
            border: Border.all(color: getTheRightColor()),
            borderRadius: BorderRadius.circular(15),
            color: getTheRightColor() == kGrayColor
                ? Colors.transparent
                : getTheRightColor().withOpacity(0.2), // Light background for selected option
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${index! + 1}. $text",
                style: TextStyle(color: getTheRightColor(), fontSize: 16),
              ),
              Container(
                height: 26,
                width: 26,
                decoration: BoxDecoration(
                  color: getTheRightColor() == kGrayColor
                      ? Colors.transparent
                      : getTheRightColor(),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: getTheRightColor()),
                ),
                child: getTheRightColor() == kGrayColor
                    ? null
                    : Icon(getTheRightIcon(), size: 16),
              )
            ],
          ),
        ),
      );
    });
  }
}
