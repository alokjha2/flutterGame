import 'dart:async';

import 'package:get/get.dart';

class CountDownController extends GetxController {
  final _countdown = 3.obs;
  Timer? _timer;

  RxInt get countdown => _countdown;

  void startCountdown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown.value > 0) {
        _countdown.value--;
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
