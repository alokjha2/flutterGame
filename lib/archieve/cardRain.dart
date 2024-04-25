// import 'dart:async';
// import 'dart:ffi';
// import 'dart:math';

// import 'package:flutter/material.dart';


// class RainOfCards extends StatefulWidget {
//   @override
//   _RainOfCardsState createState() => _RainOfCardsState();
// }

// class _RainOfCardsState extends State<RainOfCards> {
//   List<Widget> _rainCards = [];
//   int _cardCount = 0;

//   @override
//   void initState() {
//     super.initState();
//     _startRain();
//   }

//   void _startRain() {
//     Timer.periodic(Duration(milliseconds: 50), (timer) {
//       if (_cardCount < 10) {
//         setState(() {
//           _rainCards.add(_createCard());
//           _cardCount++;
//         });
//       } else {
//         timer.cancel();
//       }
//     });
//   }

//   Widget _createCard() {
//     double startPosition = Random().nextDouble() * 100;
//     double endPosition = Random().nextDouble() * 100;
//     int delay = Random().nextInt(1000);

//     return AnimatedPositioned(
//       duration: Duration(seconds: 1),
//       curve: Curves.easeInOut,
//       top: -100,
//       left: startPosition,
//       child: DelayedAnimation(
//         delay: delay,
//         child: Card(
//           elevation: 5,
//           child: Container(
//             color: Colors.blue,
//             width: 50,
//             height: 50,
//             child: Center(child: Text('Card')),
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Rain of Cards'),
//       ),
//       body: Stack(
//         children: _rainCards,
//       ),
//     );
//   }
// }

// class DelayedAnimation extends StatelessWidget {
//   final Widget child;
//   final int delay;

//   DelayedAnimation({required this.delay, required this.child});

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: Future.delayed(Duration(milliseconds: delay)),
//       builder: (context, AsyncSnapshot snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Container();
//         } else {
//           return child;
//         }
//       },
//     );
//   }
// }
