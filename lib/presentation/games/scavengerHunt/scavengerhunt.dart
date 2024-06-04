import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class ScavengerHuntScreen extends StatefulWidget {
  @override
  _ScavengerHuntScreenState createState() => _ScavengerHuntScreenState();
}

class _ScavengerHuntScreenState extends State<ScavengerHuntScreen> {
  List<String> images = [
    // 'gs://reshuffle-b787f.appspot.com/scavengerhunt/hunt1.jpg',
    'https://firebasestorage.googleapis.com/v0/b/reshuffle-b787f.appspot.com/o/scavengerhunt%2Fhunt1.jpg?alt=media&token=e1704b54-1184-4c00-8ff9-0eeaf5256b0e',
    // 'assets/image2.jpg',
    "https://firebasestorage.googleapis.com/v0/b/reshuffle-b787f.appspot.com/o/scavengerhunt%2Fwaldo.jpg?alt=media&token=96630346-99d1-4574-a7f6-0a20633e6558",
    "https://firebasestorage.googleapis.com/v0/b/reshuffle-b787f.appspot.com/o/scavengerhunt%2Froom.jpg?alt=media&token=6844fe78-a720-4617-abbb-0d870d3e453e",
    "https://firebasestorage.googleapis.com/v0/b/reshuffle-b787f.appspot.com/o/scavengerhunt%2Fhunt3.jpg?alt=media&token=5733112e-4b7d-4d68-b431-faf4c9277243",
    "https://firebasestorage.googleapis.com/v0/b/reshuffle-b787f.appspot.com/o/scavengerhunt%2Fhunt2.jpg?alt=media&token=5f617367-05ee-417f-b6f7-53b56a041be9"
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
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Image.network(targetImage),
                ),
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
