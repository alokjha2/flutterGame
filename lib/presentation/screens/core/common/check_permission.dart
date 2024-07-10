

import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  PermissionStatus _status = PermissionStatus.denied;

  PermissionStatus get status => _status;

  Future<void> requestAudioPermission() async {
    _status = await Permission.microphone.request();
  }

  
}
