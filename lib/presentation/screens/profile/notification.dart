import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Notifications'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Friend Requests'),
              Tab(text: 'Game Invitations'),
              Tab(text: 'General'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FriendRequestNotifications(),
            GameInvitationNotifications(),
            GeneralNotifications(),
          ],
        ),
      ),
    );
  }
}

class FriendRequestNotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Implement friend request notifications here
    return Center(
      child: Text('Friend Request Notifications'),
    );
  }
}

class GameInvitationNotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Implement game invitation notifications here
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Open the game link when the notification is clicked
            Get.toNamed('/quiz');
            // Get.toNamed('https://elderquest.netlify.app/#/game/quiz');
          },
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Image.asset(

                    'assets/images/angry.jpg',
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Game Invitation',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'Join the game on Elder Quest',
                          style: TextStyle(
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class GeneralNotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Implement general notifications here
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              children: [
                Image.network(
                  'https://via.placeholder.com/50',
                  width: 50,
                  height: 50,
                ),
                SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notification Title',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'This is a general notification description.',
                        style: TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}