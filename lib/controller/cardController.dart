

import 'package:get/get.dart';

class CardFlipsController extends GetxController {
  final List<RxBool> _cardFlips = List.generate(10, (_) => false.obs);

  List<RxBool> get cardFlips => _cardFlips;

  void flipCard(int index) {
    _cardFlips[index].toggle();
  }
}
