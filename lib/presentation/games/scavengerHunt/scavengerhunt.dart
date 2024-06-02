

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';


class ScavengerHuntScreen extends StatefulWidget {
  @override
  _ScavengerHuntScreenState createState() => _ScavengerHuntScreenState();
}

class _ScavengerHuntScreenState extends State<ScavengerHuntScreen> {
  List<String> images = [
    'assets/image1.jpg',
    'assets/image2.jpg',
    // Add more images here...
  ];

  String targetImage = '';
  int score = 0;
  Timer? timer;
  int timeLeft = 60; // Start with 60 seconds

  @override
  void initState() {
    super.initState();
    startGame();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startGame() {
    setState(() {
      score = 0;
      timeLeft = 60;
    });
    _startTimer();
    _setTargetImage();
  }

  void _startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          t.cancel();
          // Game Over
        }
      });
    });
  }

  void _setTargetImage() {
    setState(() {
      targetImage = images[Random().nextInt(images.length)];
    });
  }

  void _onImageTap(String tappedImage) {
    if (tappedImage == targetImage) {
      setState(() {
        score++;
      });
      _setTargetImage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scavenger Hunt'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Time left: $timeLeft seconds',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            'Score: $score',
            style: TextStyle(fontSize: 20),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => _onImageTap(targetImage),
              child: Container(
                alignment: Alignment.center,
                child: Image.asset(targetImage),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: startGame,
            child: Text('Start Game'),
          ),
        ],
      ),
    );
  }
}
