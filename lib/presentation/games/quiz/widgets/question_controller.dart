import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/exports.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class QuestionController extends GetxController with SingleGetTickerProviderMixin {
  Timer? _timer;
  var timerValue = 60.obs; // Timer value in seconds

  var questions = <Map<String, dynamic>>[].obs;
  var questionNumber = 1.obs;
  var isAnswered = false.obs;
  var correctAnswer = ''.obs;
  var selectedAnswer = ''.obs;
  var pageController = PageController();

  late AnimationController _animationController;
  late Animation _animation;

  @override
  void onInit() {
    super.onInit();
    _loadQuizQuestions();

    // Initialize the animation for the progress bar
    _animationController = AnimationController(
      duration: Duration(seconds: 60),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        update(); // Update UI when animation value changes
      });

    // Start the timer
    _startTimer();
  }

  void _startTimer() {
    // Initialize timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timerValue.value > 0) {
        timerValue.value--;
      } else {
        timer.cancel();
        // Trigger the next question or handle end of quiz
        nextQuestion();
      }
    });

    // Start the animation
    _animationController.forward();
  }

  @override
  void onClose() {
    super.onClose();
    _animationController.dispose(); // Properly dispose the animation controller
    pageController.dispose();
    _timer?.cancel(); // Cancel the timer if it's still running
  }

  void _loadQuizQuestions() async {
    try {
      final String response = await rootBundle.loadString('assets/json/data.json');
      final List<dynamic> data = json.decode(response);

      // Ensure each item in the list is a map
      final List<Map<String, dynamic>> questionsList = data.map((item) => item as Map<String, dynamic>).toList();

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

    // Stop timer and animation
    _timer?.cancel();
    _animationController.stop();

    // After the answer is selected, move to the next question
    Future.delayed(Duration(seconds: 2), () {
      if (pageController.hasClients) {
        pageController.nextPage(
            duration: Duration(milliseconds: 250), curve: Curves.ease);
      }

      // Restart the timer
      _startTimer();
    });
  }

  void nextQuestion() {
    if (questionNumber.value != questions.length) {
      isAnswered.value = false;
      pageController.nextPage(
          duration: Duration(milliseconds: 250), curve: Curves.ease);

      // Reset the timer
      timerValue.value = 60;

      // Reset the counter and start the animation again
      _animationController.reset();
      _animationController.forward();
    } else {
      // Navigate to ScoreScreen or handle end of quiz
      // Get.toNamed(AppRoutes.score);
    }
  }
}