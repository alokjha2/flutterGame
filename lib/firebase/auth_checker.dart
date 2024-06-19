

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:game/screens/contacts_screen.dart';
// import 'package:game/screens/loginScreen.dart';
// import 'package:game/screens/multiPlayer.dart'; // Replace with your authentication screen

// class AuthChecker extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//       future: FirebaseAuth.instance.authStateChanges().first,
//       builder: (context, AsyncSnapshot<User?> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           // Return a loading indicator while waiting for authentication state
//           return Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(),
//             ),
//           );
//         } else {
//           // Check if user is authenticated
//           if (snapshot.hasData && snapshot.data != null) {
//             // User is authenticated, navigate to authenticated screen
//             return ContactsScreen(); // Replace with your authenticated screen
//           } else {
//             // User is not authenticated, navigate to authentication screen
//             return LoginScreen(); // Replace with your authentication screen
//           }
//         }
//       },
//     );
//   }
// }
