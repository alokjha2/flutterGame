import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:game/components/invitationCard.dart';
import 'package:game/controller/waitingScreen.dart';
import 'package:game/exports.dart';
import 'package:get/get.dart';

class Invitation {
  // Firebase Realtime Database reference
  final DatabaseReference _database = FirebaseDatabase.instance.reference();
Future<void> sendInvitation(String recipientPhoneNumber, String roomId, context) async {
  // Check if the recipient's phone number is registered on the app
  bool isRecipientRegistered = await checkUserExists(recipientPhoneNumber);

  if (isRecipientRegistered) {
    // Prepare invitation data
    Map<String, dynamic> invitationData = {
      'senderUserId': FirebaseAuth.instance.currentUser!.uid,
      'receiverPhoneNumber': recipientPhoneNumber,
      'roomId': roomId,
    };

    // Store the invitation in the database
    await _database.child('invitations').push().set(invitationData);
    createRoom(roomId);

    showSnackBar(context, 'Invitation sent');
  } else {
    showSnackBar(context, 'Recipient is not registered on the app');
  }
}

Future<bool> checkUserExists(String phoneNumber) async {
  try {
    // Query Firestore to check if any user document contains the provided phone number
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('phoneNumber', isEqualTo: phoneNumber)
        .get();

    // If any documents are returned, the user exists
    return querySnapshot.docs.isNotEmpty;
  } catch (e) {
    // Handle errors such as Firestore connection issues
    print('Error checking user existence: $e');
    return false;
  }
}

void showSnackBar(BuildContext context, String message) {
  final snackBar = SnackBar(
    content: Text(message),
    backgroundColor: message.contains('sent') ? Colors.green : Colors.red,
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

 

  // Listen for invitations
  void listenForInvitations(phone, BuildContext context) {
    DatabaseReference invitationsRef = _database.child('invitations');
    invitationsRef.onChildAdded.listen((event) {
      Map<dynamic, dynamic> invitationData = event.snapshot.value as Map;

      // Check if the invitation is for the current user
      if (invitationData['receiverPhoneNumber'] == phone) {
        // Show dialog to accept or decline the invitation
       showDialog(
  context: context,
  builder: (BuildContext context) {
    return InvitationDialog(
      // accept: "Accept",
      // decline: "Decline",
      message: 'You have received an invitation to play!',
      onAccept: () {
        // Handle the "Accept" button action
        Navigator.of(context).pop();
        acceptInvitation(event.snapshot.key!, invitationData['roomId']);
        Get.toNamed(AppRoutes.multiPlayer);
        // Call the function to accept the invitation
      },
      onDecline: () {
                    declineInvitation(event.snapshot.key!, invitationData["roomId"]);
                    Navigator.of(context).pop();
          },
        );
      },
    );
  }
  });
  }


listenToPlayers(String roomId) {
  final WaitingScreenController waitingScreenController = Get.put(WaitingScreenController());
  final playersRef = _database.child('gameRooms').child(roomId).child('players');
  
  playersRef.onValue.listen((event) {
    DataSnapshot snapshot = event.snapshot;
    Map<dynamic, dynamic>? players = snapshot.value as Map<dynamic, dynamic>?;
    
    // Check if there are 2 players in the room
    if (players != null && players.length == 2) {
      // Hide the waiting screen
      waitingScreenController.hideWaitingScreen();
    }
  });
}


      
// Accept invitation
void acceptInvitation(String invitationId, String roomId) {
  final playersRef = _database.child('gameRooms').child(roomId).child('players');
  
  // Add the user to the game room
  playersRef.update({
    FirebaseAuth.instance.currentUser!.uid: true,
  }).then((_) {
    // Listen to changes in the players node to check the number of players in the room
    playersRef.onValue.listen((event) {
      DataSnapshot snapshot = event.snapshot;
      Map<dynamic, dynamic>? players = snapshot.value as Map<dynamic, dynamic>?;
      if (players != null && players.length == 2) {
        // Two players have joined, start the game
        // startGame(roomId);
          Get.toNamed(AppRoutes.multiPlayer, arguments: roomId);

         WaitingScreenController waitingScreenController = Get.find<WaitingScreenController>();
  // Call the hideWaitingScreen() method to hide the waiting screen
        waitingScreenController.hideWaitingScreen();
        
        // Stop listening to further changes in the players node
        // playersRef.onValue.listen(null);
      }
    });
    
    // Navigate to multiplayer screen
    // Get.toNamed(AppRoutes.multiPlayer, arguments: roomId);

    // Remove the invitation from the database 
    // _database.child('invitations').child(invitationId).remove();
  }).catchError((error) {
    // Handle error if user addition fails
    print('Failed to accept invitation: $error');
    // Optionally, show an error message to the user
  });
}




joinRoom(){

}

createRoom(roomId){

  _database.child('gameRooms').child(roomId).child('players').set({
    FirebaseAuth.instance.currentUser!.uid: true,
  }).then((_) {
  //    WaitingScreenController waitingScreenController = Get.find<WaitingScreenController>();
  // // Call the hideWaitingScreen() method to hide the waiting screen
  //       waitingScreenController.hideWaitingScreen();
  }).catchError((error) {
    // Handle error if user addition fails
    
    // print('Failed to accept invitation: $error');
    // Optionally, show an error message to the user
  });

}

leaveRoom(roomId, uid){

}


  // Decline invitation
  void declineInvitation(String invitationId, String roomId) {
    _database.child('gameRooms').child(roomId).child('players').update({
    FirebaseAuth.instance.currentUser!.uid: false,
    }).then((_) {
  // Remove the invitation document from the database
  _database.child('invitations').child(invitationId).remove()
    .then((_) {
      // Invitation removed successfully
     void showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('User declined request'),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
          
          // print('Player $playerId joined the game room $roomId');

    })
    .catchError((error) {
      // Handle error if removing the invitation fails
      print('Failed to decline invitation: $error');
      // Optionally, show an error message to the user
    });

 }).catchError((error) {
    // Handle error if user addition fails
    print('Failed to accept invitation: $error');
    // Optionally, show an error message to the user
  });
}
}