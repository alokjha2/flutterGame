import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class QuestionController extends GetxController {
  var questions = <Map<String, dynamic>>[].obs;
  var questionNumber = 1.obs;
  var isAnswered = false.obs;
  var correctAnswer = ''.obs;
  var selectedAnswer = ''.obs;
  var pageController = PageController();

  @override
  void onInit() {
    super.onInit();
    _loadQuizQuestions();
  }

  void _loadQuizQuestions() async {
    try {
      final String response = await rootBundle.loadString('assets/json/data.json');
      final List<dynamic> data = json.decode(response);
      
      // Ensure each item in the list is a map
      final List<Map<String, dynamic>> questionsList = 
          data.map((item) => item as Map<String, dynamic>).toList();
      
      questions.assignAll(questionsList);
    } catch (e) {
      print("Error loading quiz questions: $e");
      // Handle the error (e.g., show an error message to the user)
    }
  }

  void updateTheQnNum(int index) {
    questionNumber.value = index + 1;
    isAnswered.value = false; // Reset for the new question
    selectedAnswer.value = ''; // Reset selected answer
  }

  void checkAnswer(int index, Map<String, dynamic> question) {
    isAnswered.value = true;
    correctAnswer.value = question['correct_answer'];
    selectedAnswer.value = question['options'][index];

    Logger().i("Selected answer: ${selectedAnswer.value}, Correct answer: ${correctAnswer.value}");

    // After the answer is selected, move to the next question
    Future.delayed(Duration(seconds: 2), () {
      if (pageController.hasClients) {
        pageController.nextPage(
            duration: Duration(milliseconds: 250), curve: Curves.ease);
      }
    });
  }
}
