import 'dart:async';
import 'package:get/get.dart';

class GameTimerController extends GetxController {
  late Timer _durationTimer;
  RxInt _gameDuration = 0.obs;

  RxInt get gameDuration => _gameDuration;

  void startDuration() {
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      _gameDuration++; // Increment game duration every second
    });
  }

  @override
  void onClose() {
    _durationTimer.cancel();
    super.onClose();
  }
}
