import 'package:flutter/material.dart';
import 'package:game/presentation/router/routes.dart';
import 'package:get/get.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<String> _allCategories = [
    "MBA", "Science", "Current Affairs", "Human Body", "Technology", 
    "Health", "History", "Mathematics", "Physics", "Chemistry", 
    "Biology", "Geography", "Entertainment", "Sports", "Literature",
    "AI", "Blockchain", "Machine Learning", "USA", "India", "China",
    "Germany", "France", "UK", "World War I", "World War II", "Ancient Rome",
    "Renaissance", "Benjamin Franklin", "Albert Einstein", "Marie Curie",
    "Mahatma Gandhi", "Astronomy", "Cybersecurity", "Algebra", "Geometry",
    "Calculus", "Statistics", "Continents", "Oceans", "Rivers", "Mountains",
    "Human Body", "Plants", "Animals", "Genetics"
  ];

  List<String> _filteredCategories = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredCategories = _allCategories;
    _searchController.addListener(_filterCategories);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCategories() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCategories = _allCategories
          .where((category) => category.toLowerCase().contains(query))
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
        child: Column(
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
                  return CategoryCard(category: _filteredCategories[index]);
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("hello");
        Get.toNamed(AppRoutes.quiz);
      },
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
