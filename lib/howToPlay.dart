import 'package:auto_size_text/auto_size_text.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'design.dart';
import 'main.dart';

var style = TextStyle(color: colorBlack, fontSize: height * 3);

class HowToPlay extends StatefulWidget {
  const HowToPlay({Key? key}) : super(key: key);

  @override
  State<HowToPlay> createState() => _HowToPlayState();
}

class _HowToPlayState extends State<HowToPlay>
    with SingleTickerProviderStateMixin {
  late Map<dynamic, dynamic>? series;
  late Map<dynamic, dynamic>? whichWord;
  late Map<dynamic, dynamic>? generalStatistic;
  late AnimationController seriesController;
  AutoSizeGroup textGroup = AutoSizeGroup();

  @override
  void initState() {
    super.initState();
    seriesController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
      animationBehavior: AnimationBehavior.preserve,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Future.delayed(Duration(milliseconds: 100), () => _turnFlipKey());
    });
  }

  List flipKeys = [for (int a = 0; a < 3; a++) GlobalKey<FlipCardState>()];
  List<dynamic> textBoxes = ["ATLAS", "ÇELİK", "GÜNEŞ"];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: AlertDialog(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0))),
            backgroundColor: Colors.transparent,
            insetPadding: EdgeInsets.all(0),
contentPadding: EdgeInsets.only(
                top: height * 5,
                bottom: height * 5,
                left: width * 10,
                right: width * 10),
            content: Column(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max , children: [
              SizedBox(
                height: height * 2,
              ),
              Container(
                height: height * 8,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: white.withOpacity(0.3),
                      blurRadius: 25,
                      spreadRadius: 1,
                    ),
                  ],
                  color: green,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(width * 3),
                    topRight: Radius.circular(width * 3),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: width * 10,
                    ),
                    SizedBox(
                      width: width * 60,
                      child: AutoSizeText("Nasıl Oynanır?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: colorBlack,
                              fontSize: height * 4,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      width: width * 10,
                      child: IconButton(
                        icon: Icon(
                          Icons.cancel_rounded,
                          shadows: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 25,
                              spreadRadius: 1,
                            ),
                          ],
                          color: white,
                          size: height * 5,
                        ),
                        onPressed: () {
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                        padding: EdgeInsets.all(0),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  padding: EdgeInsets.all(width * 3),
                  width: width * 100,
                  height: height * 90,
                  decoration: BoxDecoration(
                    color: lightGreen,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.zero,
                      topRight: Radius.zero,
                      bottomLeft: Radius.circular(width * 3),
                      bottomRight: Radius.circular(width * 3),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: white.withOpacity(0.3),
                        blurRadius: 25,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      AutoSizeText(
                        "24 saatte bir yenilenen günün kelimesini 6 denemede bul.\n",
                        style: style,
                      ),
                      AutoSizeText(
                        "Kutucukların renkleri, günün kelimesini bulman için ipucu verir.",
                        style: style,
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: width * 3, top: width * 3),
                        child: Divider(
                          color: Color(0xff21821e),
                          thickness: 0.5,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: AutoSizeText(
                          "Örnekler\n",
                          style: TextStyle(
                              color: colorBlack,
                              fontSize: height * 3,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: width * 3,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ...createLittleSquares(0, 0),
                          ],
                        ),
                      ),
                      AutoSizeText.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "A",
                              style: TextStyle(
                                  color: colorBlack,
                                  fontSize: height * 3,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: " harfi günün kelimesinde var ve doğru yerde.\n",
                              style: TextStyle(
                                color: colorBlack,
                                fontSize: height * 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: width * 3,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ...createLittleSquares(1, 2),
                          ],
                        ),
                      ),
                      AutoSizeText.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "L",
                              style: TextStyle(
                                  color: colorBlack,
                                  fontSize: height * 3,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: " harfi günün kelimesinde var fakat yanlış yerde.\n",
                              style: TextStyle(
                                color: colorBlack,
                                fontSize: height * 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: width * 3,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ...createLittleSquares(2, 4),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: AutoSizeText.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Ş",
                                style: TextStyle(
                                    color: colorBlack,
                                    fontSize: height * 3,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: " harfi günün kelimesinde yok.",
                                style: TextStyle(
                                  color: colorBlack,
                                  fontSize: height * 3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ))
            ])),
      ),
    );
  }

  /// Harf girilen Kutucukları oluşturuyor
  List<Widget> createLittleSquares(int squareRowCount, int letterIndex) {
    List<Widget> littleSquares = [];
    for (int i = 0; i < 5; i++) {
      var box = Padding(
          padding: EdgeInsets.only(right: i != 20 ? width * 1.2 : 0),
          child: SizedBox(
            width: height * 7,
            height: height * 7,
            child: i == letterIndex
                ? FlipCard(
                    speed: 650,
                    key: flipKeys[squareRowCount],
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
                      child: Text(
                        textBoxes[squareRowCount][i],
                        style: TextStyle(
                            fontSize: height * 5, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    back: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: squareRowCount == 0
                            ? green
                            : squareRowCount == 1
                                ? yellow
                                : Colors.black54,
                      ),
                      child: Text(
                        textBoxes[squareRowCount][i],
                        style: TextStyle(
                            fontSize: height * 5, color: Colors.white),
                      ),
                    ),
                  )
                : Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white38,
                      border: Border.all(
                        color: grey,
                        width: 0.9,
                      ),
                    ),
                    child: Text(
                      textBoxes[squareRowCount][i],
                      style:
                          TextStyle(fontSize: height * 5, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
          ));

      littleSquares.add(box);
    }
    return littleSquares;
  }

  _turnFlipKey() {
    for (int i = 0; i < flipKeys.length; i++) {
      flipKeys[i].currentState.toggleCard();
    }
  }
}
