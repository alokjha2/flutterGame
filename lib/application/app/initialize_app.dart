import 'package:elder_quest/core/services/shorebird_update_service.dart';

class InitializeApp {
  final ShorebirdUpdateService updateService;

  InitializeApp(this.updateService);

  Future<void> call() async {
    await updateService.checkForUpdates();
  }
}