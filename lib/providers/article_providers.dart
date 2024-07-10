import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:game/repository/article_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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
      print("error");
    }
  }

  String preprocessArticleContent(String articleContent) {
    String cleanedContent = articleContent.replaceAll(RegExp(r'[*\-'':]+'), '');
    return cleanedContent;
  }

  Future<void> _generateMcqs(String scrappedData) async {
    _gemini.streamGenerateContent(
      "Here is the scrapped data $scrappedData, generate interesting amazing 7 quiz questions with 4 options and correct answer. and give questions and answer in this format data = [ {1. 'question' : 'xyz', 'options': {0: '', 1 : '', 2 : '', 3: ''}, 'correctOption' : 3}, {2. 'question' : 'xyz23', 'options': {0: '', 1 : '', 2 : '', 3: ''}, 'correctOption' : 2} ] and never ever change format. If you can't generate questions from the article, generate random 10 questions related to finance, politics, keep questions short, option short etc",
    ).listen(
      (value) {
        print(value.output);
        _parseQuizContent(value.output!);
        notifyListeners();
      },
      onError: (e) {
        notifyListeners();
      },
    );
  }

  void _parseQuizContent(String content) {
    final List<Map<String, dynamic>> quizData = [];
    final RegExp questionRegex = RegExp(r"'question' : '(.*?)'");
    final RegExp optionsRegex = RegExp(r"'options': {(.*?)},");
    final RegExp correctOptionRegex = RegExp(r"'correctOption' : (.*?)(?=},)");

    final questionMatches = questionRegex.allMatches(content);
    final optionsMatches = optionsRegex.allMatches(content);
    final correctOptionMatches = correctOptionRegex.allMatches(content);

    for (int i = 0; i < questionMatches.length; i++) {
      String question = questionMatches.elementAt(i).group(1)!;
      String optionsString = optionsMatches.elementAt(i).group(1)!;
      String correctOption = correctOptionMatches.elementAt(i).group(1)!.trim();

      List<String> options = optionsString.split(', ').map((option) {
        int colonIndex = option.indexOf(':');
        return option.substring(colonIndex + 1).trim().replaceAll("'", "");
      }).toList();

      quizData.add({
        'question': question,
        'options': {for (int j = 0; j < options.length; j++) j: options[j]},
        'correctOption': int.parse(correctOption),
      });
    }

    _quizQuestions = quizData;
    print(quizData);
    _saveQuizContentToFile(quizData);
  }

  Future<void> _saveQuizContentToFile(List<Map<String, dynamic>> quizContent) async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/quiz_content.json');
    final jsonString = jsonEncode(quizContent);
    await file.writeAsString(jsonString);
  }

  void nextQuestion() {
    if (_currentQuestionIndex < _quizQuestions.length - 1) {
      _currentQuestionIndex++;
    } else {
      scrapeAndGenerateQuiz("https://medium.com/@amaka.anicho/when-your-dreams-die-but-you-dont-9a86dbdb7228");
    }
    notifyListeners();
  }

  Map<String, dynamic> get currentQuestion => _quizQuestions.isNotEmpty
      ? _quizQuestions[_currentQuestionIndex]
      : {};
}
