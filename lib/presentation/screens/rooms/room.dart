import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class RoomPage extends StatefulWidget {
  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  bool isCreatingRoom = false;
  String roomName = '';
  bool isPrivate = true;
  String roomId = '';

  void _createRoom() {
    setState(() {
      isCreatingRoom = true;
      roomId = _generateRoomId();
    });
  }

  void _closeCreateRoom() {
    setState(() {
      isCreatingRoom = false;
      roomName = '';
      isPrivate = true;
      roomId = '';
    });
  }

  String _generateRoomId() {
    final random = Random();
    final buffer = StringBuffer();
    for (int i = 0; i < 9; i++) {
      buffer.write(random.nextInt(10));
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    // Sample room data
    List<Map<String, String>> rooms = List.generate(
      20,
      (index) => {
        'name': 'Room ${index + 1}',
        'participants': '${(index + 1) * 2} participants'
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Rooms'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Four Cards in a Row
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    // First card for "Create Room"
                    if (index == 0) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 200,
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Create Room',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: _createRoom,
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(16),
                                    ),
                                    child: Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                    // Other cards
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Container(
                          width: 150,
                          height: 150,
                          child: Center(
                            child: Text('Card ${index}'),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              // Create Room Card
              if (isCreatingRoom)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Room Name',
                          ),
                          onChanged: (value) {
                            setState(() {
                              roomName = value;
                            });
                          },
                        ),
                        SwitchListTile(
                          title: Text('Private Room'),
                          value: isPrivate,
                          onChanged: (value) {
                            setState(() {
                              isPrivate = value;
                            });
                          },
                        ),
                        SizedBox(height: 10),
                        if (isPrivate)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    'Room ID: $roomId (Share this Room ID with friends and ask them to join the room using this ID)',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(text: roomId),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Room ID copied to clipboard'),
                                      ),
                                    );
                                  },
                                  icon: Icon(Icons.copy),
                                ),
                              ],
                            ),
                          ),
                        if (!isPrivate)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'https://example.com/room/$roomId',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Clipboard.setData(
                                          ClipboardData(
                                            text: 'https://example.com/room/$roomId',
                                          ),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Room link copied to clipboard'),
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.copy),
                                    ),
                                  ],
                                ),
                                Text("Anyone with the link can join")
                              ],
                            ),
                          ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _closeCreateRoom,
                          child: Text('Next'),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 20),
              // Active Rooms Section
              Text(
                'Active Rooms',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: rooms.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text(rooms[index]['name']![0]),
                      ),
                      title: Text(rooms[index]['name']!),
                      subtitle: Text(rooms[index]['participants']!),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}