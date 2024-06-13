import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

class GameOverScreen extends StatefulWidget {
  final int duration;
  final player2Points;
  final player1Points;

  const GameOverScreen({super.key, required this.duration, this.player2Points, this.player1Points});

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen> {
  bool isConfettiPlaying = true;
  final _confettiController = ConfettiController(
    duration: const Duration(seconds: 12),
  );
  

  @override
  void initState() {
    super.initState();
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text: "Under ",
                    style: theme.bodyLarge,
                    children: [
                      TextSpan(
                          text: "${widget.duration}",
                          style: theme.displaySmall),
                      TextSpan(text: "seconds", style: theme.bodySmall),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: "Congratulations! \n",
                    style: theme.bodyLarge,
                    children: [
                      TextSpan(
                          text:
                              "",
                          style: theme.bodySmall,
                          
                          ),

                          TextSpan(
                            text: "\n Player 1 Point : ${widget.player1Points!=null? widget.player1Points : ''} "),

                          TextSpan(
                            text: "\n Player 2 Point : ${widget.player2Points!=null? widget.player2Points : ''} "),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  child: const Text("Replay Game"),
                ),
              ],
            ),
          ),
          ConfettiWidget(
            numberOfParticles: 30,
            minBlastForce: 10,
            maxBlastForce: 20,
            blastDirectionality: BlastDirectionality.explosive,
            confettiController: _confettiController,
            gravity: 0.1,
          ),
        ],
      ),
    );
  }
}
