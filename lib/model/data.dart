import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';

List<String> imageSource() {
  return [
    'assets/images/kishor.jpg',
    'assets/images/kishor.jpg',
    'assets/images/mother.jpg',
    'assets/images/mother.jpg',
    'assets/images/onion.jpg',
    'assets/images/onion.jpg',
    'assets/images/rajesh.jpg',
    'assets/images/rajesh.jpg',
    'assets/images/pooh.jpg',
    'assets/images/pooh.jpg',
    'assets/images/tom.jpg',
    'assets/images/tom.jpg',
    'assets/images/pineapple.jpg',
    "assets/images/angry.jpg",
    "assets/images/angry.jpg",
    'assets/images/pineapple.jpg',
  ];
}

List<String> cartoon(){
  return [

    "assets/images/angry.jpg",
    "assets/images/angry.jpg",
    "assets/images/tom.jpg",
    "assets/images/tom.jpg",
    "assets/images/shinjo.jpg",
    "assets/images/shinjo.jpg",
    "assets/images/pooh.jpg",
    "assets/images/pooh.jpg",
    "assets/images/perman.jpg",
    "assets/images/perman.jpg",
    "assets/images/parrot.jpg",
    "assets/images/parrot.jpg",
    "assets/images/mouse.png",
    "assets/images/mouse.png",
    "assets/images/minion.jpg",
    "assets/images/minion.jpg",
    "assets/images/kanachi.jpg",
    "assets/images/kanachi.jpg",
    "assets/images/jerry.png",
    "assets/images/jerry.png",
    "assets/images/hatori.jpg",
    "assets/images/hatori.jpg",
    "assets/images/jerry.png",
    "assets/images/jerry.png",
    "assets/images/bird2.png",
    "assets/images/bird2.png",
  ];
}


List<String> celebrity(){
  return [
    "assets/images/gandhi1.png",
    "assets/images/gandhi1.png",
    "assets/images/bose.png",
    "assets/images/bose.png",
    "assets/images/trump.jpg",
    "assets/images/trump.jpg",
    "assets/images/rajesh.jpg",
    "assets/images/rajesh.jpg",
    "assets/images/mother.jpg",
    "assets/images/mother.jpg",
    "assets/images/kishor.jpg",
    "assets/images/kishor.jpg",
    "assets/images/apj.jpg",
    "assets/images/apj.jpg",
    "assets/images/azaad.jpg",
    "assets/images/azaad.jpg",
    "assets/images/bose.png",
    "assets/images/bose.png",
    "assets/images/charlie.jpg",
    "assets/images/charlie.jpg",

  ];
}


List<String> fruits(){
  return [
    "assets/images/redchilli.jpg",
    "assets/images/redchilli.jpg",
    "assets/images/pineapple.jpg",
    "assets/images/pineapple.jpg",
    "assets/images/onion.jpg",
    "assets/images/onion.jpg",

  ];
}



List<String> animals(){
  return [

  ];
}

List createShuffledListFromImageSource() {
  List shuffledImages = [];
  List sourceArray = imageSource();
  // List sourceArray = celebrity();
  for (var element in sourceArray) {
    shuffledImages.add(element);
  }
  shuffledImages.shuffle();
  return shuffledImages;
}

List<bool> getInitialItemStateList() {
  List<bool> initialItem = <bool>[];
  for (int i = 0; i < 16; i++) {
  // for (int i = 0; i < 16; i++) {
    initialItem.add(true);
  }
  return initialItem;
}

List<GlobalKey<FlipCardState>> createFlipCardStateKeysList() {
  List<GlobalKey<FlipCardState>> cardStateKeys = <GlobalKey<FlipCardState>>[];
  for (int i = 0; i < 16; i++) {
    cardStateKeys.add(GlobalKey<FlipCardState>());
  }
  return cardStateKeys;
}
