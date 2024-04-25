

import 'package:firebase_core/firebase_core.dart';
import 'package:game/screens/contacts_screen.dart';

import 'exports.dart';


void main() async{
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Memory Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppRoutes.homePage,
      getPages: [
        GetPage(name: AppRoutes.homePage, page: () => HomeScreen()),
        GetPage(name: AppRoutes.gamePage, page: () => GamePage()),
        GetPage(name: AppRoutes.winGamePage, page: () => GameOverScreen(duration: 0,)),
        GetPage(name: AppRoutes.selectMatrix, page: () => MatrixSelection()),
        GetPage(name: AppRoutes.multiPlayer, page: () => ContactsScreen()),
      ],
    );
  }
}
