

import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Screen'),
      ),
      body: Center(
        child: Text(
          'Welcome to the Game! \n we are working on games currently. will release them in second update',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
