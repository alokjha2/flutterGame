


import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:share/share.dart';

class SnapHunt extends StatefulWidget {
  @override
  _SnapHuntState createState() => _SnapHuntState();
}

class _SnapHuntState extends State<SnapHunt> {
  void _shareLink() {
    final link = 'https://reshuffle.netlify.app/#/game/snapHunt';
    Share.share('Check out SnapHunt: $link');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SnapHunt'),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: _shareLink,
          ),
        ],
      ),
      body: Center(
        child: Text(
          'Welcome to SnapHunt!',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
