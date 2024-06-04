import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  String _selectedOption = '';

  void _checkAnswer(String selectedOption) {
    setState(() {
      _selectedOption = selectedOption;
    });
  }

  void _shareLink() {
    final link = 'https://reshuffle.netlify.app/#/game/quiz';
    Share.share('Check out this quiz: $link');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _shareLink,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: _selectedOption == 'B' ? Colors.green : Colors.red,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'What is the capital of France?',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    Column(
                      children: [
                        InkWell(
                          onTap: () => _checkAnswer('A'),
                          child: Card(
                            color: _selectedOption == 'A' ? Colors.green : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'A. London',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => _checkAnswer('B'),
                          child: Card(
                            color: _selectedOption == 'B' ? Colors.green : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'B. Paris',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => _checkAnswer('C'),
                          child: Card(
                            color: _selectedOption == 'C' ? Colors.green : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'C. Rome',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () => _checkAnswer('D'),
                          child: Card(
                            color: _selectedOption == 'D' ? Colors.green : Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'D. Berlin',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
