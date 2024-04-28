


import "package:firebase_auth/firebase_auth.dart";
import "package:game/controller/countDownController.dart";
import "package:game/controller/gameTimerController.dart";
import "package:game/controller/waitingScreen.dart";
import "package:game/exports.dart";
import "package:game/invitation.dart";
import "package:get/get.dart";
import "package:socket_io_client/socket_io_client.dart" as io;

import "package:game/controller/countDownController.dart";
import "package:game/controller/gameTimerController.dart";
import "package:game/controller/waitingScreen.dart";
import "package:game/exports.dart";
import "package:game/invitation.dart";
import "package:get/get.dart";
import "package:socket_io_client/socket_io_client.dart" as io;
import 'package:firebase_database/firebase_database.dart'; // Import Firebase Realtime Database package

int _previousIndex = -1;
bool _flip = false;
bool _start = false;
bool _wait = false;
late bool _isFinished;
late int _left;
bool _isPlayer1Turn = true; // Track whose turn it is
late List _data;
late List<bool> _cardFlips;
late List<GlobalKey<FlipCardState>> _cardStateKeys;
final player = AssetsAudioPlayer();

class MultiPlayerScreen extends StatefulWidget {
  const MultiPlayerScreen({Key? key});

  @override
  State<MultiPlayerScreen> createState() => _MultiPlayerScreenState();
}

class _MultiPlayerScreenState extends State<MultiPlayerScreen> {
  final gameTimerController = Get.put(GameTimerController());
  final countDownController = Get.put(CountDownController());
  final WaitingScreenController waitingScreenController =
      Get.put(WaitingScreenController());

  String roomId = Get.arguments;

  // Firebase Realtime Database reference
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  // Game state variables
  Map<String, dynamic> _gameState = {}; // Store the game state
  String? _currentTurn; // Track whose turn it is
  int _player1Score = 0; // Store player 1's score
  int _player2Score = 0; // Store player 2's score

  @override
  void initState() {
    super.initState();
    countDownController.startCountdown();
    initializeGameData();
    Invitation().listenToPlayers(roomId);
    _listenToGameState(); // Listen to game state changes
  }

  @override
  void dispose() {
    super.dispose();
    countDownController;
    gameTimerController;
  }

  

  // Listen to game state changes in the Firebase Realtime Database
  void _listenToGameState() {
    _database.child('gameRooms/$roomId/gameState').onValue.listen((event) {
      final gameState = event.snapshot.value as Map<dynamic, dynamic>?;
      if (gameState != null) {
        setState(() {
          _gameState = gameState.cast<String, dynamic>();
          _currentTurn = _gameState['currentTurn'];
          _player1Score = _gameState['player1Score'] ?? 0;
          _player2Score = _gameState['player2Score'] ?? 0;
        });
      }
    });
  }

  // Update the game state in the Firebase Realtime Database
  void _updateGameState(Map<String, dynamic> updatedState) {
    _database
        .child('gameRooms/$roomId/gameState')
        .update(updatedState)
        .catchError((error) {
      print('Failed to update game state: $error');
    });
  }

  // Flip the card and handle the game logic
  onFlip(index) {
    player.open(
      Audio("assets/sounds/flip.mp3"),
    );

    // Check if it's the player's turn
    if (_currentTurn == FirebaseAuth.instance.currentUser!.uid) {
      if (!_flip) {
        _flip = true;
        _previousIndex = index;
      } else {
        _flip = false;
        if (_previousIndex != index) {
          if (_data[_previousIndex] != _data[index]) {
            _wait = true;

            Future.delayed(const Duration(milliseconds: 1500), () {
              _cardStateKeys[_previousIndex].currentState!.toggleCard();
              _previousIndex = index;
              _cardStateKeys[_previousIndex].currentState!.toggleCard();

              Future.delayed(const Duration(milliseconds: 160), () {
                setState(() {
                  _wait = false;
                });
              });
            });
          } else {
            player.open(
              Audio("assets/sounds/90s-game-ui-7-185100.mp3"),
            );
            _cardFlips[_previousIndex] = false;
            _cardFlips[index] = false;
            setState(() {
              _left -= 1;
            });

            // Update the player's score
            if (_currentTurn == FirebaseAuth.instance.currentUser!.uid) {
              _updatePlayerScore();
            }

            if (_cardFlips.every((t) => t == false)) {
              debugPrint("Won");
              Future.delayed(const Duration(milliseconds: 160), () {
                setState(() {
                  _isFinished = true;
                  _start = false;
                });
              });
            }

            // Check if the player can get another chance
            if (_data[_previousIndex] == _data[index]) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('You matched a pair! You get one more chance.'),
                  duration: Duration(seconds: 2),
                ),
              );
              return;
            }
          }
        }
      }
      setState(() {});
      _updateTurn(); // Update the turn
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please wait for your turn.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Update the player's score
  void _updatePlayerScore() {
    if (_currentTurn == FirebaseAuth.instance.currentUser!.uid) {
      setState(() {
        if (_currentTurn == _gameState['player1']) {
          _player1Score++;
        } else {
          _player2Score++;
        }
      });
      _updateGameState({
        'player1Score': _player1Score,
        'player2Score': _player2Score,
      });
    }
  }

  // Update the turn
  void _updateTurn() {
    String? nextTurn;
    if (_currentTurn == _gameState['player1']) {
      nextTurn = _gameState['player2'];
    } else {
      nextTurn = _gameState['player1'];
    }
    _updateGameState({'currentTurn': nextTurn});
  }

  // Rest of your code...


  void _startGame() {
    _start = true;
    player.open(
      Audio("assets/sounds/start.mp3"),
    );
    gameTimerController.startDuration();
  }

  void initializeGameData() {
    _data = createShuffledListFromImageSource();
    _cardFlips = getInitialItemStateList();
    _cardStateKeys = createFlipCardStateKeysList();
    _left = (_data.length ~/ 2);
    _isFinished = false;
  }


    
 Widget getItem(int index) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Center(
          child: FlipCard(
            key: _cardStateKeys[index],
            onFlip: ()=>onFlip(index),
            flipOnTouch: _wait ? false : _cardFlips[index],
            direction: FlipDirection.HORIZONTAL,
            front: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(
                  image: AssetImage("assets/images/front.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              width: 100, // Adjust width to fit your design
              height: 200, // Adjust height to fit your design
            ),
            back: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.lightBlue,
                image: DecorationImage(
                  image: AssetImage(_data[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return _isFinished
        ? GameOverScreen(
            duration: gameTimerController.gameDuration.value,
          )
        : 
        
        Scaffold(
            body: 
            
        Obx(
        () => Center(
          child: waitingScreenController.showWaitingScreen.value == true
              ? Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text('Waiting for other players...'),
                  ),
                )
              :
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 1, // Adjust width factor as needed
                height: MediaQuery.of(context).size.height * 1, // Adjust height factor as needed
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/bg.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                           Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildPlayerContainer("Player 1", 3, Colors.red),
                                  _buildPlayerContainer("Player 2", 8, Colors.green),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            GridView.builder(
                              padding: const EdgeInsets.fromLTRB(4, 6, 2, 6),
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 0.7,
                                crossAxisCount: 4,
                              ),
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: _start
                                    ? getItem(index)
                                    : getItem(index),
                              ),
                              itemCount: _data.length,
                            ),
                          ],
                        ),
                      ),
                      Obx(
  () {
    if (!_start && countDownController.countdown.value > 0) {
      return CountdownOverlay(timerValue: countDownController.countdown.value);
    } else {
      _startGame();
      return Container();
    }
  },
),

                    ],
                  ),
                ),
              ),
            ),))
          );
  }
 Widget _buildPlayerContainer(String playerName, int points, color) {
  return Container(
    height: 100,
    width: 150,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(25), // Circular border
      border: Border.all(color: Colors.black, width: 2), // Border color and width
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          playerName,
        ),
        SizedBox(height: 10),
        Text(
          'Points: $points',
        
        ),
        // Obx(() => 
        //   Text(
        //     'Duration: ${gameTimerController.gameDuration.value}s',
           
        //   ),
        // ),
      ],
    ),
  );
} 
}
