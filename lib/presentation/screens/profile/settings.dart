// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:game/presentation/screens/friends/friends.dart';
import 'package:game/presentation/screens/profile/account.dart';
import 'package:game/presentation/screens/profile/help.dart';
import 'package:game/presentation/screens/profile/notification.dart';
import 'package:game/presentation/screens/profile/privacy.dart';
import 'package:game/presentation/screens/profile/security.dart';
import 'package:get/get.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Account'),
            subtitle: Text('Manage your account settings'),
            leading: Icon(Icons.person),
            onTap: () {
              Get.to(() => AccountScreen());
            },
          ),

          ListTile(
            title: Text('Friends'),
            subtitle: Text('Manage your account settings'),
            leading: Icon(Icons.person),
            onTap: () {
              Get.to(() => FriendListScreen());
            },
          ),

          ListTile(
            title: Text('Notifications'),
            subtitle: Text('Manage notification settings'),
            leading: Icon(Icons.notifications),
            onTap: () {
              Get.to(() => NotificationScreen());
            },
          ),

          ListTile(
            title: Text('Share Ling'),
            subtitle: Text('Sharing ling can help us alot'),
            leading: Icon(Icons.notifications),
            onTap: () {
              // Get.to(() => NotificationsScreen());
            },
          ),
          ListTile(
            title: Text('Privacy'),
            subtitle: Text('Manage your privacy settings'),
            leading: Icon(Icons.lock),
            onTap: () {
              Get.to(() => PrivacyScreen());
            },
          ),
          ListTile(
            title: Text('Security'),
            subtitle: Text('Manage your security settings'),
            leading: Icon(Icons.security),
            onTap: () {
              Get.to(() => SecurityScreen());
            },
          ),
          ListTile(
            title: Text('Help'),
            subtitle: Text('Get help and support'),
            leading: Icon(Icons.help),
            onTap: () {
              Get.to(() => HelpScreen());
            },
          ),
          // ListTile(
          //   title: Text('About'),
          //   subtitle: Text('Learn more about this app'),
          //   leading: Icon(Icons.info),
          //   onTap: () {
          //     Get.to(() => AboutScreen());
          //   },
          // ),
        ],
      ),
    );
  }
}
