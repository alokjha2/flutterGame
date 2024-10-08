

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:game/presentation/games/binod/binod.dart';
import 'package:game/firebase/auth_checker.dart';
import 'package:game/firebase/notify_handler.dart';
import 'package:game/presentation/games/quiz/widgets/category.dart';
import 'package:game/presentation/games/quiz/quizScreen.dart';
import 'package:game/presentation/games/scavengerHunt/scavengerhunt.dart';
import 'package:game/presentation/games/snapHunt/snaphunt.dart';
import 'package:game/presentation/screens/rooms/room.dart';
import 'package:game/providers/article_providers.dart';
import 'package:game/screens/contacts_screen.dart';
import 'package:game/screens/error.dart';
import 'package:game/screens/games_category_page.dart';
import 'package:game/screens/loginScreen.dart';
import 'package:game/screens/multiPlayer.dart';
import 'package:game/screens/phoneMultiplayer.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'exports.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // initializeFirebaseMessaging(); // Call the function here
  Gemini.init(apiKey: "AIzaSyDztTJXIubhrH5LQ_Jejqys712iylUchwI");
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return 
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ArticleProvider()),
      ],
      child : 
    GetMaterialApp(
      title: 'ElderQuest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppRoutes.homePage,
      
      getPages: [
        GetPage(name: AppRoutes.homePage, page: () => HomeScreen()),
        // GetPage(name: AppRoutes.gamePage, page: () => GamePage()),
        // GetPage(name: AppRoutes.winGamePage, page: () => GameOverScreen(duration: 0,)),
        // GetPage(name: AppRoutes.selectMatrix, page: () => MatrixSelection()),
        // GetPage(name: AppRoutes.contacts, page: () => ContactsScreen()),
        // GetPage(name: AppRoutes.multiPlayer, page: () => MultiPlayerScreen()),
        // GetPage(name: AppRoutes.login, page: () => LoginScreen()),
        // GetPage(name: AppRoutes.Auth, page: () => AuthChecker()),
        GetPage(name: AppRoutes.quiz, page: () => QuizScreen()),
        // GetPage(name: AppRoutes.phoneMultiPlayer, page: () => PhoneMultiPlayer()),
        // GetPage(name: AppRoutes.category, page: () => CategoryScreen()),
        // GetPage(name: AppRoutes.gamesCategory, page: () => GamesCategory()),
        // GetPage(name: AppRoutes.binod, page: () => Binod()),
        // GetPage(name: AppRoutes.hunt, page: () => ScavengerHuntScreen()),
        GetPage(
          name: AppRoutes.room,
          page: () => RoomPage(),
        ),
        // GetPage(name: '/gamesCategory/quiz', page: () => QuizScreen()), 
        // GetPage(name: '/game/snaphunt', page: () => SnapHunt()), 
        // GetPage(name: '/game/memory', page: () => PhoneMultiPlayer()), 
        GetPage(name: AppRoutes.snapHunt, page: () => SnapHunt()), 
      ],
      
    )
    );
  }
}


