


import 'package:firebase_database/firebase_database.dart';

class RoomService {
  final databaseReference = FirebaseDatabase.instance.reference();

  Future<String> createRoom(String creatorUserId) async {
    try {
      // Generate a unique room ID
      String roomId = databaseReference.child('rooms').push().key ?? '';
      
      // Create the room with initial data
      await databaseReference.child('rooms').child(roomId).set({
        'creatorUserId': creatorUserId,
        // Add any other initial room data here
      });

      return roomId;
    } catch (error) {
      print('Error creating room: $error');
      throw error;
    }
  }

  Future<void> joinRoom(String roomId, String userId) async {
    try {
      // Update room data to reflect new player joining
      await databaseReference.child('rooms').child(roomId).update({
        'player2UserId': userId,
        // Add any other updates here
      });
    } catch (error) {
      print('Error joining room: $error');
      throw error;
    }
  }
}
