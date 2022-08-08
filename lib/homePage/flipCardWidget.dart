import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:first_project/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  State<FlipCardWidget> createState() => _FlipCardWidgetState();
}

class _FlipCardWidgetState extends State<FlipCardWidget> {

  AutoSizeGroup textSizeGroup = AutoSizeGroup();
  EdgeInsetsGeometry paddingForButtons = EdgeInsets.only(left: width * 2, right: width * 2);



  @override
  void initState() {
    super.initState();

      AdHelper().loadInterstitialAd();

    _connectDbAndMakeAuth();
  }


  @override
  void dispose() {
    interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? userName = prefs.getString("userName");
    return Column(
      children: [
        Container(
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
                          PushPage().pushPage(MyHomePage());
                        }
                      },
                      style: roundedButtonStyle,
                      child: Padding(
                        padding: EdgeInsets.only(left: width, right: width),
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
                        PushPage().pushPage(TrainingPage());
                      },
                      style: roundedButtonStyle,
                      child: Padding(
                        padding: paddingForButtons,
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
                      onPressed: () async {
                        try {
                          interstitialAd?.show();
                        } catch (e) {
                        }

                        PushPage().pushDialog(ScorePage());

                      },
                      style: roundedButtonStyle,
                      child: Padding(
                        padding: paddingForButtons,
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
                        PushPage().pushDialog(GeneralStatistic());

                      },
                      style: roundedButtonStyle,
                      child: Padding(
                        padding: paddingForButtons,
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
                        PushPage().pushDialog(HowToPlay());
                      },
                      style: roundedButtonStyle,
                      child: Padding(
                        padding: paddingForButtons,
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
                      style: roundedButtonStyle,
                      child: Padding(
                        padding: paddingForButtons,
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
      ],
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
            content: Container(
              padding: EdgeInsets.only(bottom: height * 2, top: height, left: width * 2, right: width * 2),
              height: height * 45,
              width: width * 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                    Radius.circular(width * 5),),
                color: green,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: width * 10,
                      ),
                      SizedBox(
                        width: width * 45,
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
                  SizedBox(
                    height: height * 14,
                    child: Text(
                        "İnternete bağlı değilsiniz. Antrenman modunu çevrimdışı oynayabilirsiniz.",
                        style: TextStyle(
                            fontSize: height * 3, color: white),
                        textAlign: TextAlign.center),
                  ),
                  SizedBox(
                    width: width * 40,
                    height: height * 6,
                    child: ElevatedButton(
                        onPressed: () {
                          PushPage().pushPage(TrainingPage());
                        },
                        style: ButtonStyle(
                          overlayColor: MaterialStateProperty.all(
                              Colors.grey.withOpacity(0.2)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(width * 2),
                              ),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(white),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(left: width,right: width),
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
