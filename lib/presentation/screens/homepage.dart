import 'dart:ui';

import 'package:flutter_autoupdate/flutter_autoupdate.dart';
import 'package:game/components/homepage_btn.dart';
import 'package:game/exports.dart';
import 'package:game/presentation/screens/profile/settings.dart';
import 'package:game/widgets/fancyButton.dart';
import 'package:get/get.dart';
import 'package:new_version/new_version.dart';
// import 'package:package_info_plus/package_info_plus.dart';
import 'package:version/version.dart';
import 'package:in_app_update/in_app_update.dart';
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // PackageInfo? packageInfo;
  UpdateResult? _result;
  var _startTime = 0;
  var _bytesPerSec;
  var _download;

  @override
  void initState() {
    super.initState();
    final Version currentVersion = new Version(1, 0, 3);
    final Version latestVersion = Version.parse("2.1.0");

    if (latestVersion > currentVersion) {
      print("Update is available");
    }

    final Version betaVersion =
        new Version(2, 1, 0, preRelease: <String>["beta"]);
    // Note: this test will return false, as pre-release versions are considered
    // lesser than a non-pre-release version that otherwise has the same numbers.
    if (betaVersion > latestVersion) {
      print("More recent beta available");
    }
    update();
    // getPackageInfoData();
    // initPlatformState();
  }

  Future<void> checkForUpdate() async {
     InAppUpdate.checkForUpdate().then((updateInfo) {
     if (updateInfo.updateAvailability ==true) {
     InAppUpdate.startFlexibleUpdate().catchError((e) => print(e));
     }
   });
 }

  void update() {
    final newVersion = NewVersion(
      // iOSId: 'com.google.Vespa',
      androidId: 'com.peckishhuman.memorygame',
    );

    const simpleBehavior = true;

    if (simpleBehavior) {
      basicStatusCheck(newVersion);
    } else {
      // Add your else statement logic here
      // For example:
      print("simpleBehavior is false, performing alternative actions");
      advancedStatusCheck(newVersion);
    }
  }

  void basicStatusCheck(NewVersion newVersion) {
    newVersion.showAlertIfNecessary(context: context);
  }

  void advancedStatusCheck(NewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      debugPrint(status.releaseNotes);
      debugPrint(status.appStoreLink);
      debugPrint(status.localVersion);
      debugPrint(status.storeVersion);
      debugPrint(status.canUpdate.toString());
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'Custom Title',
        dialogText: 'Custom Text',
      );
    }
  }

  // Future<void> getPackageInfoData() async {
  //   setState(() async {
  //     packageInfo = await PackageInfo.fromPlatform();
  //   });
  // }

  // Future<void> initPlatformState() async {
  //   UpdateResult? result;
  
  //   String versionUrl = 'https://github.com/alokjha2/version/blob/main/main.json'; 
  //   var manager = UpdateManager(versionUrl: versionUrl);
    
  //   try {
  //     result = await manager.fetchUpdates();
    
  //     setState(() {
  //       _result = result;
  //     });

  //     if (packageInfo != null) {
  //       if (Version.parse(packageInfo!.version) < result?.latestVersion) {
  //         var controller = await result?.initializeUpdate();
  //         controller?.stream.listen((event) async {
  //           setState(() {
  //             if (DateTime.now().millisecondsSinceEpoch - _startTime >= 1000) {
  //               _startTime = DateTime.now().millisecondsSinceEpoch;
  //               _bytesPerSec = event.receivedBytes - _bytesPerSec;
  //             }
  //             _download = event;
  //           });

  //           if (event.completed) {
  //             await controller.close();
  //             await result?.runUpdate(event.path, autoExit: true);
  //           }
  //         });
  //       }
  //     }
  //   } on Exception {
  //     // Handle exceptions
  //   }
  // }
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

    //             Container(
    //               width: 220,
    //   height: 90,
    //   decoration: BoxDecoration(
    //           image: DecorationImage(image: AssetImage("assets/images/blue.png"), fit: BoxFit.cover),
    //     borderRadius: BorderRadius.circular(15),
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.black.withOpacity(0.3), // Shadow color
    //         spreadRadius: 1,
    //         blurRadius: 5,
    //         offset: Offset(0, 3), // Adjust the offset to control the shadow position
    //       ),
    //     ],
    //   ),
    //   child: ClipRRect(
    //     borderRadius: BorderRadius.circular(15),
    //     child: BackdropFilter(
    //       filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
    //       child: Container(
    //         padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    //         decoration: BoxDecoration(
    //           color: Colors.lightBlue.withOpacity(0.7),
    //           borderRadius: BorderRadius.circular(15),
    //           border: Border.all(
    //             color: Colors.white.withOpacity(0.2),
    //             width: 1,
    //           ),
    //         ),
    //         child: GestureDetector(
    //           onTap: (){
    //                  Get.toNamed(AppRoutes.category);

    //           },
    //           child: Text(
    //             "Quiz",
    //             style: TextStyle(
    //               fontSize: 16,
    //               color: Colors.white,
    //             ),
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // ),


                // SizedBox(height: 20), // Adjust spacing between buttons

                // HomeFancyButton(text: 'Games', color: Colors.purple, onPressed: (){},),
                // RectangleButton(
                //   color: Colors.blue,
                //   text: 'Play with friend',
                //   onPressed: () {
                //      Get.toNamed(AppRoutes.Auth);
                    
                //     // Action for Button 1
                //   },
                // ),
                // SizedBox(height: 20), // Adjust spacing between buttons

                // RectangleButton(
                //   color: Colors.purple,
                //   text: 'Phone MultiPlayer',
                //   onPressed: () {
                //      Get.toNamed(AppRoutes.phoneMultiPlayer);
                    
                //     // Action for Button 1
                //   },
                // ),
                // SizedBox(height: 20), // Adjust spacing between buttons
                // RectangleButton(
                //   color: Colors.green,
                //   text: 'Login',
                //   onPressed: () {
                //      Get.toNamed(AppRoutes.login);
                //     // Action for Button 2
                //   },
                // ),
                // SizedBox(height: 20), // Adjust spacing between buttons
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

