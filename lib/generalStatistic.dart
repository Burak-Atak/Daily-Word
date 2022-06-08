import 'package:auto_size_text/auto_size_text.dart';
import 'package:first_project/helper.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'main.dart';

List<String> keys = ["first", "second", "third", "fourth", "fifth", "sixth"];

class GeneralStatistic extends StatefulWidget {
  const GeneralStatistic({Key? key}) : super(key: key);

  @override
  State<GeneralStatistic> createState() => _GeneralStatisticState();
}

class _GeneralStatisticState extends State<GeneralStatistic> {
  late Map<dynamic, dynamic>? series;
  late Map<dynamic, dynamic>? whichWord;
  late Map<dynamic, dynamic>? generalStatistic;
  AutoSizeGroup textGroup = AutoSizeGroup();

  @override
  Widget build(BuildContext context) {
    Future<Map?> getSeries() async {
      await database.ref('series/${userName}').get().then((snapshot) {
        if (snapshot.value == null) {
          return;
        }
        series = snapshot.value as Map;
        return;
      });
      return series;
    }

    Future<Map?> getGeneralStatistic() async {
      await database.ref('users/${userName}').get().then((snapshot) {
        if (snapshot.value == null) {
          return;
        }

        generalStatistic = snapshot.value as Map;
        return;
      });

      return generalStatistic;
    }

    Future<Map?> getWhichWord() async {
      await database.ref('whichWord/${userName}').get().then((snapshot) {
        if (snapshot.value == null) {
          return;
        }

        whichWord = snapshot.value as Map;
        return;
      });
      print("123");
      return whichWord;
    }

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.headline2!,
      textAlign: TextAlign.center,
      child: FutureBuilder<List<Map?>>(
        future: Future.wait([
          getSeries(),
          getGeneralStatistic(),
          getWhichWord(),
        ]),
        builder: (BuildContext context, AsyncSnapshot<List<Map?>> snapshot) {
          late Widget child;
          if (snapshot.hasData) {
            child = mainStatisticPage();
          } else {
            child = Center(
              child: CircularProgressIndicator(),
            );
          }
          return child;
        },
      ),
    );
  }

  Widget mainStatisticPage() {
    return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0))),
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.only(
            top: height * 5,
            bottom: height * 5,
            left: width * 10,
            right: width * 10),
        insetPadding: EdgeInsets.all(0),
        content: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
              padding: EdgeInsets.all(width * 2),
              width: width * 100,
              height: height * 100,
              decoration: BoxDecoration(
                color: green,
                borderRadius: BorderRadius.all(Radius.circular(width * 5)),
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
                  Text(
                    "Tahmin Dağılımı",
                    style:
                        TextStyle(color: colorBlack, fontSize: height * 3.64),
                  ),
                  for (int i = 0; i < 6; i++)
                    LinearPercentIndicator(
                      width: whichWord![keys[i]] /
                              whichWord!.values
                                  .toList()
                                  .reduce((value, element) => value + element) *
                              width *
                              60 +
                          width * 10,
                      animation: true,
                      animationDuration: 1000,
                      lineHeight: height * 3.64,
                      leading: new Text(
                        (i + 1).toString(),
                        style: TextStyle(
                            color: colorBlack, fontSize: height * 3.64),
                      ),
                      percent: 1,
                      center: Text(whichWord![keys[i]].toString(),
                          style: TextStyle(color: white, fontSize: height * 3)),
                      progressColor: Colors.black54,
                      backgroundColor: Colors.transparent,
                    ),
                  Padding(
                    padding: EdgeInsets.only(top: height * 3, bottom: height * 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircularPercentIndicator(
                          animation: true,
                          animationDuration: 1000,
                          radius: 30.0,
                          lineWidth: 5.0,
                          percent: 1,
                          header: Text(
                            "Oynanan",
                            style: TextStyle(
                                color: colorBlack, fontSize: height * 3),
                          ),
                          center: new Text(
                            generalStatistic!["totalGame"].toString(),
                            style: TextStyle(
                                color: colorBlack, fontSize: height * 3),
                          ),
                          backgroundColor: Colors.transparent,
                          progressColor: Colors.black54,
                          circularStrokeCap: CircularStrokeCap.butt,
                        ),
                        CircularPercentIndicator(
                          animation: true,
                          animationDuration: 1000,
                          radius: 30.0,
                          lineWidth: 5.0,
                          percent: generalStatistic!["totalGame"] /
                              100 *
                              generalStatistic!["totalWin"] /
                              10,
                          header: Text(
                            "Kazanılan",
                            style: TextStyle(
                                color: colorBlack, fontSize: height * 3),
                          ),
                          center: new Text(
                            generalStatistic!["totalWin"].toString(),
                            style: TextStyle(
                                color: colorBlack, fontSize: height * 3),
                          ),
                          backgroundColor: Colors.transparent,
                          progressColor: Colors.black54,
                          circularStrokeCap: CircularStrokeCap.butt,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: width * 19,
                        child: AutoSizeText(
                          "Seri",
                          style: TextStyle(
                              color: colorBlack, fontSize: height * 3),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          group: textGroup,
                        ),
                      ),
                      SizedBox(
                        width: width * 19,
                        child: AutoSizeText(
                          "Seri Rekoru",
                          style: TextStyle(
                              color: colorBlack, fontSize: height * 3),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          group: textGroup,
                        ),
                      ),
                      SizedBox(
                        width: width * 19,
                        child: AutoSizeText(
                          "Galibiyet Serisi",
                          style: TextStyle(
                              color: colorBlack, fontSize: height * 3),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          group: textGroup,
                        ),
                      ),
                      SizedBox(
                        width: width * 19,
                        child: AutoSizeText(
                          "Galibiyet Serisi Rekoru",
                          style: TextStyle(
                              color: colorBlack, fontSize: height * 3),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          group: textGroup,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: width * 19,
                        child: AutoSizeText(
                          series!["gameSeries"].toString(),
                          style: TextStyle(
                              color: colorBlack, fontSize: height * 3),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          group: textGroup,
                        ),
                      ),
                      SizedBox(
                        width: width * 19,
                        child: AutoSizeText(
                          series!["seriesRecord"].toString(),
                          style: TextStyle(
                              color: colorBlack, fontSize: height * 3),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          group: textGroup,
                        ),
                      ),
                      SizedBox(
                        width: width * 19,
                        child: AutoSizeText(
                          series!["winSeries"].toString(),
                          style: TextStyle(
                              color: colorBlack, fontSize: height * 3),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          group: textGroup,
                        ),
                      ),
                      SizedBox(
                        width: width * 19,
                        child: AutoSizeText(
                          series!["winSeriesRecord"].toString(),
                          style: TextStyle(
                              color: colorBlack, fontSize: height * 3),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          group: textGroup,
                        ),
                      ),

                    ],
                  ),
                  Text("Ort. Süre",
                    style: TextStyle(
                        color: colorBlack, fontSize: height * 3),),
                  Text(timeFormat((generalStatistic!["totalSeconds"] /generalStatistic!["totalWin"]).round()))
                ],
              ))
        ]));
  }
}
