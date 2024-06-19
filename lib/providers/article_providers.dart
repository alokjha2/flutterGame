import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:game/repository/article_repository.dart';

class ArticleProvider extends ChangeNotifier {
  final ArticleRepository _articleRepository = ArticleRepository();
  final Gemini _gemini = Gemini.instance;

  List<Map<String, dynamic>> _quizQuestions = [];
  List<Map<String, dynamic>> get quizQuestions => _quizQuestions;

  int _currentQuestionIndex = 0;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> scrapeAndGenerateQuiz(String url) async {
    _isLoading = true;
    notifyListeners();

    try {
      final scrappedData = await _scrapeArticle(url);
      if (scrappedData != null) {
        print("scrapping");
        // print("scrapping");
        await _generateMcqs(scrappedData);
      } else {
        // Handle scraping failure
      }
    } catch (e) {
      // Handle exceptions
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

 Future<String?> _scrapeArticle(String url) async {
  final response = await http.post(
    Uri.parse('https://elderquestapi.vercel.app/scrape'),
    // Uri.parse('http://192.168.3.240:5000/scrape'),
    headers: {'Content-Type': 'application/json; charset=UTF-8'},
    body: jsonEncode({'url': url}),
  );
  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final scrappedData = data['content'];
    final cleanedData = preprocessArticleContent(scrappedData);
  print("api used: ");
    return cleanedData;
  } else {
    // return Text(scrappedData);
    print("error");
  }
}

String preprocessArticleContent(String articleContent) {
  // Remove unwanted characters using regular expressions
  String cleanedContent = articleContent.replaceAll(RegExp(r'[*\-:]+'), '');
  return cleanedContent;
}

void _parseQuizContent(String content) {
  // Extracting question
  final questionStartIndex = content.indexOf('{question');
  final questionEndIndex = content.indexOf(',', questionStartIndex);
  final question = content.substring(questionStartIndex + 10, questionEndIndex - 1);

  // Extracting options
  final optionsStartIndex = content.indexOf('{answers');
  final optionsEndIndex = content.indexOf('}', optionsStartIndex);
  final optionsString = content.substring(optionsStartIndex + 10, optionsEndIndex - 1);
  final optionsList = optionsString.split('. ');

  // Extracting correct answer
  final correctAnswerStartIndex = content.indexOf('correct answer');
  final correctAnswerEndIndex = content.indexOf('}', correctAnswerStartIndex);
  final correctAnswer = content.substring(correctAnswerStartIndex + 16, correctAnswerEndIndex - 1);

  // Adding extracted data to _quizQuestions
  _quizQuestions.add({
    'question': question,
    'options': optionsList,
    'correctAnswer': correctAnswer,
  });
}





String preprocessQuestion(String question) {
  // Remove unwanted characters from the question
  return question.replaceAll(RegExp(r'[*\-:]+'), '');
}

String preprocessOption(String option) {
  // Remove unwanted characters from the option
  return option.replaceAll(RegExp(r'[*\-:]+'), '');
}


  Future<void> _generateMcqs(String scrappedData) async {
    _gemini.streamGenerateContent(
      "Here is the scrapped data $scrappedData, generate interesting amazing 10 quiz questions with 4 options and correct answer. and give questions and answer in this format {question 1. whatever question is ? , {answers : option 1. , option 2. option 3. option 4. }, correct answer : option 3} and never ever change format. If you can't generate questions from the article, generate random 10 questions related to finance, politics, etc",
    ).listen(
      (value) {
        print(value.output);
        
        _parseQuizContent(value.output!);
        notifyListeners();
      },
      onError: (e) {
        // Handle error
        notifyListeners();
      },
    );
  }

  // void _parseQuizContent(String content) {
  //   // Parse the content to extract questions and options
  //   final parsedContent = jsonDecode(content);
  //   _quizQuestions = parsedContent['questions'];
  // }

  void nextQuestion() {
    if (_currentQuestionIndex < _quizQuestions.length - 1) {
      _currentQuestionIndex++;
    } else {
      // Fetch more questions if needed
      scrapeAndGenerateQuiz("https://medium.com/@amaka.anicho/when-your-dreams-die-but-you-dont-9a86dbdb7228");
    }
    notifyListeners();
  }

  Map<String, dynamic> get currentQuestion =>
      _quizQuestions.isNotEmpty ? _quizQuestions[_currentQuestionIndex] : {};
}
