import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:game/presentation/games/quiz/widgets/option.dart';
import 'package:game/presentation/games/quiz/widgets/question_controller.dart';
import 'package:get/get.dart';
import 'package:game/presentation/games/quiz/widgets/progress_bar.dart';
import 'package:game/presentation/games/quiz/widgets/question_card.dart';
import 'package:game/utils/constants.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    QuestionController _questionController = Get.put(QuestionController());
    return Stack(
      children: [
        // Background image (if any)
        SvgPicture.asset("assets/icons/bg.svg", fit: BoxFit.fill),
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: ProgressBar(),
              ),
              SizedBox(height: kDefaultPadding),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Obx(
                  () => Text.rich(
                    TextSpan(
                      text: "Question ${_questionController.questionNumber.value}",
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(color: kSecondaryColor),
                      children: [
                        TextSpan(
                          text: "/${_questionController.questions.length}",
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(color: kSecondaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(thickness: 1.5),
              SizedBox(height: kDefaultPadding),
               Expanded(
                child: Obx(
                  () => PageView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    controller: _questionController.pageController,
                    onPageChanged: _questionController.updateTheQnNum,
                    itemCount: _questionController.questions.length,
                    itemBuilder: (context, index) {
                      final question = _questionController.questions[index];
                      return Column(
                        children: [
                          Text(
                            question['question'],
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          ...List.generate(4, (optionIndex) {
                            return Option(
                              text: question['options'][optionIndex],
                              index: optionIndex,
                              press: () => _questionController.checkAnswer(
                                  optionIndex, question),
                            );
                          }),
                          Spacer(),
                        ],
                      );
                    },
                  ),
                
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}