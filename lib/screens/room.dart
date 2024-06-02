

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomSelectionPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void createRoom(BuildContext context) async {
    DocumentReference roomRef = _firestore.collection('rooms').doc();
    await roomRef.set({
      'id': roomRef.id,
      'name': 'Room ${DateTime.now()}',
      'players': [],
    });
    print('Room Created: ${roomRef.id}');
    // Navigate to room screen
  }

  void joinRoom(BuildContext context, String roomId) async {
    DocumentReference roomRef = _firestore.collection('rooms').doc(roomId);
    await roomRef.update({
      'players': FieldValue.arrayUnion(['player_id']),
    });
    print('Joined Room: $roomId');
    // Navigate to room screen
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController roomIdController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Trivia Quiz Game'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () => createRoom(context),
                child: Text('Create Room'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: roomIdController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Room ID',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => joinRoom(context, roomIdController.text),
                child: Text('Join Room'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

