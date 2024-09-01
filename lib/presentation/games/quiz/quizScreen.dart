import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/exports.dart';
import 'package:game/presentation/games/quiz/widgets/body.dart';
import 'package:game/presentation/games/quiz/widgets/question_controller.dart';
import 'package:get/get.dart';


class QuizScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    QuestionController _controller = Get.put(QuestionController());
    return Scaffold(
      extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
      appBar: AppBar(
        // Fluttter show the back button automatically
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(onPressed: (){
            Get.find<QuestionController>().skipQuestion();
          }, child: Text("Skip", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400))),
        ],
      ),
      body: Body(),
    );
  }
}