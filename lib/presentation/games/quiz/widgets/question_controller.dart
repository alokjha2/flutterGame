import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class QuestionController extends GetxController {
  var questions = [].obs;
  var questionNumber = 1.obs;
  var isAnswered = false.obs;
  var correctAnswer;
  var selectedAnswer;
  var pageController = PageController();

  @override
  void onInit() {
    super.onInit();
    _loadQuizQuestions();
  }

  void _loadQuizQuestions() async {
    final String response = await rootBundle.loadString('assets/json/data.json');
    final data = await json.decode(response);
    questions.assignAll(data);
  }

  void updateTheQnNum(int index) {
    questionNumber.value = index + 1;
  }

  void checkAnswer(int index, dynamic question) {
    isAnswered.value = true;
    correctAnswer = question['correct_answer'];
    selectedAnswer = question['options'][index];

    if (selectedAnswer == correctAnswer) {
      // Correct answer logic
      // You can handle the logic here, like updating scores
    } else {
      // Incorrect answer logic
    }

    // After the answer is selected, move to the next question
    Future.delayed(Duration(seconds: 2), () {
      if (pageController.hasClients) {
        pageController.nextPage(
            duration: Duration(milliseconds: 250), curve: Curves.ease);
      }
    });
  }
}
