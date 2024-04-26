

// Example code to send an invitation to a contact
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_contacts/contact.dart';


class Invitation {
  
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> sendInvitation(recipientPhoneNumber) async {
  try {
    // Get the FCM token for the recipient user
    final recipientSnapshot = await _firestore
        .collection('users')
        .where('phoneNumber', isEqualTo: recipientPhoneNumber)
        .get();

    if (recipientSnapshot.docs.isNotEmpty) {
      final recipientFcmToken = recipientSnapshot.docs.first['fcmToken'];

     if (recipientFcmToken != null) {
  Map<String, String> innerData = {
    'senderName': 'player',
    'senderPhoneNumber': 'YOUR_PHONE_NUMBER',
  };

  Map<String, String> data = {
    'invitation': innerData.toString(),
  };

  await FirebaseMessaging.instance.sendMessage(
    to: recipientFcmToken,
    data: data,
  );


        print('Invitation sent successfully');
      } else {
        print('Recipient FCM token not found');
      }
    } else {
      print('Recipient user not found');
    }
  } catch (e) {
    print('Failed to send invitation: $e');
  }
}

// void listenForInvitations() {
//   databaseReference.child('invitations').onChildAdded.listen((event) {
//     Map<String, dynamic> invitationData = event.snapshot.value;
//     // Check if the invitation is for the current user
//     if (invitationData['receiverContactNumber'] == currentUserContactNumber) {
//       // Show dialog box to notify the user about the invitation
//       showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text('Invitation Received'),
//             content: Text('You have received an invitation from ${invitationData['senderUserId']}'),
//             actions: <Widget>[
//               FlatButton(
//                 child: Text('Accept'),
//                 onPressed: () {
//                   // Handle invitation acceptance
//                   acceptInvitation(event.snapshot.key);
//                   Navigator.of(context).pop();
//                 },
//               ),
//               FlatButton(
//                 child: Text('Decline'),
//                 onPressed: () {
//                   // Handle invitation rejection
//                   declineInvitation(event.snapshot.key);
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ],
//           );
//         },
//       );
//     }
//   });
// }

// Example code to accept an invitation
void acceptInvitation(invitation) {
  // Start the multiplayer memory card game session
}

// Example code to decline an invitation
void declineInvitation(invitation) {
  // Remove the invitation from the database
}

}