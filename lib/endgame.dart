import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:first_project/my_flutter_app_icons.dart';
import 'package:first_project/scorePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ntp/ntp.dart';
import 'package:share_plus/share_plus.dart';
import 'package:turkish/turkish.dart';
import 'countDowner.dart';
import 'design.dart';
import 'dictAlertDialog.dart';
import 'generalStatistic.dart';
import 'main.dart';
import 'helper.dart';

class EndGame extends StatefulWidget {
  const EndGame({Key? key}) : super(key: key);

  @override
  State<EndGame> createState() => _EndGamePageState();
}

class _EndGamePageState extends State<EndGame>
    with SingleTickerProviderStateMixin {
  bool isButtonPressed = false;
  late Animation<double> animation;
  late AnimationController controller;
  late Future<Duration?> remainingTimeFuture;
  late Duration remainingTime;

  @override
  void initState() {
    super.initState();

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

    remainingTimeFuture = _checkTime();
  }

  String myTime = timeFormat(totalSeconds, isEndTime: true);
  var textSizeGroup = AutoSizeGroup();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  double scale = 1.0;
  late DateTime after;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Duration?>(
      future: remainingTimeFuture,
      // a previously-obtained Future<String> or null
      builder: (BuildContext context, AsyncSnapshot<Duration?> snapshot) {
        late Widget child;
        if (snapshot.hasData) {
          child = endGamePage();
        } else {
          child = endGamePageWithoutRemainingTime();
        }
        return child;
      },
    );
  }

  Widget endGamePage() {
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
              padding: EdgeInsets.only(top: height, bottom: height),
              width: width * 80,
              height: height * 70,
              decoration: BoxDecoration(
                color: lightGreen,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: width * 10,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: SizedBox(
                          width: width * 10,
                          height: height * 5,
                          child: IconButton(
                            icon: Icon(
                              Icons.cancel_rounded,
                              shadows: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 10,
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
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: width * 10,
                      ),
                      Text(
                        '${turkish.toUpperCase(wordOfDay)}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xff2bb429),
                            fontSize: height * 6,
                            fontFamily: "DMSans"),
                      ),
                      SizedBox(
                        width: width * 10,
                        child: DictButton(
                          onTap: buttonPressed,
                          size: scale,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 40,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: height * 2,
                              left: width * 8,
                              right: width * 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.watch_later_outlined,
                                      color: colorBlack, size: height * 3.5),
                                  Text(
                                    " " + myTime,
                                    style: TextStyle(
                                        color: colorBlack,
                                        fontSize: height * 3.5,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    MyFlutterApp.medal,
                                    color: colorBlack,
                                    size: height * 2.8,
                                  ),
                                  Text(
                                    " " + userScore.toString(),
                                    style: TextStyle(
                                        color: colorBlack,
                                        fontSize: height * 3.5,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: width * 44,
                          height: height * 7,
                          child: ElevatedButton(
                              onPressed: () {
                                _goScorePage();
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
                                      horizontal: 5, vertical: 0),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    MyFlutterApp.cup,
                                    color: green,
                                    size: width * 4.5,
                                  ),
                                  SizedBox(
                                    width: width * 33.5,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: AutoSizeText(
                                        "Skor Tablosu ",
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
                                showDialog(
                                  barrierColor: Colors.black.withOpacity(0.5),
                                  context: context,
                                  builder: (context) =>
                                      const GeneralStatistic(),
                                );
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
                                    Icons.bar_chart_rounded,
                                    color: green,
                                    size: width * 7,
                                  ),
                                  SizedBox(
                                    width: width * 33.5,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: AutoSizeText(
                                        "İstatistik ",
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
                              onPressed: () async {
                                Share.share(_prepareShareText());
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
                                    Icons.share,
                                    color: green,
                                    size: width * 5.5,
                                  ),
                                  SizedBox(
                                    width: width * 33.5,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: AutoSizeText(
                                        "Paylaş",
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
                                SystemChannels.platform
                                    .invokeMethod('SystemNavigator.pop');
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
                                        "Çıkış ",
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
                  Column(
                    children: [
                      Text(
                        "Sonraki kelimeye kalan süre\n",
                        style: TextStyle(
                            color: colorBlack,
                            fontSize: height * 2.5,
                            fontWeight: FontWeight.bold),
                      ),
                      CountdownTimerDemo(
                        remainingTime: remainingTime,
                        textStyle: TextStyle(
                            color: colorBlack,
                            fontSize: height * 3.5,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget endGamePageWithoutRemainingTime() {
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
              padding: EdgeInsets.only(top: height, bottom: height),
              width: width * 80,
              height: height * 70,
              decoration: BoxDecoration(
                color: lightGreen,
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: width * 10,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: SizedBox(
                          width: width * 10,
                          height: height * 5,
                          child: IconButton(
                            icon: Icon(
                              Icons.cancel_rounded,
                              shadows: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 10,
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
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: width * 10,
                      ),
                      Text(
                        '${turkish.toUpperCase(wordOfDay)}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xff2bb429),
                            fontSize: height * 6,
                            fontFamily: "DMSans"),
                      ),
                      SizedBox(
                        width: width * 10,
                        child: DictButton(
                          onTap: buttonPressed,
                          size: scale,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * 40,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                              bottom: height * 2,
                              left: width * 8,
                              right: width * 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.watch_later_outlined,
                                      color: colorBlack, size: height * 3.5),
                                  Text(
                                    " " + myTime,
                                    style: TextStyle(
                                        color: colorBlack,
                                        fontSize: height * 3.5,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(
                                    MyFlutterApp.medal,
                                    color: colorBlack,
                                    size: height * 2.8,
                                  ),
                                  Text(
                                    " " + userScore.toString(),
                                    style: TextStyle(
                                        color: colorBlack,
                                        fontSize: height * 3.5,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: width * 44,
                          height: height * 7,
                          child: ElevatedButton(
                              onPressed: () {
                                _goScorePage();
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
                                      horizontal: 5, vertical: 0),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Icon(
                                    MyFlutterApp.cup,
                                    color: green,
                                    size: width * 4.5,
                                  ),
                                  SizedBox(
                                    width: width * 33.5,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: AutoSizeText(
                                        "Skor Tablosu ",
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
                                showDialog(
                                  barrierColor: Colors.black.withOpacity(0.5),
                                  context: context,
                                  builder: (context) =>
                                      const GeneralStatistic(),
                                );
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
                                    Icons.bar_chart_rounded,
                                    color: green,
                                    size: width * 7,
                                  ),
                                  SizedBox(
                                    width: width * 33.5,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: AutoSizeText(
                                        "İstatistik ",
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
                              onPressed: () async {
                                Share.share(_prepareShareText());
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
                                    Icons.share,
                                    color: green,
                                    size: width * 5.5,
                                  ),
                                  SizedBox(
                                    width: width * 33.5,
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: AutoSizeText(
                                        "Paylaş",
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
                                SystemChannels.platform
                                    .invokeMethod('SystemNavigator.pop');
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
                                        "Çıkış ",
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
                  Column(
                    children: [
                      Text(
                        "Sonraki kelimeye kalan süre\n",
                        style: TextStyle(
                            color: colorBlack,
                            fontSize: height * 2.5,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "",
                        style: TextStyle(fontSize: height * 3.5),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Duration?> _checkTime() async {
    await (() async {
      try {
        var globalTime;

        var now = await NTP.now();
        Duration zoneOffSet = now.timeZoneOffset;

        int zoneDiff;

        if (zoneOffSet.inHours < 3) {
          zoneDiff = 3 - zoneOffSet.inHours;
        } else if (zoneOffSet.inHours == 3) {
          zoneDiff = 3;
        } else {
          zoneDiff = zoneOffSet.inHours - 3;
        }

        globalTime = DateTime.fromMillisecondsSinceEpoch(
            now.millisecondsSinceEpoch + zoneDiff * 1000 * 60 * 60 + 1000);

        String month = globalTime.month.toString().length == 1
            ? "0${globalTime.month}"
            : globalTime.month.toString();
        String day = globalTime.day.toString().length == 1
            ? "0${globalTime.day + 1}"
            : (globalTime.day + 1).toString();
        /*    String hour = (now.hour + 1).toString().length == 1
          ? "0${now.hour + 1}"
          : (now.hour + 1).toString();*/

        var after =
            DateTime.parse("${globalTime.year}-${month}-${day} 00:00:00");
        remainingTime = after.difference(globalTime);
        return remainingTime;
      } catch (e) {
        throw e;
      }
    })();

    return remainingTime;
  }

  void _goScorePage() async {
    showDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      context: context,
      builder: (context) => const MyAlertDialog(),
    );
  }

  String _prepareShareText() {
    String shareText = " T O K A T L A N D I N\n\n";
    for (int i = 0; i < whichWordUserFound + 1; i++) {
      for (int j = 0; j < 5; j++) {
        if (lastSquaresColors[i][j] == green) {
          shareText += "🟩";
        } else if (lastSquaresColors[i][j] == yellow) {
          shareText += "🟨";
        } else {
          shareText += "⬛";
        }
      }
      shareText += "\n";
    }
    return shareText;
  }

  void buttonPressed() {
    setState(() {
      controller.forward();
      isButtonPressed = true;
      showDialog(
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) => DictAlertDialog(wordOfDay),
      ).then((value) => setState(() {
            isButtonPressed = false;
            controller.reverse();
          }));
    });
  }
}

class DictButton extends StatelessWidget {
  final onTap;
  final size;

  DictButton({this.onTap, this.size});

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
