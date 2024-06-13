import 'dart:async';
import 'package:flutter/material.dart';
import 'package:game/providers/article_providers.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class QuizScreen extends StatefulWidget {
  // final String articleUrl;

  // QuizScreen({required this.articleUrl});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _countdown = 3;
  Timer? _countdownTimer;
  bool _isStarted = false;
  String _selectedOption = '';
  bool _isAnswerChecked = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel();
        setState(() {
          _isStarted = true;
        });
        _startQuiz();
      }
    });
  }

  void _startQuiz() {
    Provider.of<ArticleProvider>(context, listen: false)
        .scrapeAndGenerateQuiz("https://medium.com/@vkhosla/where-ai-meets-copyright-law-present-and-future-4ff2259b8f18");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<ArticleProvider>(
        builder: (context, provider, child) {
          if (_countdown > 0 && !_isStarted) {
            return Center(
              child: Text(
                'Quiz starting in $_countdown seconds...',
                style: TextStyle(fontSize: 24),
              ),
            );
          }

          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (!_isStarted) {
            return _buildStartButton();
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: provider.quizQuestions.isNotEmpty
                          ? _buildQuizContent(provider.currentQuestion)
                          : [Text('No quiz available')],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStartButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          _startQuiz();
          setState(() {
            _isStarted = true;
          });
        },
        child: Text('Start'),
      ),
    );
  }

  List<Widget> _buildQuizContent(Map<String, dynamic> question) {
  final List<Widget> optionCards = question['options'].map<Widget>((option) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: _isAnswerChecked
            ? null
            : () {
                setState(() {
                  _selectedOption = option;
                  _isAnswerChecked = true;
                });
                // Show if the answer is correct or wrong
                bool isCorrect = option == question['correctAnswer'];
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isCorrect ? 'Correct!' : 'Wrong!',
                      style: TextStyle(color: isCorrect ? Colors.green : Colors.red),
                    ),
                    duration: Duration(seconds: 1),
                  ),
                );
                // Move to next question after a delay
                Future.delayed(Duration(seconds: 2), () {
                  setState(() {
                    _isAnswerChecked = false;
                    Provider.of<ArticleProvider>(context, listen: false).nextQuestion();
                  });
                });
              },
        child: Container(
          padding: EdgeInsets.all(16),
          child: Text(
            option,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }).toList();

  return [
    Text(question['question'], style: TextStyle(fontSize: 22)),
    SizedBox(height: 20),
    ...optionCards,
    SizedBox(height: 20),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(
          onPressed: () {
            Provider.of<ArticleProvider>(context, listen: false).nextQuestion();
          },
          child: Text('Previous'),
        ),
        ElevatedButton(
          onPressed: () {
            Provider.of<ArticleProvider>(context, listen: false).nextQuestion();
          },
          child: Text('Next'),
        ),
      ],
    ),
  ];
}


  Widget _buildOption(String text) {
    final provider = Provider.of<ArticleProvider>(context, listen: false);
    return GestureDetector(
      onTap: _isAnswerChecked
          ? null
          : () {
              setState(() {
                _selectedOption = text;
                _isAnswerChecked = true;
              });
              // Show if the answer is correct or wrong
              bool isCorrect = text == provider.currentQuestion['correctAnswer'];
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isCorrect ? 'Correct!' : 'Wrong!',
                    style: TextStyle(color: isCorrect ? Colors.green : Colors.red),
                  ),
                  duration: Duration(seconds: 1),
                ),
              );
              // Move to next question after a delay
              Future.delayed(Duration(seconds: 2), () {
                setState(() {
                  _isAnswerChecked = false;
                  provider.nextQuestion();
                });
              });
            },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: _selectedOption == text ? Colors.green : Colors.purpleAccent,
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
