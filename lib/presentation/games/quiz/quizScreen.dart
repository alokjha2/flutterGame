import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/exports.dart';
import 'package:game/presentation/games/quiz/widgets/body.dart';
import 'package:game/presentation/games/quiz/widgets/question_controller.dart';
import 'package:game/utils/constants.dart';
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
       leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: 
              // SizedBox(width: 10), // Add some padding to the left
              Container(
                // decoration: BoxDecoration(color: kGrayColor),
                child: Icon(
                  Icons.arrow_back_ios, // Use the iOS-style back icon
                  color: Colors.white, // Set the color of the icon
                          ),
              ),
        ),
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