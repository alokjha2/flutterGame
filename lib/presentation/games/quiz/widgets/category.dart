import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:game/presentation/games/quiz/widgets/question_controller.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:game/presentation/router/routes.dart';
import 'package:logger/logger.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _filteredCategories = [];
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _searchController.addListener(_filterCategories);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('http://192.168.3.240:5000/categories'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _categories = data.cast<Map<String, dynamic>>();
          _filteredCategories = _categories;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Handle the error (e.g., show an error message to the user)
      print('Error fetching categories: $e');
    }
  }

  void _filterCategories() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCategories = _categories
          .where((category) => category['category'].toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search Categories',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns
                        crossAxisSpacing: 10.0, // Spacing between columns
                        mainAxisSpacing: 10.0, // Spacing between rows
                        childAspectRatio: 2, // Width to height ratio of each grid item
                      ),
                      itemCount: _filteredCategories.length,
                      itemBuilder: (context, index) {
                        return CategoryCard(
                          category: _filteredCategories[index]['category'],
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String category;

  CategoryCard({required this.category});

// Future<void> _generateQuiz(BuildContext context) async {
//   try {
//     final response = await http.post(
//       Uri.parse('http://192.168.3.240:5000/generatequiz'),
//       headers: {'Content-Type': 'application/json'},
//       body: json.encode({
//         'num_questions': 5, // Example number of questions
//         'category': category,
//         'difficulty': 'medium', // Example difficulty
//       }),
//     );

//     if (response.statusCode == 200) {
//       final responseBody = json.decode(response.body);

//       // Ensure the "questions" field is a list of maps
//       Logger().i(responseBody);
//       final List<dynamic> questionsData = responseBody['questions'];
//       final List<Map<String, dynamic>> questionsList = 
//         questionsData.map((item) => item as Map<String, dynamic>).toList();

//       Logger().i("data: " + questionsList.toString());

//       // Access the QuestionController and set the questions
//       QuestionController questionController = Get.find<QuestionController>();
//       questionController.questions.assignAll(questionsList);

//       // Navigate to the quiz page
//       Get.toNamed(AppRoutes.quiz);
//     } else {
//       throw Exception('Failed to generate quiz');
//     }
//   } catch (e) {
//     print('Error generating quiz: $e');
//     // Handle the error (e.g., show an error message to the user)
//   }
// }



  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => 
       Get.toNamed(AppRoutes.quiz),
      // _generateQuiz(context),
      child: Card(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              category,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
