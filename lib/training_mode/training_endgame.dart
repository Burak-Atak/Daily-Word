import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:first_project/dictAlertDialog.dart';
import 'package:first_project/homePage/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:turkish/turkish.dart';

import '../ad_helper.dart';
import '../design.dart';
import '../main.dart';
import '../my_flutter_app_icons.dart';
import 'trainingHomePage.dart';

bool startNewTrainingGame = false;

class EndGame extends StatefulWidget {
  const EndGame({Key? key}) : super(key: key);

  @override
  State<EndGame> createState() => _EndGamePageState();
}

class _EndGamePageState extends State<EndGame>
    with SingleTickerProviderStateMixin {
  bool isButtonPressed = false;
  bool isDictOpen = true;
  late Animation<double> animation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    _loadInterstitialAd();
    final quick = const Duration(milliseconds: 200);
    final scaleTween = Tween(begin: 1.0, end: 0.8);
    controller = AnimationController(duration: quick, vsync: this);
    animation = scaleTween.animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
      ),
    )..addListener(() {
        setState(() => scale = animation.value);
      });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 300));
      await controller.forward();
      await Future.delayed(const Duration(milliseconds: 200));
      await controller.reverse();
    });
  }

  InterstitialAd? _interstitialAd;

  Future<void> _loadInterstitialAd() async {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) async {
            },
          );
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (err) {
        },
      ),
    );

    return;
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    controller.dispose();
    super.dispose();
  }

  double scale = 1.0;

  @override
  Widget build(BuildContext context) {
    var textSizeGroup = AutoSizeGroup();
    return StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0))),
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.only(
            top: height * 5,
            bottom: height * 5,
            left: width * 8,
            right: width * 8),
        insetPadding: EdgeInsets.all(0),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: width * 80,
              height: height * 55,
              decoration: BoxDecoration(
                color: Color(0xffbbe7bb),
                borderRadius: BorderRadius.all(
                  Radius.circular(width * 3),
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: height * 7,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width * 10,
                        ),
                        SizedBox(
                          width: width * 10,
                          height: height * 5,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: width * 10,
                      ),
                      Text(
                        '${turkish.toUpperCase(wordOfDayTraining)}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xff2bb429),
                            fontSize: height * 6,
                            fontFamily: "DMSans"),
                      ),
                      SizedBox(
                        width: width * 10,
                        child: TrainingDictButton(
                          onTap: buttonPressed,
                          size: scale,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 28,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: height * 2,
                              left: width * 8,
                              right: width * 8),
                        ),
                        SizedBox(
                          width: width * 44,
                          height: height * 7,
                          child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                    HomePage()), (Route<dynamic> route) => false);
                              },
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(width * 2),
                                    ),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all(white),
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      horizontal: 3, vertical: 0),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    Icons.home,
                                    size: width * 7,
                                    color: green,
                                  ),
                                  SizedBox(
                                    width: width * 33.5,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: AutoSizeText(
                                        "Ana Men??",
                                        style: TextStyle(
                                            fontSize: height * 3.64,
                                            color: green),
                                        maxLines: 1,
                                        group: textSizeGroup,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        SizedBox(
                          width: width * 44,
                          height: height * 7,
                          child: ElevatedButton(
                              onPressed: () {
                                startNewTrainingGame = true;
                                try {
                                  _interstitialAd?.show();
                                } catch (e) {
                                }
                                Navigator.pop(context);
                              },
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(width * 2),
                                    ),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all(white),
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      horizontal: 3, vertical: 0),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    Icons.refresh,
                                    size: width * 7,
                                    color: green,
                                  ),
                                  SizedBox(
                                    width: width * 33.5,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: AutoSizeText(
                                        "Yeni Oyun",
                                        style: TextStyle(
                                            fontSize: height * 3.64,
                                            color: green),
                                        maxLines: 1,
                                        group: textSizeGroup,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        SizedBox(
                          width: width * 44,
                          height: height * 7,
                          child: ElevatedButton(
                              onPressed: () {
                                SystemChannels.platform.invokeMethod(
                                    'SystemNavigator.pop');
                              },
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(width * 2),
                                    ),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all(white),
                                padding: MaterialStateProperty.all(
                                  EdgeInsets.symmetric(
                                      horizontal: 3, vertical: 0),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                    width: width * 33.5,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: AutoSizeText(
                                        "????k????",
                                        style: TextStyle(
                                            fontSize: height * 3.64,
                                            color: green),
                                        maxLines: 1,
                                        group: textSizeGroup,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void buttonPressed() {
    setState(() {

        controller.forward();
        showDialog(
          barrierColor: Colors.transparent,
          context: context,
          builder: (context) =>
           DictAlertDialog(wordOfDayTraining),
        ).then((value) => setState(() {
          isButtonPressed = false;
          controller.reverse();
            }));

    });
  }
}

class TrainingDictButton extends StatelessWidget {
  final onTap;
  final size;

  TrainingDictButton({this.onTap, this.size});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.scale(
        scale: size,
        child: Icon(
          MyFlutterApp2.dictionary2,
          color: Colors.black,
          size: height * 4.5,
        ),
      ),
    );
  }
}
