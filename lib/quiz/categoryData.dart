

import 'dart:convert';
import 'package:http/http.dart' as http;

class CategoryService {
  static const String _baseUrl = 'https://opentdb.com/api_category.php';

  Future<List<String>> fetchCategories() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final categories = data['trivia_categories'] as List;
      return categories.map((category) => category['name'] as String).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
