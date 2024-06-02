

import 'package:flutter/material.dart';


class BinodCard extends StatelessWidget {
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
                SizedBox(height: 10),
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
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          child: Text(name[0]),
        ),
        SizedBox(height: 5),
        Text(name),
      ],
    );
  }
}
