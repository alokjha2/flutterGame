

// import 'package:flutter_contacts/contact.dart';

// class getContacts {
//   List<Contact> _contacts = [];
//   bool _isPermissionGranted = false;

//   Future<void> _requestPermissions() async {
//     PermissionStatus status = await Permission.contacts.request();
//     if (status.isGranted) {
//       // Permission granted, fetch contacts
//       _getContacts();
//       setState(() {
//         _isPermissionGranted = true;
//       });
//     } else {
//       // Permission denied
//       setState(() {
//         _isPermissionGranted = false;
//       });
//     }
//   }

//   Future<void> _getContacts() async {
//     List<Contact> contacts = await FlutterContacts.getContacts();
//     setState(() {
//       _contacts = contacts;
//     });
//   }



// }