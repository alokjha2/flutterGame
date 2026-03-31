import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'application/app/initialize_app.dart';
import 'core/services/shorebird_update_service.dart';

Future<void> bootstrap(Widget Function() builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  await InitializeApp(ShorebirdUpdateService())();
  runApp(builder());
}
