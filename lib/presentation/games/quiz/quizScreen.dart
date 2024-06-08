import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:game/providers/article_providers.dart';
import 'package:game/quizGenerate.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';

import 'package:share_plus/share_plus.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  String _selectedOption = '';
  int timeLeft = 60; // Timer set to 60 seconds
  Timer? _timer;
  int diamonds = 500;
  int hearts = 1; // Assume 1 heart to represent lives
  int coins = 29;
  bool _isStarted = false;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

 
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() {
          timeLeft--;
        });
      } else {
        timer.cancel();
        // Timer ends, you can add your game over logic here
      }
    });
  }

  void _checkAnswer(String selectedOption) {
    setState(() {
      _selectedOption = selectedOption;
    });
  }

  void _shareLink() {
    final link = 'https://elderquest.netlify.app/#/game/quiz';
    Share.share('Check out this quiz: $link');
  }

  // void _showUserDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Participants'),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               Text('Peckish Human'),
  //               // Add more participants as needed
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text('Close'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
     final provider = Provider.of<ArticleProvider>(context);
    return Scaffold(
      body: 
      _isStarted ?
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoIcon(Icons.timer, '$timeLeft'),
                _buildInfoIcon(Icons.favorite, '$hearts'),
                _buildInfoIcon(Icons.account_circle_rounded, '$diamonds', () => _showUserDialog(context)),
                _buildInfoIcon(Icons.exit_to_app, '$coins'),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.purple, width: 2),
                      ),
                      child: Text(
                        'Which golf term is defined as "club especially designed for putting"?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildOption('Divot', 'A'),
                    _buildOption('Front Nine', 'B'),
                    _buildOption('Bunker', 'C'),
                    _buildOption('Putter', 'D'),
                  ],
                ),
              ),
            ),
          ],
        ),
      )  : _buildStartButton()
    );
  }

  Widget _buildInfoIcon(IconData icon, String text, [VoidCallback? onTap]) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 30, color: Colors.purple),
          SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(fontSize: 20, color: Colors.purple, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

   Widget _buildStartButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // sendMessage();
          // runPythonScript();
          // _scrapeArticle();
          setState(() {
            _isStarted = true;
          });
        },
        child: Text('Start'),
      ),
    );
  }

 void _showUserDialog(BuildContext context) async {
  final RenderBox overlay = Overlay.of(context)!.context.findRenderObject() as RenderBox;
  final position = RelativeRect.fromRect(
    Rect.fromLTRB(
      overlay.size.width - 50,
      50, // Adjust this value as needed to fit your design
      overlay.size.width,
      0,
    ),
    Offset.zero & overlay.size,
  );

  String? selectedUser = await showMenu<String>(
    context: context,
    position: position,
    items: [
      PopupMenuItem<String>(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                // Implement search functionality here
              },
            ),
            Divider(),
          ],
        ),
        enabled: false,
      ),
      for (int i = 1; i <= 20; i++)
        PopupMenuItem<String>(
          value: 'user$i',
          child: Text('User $i'),
        ),
    ],
    elevation: 8,
  );

  if (selectedUser != null) {
    // Handle the selection if needed
  }
}


  Widget _buildOption(String text, String option) {
    return GestureDetector(
      onTap: () => _checkAnswer(option),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: _selectedOption == option ? Colors.green : Colors.purpleAccent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white, width: 2),
        ),
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
