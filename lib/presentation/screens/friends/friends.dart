import 'package:flutter/material.dart';

class FriendListScreen extends StatefulWidget {
  @override
  _FriendListScreenState createState() => _FriendListScreenState();
}

class _FriendListScreenState extends State<FriendListScreen> {
  final List<String> friends = [
    'Alice',
    'Bob',
    'Charlie',
    'David',
    'Eve',
    'Frank',
    'Grace',
    'Harry',
    'Ivy',
    'Jack',
    'Kate',
    'Liam',
    'Mia',
    'Noah',
    'Olivia',
    'Peter',
    'Quinn',
    'Rachel',
    'Sam',
    'Tom',
  ];

  Set<String> selectedFriends = Set();

  bool isSelected(String friend) {
    return selectedFriends.contains(friend);
  }

  void toggleSelection(String friend) {
    setState(() {
      if (selectedFriends.contains(friend)) {
        selectedFriends.remove(friend);
      } else {
        selectedFriends.add(friend);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friend List'),
      ),
      body: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          final friend = friends[index];
          final isFriendSelected = isSelected(friend);

          return ListTile(
            title: Text(friend),
            leading: CircleAvatar(
              child: Text(friend[0]),
            ),
            trailing: ElevatedButton(
              onPressed: () {
                toggleSelection(friend);
              },
              child: Text(isFriendSelected ? 'Remove' : 'Add'),
              style: ElevatedButton.styleFrom(
                backgroundColor
                : isFriendSelected ? Colors.red : Colors.green,
              ),
            ),
            onTap: () {
              // Add action when tapping on a friend
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Selected Friend'),
                  content: Text('You tapped on $friend'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('OK'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
