import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:game/components/invitationCard.dart';
import 'package:game/invitation.dart';
import 'package:game/routes.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ContactsScreen extends StatefulWidget {
  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  List<Contact> _contacts = [];
  bool _isPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    // Request permissions when the screen is first opened
    _requestPermissions();
    }


  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _requestPermissions() async {
    PermissionStatus status = await Permission.contacts.request();
    if (status.isGranted) {
      // Permission granted, fetch contacts
      _getContacts();
      setState(() {
        _isPermissionGranted = true;
      });
    } else {
      // Permission denied
      setState(() {
        _isPermissionGranted = false;
      });
    }
  }

  Future<void> _getContacts() async {
    List<Contact> contacts = await FlutterContacts.getContacts();
    setState(() {
      _contacts = contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: _isPermissionGranted
          ? _contacts.isEmpty
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: _contacts.length,
                  itemBuilder: (context, index) {
                    Contact contact = _contacts[index];
                    return Card(
  elevation: 5, // Set the elevation for the card
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10), // Set border radius for rounded corners
  ),
  child: Container(
    height: 70,
    width: double.maxFinite,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white,
    ),
    child: ListTile(
      leading: CircleAvatar(
        child: Text(contact.displayName[0]),
      ),
      trailing: TextButton(child: Text("Play"),
      onPressed: (){
       play(contact);
      },),
      title: Text(contact.displayName),
      subtitle: Text(contact.phones.isNotEmpty ? contact.phones.first.number : ''),
    ),
  ),
);

                  },
                )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Permission to access contacts is required.'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _requestPermissions,
                    child: Text('Grant Permission'),
                  ),
                ],
              ),
            ),
    );
  }

  void play(contact) async{

    await Invitation().sendInvitation(contact);
    Get.toNamed(AppRoutes.multiPlayer);
    print("${contact.phones}");
    showSnackBar(context);
    showDialog(
  context: context,
  builder: (BuildContext context) {
    return InvitationDialog(
      message: 'You have received an invitation to play!',
      onAccept: () {
        // Handle the "Accept" button action
        Navigator.of(context).pop();
        // Call the function to accept the invitation
      },
      onDecline: () {
        // Handle the "Decline" button action
        Navigator.of(context).pop();
        // Call the function to decline the invitation
      },
    );
  },
);

  }
  void showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Hi, Flutter developers'),
      backgroundColor: Colors.teal,
      behavior: SnackBarBehavior.floating,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  
}
