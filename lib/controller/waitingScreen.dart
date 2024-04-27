import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class WaitingScreenController extends GetxController {
  var showWaitingScreen = true.obs;

  void hideWaitingScreen() {
    showWaitingScreen.value = false;
  }
}
