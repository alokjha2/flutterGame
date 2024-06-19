

import 'dart:convert';
import 'package:http/http.dart' as http;

class ArticleRepository {
  Future<String?> scrapeArticle(String url) async {
      print("api called");
    final response = await http.post(
      // Uri.parse('http://192.168.3.240:5000/scrape'),
      Uri.parse('https://elderquestapi-osmh1da3x-alokjha2s-projects.vercel.app/scrape'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{ 'url': url }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['content'];
    } else {
      throw Exception('Failed to scrape the article');
    }
  }
}
