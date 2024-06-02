

import 'package:firebase_core/firebase_core.dart';
import 'package:game/firebase/auth_checker.dart';
import 'package:game/firebase/notify_handler.dart';
import 'package:game/quiz/category.dart';
import 'package:game/quiz/quizScreen.dart';
import 'package:game/screens/contacts_screen.dart';
import 'package:game/screens/error.dart';
import 'package:game/screens/games.dart';
import 'package:game/screens/loginScreen.dart';
import 'package:game/screens/multiPlayer.dart';
import 'package:game/screens/phoneMultiplayer.dart';
import 'package:get/get.dart';

import 'exports.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  initializeFirebaseMessaging(); // Call the function here
//  FlutterError.onError = (FlutterErrorDetails details) {
//     // Log the error
//     FlutterError.dumpErrorToConsole(details);

//     // Navigate to the error screen
//     Get.to(() => ErrorScreen(errorMessage: details.exceptionAsString()));
//   };

  // runZonedGuarded(() {
    runApp(MyApp());
  // }, (error, stackTrace) {
    // Handle any errors that are not caught by Flutter's framework
  //   Get.to(() => ErrorScreen(errorMessage: error.toString()));
  // });

}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ElderQuest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Games(),
      // initialRoute: AppRoutes.homePage,
      
      // getPages: [
      //   GetPage(name: AppRoutes.homePage, page: () => HomeScreen()),
      //   GetPage(name: AppRoutes.gamePage, page: () => GamePage()),
      //   GetPage(name: AppRoutes.winGamePage, page: () => GameOverScreen(duration: 0,)),
      //   GetPage(name: AppRoutes.selectMatrix, page: () => MatrixSelection()),
      //   GetPage(name: AppRoutes.contacts, page: () => ContactsScreen()),
      //   GetPage(name: AppRoutes.multiPlayer, page: () => MultiPlayerScreen()),
      //   GetPage(name: AppRoutes.login, page: () => LoginScreen()),
      //   GetPage(name: AppRoutes.Auth, page: () => AuthChecker()),
      //   GetPage(name: AppRoutes.quiz, page: () => QuizScreen()),
      //   GetPage(name: AppRoutes.phoneMultiPlayer, page: () => PhoneMultiPlayer()),
      //   GetPage(name: AppRoutes.category, page: () => CategoryScreen()),
      // ],
      
      
    );
  }
}
