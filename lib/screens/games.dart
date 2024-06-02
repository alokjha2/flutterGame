



import 'package:flutter/material.dart';



class Games extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Game Selector'),
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
          return Card(
            child: Center(
              child: Text(
                games[index],
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }
}

final List<String> singlePlayerGames = [
  'Memory Game',
  'Puzzle Game',
  'Hunt Game',
  'Maze Runner',
  'Sudoku',
  'Word Search',
];

final List<String> multiplayerGames = [
  'Chess',
  'Checkers',
  'Battleship',
  'Pictionary',
  'Scrabble',
  'Tic Tac Toe',
  "Binod", 
];
