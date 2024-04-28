import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:get/get.dart';
import 'package:game/controller/countDownController.dart';
import 'package:game/controller/gameTimerController.dart';
import 'package:game/exports.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

int _previousIndex = -1;
bool _flip = false;
bool _start = false;
bool _wait = false;
bool _isFinished = false;
int _left = 0;
List _data = [];
List<bool> _cardFlips = [];
List<GlobalKey<FlipCardState>> _cardStateKeys = [];
int _player1Points = 0;
int _player2Points = 0;
int _currentPlayer = 1;
int _chancesLeft = 2;

final player = AssetsAudioPlayer();

class PhoneMultiPlayer extends StatefulWidget {
  const PhoneMultiPlayer({Key? key});

  @override
  State<PhoneMultiPlayer> createState() => _PhoneMultiPlayerState();
}

class _PhoneMultiPlayerState extends State<PhoneMultiPlayer> {
  final gameTimerController = Get.put(GameTimerController());
  final countDownController = Get.put(CountDownController());

  @override
  void initState() {
    super.initState();
    countDownController.startCountdown();
    initializeGameData();
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
            onFlip: () => onFlip(index),
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
              width: 100,
              height: 200,
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

  onFlip(int index) {
    player.open(Audio("assets/sounds/flip.mp3"));
    if (!_flip && _chancesLeft > 0) {
      _flip = true;
      _previousIndex = index;
      _chancesLeft--;
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
                _chancesLeft = 2;
                switchPlayer();
              });
            });
          });
        } else {
          player.open(Audio("assets/sounds/90s-game-ui-7-185100.mp3"));
          _cardFlips[_previousIndex] = false;
          _cardFlips[index] = false;
          setState(() {
            _left -= 1;
            if (_currentPlayer == 1) {
              _player1Points++;
            } else {
              _player2Points++;
            }
            if (_cardFlips.every((t) => t == false)) {
              _isFinished = true;
              _start = false;
            }
            _chancesLeft = 2;
            switchPlayer();
          });
        }
      }
    }
    setState(() {});
  }

  void switchPlayer() {
    _currentPlayer = _currentPlayer == 1 ? 2 : 1;
  }

  void _startGame() {
    _start = true;
    player.open(Audio("assets/sounds/start.mp3"));
    gameTimerController.startDuration();
  }

  @override
  void dispose() {
    super.dispose();
    countDownController;
    gameTimerController;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return _isFinished
        ? GameOverScreen(
            duration: gameTimerController.gameDuration.value,
            player1Points: _player1Points,
            player2Points: _player2Points,
          )
        : Scaffold(
            body: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 1,
                height: MediaQuery.of(context).size.height * 1,
                child: Container(
                  decoration: BoxDecoration(
                    // image: DecorationImage(
                    //   image: AssetImage("assets/images/bg.jpg"),
                    //   fit: BoxFit.cover,
                    // ),
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
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: _currentPlayer == 1 ? Colors.green : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        'Player 1 Points: $_player1Points',
                                        style: theme.bodyMedium,
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: _currentPlayer == 2 ? Colors.green : Colors.transparent,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        'Player 2 Points: $_player2Points',
                                        style: theme.bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
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
                                child: _start ? getItem(index) : getItem(index),
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
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
