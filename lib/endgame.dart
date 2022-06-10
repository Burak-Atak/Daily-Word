import 'dart:math';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:first_project/my_flutter_app_icons.dart';
import 'package:first_project/scorePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:turkish/turkish.dart';
import 'generalStatistic.dart';
import 'main.dart';
import 'helper.dart';

class EndGame extends StatefulWidget {
  const EndGame({Key? key}) : super(key: key);

  @override
  State<EndGame> createState() => _EndGamePageState();
}

class _EndGamePageState extends State<EndGame> {
  @override
  Widget build(BuildContext context) {
    // todo: check internet connection
    var now = DateTime.now();
    /*var after = DateTime.parse("2022-05-${now.day + 1} 15:00:00+03:00");*/
    String month = now.month.toString().length == 1
        ? "0${now.month}"
        : now.month.toString();
    String day =
        now.day.toString().length == 1 ? "0${now.day}" : now.day.toString();
    String hour = (now.hour + 1).toString().length == 1
        ? "0${now.hour + 1}"
        : (now.hour + 1).toString();

    var after = DateTime.parse("${now.year}-${month}-${day} ${hour}:00:00");
    String myTime = timeFormat(totalSeconds);
    bool isWin = prefs.getBool("isWin")!;
    var textSizeGroup = AutoSizeGroup();
    return AlertDialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0))),
      backgroundColor: Colors.black.withOpacity(0.5),
      contentPadding: EdgeInsets.only(
          top: height * 5,
          bottom: height * 5,
          left: width * 10,
          right: width * 10),
      insetPadding: EdgeInsets.all(0),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: width * 100,
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                isWin
                    ? Text(
                        'Tebrikler!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: green, fontSize: height * 7),
                      )
                    : Text(
                        turkish.toUpperCase(wordOfDay),
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(color: Colors.red, fontSize: height * 7),
                      ),
                Padding(
                  padding: EdgeInsets.only(left: width * 5, right: width * 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.hourglass_bottom_rounded,
                              color: Colors.white, size: height * 4.86),
                          Text(
                            myTime,
                            style: TextStyle(
                                color: Colors.white, fontSize: height * 4.25),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(MyFlutterApp.medal,
                              color: Colors.white, size: height * 4),
                          Text(
                            userScore.toString(),
                            style: TextStyle(
                                color: Colors.white, fontSize: height * 4.25),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                Container(
                  width: width * 70,
                  height: height * 47,
                  padding: EdgeInsets.only(bottom: height * 5),
                  decoration: BoxDecoration(
                    color: green,
                    borderRadius: BorderRadius.circular(width * 5),
                    boxShadow: [
                      BoxShadow(
                        color: white.withOpacity(0.3),
                        blurRadius: 25,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
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
                      ),
                      SizedBox(
                        width: width * 42,
                        height: height * 7,
                        child: ElevatedButton(
                            onPressed: () {
                              _goScorePage();
                            },
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
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
                                    horizontal: 2, vertical: 0),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  MyFlutterApp.cup,
                                  color: green,
                                  size: width * 5.2,
                                ),
                                SizedBox(
                                  width: width * 33.5,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                     "Skor Tablosu ",
                                          style: TextStyle(
                                              fontSize: height * 3.64, color: green),
                                      maxLines: 1,
                                      group: textSizeGroup,

                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      SizedBox(
                        width: width * 42,
                        height: height * 7,
                        child: ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => const GeneralStatistic(),
                              );
                            },
                            style: ButtonStyle(
                              overlayColor:
                              MaterialStateProperty.all(Colors.transparent),
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
                                  width: width * 33.5,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      "İstatistik ",
                                      style: TextStyle(
                                          fontSize: height * 3.64, color: green),
                                      maxLines: 1,
                                      group: textSizeGroup,

                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      SizedBox(
                        width: width * 42,
                        height: height * 7,
                        child: ElevatedButton(
                            onPressed: () async {
                              Share.share(_prepareShareText());
                            },
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Icon(
                                  Icons.share,
                                  color: green,
                                  size: width * 6.5,
                                ),
                                SizedBox(
                                  width: width * 33.5,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      "Paylaş",
                                      style: TextStyle(
                                          fontSize: height * 3.64, color: green),
                                      maxLines: 1,
                                      group: textSizeGroup,

                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                      SizedBox(
                        width: width * 42,
                        height: height * 7,
                        child: ElevatedButton(
                            onPressed: () {
                              SystemChannels.platform
                                  .invokeMethod('SystemNavigator.pop');
                            },
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Transform.rotate(
                                    angle: 180 * pi / 180,
                                    child: Icon(
                                      Icons.exit_to_app_rounded,
                                      size: width * 6.5,
                                      color: green,
                                    )),
                                SizedBox(
                                  width: width * 33.5,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: AutoSizeText(
                                      "Çıkış ",
                                      style: TextStyle(
                                          fontSize: height * 3.64, color: green),
                                      maxLines: 1,
                                      group: textSizeGroup,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: height * 5),
                  child: Text(
                    "Sonraki kelimeye kalan süre",
                    style: TextStyle(color: white, fontSize: height * 3.64),
                  ),
                ),
                CountdownTimer(
                  endTime: after.millisecondsSinceEpoch,
                  onEnd: () {},
                  widgetBuilder: (_, CurrentRemainingTime? time) {
                    if (time == null) {
                      return Text(
                        '',
                        style: TextStyle(color: white, fontSize: height * 3.64),
                      );
                    }
                    return Text(
                      '${time.hours == null ? "00" : time.hours.toString().length < 2 ? "0${time.hours}" : time.hours}:${time.min == null ? "00" : time.min.toString().length < 2 ? "0${time.min}" : time.min}:${time.sec == null ? "00" : time.sec.toString().length < 2 ? "0${time.sec}" : time.sec}',
                      style: TextStyle(color: white, fontSize: height * 4.86),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _goScorePage() async {
    showDialog(
      context: context,
      builder: (context) => const MyAlertDialog(),
    );
  }

  String _prepareShareText() {
    String shareText = " T O K A T L A N D I N\n\n";
    for (int i = 0; i < whichWordUserFound + 1; i++) {
        for (int j = 0; j < 5 ; j++) {
          if (squaresColors[i][j] == green) {
            shareText += "🟩";
          } else if (squaresColors[i][j] == yellow) {
            shareText += "🟨";
          } else {
            shareText += "⬛";
          }
        }
        shareText += "\n";
    }
    return shareText;
  }

}
