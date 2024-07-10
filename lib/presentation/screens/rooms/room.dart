import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:game/components/invitationCard.dart';
import 'package:game/firebase/room_service.dart';
import 'package:game/presentation/router/routes.dart';
import 'package:get/get.dart';

class RoomPage extends StatefulWidget {
  @override
  _RoomPageState createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  bool isCreatingRoom = false;
  bool isJoiningRoom = false;
  String roomName = '';
  bool isPrivate = true;
  String roomId = '';
  String joinRoomId = '';
  String userName = '';
   String gameName = '';

  @override
  void initState() {
    super.initState();
    // Get the game name argument from the previous screen
    gameName = Get.arguments as String;
  }

  void _createRoom() {
    setState(() {
      isCreatingRoom = true;
      roomId = _generateRoomId();
    });

  }

  void _joinRoom() {
    setState(() {
      isJoiningRoom = true;
    });
  }

  void _closeCreateRoom() {
    setState(() {
      isCreatingRoom = false;
      isJoiningRoom = false;
      roomName = '';
      isPrivate = true;
      roomId = '';
      joinRoomId = '';
      userName = '';
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

  bool _isValidInput() {
    return roomName.isNotEmpty && userName.isNotEmpty;
  }

  void _handleNextButtonClick() {
    if (_isValidInput()) {
      switch (gameName) {
        case 'Who is Binod?':
        
          Navigator.pushNamed(context, AppRoutes.binod, arguments: {
            'roomName': roomName,
            'roomId': roomId,
            'userName': userName,
            'isPrivate': isPrivate,
          });
          break;
        case 'Quiz':
          Navigator.pushNamed(context, AppRoutes.quiz, arguments: {
            'roomName': roomName,
            'roomId': roomId,
            'userName': userName,
            'isPrivate': isPrivate,
          });
          break;
        // Add cases for other games if needed
        default:
          print('Game not found or not implemented yet.');
      }
      
      // _closeCreateRoom();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter room name and user name'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 4,
                  itemBuilder: (context, index) {
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
                    } else if (index == 1) {
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
                                    'Join Room',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: _joinRoom,
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(16),
                                    ),
                                    child: Icon(Icons.join_full),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else if (index == 2) {
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
                                    'Settings',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Settings logic here
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(16),
                                    ),
                                    child: Icon(Icons.settings),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
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
                                    'Help',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Help logic here
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      padding: EdgeInsets.all(16),
                                    ),
                                    child: Icon(Icons.help),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
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
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Your Name',
                          ),
                          onChanged: (value) {
                            setState(() {
                              userName = value;
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Room ID: $roomId',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Clipboard.setData(
                                            ClipboardData(text: roomId));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Room ID copied to clipboard'),
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.copy),
                                    ),
                                  ],
                                ),
                                Text(
                                    "Share this Room ID with friends and ask them to join the room using this ID"),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: (){
                                    RoomService().createRoom(userName, roomName, isPrivate, gameName );
                                  },
                                  // _isValidInput() 
                                  //     ? _handleNextButtonClick :  RoomService().createRoom(userName, roomName, isPrivate, gameName ),
                                  //     : null,
                                  child: Text('Next'),
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
                                        'https://elderquest.netlify.app/games/binod',
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
                                              text:
                                                  'https://example.com/room/$roomId'),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Room link copied to clipboard'),
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.copy),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  onPressed: _isValidInput()
                                      ? _handleNextButtonClick
                                      : null,
                                  child: Text('Next'),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              if (isJoiningRoom)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Your Name',
                          ),
                          onChanged: (value) {
                            setState(() {
                              roomName = value;
                            });
                          },
                        ),
                        SizedBox(height: 16.0),
                        TextField(
                          decoration: InputDecoration(
                            labelText: 'Room ID',
                          ),
                          onChanged: (value) {
                            setState(() {
                              joinRoomId = value;
                            });
                          },
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            print('Joining room with ID: $joinRoomId');
                            _closeCreateRoom();
                          },
                          child: Text('Join Room'),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 20),
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
                  return InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return InvitationDialog(
                            message: 'Do you want to join?',
                            onAccept: () {
                              Navigator.of(context).pop();
                            },
                            onDecline: () {
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      );
                    },
                    child: Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(rooms[index]['name']![0]),
                        ),
                        title: Text(rooms[index]['name']!),
                        subtitle: Text(rooms[index]['participants']!),
                      ),
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
