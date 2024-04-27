import 'dart:io';

import 'package:contacts_service/contacts_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_contacts/flutter_contacts.dart';
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
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    Invitation().listenForInvitations(user!.phoneNumber.toString(), context);
    // Request permissions when the screen is first opened
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
   List<Contact> contacts = await ContactsService.getContacts();  

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
        child: Text(contact.displayName![0]),
      ),
      trailing: TextButton(child: Text("Play"),
      onPressed: (){
        play(contact.phones!.isNotEmpty ? contact.phones![0].value : '');

      // print(contact.phones![0]);

      },
    ),
      title: Text(contact.displayName!),
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

  String generateRoomId() {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  // String randomString = generateRandomString(6); // Example: "ABC123"
  return '$userId-$timestamp';
}


  play(phone) async {
  // Check if the recipient is registered on the app
  bool isRecipientRegistered = await Invitation().checkUserExists(phone);

  if (isRecipientRegistered) {
    // If recipient is registered, send invitation and push user to game screen
    await Invitation().sendInvitation(phone, generateRoomId(), context).then((value) {
      Get.toNamed(AppRoutes.multiPlayer, arguments: generateRoomId);
    });
  } else {
    // If recipient is not registered, show a message to the user
   Invitation().showSnackBar(context, 'Recipient is not registered on the app');
  }
}

}
