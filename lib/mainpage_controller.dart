import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'design.dart';

class MainController extends GetxController
    with GetTickerProviderStateMixin {
  late var winController;


  Map<String, dynamic> rowLettersMap = {
    "E": grey.obs,
    "R": grey.obs,
    "T": grey.obs,
    "Y": grey.obs,
    "U": grey.obs,
    "I": grey.obs,
    "O": grey.obs,
    "P": grey.obs,
    "Ğ": grey.obs,
    "Ü": grey.obs,
    "A": grey.obs,
    "S": grey.obs,
    "D": grey.obs,
    "F": grey.obs,
    "G": grey.obs,
    "H": grey.obs,
    "J": grey.obs,
    "K": grey.obs,
    "L": grey.obs,
    "Ş": grey.obs,
    "İ": grey.obs,
    "Z": grey.obs,
    "C": grey.obs,
    "V": grey.obs,
    "B": grey.obs,
    "N": grey.obs,
    "M": grey.obs,
    "Ö": grey.obs,
    "Ç": grey.obs,
  };

  List<List<RxString>> textBoxes = [
    for (int i = 0; i < 6; i++) [for (int a = 0; a < 5; a++) "".obs]
  ];

  List<List<Rx<GlobalKey<FlipCardState>>>> flipKeys = [
    for (int i = 0; i < 6; i++)
      [for (int a = 0; a < 5; a++) GlobalKey<FlipCardState>().obs]
  ];

  List<dynamic> squaresColors = [
    for (int i = 0; i < 6; i++)
      [for (int a = 0; a < 5; a++) squaresMainColor.obs]
  ];

  RxBool isWordExist = false.obs;
  var isFirstBuildCompleted = false.obs;

  void changeIsFirstBuildCompleted() {
    isFirstBuildCompleted.value = true;
  }

  Future<void> initAnimationController() async {
    winController = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 2,),
        animationBehavior: AnimationBehavior.preserve,
    ).obs;
  }

  void resetSquaresColor() {
    squaresColors = [
      for (int i = 0; i < 6; i++)
        [for (int a = 0; a < 5; a++) squaresMainColor.obs]
    ];
  }

  Future<void> controlWinAnimation() async {
    winController.value.forward();
    await Future.delayed(Duration(milliseconds: 1500), () {
      winController.value.reverse();
    });
    await Future.delayed(Duration(milliseconds: 1500), () {
      winController.value.dispose();
    });
  }

  void changeIsWordExist(bool value) {
    isWordExist.value = value;
  }

  void setColorForSquare(int row, int column, Color color) {
    squaresColors[row][column].value = color;
  }

  void flipCard(int row, int col) {
    flipKeys[row][col].value.currentState?.toggleCard();
  }

  void setLetter(int row, int col, String letter) {
    textBoxes[row][col].value = letter;
  }

  void setColor(String letter, Color color) {
    rowLettersMap[letter]!.value = color;
  }
}
