import "package:game/controller/countDownController.dart";
import "package:game/controller/gameTimerController.dart";
import "package:game/exports.dart";
import "package:get/get.dart";


int _previousIndex = -1;
// int _time = 3;
// int gameDuration = -3;
bool _flip = false;
bool _start = false;
bool _wait = false;
late bool _isFinished;
// late Timer _timer;
// late Timer _durationTimer;
late int _left;
late List _data;
late List<bool> _cardFlips;
late List<GlobalKey<FlipCardState>> _cardStateKeys;
final player = AssetsAudioPlayer();
class GamePage extends StatefulWidget {
  const GamePage({Key? key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  final gameTimerController = Get.put(GameTimerController());
  final countDownController = Get.put(CountDownController());

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


onFlip(index){
  player.open(
                Audio("assets/sounds/flip.mp3"),
              );
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
                      Audio("assets/sounds/90s-game-ui-7-185100.mp3"), // Play sound on match
                      // Audio("assets/sounds/start.mp3"), // Play sound on match
                    );
                    _cardFlips[_previousIndex] = false;
                    _cardFlips[index] = false;
                    setState(() {
                      _left -= 1;
                    });


                    if (_cardFlips.every((t) => t == false)) {
                      debugPrint("Won");
                      Future.delayed(const Duration(milliseconds: 160), () {
                        setState(() {
                          _isFinished = true;
                          _start = false;
                        });
                      });
                    }
                  }
                }
              }
              setState(() {});
}
  

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

  @override
  void initState() {
    super.initState();
    countDownController.startCountdown();
    initializeGameData();
  }

  @override
void dispose() {
  // Dispose of the controllers properly
  countDownController.dispose();
  gameTimerController.dispose();
  super.dispose();
}

  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return _isFinished
        ? GameOverScreen(
            duration: gameTimerController.gameDuration.value,
          )
        : Scaffold(
            body: Center(
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
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [

                                    IconButton(onPressed: (){
      
                                    }, icon: Icon(Icons.mic)),
                                    IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        // Navigate back when the back button is pressed
        Get.back();
      },
    ),
                                    Text(
                                      'Remaining: $_left',
                                      style: theme.bodyMedium,
                                    ),
                                    Obx(() => 
                                    Text(
                                      'Duration: ${gameTimerController.gameDuration.value}s',
                                      style: theme.bodyMedium,
                                    ),)
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
      // Countdown reached 0, start the game and return an empty container or null to remove the countdown from the screen
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
