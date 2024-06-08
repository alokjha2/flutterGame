

import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:game/repository/article_repository.dart';
// import 'article_repository.dart';

class ArticleProvider extends ChangeNotifier {
  final ArticleRepository _articleRepository = ArticleRepository();
  final Gemini _gemini = Gemini.instance;
  
  String _articleContent = 'No quiz question yet';
  String get articleContent => _articleContent;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> scrapeAndGenerateQuiz(String url) async {
    _isLoading = true;
    notifyListeners();
    
    try {
      final scrappedData = await _articleRepository.scrapeArticle(url);
      if (scrappedData != null) {
        _generateMcqs(scrappedData);
      } else {
        _articleContent = 'Failed to scrape the article.';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _articleContent = 'An error occurred: $e';
      _isLoading = false;
      notifyListeners();
    }
  }

  void _generateMcqs(String scrappedData) {
    _gemini.streamGenerateContent(
      "Here is the scrapped data $scrappedData, generate interesting amazing 10 quiz questions with 4 options and correct answer. If you can't generate questions from the article, generate random 10 questions."
    ).listen(
      (value) {
        _articleContent = value.output!;
        _isLoading = false;
        notifyListeners();
      },
      onError: (e) {
        _articleContent = "Sorry, we couldn't generate quiz questions.";
        _isLoading = false;
        notifyListeners();
      },
    );
  }
}
