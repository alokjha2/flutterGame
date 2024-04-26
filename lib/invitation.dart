import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:game/components/invitationCard.dart';
import 'package:game/exports.dart';

class Invitation {
  // Firebase Realtime Database reference
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  // Send invitation
  Future<void> sendInvitation(String recipientPhoneNumber, String roomId, context) async {
    // Prepare invitation data
    Map<String, dynamic> invitationData = {
      'senderUserId': FirebaseAuth.instance.currentUser!.uid,
      'receiverPhoneNumber': recipientPhoneNumber,
      'roomId': roomId,
    };

    // Store the invitation in the database
    await _database.child('invitations').push().set(invitationData);
    showSnackBar(context);

  }
     void showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Invitation sent'),
      backgroundColor: Colors.teal,
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
      message: 'You have received an invitation to play!',
      onAccept: () {
        // Handle the "Accept" button action
                    acceptInvitation(event.snapshot.key!, invitationData['roomId']);
        Navigator.of(context).pop();
        // Call the function to accept the invitation
      },
      onDecline: () {
                    declineInvitation(event.snapshot.key!);
                    Navigator.of(context).pop();
        // Handle the "Decline" button action
        Navigator.of(context).pop();
        // Call the function to decline the invitation
          },
        );
      },
    );
  }
  });
  }
      


  // Accept invitation
  void acceptInvitation(String invitationId, String roomId) {
    // Add the user to the game room
    _database.child('gameRooms').child(roomId).child('players').update({
      FirebaseAuth.instance.currentUser!.uid: true,
    });

    // Remove the invitation from the database
    _database.child('invitations').child(invitationId).remove();
  }

  // Decline invitation
  void declineInvitation(String invitationId) {
    // Remove the invitation from the database
    _database.child('invitations').child(invitationId).remove();
  }
}
