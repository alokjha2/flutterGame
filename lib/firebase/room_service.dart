import 'package:firebase_database/firebase_database.dart';

class RoomService {
  final databaseReference = FirebaseDatabase.instance.reference();

  Future<String> createRoom(
      String creatorUserId, String roomName, bool isPrivate, String gameName) async {
    try {
      // Generate a unique room ID
      String roomId = databaseReference.child('games').child(gameName).push().key ?? '';

      // Create the room with initial data
      await databaseReference.child('games').child(gameName).child(roomId).set({
        'roomName': roomName,
        'roomId': roomId,
        'isPrivate': isPrivate,
        'creatorUserId': creatorUserId,
        'playerList': [creatorUserId],
        'startedAt': ServerValue.timestamp,
        'roomStatus': 'active',
        "maxPlayer" : 0,
        
      });
      return roomId;
    } catch (error) {
      print('Error creating room: $error');
      throw error;
    }
  }

  Future<void> joinRoom(String roomId, String userId) async {
  try {
    // Get the current player list snapshot
    final snapshot =
        await databaseReference.child('games').child('binod').child(roomId).once();

    // Get the player list from the snapshot data, or an empty list if the value is null
    final playerList = (snapshot.snapshot.value as Map<dynamic, dynamic>?)?.values.toList() ?? [];

    // Add the new player to the list
    playerList.add(userId);

    // Update room data to reflect the new player joining
    await databaseReference.child('games').child('binod').child(roomId).update({
      'playerList': playerList,
    });
  } catch (error) {
    print('Error joining room: $error');
    throw error;
  }
}

Future<void> leaveRoom(String roomId, String userId) async {
  try {
    // Get the current player list snapshot
    final snapshot =
        await databaseReference.child('games').child('binod').child(roomId).once();

    // Get the player list from the snapshot data, or an empty list if the value is null
    final playerList = (snapshot.snapshot.value as Map<dynamic, dynamic>?)?.values.toList() ?? [];

    // Remove the player from the list
    playerList.remove(userId);

    // Check if the room should be ended
    final shouldEndRoom = playerList.isEmpty;

    // Update room data to reflect the player leaving
    await databaseReference.child('games').child('binod').child(roomId).update({
      'playerList': playerList,
      if (shouldEndRoom) 'roomStatus': 'ended',
    });
  } catch (error) {
    print('Error leaving room: $error');
    throw error;
  }
}}