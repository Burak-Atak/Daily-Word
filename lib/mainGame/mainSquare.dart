import 'package:auto_size_text/auto_size_text.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../design.dart';
import '../main.dart';

class mainSquare extends StatelessWidget {
  /// Her bir kutucuğun stringini tanımlıyoruz
  List<List<RxString>> textBoxes = mainController.textBoxes;

  /// Kutucukların animasyonunu kontrol eden keylerin bulundugu liste
  List flipKeys = mainController.flipKeys;

  /// Klavye harflerini ve renklerini tutan map
  Map<String, dynamic> rowLettersMap = mainController.rowLettersMap;
  List squaresColors = mainController.squaresColors;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          childAspectRatio: 1,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        padding: paddingForSquare,
        itemCount: 30,
        itemBuilder: (BuildContext context, int index) {
          return FlipCard(
            speed: 650,
            key: flipKeys[index ~/ 5][index % 5].value,
            flipOnTouch: false,
            front: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white38,
                  border: Border.all(
                    color: grey,
                    width: 0.9,
                  ),
                ),

              child: Obx(
                  () => AutoSizeText(
                    textBoxes[index ~/ 5][index % 5].value,
                    style: TextStyle(fontSize: height * 6, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),

            ),
            back: Obx(
              () => Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: squaresColors[index ~/ 5][index % 5].value,
                ),
                child:    AutoSizeText(
                    textBoxes[index ~/ 5][index % 5].value,
                    style: TextStyle(fontSize: height * 6, color: Colors.white),
                    textAlign: TextAlign.center,
                  )

              ),
            )
          );
        });
  }
}
