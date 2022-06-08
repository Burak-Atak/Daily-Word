import 'package:auto_size_text/auto_size_text.dart';
import 'package:first_project/helper.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'main.dart';

List<String> keys = ["first", "second", "third", "fourth", "fifth", "sixth"];

class GeneralStatistic extends StatefulWidget {
  const GeneralStatistic({Key? key}) : super(key: key);

  @override
  State<GeneralStatistic> createState() => _GeneralStatisticState();
}

class _GeneralStatisticState extends State<GeneralStatistic>
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
  }

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
            height: height * 8,
            decoration: BoxDecoration(
              color: green,
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
                SizedBox(
                  width: width * 60,
                  child: AutoSizeText("İstatistik",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: colorBlack,
                          fontSize: height * 4,
                          fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  width: width * 10,
                  child: IconButton(
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    icon: Icon(
                      Icons.cancel_rounded,
                      shadows: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.7),
                          blurRadius: 25,
                          spreadRadius: 1,
                        ),
                      ],
                      color: colorBlack,
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
              padding: EdgeInsets.all(width * 2),
              width: width * 100,
              height: height * 90,
              decoration: BoxDecoration(
                color: Color(0xffbbe7bb),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.zero,
                  topRight: Radius.zero,
                  bottomLeft: Radius.circular(width * 5),
                  bottomRight: Radius.circular(width * 5),
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
                  Padding(
                    padding: EdgeInsets.only(bottom: height * 0.8),
                    child: Text(
                      "Tahmin Dağılımı",
                      style:
                          TextStyle(color: colorBlack, fontSize: height * 3.64),
                    ),
                  ),
                  for (int i = 0; i < 6; i++)
                    Padding(
                      padding: EdgeInsets.only(bottom: height * 0.8),
                      child: LinearPercentIndicator(
                        width: whichWord![keys[i]] /
                                whichWord!.values.toList().reduce(
                                    (value, element) => value + element) *
                                width *
                                60 +
                            width * 10,
                        animation: true,
                        animationDuration: 1000,
                        lineHeight: height * 3.5,
                        leading: Text(
                          (i + 1).toString(),
                          style: TextStyle(
                              color: colorBlack, fontSize: height * 3),
                        ),
                        percent: 1,
                        center: Text(
                          whichWord![keys[i]].toString(),
                          style: TextStyle(color: white, fontSize: height * 3),
                          textAlign: TextAlign.center,
                        ),
                        progressColor: green,
                        backgroundColor: Colors.transparent,
                      ),
                    ),
                  Text(
                    "Ortalama Süre",
                    style: TextStyle(color: colorBlack, fontSize: height * 3),
                  ),
                  Text(timeFormat((generalStatistic!["totalSeconds"] /
                          generalStatistic!["totalWin"])
                      .round())),
                  Padding(
                    padding:
                        EdgeInsets.only(top: height * 3, bottom: height * 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: width * 38,
                          child: CircularPercentIndicator(
                            animation: true,
                            animationDuration: 1000,
                            radius: 25.0,
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
                            backgroundColor: Colors.white.withOpacity(0.4),
                            progressColor: green,
                            circularStrokeCap: CircularStrokeCap.butt,
                          ),
                        ),
                        SizedBox(
                          width: width * 38,
                          child: CircularPercentIndicator(
                            animation: true,
                            animationDuration: 1000,
                            radius: 25.0,
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
                            backgroundColor: Colors.white.withOpacity(0.4),
                            progressColor: green,
                            circularStrokeCap: CircularStrokeCap.butt,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: height * 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Stack(children: [
                          Padding(
                            padding:
                                EdgeInsets.only(left: width * 10),
                            child: Lottie.asset('assets/fire.json',
                                height: height * 13,
                                width: height * 13,
                                controller: seriesController,
                                onLoaded: (composition) {
                              // Configure the AnimationController with the duration of the
                              // Lottie file and start the animation.
                              seriesController.. repeat().. forward();
                            }),
                          ),
                          SizedBox(
                            width: width * 38,
                            child: CircularPercentIndicator(
                              animation: true,
                              animationDuration: 1000,
                              radius: 25.0,
                              lineWidth: 5.0,
                              percent: series!["seriesRecord"] /
                                  100 *
                                  series!["gameSeries"] /
                                  10,
                              header: Text(
                                "Seri",
                                style: TextStyle(
                                    color: colorBlack, fontSize: height * 3),
                              ),
                              center: new Text(
                                series!["gameSeries"].toString(),
                                style: TextStyle(
                                    color: colorBlack, fontSize: height * 3),
                              ),
                              backgroundColor: Colors.white.withOpacity(0.4),
                              progressColor: green,
                              circularStrokeCap: CircularStrokeCap.butt,
                            ),
                          ),
                        ]),
                        SizedBox(
                          width: width * 38,
                          child: CircularPercentIndicator(
                            animation: true,
                            animationDuration: 1000,
                            radius: 25.0,
                            lineWidth: 5.0,
                            percent: 1,
                            header: Text(
                              "Seri Rekoru",
                              style: TextStyle(
                                  color: colorBlack, fontSize: height * 3),
                            ),
                            center: new Text(
                              series!["seriesRecord"].toString(),
                              style: TextStyle(
                                  color: colorBlack, fontSize: height * 3),
                            ),
                            backgroundColor: Colors.white.withOpacity(0.4),
                            progressColor: green,
                            circularStrokeCap: CircularStrokeCap.butt,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: width * 38,
                        child: CircularPercentIndicator(
                          animation: true,
                          animationDuration: 1000,
                          radius: 25.0,
                          lineWidth: 5.0,
                          percent: series!["winSeriesRecord"] /
                              100 *
                              series!["winSeries"] /
                              10,
                          header: Text(
                            "Galibiyet Serisi",
                            style: TextStyle(
                                color: colorBlack, fontSize: height * 3),
                          ),
                          center: new Text(
                            series!["winSeries"].toString(),
                            style: TextStyle(
                                color: colorBlack, fontSize: height * 3),
                          ),
                          backgroundColor: Colors.white.withOpacity(0.4),
                          progressColor: green,
                          circularStrokeCap: CircularStrokeCap.butt,
                        ),
                      ),
                      SizedBox(
                        width: width * 38,
                        child: CircularPercentIndicator(
                          animation: true,
                          animationDuration: 1000,
                          radius: 25.0,
                          lineWidth: 5.0,
                          percent: 1,
                          header: Text(
                            "Galibiyet S. Rekoru",
                            style: TextStyle(
                                color: colorBlack, fontSize: height * 3),
                          ),
                          center: new Text(
                            series!["winSeriesRecord"].toString(),
                            style: TextStyle(
                                color: colorBlack, fontSize: height * 3),
                          ),
                          backgroundColor: Colors.white.withOpacity(0.4),
                          progressColor: green,
                          circularStrokeCap: CircularStrokeCap.butt,
                        ),
                      ),
                    ],
                  ),
                ],
              ))
        ]));
  }
}
