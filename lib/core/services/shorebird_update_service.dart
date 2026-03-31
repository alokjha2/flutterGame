import 'package:shorebird_code_push/shorebird_code_push.dart';

class ShorebirdUpdateService {
  final ShorebirdUpdater _updater = ShorebirdUpdater();

  Future<void> checkForUpdates() async {
    try {
      final status = await _updater.checkForUpdate();

      if (status == UpdateStatus.outdated) {
        await _updater.update();
      }
    } catch (_) {
      
    }
  }
}