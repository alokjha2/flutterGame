import 'package:flutter/material.dart';
import 'package:game/presentation/router/routes.dart';
import 'package:get/get.dart';
// import 'app_routes.dart'; // Import your AppRoutes class

class GamesCategory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Games'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Single Player'),
              Tab(text: 'Multiplayer'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GameGridView(games: singlePlayerGames),
            GameGridView(games: multiplayerGames),
          ],
        ),
      ),
    );
  }
}

class GameGridView extends StatelessWidget {
  final List<String> games;

  GameGridView({required this.games});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 1.6
        ),
        itemCount: games.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              navigateToGame(context, games[index]);
            },
            child: Card(
              child: Center(
                child: Text(
                  games[index],
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void navigateToGame(BuildContext context, String gameName) {
    switch (gameName) {
      case 'Quiz':
        Get.toNamed(AppRoutes.quiz); // Use AppRoutes to get the route name
        break;
      case 'Memory Game':
        // Get.toNamed(AppRoutes.);
      break;
      case 'Who is Binod?':
        Get.toNamed(AppRoutes.room);
      break;
      case 'Hunt':
        Get.toNamed(AppRoutes.hunt);
      break;
      case 'snapHunt':
        // Get.toNamed(AppRoutes.);
      break;
      // Add cases for other games if needed
    }
  }
}

final List<String> singlePlayerGames = [
  'Quiz',
  'Hunt',
  'Memory Game',
];

final List<String> multiplayerGames = [
  'Who is Binod?',
  'Quiz',
  'Hunt',
  'Memory Game',
  "snapHunt"
];
