import 'dart:collection';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:first_project/helper.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'containerForBadConnection.dart';
import 'design.dart';
import 'main.dart';

Map? scoreTable;
Map? weeklyScoreTable;
double playerHeight = height * 4;
double playerWidth = width * 50;
TextStyle scoreStyle = TextStyle(
  color: colorBlack,
  fontSize: height * 3,
);

TextStyle scoreStyleMedals = TextStyle(
  color: colorBlack,
  fontSize: height * 3.5,
);

const chosenColor = green;
const playerColor = Color(0xff53d952);
const notChosen = Color(0xff5e5e5e);
const userColorOne = Color(0xffa1cba1);
const userColorTwo = lightGreen;

class ScorePage extends StatefulWidget {
  const ScorePage({Key? key}) : super(key: key);

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  bool selectedDaily = true;

  @override
  Widget build(BuildContext context) {
    Future<Map?> getDailyScoreTable() async {
      await database.ref('dailyRank').get().timeout(Duration(seconds: 5),
          onTimeout: (() {
        throw Exception("dailyScoreTable is null");
      })).then((snapshot) {
        if (snapshot.value == null) {
          scoreTable = null;
          return null;
        }
        Map<dynamic, dynamic> dailyDict = snapshot.value as Map;

        scoreTable = dailyDict.length > 1
            ? SplayTreeMap.from(
                dailyDict,
                (a, b) => ((dailyDict[a]['score'] == dailyDict[b]['score']) &&
                        (dailyDict[a]['seconds'] == dailyDict[b]['seconds']))
                    ? 1
                    : ((dailyDict[a]['score'] - dailyDict[b]['score']) != 0)
                        ? dailyDict[b]['score'].compareTo(dailyDict[a]['score'])
                        : dailyDict[a]['seconds']
                            .compareTo(dailyDict[b]['seconds']))
            : dailyDict;
      });

      return scoreTable;
    }

    Future<Map?> getWeeklyScoreTable() async {
      await database.ref('weeklyRank').get().timeout(Duration(seconds: 5),
          onTimeout: (() {
        throw Exception("weeklyScoreTable is null");
      })).then((snapshot) {
        if (snapshot.value == null) {
          weeklyScoreTable = null;
          return null;
        }

        Map<dynamic, dynamic> weeklyDict = snapshot.value as Map;

        weeklyScoreTable = weeklyDict.length > 1
            ? SplayTreeMap.from(
                weeklyDict,
                (a, b) => ((weeklyDict[a]['score'] == weeklyDict[b]['score']) &&
                        (weeklyDict[a]['totalSeconds'] ==
                            weeklyDict[b]['totalSeconds']))
                    ? 1
                    : ((weeklyDict[a]['score'] - weeklyDict[b]['score']) != 0)
                        ? weeklyDict[b]['score']
                            .compareTo(weeklyDict[a]['score'])
                        : weeklyDict[a]['totalSeconds']
                            .compareTo(weeklyDict[b]['totalSeconds']))
            : weeklyDict;
      });

      return weeklyScoreTable;
    }

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2!,
      textAlign: TextAlign.center,
      child: FutureBuilder<List<Map?>>(
        future: Future.wait([
          getDailyScoreTable(),
          getWeeklyScoreTable(),
        ]),
        // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<List<Map?>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return LoadingAnimationWidget.inkDrop(
                color: green,
                size: height * 5,
              );
            case ConnectionState.active:
              return LoadingAnimationWidget.inkDrop(
                color: green,
                size: height * 5,
              );
            case ConnectionState.done:
              if (snapshot.hasError) {
                return BadConnection();
              } else {
                return mainScorePage();
              }
            case ConnectionState.none:
              // TODO: Handle this case.
              return BadConnection();
          }
        },
      ),
    );
  }

  Widget mainScorePage() {
    Map? chosenScoreTable = selectedDaily ? scoreTable : weeklyScoreTable;
    var textSizeGroup = AutoSizeGroup();

    _checkUserInScoreTable(int i, int length) {
      if (length <= i) {
        return false;
      }
      if (chosenScoreTable!.entries.toList()[i].key == userName) {
        return true;
      }
      return false;
    }

    return StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0))),
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.only(
            top: height * 5,
            bottom: height * 5,
            left: width * 10,
            right: width * 10),
        insetPadding: EdgeInsets.all(0),
        content: Stack(
          children: [

            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
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
                      Container(
                          height: height * 8,
                          decoration: BoxDecoration(
                            color: chosenColor,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(width * 5),
                              topRight: Radius.circular(width * 5),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: width * 10,
                              ),
                              Text(
                                  selectedDaily
                                      ? "Günlük Sıralama"
                                      : "Haftalık Sıralama",
                                  style: TextStyle(
                                      color: colorBlack,
                                      fontSize: height * 3.64,
                                      fontWeight: FontWeight.bold)),
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
                          )),
                      Container(
                        decoration: BoxDecoration(
                          color: userColorTwo,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                height: height * 5,
                                width: width * 15,
                                child: Align(
                                    child: Text(
                                  "#",
                                  style: TextStyle(
                                      color: colorBlack,
                                      fontSize: height * 2.5),
                                ))),
                            SizedBox(
                              height: height * 5,
                              width: width * 30,
                              child: Align(
                                child: Text(
                                  "İsim",
                                  style: TextStyle(
                                      color: colorBlack,
                                      fontSize: height * 2.5),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 5,
                              width: width * 15,
                              child: Align(
                                child: Text(
                                  "Puan",
                                  style: TextStyle(
                                      color: colorBlack,
                                      fontSize: height * 2.5),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * 5,
                              width: width * 20,
                              child: Align(
                                child: Text(
                                  selectedDaily ? "Süre" : "Ort.Süre",
                                  style: TextStyle(
                                      color: colorBlack,
                                      fontSize: height * 2.5),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      if (chosenScoreTable == null)
                        for (var i = 0; i < 10; i++)
                          Container(
                            decoration: BoxDecoration(
                              color: i % 2 == 0 ? userColorOne : userColorTwo,
                              /*             borderRadius: chosenScoreTable!.length < 10 &&
                                      i == chosenScoreTable!.length - 1
                                  ? BorderRadius.only(
                                      bottomLeft: Radius.circular(width * 5),
                                      bottomRight: Radius.circular(width * 5),
                                    )
                                  : BorderRadius.zero,*/
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: height * 7,
                                  width: width * 15,
                                  child: Align(
                                    child: Text(
                                      "",
                                      //userScores.key,
                                      textAlign: TextAlign.center,
                                      style:
                                      i < 3 ? scoreStyleMedals : scoreStyle,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 7,
                                  width: width * 30,
                                  child: Align(
                                    child: Text(
                                      "",
                                      //userScores.key,
                                      textAlign: TextAlign.center,
                                      style: scoreStyle,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 7,
                                  width: width * 15,
                                  child: Align(
                                    child: Text(
                                      "",
                                      //userScores.value["score"].toString(),
                                      textAlign: TextAlign.center,
                                      style: scoreStyle,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 7,
                                  width: width * 20,
                                  child: Align(
                                    child: Text(
                                      "",
                                      textAlign: TextAlign.center,
                                      style: scoreStyle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (chosenScoreTable != null)
                          for (var i = 0; i < 10; i++)
                            Container(
                            decoration: BoxDecoration(
                              color: _checkUserInScoreTable(
                                      i, chosenScoreTable!.length)
                                  ? playerColor
                                  : i % 2 == 0
                                      ? userColorOne
                                      : userColorTwo,
                              /*             borderRadius: chosenScoreTable!.length < 10 &&
                                      i == chosenScoreTable!.length - 1
                                  ? BorderRadius.only(
                                      bottomLeft: Radius.circular(width * 5),
                                      bottomRight: Radius.circular(width * 5),
                                    )
                                  : BorderRadius.zero,*/
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: height * 7,
                                  width: width * 15,
                                  child: Align(
                                    child: Text(
                                      chosenScoreTable!.length <= i
                                          ? ""
                                          : i == 0
                                              ? "🥇"
                                              : i == 1
                                                  ? "🥈"
                                                  : i == 2
                                                      ? "🥉 "
                                                      : "${(i + 1).toString()}.",
                                      //userScores.key,
                                      textAlign: TextAlign.center,
                                      style:
                                          i < 3 ? scoreStyleMedals : scoreStyle,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 7,
                                  width: width * 30,
                                  child: Align(
                                    child: AutoSizeText(
                                      chosenScoreTable!.entries.length <= i
                                          ? ""
                                          : chosenScoreTable!.entries
                                              .toList()[i]
                                              .key,
                                      //userScores.key,
                                      textAlign: TextAlign.center,
                                      minFontSize: 15,
                                      group: textSizeGroup,
                                      maxLines: 1,
                                      style: scoreStyle,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 7,
                                  width: width * 15,
                                  child: Align(
                                    child: AutoSizeText(
                                      chosenScoreTable!.entries.length <= i
                                          ? ""
                                          : chosenScoreTable!.entries
                                              .toList()[i]
                                              .value["score"]
                                              .toString(),
                                      //userScores.value["score"].toString(),
                                      textAlign: TextAlign.center,
                                      group: textSizeGroup,
                                      maxLines: 1,
                                      style: scoreStyle,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: height * 7,
                                  width: width * 20,
                                  child: Align(
                                    child: AutoSizeText(
                                      chosenScoreTable!.entries.length <= i
                                          ? ""
                                          : selectedDaily
                                              ? timeFormat(
                                                      chosenScoreTable!.entries
                                                          .toList()[i]
                                                          .value["seconds"],
                                                      isEndTime: true)
                                                  .toString()
                                              : timeFormat(
                                                      (chosenScoreTable!.entries
                                                                      .toList()[i]
                                                                      .value[
                                                                  "totalSeconds"] /
                                                              chosenScoreTable!
                                                                      .entries
                                                                      .toList()[i]
                                                                      .value[
                                                                  "totalGame"])
                                                          .round(),
                                                      isEndTime: true)
                                                  .toString(),
                                      textAlign: TextAlign.center,
                                      group: textSizeGroup,
                                      maxLines: 1,
                                      style: scoreStyle,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                      if (chosenScoreTable != null)
                        if (chosenScoreTable!.keys.toList().contains(userName)
                            && (chosenScoreTable!.keys
                            .toList()
                            .indexOf(userName) >
                            9))
                            Container(
                                decoration: BoxDecoration(
                                  color: playerColor,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      height: height * 7,
                                      width: width * 15,
                                      child: Align(
                                        child: Text(
                                          "${(chosenScoreTable!.keys.toList().indexOf(userName) + 1)
                                              .toString()}.",
                                          textAlign: TextAlign.center,
                                          style: scoreStyle,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 7,
                                      width: width * 30,
                                      child: Align(
                                        child: AutoSizeText(
                                          userName!, //userScores.key,
                                          textAlign: TextAlign.center,
                                          group: textSizeGroup,
                                          maxLines: 1,
                                          style: scoreStyle,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 7,
                                      width: width * 15,
                                      child: Align(
                                        child: AutoSizeText(
                                          chosenScoreTable!.entries.toList()[chosenScoreTable!.keys.toList().indexOf(userName)].value['score'].toString()
                                          ,
                                          //userScores.value["score"].toString(),
                                          textAlign: TextAlign.center,
                                          group: textSizeGroup,
                                          maxLines: 1,
                                          style: scoreStyle,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: height * 7,
                                      width: width * 20,
                                      child: Align(
                                        child: AutoSizeText(
                                          timeFormat(chosenScoreTable!.entries.toList()[chosenScoreTable!.keys.toList().indexOf(userName)].value[
                                          selectedDaily
                                              ? "seconds"
                                              : "totalSeconds"], isEndTime: true),
                                          textAlign: TextAlign.center,
                                          group: textSizeGroup,
                                          maxLines: 1,
                                          style: scoreStyle,
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                      Row(
                        children: [
                          SizedBox(
                            height: height * 10,
                            width: width * 40,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(width * 5),
                                    ),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                    selectedDaily ? chosenColor : notChosen),
                              ),
                              onPressed: () {
                                setState(() {
                                  selectedDaily = true;
                                  chosenScoreTable = scoreTable;
                                });
                              },
                              child: Text(
                                'Günlük',
                                style: TextStyle(
                                    color: colorBlack,
                                    fontSize: selectedDaily
                                        ? height * 3.64
                                        : height * 3),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: height * 10,
                            width: width * 40,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedDaily = false;
                                  chosenScoreTable = weeklyScoreTable;
                                });
                              },
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(width * 5),
                                    ),
                                  ),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                    selectedDaily ? notChosen : chosenColor),
                              ),
                              child: Text(
                                'Haftalık',
                                style: TextStyle(
                                    color: colorBlack,
                                    fontSize: selectedDaily
                                        ? height * 3
                                        : height * 3.64),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/*
* for (var i = 0; i < 10; i++)
              Container(
                decoration: BoxDecoration(
                  color: green,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: height * 7,
                      width: width * 15,
                      child: Align(
                        child: Text(
                          i == 0
                              ? "🥇"
                              : i == 1
                                  ? "🥈"
                                  : i == 2
                                      ? "🥉 "
                                      : "${(i + 1).toString()}.", //userScores.key,
                          textAlign: TextAlign.center,
                          style: i < 3 ? scoreStyleMedals : scoreStyle,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 7,
                      width: width * 30,
                      child: Align(
                        child: Text(
                          "adsads",
                          //userScores.key,
                          textAlign: TextAlign.center,
                          style: scoreStyle,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 7,
                      width: width * 15,
                      child: Align(
                        child: Text(
                          "25",
                          //userScores.value["score"].toString(),
                          textAlign: TextAlign.center,
                          style: scoreStyle,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height * 7,
                      width: width * 20,
                      child: Align(
                        child: Text(
                          "00.25",
                          //timeFormat(userScores.value["seconds"]),
                          textAlign: TextAlign.center,
                          style: scoreStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),*/
