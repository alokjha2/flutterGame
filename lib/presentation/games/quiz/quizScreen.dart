import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game/exports.dart';
import 'package:game/presentation/games/quiz/widgets/body.dart';
import 'package:game/presentation/games/quiz/widgets/question_controller.dart';
import 'package:get/get.dart';

// class QuizScreen extends StatefulWidget {
//   @override
//   _QuizScreenState createState() => _QuizScreenState();
// }

// class _QuizScreenState extends State<QuizScreen> {
//   List<dynamic> _questions = [];
//   int _currentQuestionIndex = 0;
//   Timer? _timer;

//   @override
//   void initState() {
//     super.initState();
//     _loadQuizQuestions();
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }

//   Future<void> _loadQuizQuestions() async {
//     final String response = await rootBundle.loadString('assets/json/data.json');
//     final data = await json.decode(response);
//     setState(() {
//       _questions = data;
//     });
//     _startQuiz();
//   }

//   void _startQuiz() {
//     _timer = Timer.periodic(Duration(seconds: 10), (Timer timer) {
//       setState(() {
//         _currentQuestionIndex = (_currentQuestionIndex + 1) % _questions.length;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_questions.isEmpty) {
//       return Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }

//     final question = _questions[_currentQuestionIndex];

//     return Scaffold(
//       backgroundColor: Colors.purple.shade50,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {},
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.filter_list, color: Colors.black),
//             onPressed: () {},
//           )
//         ],
//       ),
//       body: Body()
      
      //  Padding(
      //   padding: const EdgeInsets.all(16.0),
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //     children: [
      //       // Progress and Timer
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           Text(
      //             '${_currentQuestionIndex + 1} / ${_questions.length}',
      //             style: TextStyle(fontSize: 18, color: Colors.green),
      //           ),
      //           CircleAvatar(
      //             backgroundColor: Colors.purple.shade100,
      //             child: Text(
      //               '18', // Placeholder for timer
      //               style: TextStyle(fontSize: 18, color: Colors.purple),
      //             ),
      //           ),
      //           Text(
      //             '07',
      //             style: TextStyle(fontSize: 18, color: Colors.red),
      //           ),
      //         ],
      //       ),
      //       SizedBox(height: 20),
      //       // Question
      //       Text(
      //         '${question['question']}',
      //         style: TextStyle(
      //           fontSize: 22,
      //           fontWeight: FontWeight.bold,
      //           color: Colors.black87,
      //         ),
      //         textAlign: TextAlign.center,
      //       ),
      //       SizedBox(height: 20),
      //       // Options
      //       ...List.generate(4, (index) {
      //         bool isCorrect = question['options'][index] == question['correct_answer'];
      //         return Padding(
      //           padding: const EdgeInsets.symmetric(vertical: 8.0),
      //           child: ElevatedButton(
      //             style: ElevatedButton.styleFrom(
      //               backgroundColor: isCorrect ? Colors.green : Colors.white,
      //               side: BorderSide(
      //                 color: isCorrect ? Colors.green : Colors.red,
      //               ),
      //               padding: EdgeInsets.symmetric(vertical: 16),
      //               shape: RoundedRectangleBorder(
      //                 borderRadius: BorderRadius.circular(10),
      //               ),
      //             ),
      //             onPressed: () {
      //               if (isCorrect) {
      //                 ScaffoldMessenger.of(context).showSnackBar(
      //                   SnackBar(content: Text('Correct!')),
      //                 );
      //               } else {
      //                 ScaffoldMessenger.of(context).showSnackBar(
      //                   SnackBar(content: Text('Wrong!')),
      //                 );
      //               }
      //             },
      //             child: Text(
      //               question['options'][index],
      //               style: TextStyle(
      //                 fontSize: 18,
      //                 color: isCorrect ? Colors.white : Colors.black,
      //               ),
      //             ),
      //           ),
      //         );
      //       }),
      //       Spacer(),
      //     ],
      //   ),
      // ),
//     );
//   }
// }


class QuizScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    QuestionController _controller = Get.put(QuestionController());
    return Scaffold(
      extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
      appBar: AppBar(
        // Fluttter show the back button automatically
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          ElevatedButton(onPressed: (){}, child: Text("Skip")),
        ],
      ),
      body: Body(),
    );
  }
}