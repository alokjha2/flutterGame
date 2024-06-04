import 'package:flutter/material.dart';
import 'package:game/presentation/router/routes.dart';
import 'package:get/get.dart';

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
            childAspectRatio: 1.6),
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
    // Get the current TabController
    TabController? tabController = DefaultTabController.of(context);
    int currentIndex = tabController?.index ?? 0;

    // Check the current tab index
    if (currentIndex == 0) {
      // Single Player tab
      switch (gameName) {
        case 'Quiz':
          Get.toNamed(AppRoutes.quiz);
          break;
        case 'Memory Game':
          // Navigate to the Memory Game screen or do nothing
          // Get.toNamed(AppRoutes.memoryGame);
          break;
        case 'Hunt':
          Get.toNamed(AppRoutes.hunt);
          break;
        // Add cases for other single-player games if needed
        default:
          // Do nothing or show a message
          print('Game not found or not implemented yet.');
      }
    } else {
      // Multiplayer tab
      if (multiplayerGames.contains(gameName)) {
        // This is a multiplayer game, navigate to the room screen
        Get.toNamed(AppRoutes.room);
      } else {
        // This is a single-player game, handle it as before
        switch (gameName) {
          case 'Quiz':
            Get.toNamed(AppRoutes.quiz);
            break;
          case 'Memory Game':
            // Navigate to the Memory Game screen or do nothing
            // Get.toNamed(AppRoutes.memoryGame);
            break;
          case 'Hunt':
            Get.toNamed(AppRoutes.hunt);
            break;
          // Add cases for other single-player games if needed
          default:
            // Do nothing or show a message
            print('Game not found or not implemented yet.');
        }
      }
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