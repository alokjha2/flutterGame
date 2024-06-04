import 'dart:ui';

import 'package:game/components/homepage_btn.dart';
import 'package:game/exports.dart';
import 'package:game/presentation/screens/profile/settings.dart';
import 'package:game/widgets/fancyButton.dart';
import 'package:get/get.dart';
class HomeScreen extends StatelessWidget {
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

