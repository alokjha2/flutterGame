import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_user_login/screens/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:game/exports.dart';
import 'package:game/screens/homepage.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _verificationId = '';
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _codeController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> loginUser(String phone, BuildContext context) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: Duration(seconds: 60),
        verificationCompleted: (AuthCredential credential) async {
          Navigator.of(context).pop();
          UserCredential result = await _auth.signInWithCredential(credential);
          User? user = result.user;
          if (user != null) {
            // Navigator.pushReplacement(
              // context,
              // MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
            // );
          } else {
            print("Error occurred while signing in");
          }
        },
        verificationFailed: (FirebaseAuthException exception) {
          print("Verification failed: ${exception.message}");
        },
        codeSent: (String verificationId, int? forceResendingToken) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text("Enter Verification Code"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      controller: _codeController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                        hintText: "Enter code",
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      String code = _codeController.text.trim();
                      AuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: verificationId, smsCode: code);
                      UserCredential result =
                          await _auth.signInWithCredential(credential);
                      User? user = result.user;
                      if (user != null) {
                        Get.toNamed(AppRoutes.contacts);
                        // Navigator.pushReplacement(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => HomeScreen(user: user),
                        //   ),
                        // );
                      } else {
                        print("Error occurred while signing in");
                      }
                    },
                    child: Text('Confirm'),
                  ),
                ],
              );
            },
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
   } catch (e) {
      print("Error: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(32),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Login", style: TextStyle(color: Colors.lightBlue, fontSize: 36, fontWeight: FontWeight.w500),),

                  SizedBox(height: 16,),

                  TextFormField(
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            // borderSide: BorderSide(color: Colors.grey[200])
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            // borderSide: BorderSide(color: Colors.grey[300])
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        hintText: "Mobile Number"

                    ),
                    controller: _phoneController,
                  ),

                  SizedBox(height: 16,),


                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: Text("LOGIN"),
                      // textColor: Colors.white,
                      // padding: EdgeInsets.all(16),
                      onPressed: () {
                        final phone = _phoneController.text.trim();

                        loginUser(phone, context);

                      },
                      // color: Colors.blue,
                    ),
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}