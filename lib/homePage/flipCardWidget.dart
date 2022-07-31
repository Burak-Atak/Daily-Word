import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:first_project/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../ad_helper.dart';
import '../design.dart';
import '../generalStatistic.dart';
import '../helper.dart';
import '../howToPlay.dart';
import '../my_flutter_app_icons.dart';
import '../scorePage.dart';
import '../training_mode/trainingHomePage.dart';

class FlipCardWidget extends StatefulWidget {
  @override
  _FlipCardWidgetState createState() => _FlipCardWidgetState();
}

class _FlipCardWidgetState extends State<FlipCardWidget>
    with TickerProviderStateMixin {
  late AnimationController _controllerX;
  late AnimationController _controllerY;
  late Animation _animationX;
  late Animation _animationY;

  AutoSizeGroup textSizeGroup = AutoSizeGroup();

  @override
  void initState() {
    super.initState();


      AdHelper().loadInterstitialAd();


    _controllerX =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            dragPositionX = _animationX.value.toDouble();
          });

    _controllerY =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {
              dragPositionY = _animationY.value.toDouble();
            });
          });

    _connectDbAndMakeAuth();
  }


  @override
  void dispose() {
    _controllerX.dispose();
    _controllerY.dispose();
    interstitialAd?.dispose();
    super.dispose();
  }


  double dragPositionX = 0;
  double dragPositionY = 0;

  @override
  Widget build(BuildContext context) {
    String? userName = prefs.getString("userName");
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          var newPositionX = dragPositionX - details.delta.dx / 150;
          if (newPositionX < -1) {
            dragPositionX = -1;
          } else if (newPositionX > 1) {
            dragPositionX = 1;
          } else {
            dragPositionX = newPositionX;
          }

          var newPositionY = dragPositionY - details.delta.dy / 150;
          if (newPositionY < -1) {
            dragPositionY = -1;
          } else if (newPositionY > 1) {
            dragPositionY = 1;
          } else {
            dragPositionY = newPositionY;
          }
        });
      },
      onPanEnd: (details) {
        _animationX = Tween(begin: dragPositionX, end: 0).animate(_controllerX);
        _controllerX.forward(from: 0);

        _animationY = Tween(begin: dragPositionY, end: 0).animate(_controllerY);
        _controllerY.forward(from: 0);
      },
      child: Column(
        children: [
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(pi * dragPositionX / 10)
              ..rotateX(pi * -dragPositionY / 10),
            child: Container(
              padding: EdgeInsets.only(bottom: height * 4, top: height*4, left: width*2, right: width*2),
              width: width * 70,
              height: height * 65,
              decoration: BoxDecoration(
                color: green,
                borderRadius: BorderRadius.circular(width * 5),
              ),
              child: SizedBox(
                height: height * 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: height * 3),
                      child: AutoSizeText(
                        userName == null
                            ? "Merhaba"
                            : "Merhaba, $userName",
                        style: TextStyle(
                          fontSize: height * 3.5,
                          fontWeight: FontWeight.bold,
                          color: white,
                        ),
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(
                      width: width * 48,
                      height: height * 7,
                      child: ElevatedButton(
                          onPressed: () async {
                            bool isConnected = await checkInternet();
                            if (!isConnected) {
                              _goTrainingPage();
                            } else {
                              Get.to(() => MyHomePage());
                            }
                          },
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                                Colors.grey.withOpacity(0.2)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(width * 5),
                                ),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(white),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(horizontal: 1, vertical: 0),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: width * 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  Icons.play_arrow,
                                  color: green,
                                  size: width * 7,
                                ),
                                SizedBox(
                                  width: width * 35.5,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: AutoSizeText(
                                      "Oyuna Başla",
                                      style: TextStyle(
                                          fontSize: height * 3.64,
                                          color: green),
                                      maxLines: 1,
                                      group: textSizeGroup,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                    SizedBox(
                      width: width * 48,
                      height: height * 7,
                      child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => TrainingPage());
                          },
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                                Colors.grey.withOpacity(0.2)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(width * 5),
                                ),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(white),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: width * 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  Icons.directions_run_rounded,
                                  color: green,
                                  size: width * 5,
                                ),
                                SizedBox(
                                  width: width * 34.5,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: AutoSizeText(
                                      "Antrenman Modu",
                                      style: TextStyle(
                                          fontSize: height * 3.64,
                                          color: green),
                                      maxLines: 1,
                                      group: textSizeGroup,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                    SizedBox(
                      width: width * 48,
                      height: height * 7,
                      child: ElevatedButton(
                          onPressed: () {
                            try {
                              interstitialAd?.show();
                            } catch (e) {
                            }
                            showDialog(
                              barrierColor: Colors.black.withOpacity(0.5),
                              context: context,
                              builder: (context) => const MyAlertDialog(),
                            );
                          },
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                                Colors.grey.withOpacity(0.2)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(width * 5),
                                ),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(white),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: width * 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  MyFlutterApp.cup,
                                  color: green,
                                  size: width * 4.5,
                                ),
                                SizedBox(
                                  width: width * 34.5,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: AutoSizeText(
                                      "Skor Tablosu",
                                      style: TextStyle(
                                          fontSize: height * 3.64,
                                          color: green),
                                      maxLines: 1,
                                      group: textSizeGroup,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                    SizedBox(
                      width: width * 48,
                      height: height * 7,
                      child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              barrierColor: Colors.black.withOpacity(0.5),
                              context: context,
                              builder: (context) => const GeneralStatistic(),
                            );
                          },
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                                Colors.grey.withOpacity(0.2)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(width * 5),
                                ),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(white),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(horizontal: 3, vertical: 0),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: width * 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  Icons.bar_chart_rounded,
                                  color: green,
                                  size: width * 7,
                                ),
                                SizedBox(
                                  width: width * 34.5,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: AutoSizeText(
                                      "İstatistik",
                                      style: TextStyle(
                                          fontSize: height * 3.64,
                                          color: green),
                                      maxLines: 1,
                                      group: textSizeGroup,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                    SizedBox(
                      width: width * 48,
                      height: height * 7,
                      child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              barrierColor: Colors.black.withOpacity(0.5),
                              context: context,
                              builder: (context) => const HowToPlay(),
                            );
                          },
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                                Colors.grey.withOpacity(0.2)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(width * 5),
                                ),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(white),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(horizontal: 3, vertical: 0),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: width * 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  Icons.info_outline_rounded,
                                  color: green,
                                  size: width * 5.5,
                                ),
                                SizedBox(
                                  width: width * 34.5,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: AutoSizeText(
                                      "Nasıl Oynanır?",
                                      style: TextStyle(
                                          fontSize: height * 3.64,
                                          color: green),
                                      maxLines: 1,
                                      group: textSizeGroup,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                    SizedBox(
                      width: width * 48,
                      height: height * 7,
                      child: ElevatedButton(
                          onPressed: () {
                            SystemChannels.platform
                                .invokeMethod('SystemNavigator.pop');
                          },
                          style: ButtonStyle(
                            overlayColor: MaterialStateProperty.all(
                                Colors.grey.withOpacity(0.2)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(width * 5),
                                ),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(white),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(horizontal: 3, vertical: 0),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: width * 3),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Transform.rotate(
                                    angle: 180 * pi / 180,
                                    child: Icon(
                                      Icons.exit_to_app_rounded,
                                      size: width * 5.5,
                                      color: green,
                                    )),
                                SizedBox(
                                  width: width * 34.5,
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: AutoSizeText(
                                      "Çıkış",
                                      style: TextStyle(
                                          fontSize: height * 3.64,
                                          color: green),
                                      maxLines: 1,
                                      group: textSizeGroup,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _goTrainingPage() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            elevation: 0,
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0))),
            contentPadding: EdgeInsets.only(
                top: height * 5,
                bottom: height * 5,
                left: width * 15,
                right: width * 15),
            insetPadding: EdgeInsets.all(0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                        width: width * 50,
                        child: AutoSizeText("İnternet Yok",
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
                              Navigator.pop(context);
                          },
                          padding: EdgeInsets.all(0),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: height, top: height, left: width * 2, right: width * 2),
                  height: height * 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(width * 3),
                        bottomRight: Radius.circular(width * 3)),
                    color: lightGreen,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SizedBox(
                        height: height * 6,
                      ),
                      SizedBox(
                        height: height * 21,
                        child: Text(
                            "İnternete bağlı değilsiniz. Antrenman modunu çevrimdışı oynayabilirsiniz.",
                            style: TextStyle(
                                fontSize: height * 3, color: Colors.black),
                            textAlign: TextAlign.center),
                      ),
                      SizedBox(
                        width: width * 44,
                        height: height * 6,
                        child: ElevatedButton(
                            onPressed: () {
                              Get.to(() => TrainingPage());
                            },
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(
                                  Colors.grey.withOpacity(0.2)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(width * 5),
                                  ),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all(white),
                              padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 0),
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(left: width * 3),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    Icons.directions_run_rounded,
                                    color: green,
                                    size: width * 5,
                                  ),
                                  SizedBox(
                                    width: width * 30.5,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: AutoSizeText(
                                        "Antrenman Modu",
                                        style: TextStyle(
                                            fontSize: height * 3.64,
                                            color: green),
                                        maxLines: 1,
                                        group: textSizeGroup,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _connectDbAndMakeAuth() async {
    bool isConnected = await checkInternet();
    if (!isConnected) {
      return;
    } else {
      /*   if (FirebaseAuth.instance.currentUser == null) {
        await FirebaseAuth.instance.signInAnonymously();
      }
      database = FirebaseDatabase.instance;
      isDbReady = true;*/
    }
    return;
  }
}
