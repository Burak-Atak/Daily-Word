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
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              Container(
                padding: EdgeInsets.all(width * 3),
                width: width * 80,
                height: height * 70,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: width * 10,
                        ),
                        isWin
                            ? Text(
                          'Tebrikler!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xff2bb429), fontSize: height * 7, fontFamily: "DMSans"),
                        )
                            : Text(
                          '"${turkish.toUpperCase(wordOfDay)}"',
                          textAlign: TextAlign.center,
                          style:
                          TextStyle(color: Colors.red, fontSize: height * 6, fontFamily: "DMSans"),
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
                      ],
                    ),
                    SizedBox(
                      height: height * 40,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only( bottom: height *2, left: width * 8, right: width * 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(Icons.hourglass_bottom_rounded,
                                        color: colorBlack, size: height * 4),
                                    Text(
                                      myTime,
                                      style: TextStyle(
                                          color: colorBlack, fontSize: height * 4, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(MyFlutterApp.medal,
                                      color: colorBlack, size: height * 3.5,),
                                    Text(
                                      userScore.toString(),
                                      style: TextStyle(
                                          color: colorBlack, fontSize: height * 4, fontWeight: FontWeight.bold),
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
                                        horizontal: 5, vertical: 0),
                                  ),
                                ),
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
                                      width: width * 33.5,
                                      child: Align(
                                        alignment: Alignment.centerLeft,
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
                            width: width * 44,
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
                                        horizontal: 3, vertical: 0),
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
                                        alignment: Alignment.centerLeft,
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
                            width: width * 44,
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
                                        horizontal: 3, vertical: 0),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            width: width * 44,
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
                                        horizontal: 3, vertical: 0),
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
                                              fontSize: height * 3.64, color: green),
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
                          style: TextStyle(color: colorBlack, fontSize: height * 3, fontWeight: FontWeight.bold),
                        ),
                        CountdownTimer(
                          endTime: after.millisecondsSinceEpoch,
                          onEnd: () {},
                          widgetBuilder: (_, CurrentRemainingTime? time) {
                            if (time == null) {
                              return Text(
                                '',
                                style: TextStyle(color: colorBlack, fontSize: height * 3.64),
                              );
                            }
                            return Text(
                              '${time.hours == null ? "00" : time.hours.toString().length < 2 ? "0${time.hours}" : time.hours}:${time.min == null ? "00" : time.min.toString().length < 2 ? "0${time.min}" : time.min}:${time.sec == null ? "00" : time.sec.toString().length < 2 ? "0${time.sec}" : time.sec}',
                              style: TextStyle(color: colorBlack, fontSize: height * 4, fontWeight: FontWeight.bold),
                            );
                          },
                        ),
                      ],
                    )


                  ],
                ),
              ),

            ],
          ),
        ],
      ),
    );
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
