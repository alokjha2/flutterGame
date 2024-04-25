import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:game/routes.dart';
import 'package:game/screens/game_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class MatrixSelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.pinkAccent.shade100,
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

          Container(
            color: Colors.pinkAccent.shade100.withOpacity(0.7), // Semi-transparent purple color
          ),

          Positioned(

            bottom: 100,
            left: 10,
            child: Container(
              height: 400,
              width: 400,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Adjust the number of columns as needed
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 10.0,
                  childAspectRatio: 2.5, // Adjust the aspect ratio as needed
                ),
                itemCount: 6, // Adjust the number of grid items as needed
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: (){
                       Get.toNamed(AppRoutes.gamePage);
                    },
                    child: FractionallySizedBox(       
                      widthFactor: 0.8,
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.9),
                              spreadRadius: 4,
                              blurRadius: 5,
                              offset: Offset(-1, 12),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Image.asset("assets/images/pick.png"),
                            Text(
                              '${(index + 2)}x${(index + 2)}', // Change the text as needed
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 100.0,
            left: 100.0,
            child: Transform.rotate(
              angle: -0.4,
              child: Container(
                width: 120.0,
                height: 120.0,
                decoration: BoxDecoration(
                  // decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                   image: DecorationImage(
                          image: AssetImage("assets/images/front.jpg"),
                          fit: BoxFit.cover,
                        ),
                
                  // color: Colors.red,
                  // borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 70.0,
            right: 30.0,
            child: Transform.rotate(
              angle: .1,
              child: Container(
                width: 150.0,
                height: 150.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                   image: DecorationImage(
                          image: AssetImage("assets/images/card.jpg"),
                          fit: BoxFit.cover,
                        ),
                
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      spreadRadius: 4,
                      blurRadius: 9,
                      offset: Offset(-10, 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20.0,
            left: 20.0,
            child: Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {
                  // Implement action for the button
                },
                icon: Icon(Icons.arrow_back),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
