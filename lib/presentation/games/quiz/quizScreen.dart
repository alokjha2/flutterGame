import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<dynamic> _questions = [];
  int _currentQuestionIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadQuizQuestions();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadQuizQuestions() async {
    final String response = await rootBundle.loadString('assets/json/data.json');
    final data = await json.decode(response);
    setState(() {
      _questions = data;
    });
    _startQuiz();
  }

  void _startQuiz() {
    _timer = Timer.periodic(Duration(seconds: 10), (Timer timer) {
      setState(() {
        _currentQuestionIndex = (_currentQuestionIndex + 1) % _questions.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final question = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${question['index']}. ${question['question']}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ...List.generate(4, (index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Option click logic
                    if (question['options'][index] == question['correct_answer']) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Correct!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Wrong!')),
                      );
                    }
                  },
                  child: Text(question['options'][index]),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
