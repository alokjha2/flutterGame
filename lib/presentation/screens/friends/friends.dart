import 'package:flutter/material.dart';


class FriendListScreen extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Friend List'),
      ),
      body: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(friends[index]),
            leading: CircleAvatar(
              child: Text(friends[index][0]),
            ),
            onTap: () {
              // Add action when tapping on a friend
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Selected Friend'),
                  content: Text('You tapped on ${friends[index]}'),
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
