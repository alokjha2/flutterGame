


import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class MultiplayerGameManager {
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  // Create a room in the database
  Future<String?> createRoom(List<String> players) async {
    final roomRef = _database.child('gameRooms').push();
    final roomId = roomRef.key;

    // Initialize game state
    await roomRef.set({
      'players': players.map((playerId) => {playerId: 0}).toList(), // Initialize players with zero points
      'gameState': {}, // Initialize game state (e.g., cards positions, moves history, etc.)
      'createdAt': ServerValue.timestamp, // Add creation timestamp
    });

    return roomId;
  }

  // Add a player to an existing room
  Future<void> joinRoom(String roomId, String playerId) async {
    final playersRef = _database.child('gameRooms/$roomId/players');
    await playersRef.update({playerId: 0}); // Add the player to the room with zero points
  }

  // Update game state in the room
  Future<void> updateGameState(String roomId, Map<String, dynamic> gameState) async {
    final gameStateRef = _database.child('gameRooms/$roomId/gameState');
    await gameStateRef.update(gameState);
  }

  // Handle player move (update game state, calculate points, etc.)
  Future<void> handlePlayerMove(String roomId, String playerId, dynamic move) async {
    // Implement your logic here
  }

  // Handle player leaving the game
  Future<void> handlePlayerLeave(String roomId, String playerId) async {
    final playersRef = _database.child('gameRooms/$roomId/players');
    await playersRef.child(playerId).remove(); // Remove the player from the room
  }
}
