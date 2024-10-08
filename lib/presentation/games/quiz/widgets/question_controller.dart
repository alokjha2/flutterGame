import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/sounds.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class QuestionController extends GetxController with SingleGetTickerProviderMixin {
  Timer? _timer;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final audioController = AudioController();

  var timerValue = 60.obs; // Timer value in seconds
  var questions = <Map<String, dynamic>>[].obs;
  var questionNumber = 1.obs;
  var isAnswered = false.obs;
  var correctAnswer = ''.obs;
  var selectedAnswer = ''.obs;
  var skippedQuestion = 0.obs;
  var score = 0.obs; // Track score
  var maxSkips = 3; // Maximum number of skips
  var pageController = PageController();
  var answeredQuestions = <int>{}.obs; // Track answered question indices

  @override
  void onInit() {
    super.onInit();
    _loadQuizQuestions();
    _initializeTimer();
  }

  void _initializeTimer() {
    _animationController = AnimationController(
      duration: Duration(seconds: 60),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        update(); // Update UI when animation value changes
      });

    // Reset timer and animation for the new question
    _resetTimer();
  }

  void _resetTimer() {
    _timer?.cancel(); // Cancel the existing timer if any
    timerValue.value = 60; // Reset timer value
    _animationController.reset(); // Reset animation controller
    _animationController.forward(); // Start animation

    // Start a new timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timerValue.value > 0) {
        timerValue.value--;
      } else {
        timer.cancel();
        nextQuestion(); // Trigger next question when timer finishes
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
    _animationController.dispose(); // Dispose the animation controller
    pageController.dispose();
    _timer?.cancel(); // Cancel the timer if still running
  }

  void _loadQuizQuestions() async {
    try {
      final String response = await rootBundle.loadString('assets/json/data.json');
      final List<dynamic> data = json.decode(response);

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
    if (isAnswered.value || answeredQuestions.contains(questionNumber.value - 1)) return;

    isAnswered.value = true;
    correctAnswer.value = question['correct_answer'];
    selectedAnswer.value = question['options'][index];

    Logger().i("Selected answer: ${selectedAnswer.value}, Correct answer: ${correctAnswer.value}");

    // Stop timer and animation
    _timer?.cancel();
    _animationController.stop();

    // Check if the answer is correct or wrong
    if (selectedAnswer.value == correctAnswer.value) {
      score.value += 2; // Award 2 points for correct answer
      audioController.playSound(SfxType.correctAnswer);
    } else {
      audioController.playSound(SfxType.wrongAnswer);
      score.value -= 1; // Deduct 1 point for wrong answer
    }

    // Mark question as answered
    answeredQuestions.add(questionNumber.value - 1);

    // After the answer is selected, move to the next question
    Future.delayed(Duration(seconds: 2), () {
      if (pageController.hasClients) {
        pageController.nextPage(
            duration: Duration(milliseconds: 250), curve: Curves.ease);
      }

      // Reset timer and animation for the new question
      _resetTimer();
    });
  }

  void skipQuestion() {
    if (skippedQuestion.value < maxSkips) {
      // Stop timer and animation
      _timer?.cancel();
      _animationController.stop();
      skippedQuestion.value++;

      // Mark current question as answered to prevent re-answering
      answeredQuestions.add(questionNumber.value - 1);

      // Move to the next question
      nextQuestion();
    } else {
      // Show message or handle the case where skips are exhausted
      print("You have reached the maximum number of skips.");
    }
  }

  void nextQuestion() {
    if (questionNumber.value != questions.length) {
      isAnswered.value = false;
      pageController.nextPage(
          duration: Duration(milliseconds: 250), curve: Curves.ease);

      // Reset the timer and animation
      _resetTimer();
    } else {
      // Navigate to ScoreScreen or handle end of quiz
      // Get.toNamed(AppRoutes.score);
    }
  }
}
