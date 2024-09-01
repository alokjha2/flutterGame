import 'dart:ui';

import 'package:game/components/homepage_btn.dart';
import 'package:game/exports.dart';
import 'package:game/presentation/screens/profile/settings.dart';
import 'package:game/widgets/fancyButton.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // PackageInfo? packageInfo;
  // UpdateResult? _result;
  var _startTime = 0;
  var _bytesPerSec;
  var _download;

  @override
  void initState() {
    super.initState();
    checkForUpdate();
  }

  Future<void> checkForUpdate() async {
     final snackBar = SnackBar(
            content: Text('update available'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change
              },
            ),
          );

          // Show the SnackBar
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          // print('update available');
          
          update();

    // print('checking for Update');
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
           final snackBar = SnackBar(
            content: Text('update available'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change
              },
            ),
          );

          // Show the SnackBar
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          // print('update available');
          
          update();
        }
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  void update() async {
    print('Updating');
     final snackBar = SnackBar(
            content: Text('updating app'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change
              },
            ),
          );

          // Show the SnackBar
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
    await InAppUpdate.startFlexibleUpdate();
    InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((e) {
      print(e.toString());
       final snackBar = SnackBar(
            content: Text("error "+ e.toString()),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change
              },
            ),
          );

          // Show the SnackBar
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.purpleAccent.shade100,

      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Purple overlay
          Container(
            color: Colors.purpleAccent.shade100.withOpacity(0.5),
          ),

          RainAnimation(screenSize: size),
          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [


                BeatingHeartButton(),
              ],
            ),
          ),
          // Rain animation
Positioned(
  bottom: 20,
  left: 20,
  child: ElevatedButton(
    onPressed: () {
      Get.to(() => SettingsScreen());
      // Action for the button
    },
    style: ElevatedButton.styleFrom(
      fixedSize: Size(70, 70),
      backgroundColor: Colors.orange,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(color: Colors.white, width: 4),
      ),
    ),
   
      child: Icon(
        Icons.settings_sharp,
        size: 25,
        color: Colors.white,
      ),
  ),
),


        ],
      ),
    );
  }
}

