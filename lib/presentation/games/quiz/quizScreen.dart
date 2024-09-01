import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/exports.dart';
import 'package:game/presentation/games/quiz/widgets/body.dart';
import 'package:game/presentation/games/quiz/widgets/question_controller.dart';
import 'package:game/sounds.dart';
import 'package:game/utils/constants.dart';
import 'package:get/get.dart';
import 'dart:ui';

import 'package:game/components/homepage_btn.dart';
import 'package:game/exports.dart';
import 'package:game/presentation/screens/profile/settings.dart';
import 'package:game/widgets/fancyButton.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:logger/logger.dart';


class QuizScreen extends StatefulWidget {
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>with WidgetsBindingObserver  {
      AudioPlayer? _audioPlayer;
        final audioController = AudioController();

  @override
  void initState() {
    super.initState();
    // _audioPlayer!.stop();
    audioController.stop();
    audioController.playSound(SfxType.background);
    WidgetsBinding.instance.addObserver(this);
    // audioController.
    // checkForUpdate();
    // _initializeAndPlayMusic();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    audioController.stop();
    // _audioPlayer?.stop(); // Stop the music when disposing
    // _audioPlayer?.dispose(); // Dispose of the AudioPlayer
    super.dispose();
  }



// Future<void> _initializeAndPlayMusic() async {
//   _audioPlayer = AudioPlayer();
  
//   await _audioPlayer!.setReleaseMode(ReleaseMode.loop); // Enable looping
  
//   final result = await _audioPlayer!.play(
//     AssetSource('sounds/bg2.mp3'), 
//     volume: 0.02 // Set the volume to a very low level
//   );
// }

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