import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';

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
      trailing: TextButton(child: Text("Play"),onPressed: (){},),
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
}
