

import 'package:firebase_messaging/firebase_messaging.dart';

void initializeFirebaseMessaging() {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Get the device token
  _firebaseMessaging.getToken().then((String? token) {
    assert(token != null);
    print("Firebase Messaging Token: $token");
    // Send the token to your server or handle it as needed
  });

  // Listen for incoming messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("Message received: ${message.data}");
    // Handle incoming message when the app is in the foreground
  });

  // Listen for message opened from terminated state
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("Message opened from terminated state: ${message.data}");
    // Handle incoming message when the app is opened from terminated state
  });
}
