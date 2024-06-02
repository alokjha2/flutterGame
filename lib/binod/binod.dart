import 'package:flutter/material.dart';

class Binod extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Who is Binod?'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Tell something about yourself in such a way that others can\'t guess:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Write here...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BinodCard()),
                );
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}

class BinodCard extends StatefulWidget {
  @override
  _BinodCardState createState() => _BinodCardState();
}

class _BinodCardState extends State<BinodCard> {
  String selectedAvatar = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Binod Card'),
      ),
      body: Center(
        child: Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Who is Binod?',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildAvatar('Alice'),
                    _buildAvatar('Bob'),
                    _buildAvatar('Charlie'),
                    _buildAvatar('David'),
                  ],
                ),
                SizedBox(height: 20),
                Text(
                  'Binod ko apne barein mein aisa lagta hai?',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(String name) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedAvatar = name;
        });
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            child: Text(name[0]),
            backgroundColor: selectedAvatar == name ? Colors.blue : null,
          ),
          SizedBox(height: 5),
          Text(name),
        ],
      ),
    );
  }
}

