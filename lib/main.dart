import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:first_project/endgame.dart';
import 'package:first_project/helper.dart';
import 'package:first_project/internetConnectionDialog.dart';
import 'package:first_project/register.dart';
import 'package:first_project/scorePage.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:first_project/new_deneme.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:ntp/ntp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:turkish/turkish.dart';
import 'package:confetti/confetti.dart';
import 'dart:math' as math;
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'generalStatistic.dart';

// TODO: Oyun bitişi animasyonu yap
// TODO: Hakkında penceresi yap
// TODO: Genel istatistik ekle

Color squaresMainColor = Colors.white38;
late SharedPreferences prefs;
String? userName;
String wordOfDay = "-----";
List vibrateController = [];
late double width;
late double height;
String title = 'Daily Word';
bool isFirstBuild = true;
bool? isGameEnd;
bool isAnimationCompleted = true;
late FirebaseDatabase database;
String? lastWordInLocal;
late int totalSeconds;
late int userScore;
late int whichWordUserFound;

/// Ana renkler

List<dynamic> squaresColors = [
  for (int i = 0; i < 6; i++) [for (int a = 0; a < 5; a++) squaresMainColor]
];

const colorBlack = Colors.black;
const green = Color.fromRGBO(106, 170, 100, 1);
const green3 = Color(0xff39FF14);
const green2 = Color(0xff00ff00);
const yellow = Color.fromRGBO(201, 180, 88, 0.8);
const white = Color(0xffF5FFFA);
const grey = Colors.grey;
Map<int, Color> materialColor = {
  50: const Color.fromRGBO(106, 170, 100, .1),
  100: const Color.fromRGBO(106, 170, 100, .2),
  200: const Color.fromRGBO(106, 170, 100, .3),
  300: const Color.fromRGBO(106, 170, 100, .4),
  400: const Color.fromRGBO(106, 170, 100, .5),
  500: const Color.fromRGBO(106, 170, 100, .6),
  600: const Color.fromRGBO(106, 170, 100, .7),
  700: const Color.fromRGBO(106, 170, 100, .8),
  800: const Color.fromRGBO(106, 170, 100, .9),
  900: const Color.fromRGBO(106, 170, 100, 1),
};

Future<void> main() async {
/*  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  prefs = await SharedPreferences.getInstance();

  /// Read word of day from firebase
  DatabaseReference ref = FirebaseDatabase.instance.ref();
  database = FirebaseDatabase.instance;
  // var snapshot = await ref.child('word').get();
  wordOfDay = "burak";

  runApp(Phoenix(child: MyApp()));*/

  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    prefs = await SharedPreferences.getInstance();

    /// Read word of day from firebase
    database = FirebaseDatabase.instance;

    // The following lines are the same as previously explained in "Handling uncaught errors"
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    runApp(Phoenix(child: MyApp()));
  },
      (error, stack) =>
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: MaterialColor(0xFF6aaa64, materialColor),
        ),
        title: title,
        home: Builder(
          builder: (BuildContext context) {
            width = MediaQuery.of(context).size.width / 100;
            double heightWithApp = MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom;
            height = (heightWithApp - heightWithApp * 9.4 / 100) / 100;
            if (height > 6.5) {
              height = height - height * 0.1;
            }
            if (width > 4.5) {
              width = width - width * 0.3;
            }

            return MyHomePage(
              title: title,
            );
          },
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    winController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
      animationBehavior: AnimationBehavior.preserve,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (isFirstBuild) {
        Future.delayed(Duration(milliseconds: 500), () => _afterBuild());
      }
    });
  }

  /// Her bir kutucuğun stringini tanımlıyoruz
  List<dynamic> textBoxes = [
    for (int i = 0; i < 6; i++) [for (int a = 0; a < 5; a++) ""]
  ];

  /// Uygulama build edilirken hangi kutucuk satırında olduğunu tutuan değişken
  int squareRowCount = 0;

  /// Hangi kelimede olduğumuzu tutuyor
  int chosenWord = 0;

  /// Hangi kutucukta oldğumuzu tutuyor
  int chosenLetter = 0;

  /// Kutucukların animasyonunu kontrol eden keylerin bulundugu liste
  List flipKeys = [
    for (int i = 0; i < 6; i++)
      [for (int a = 0; a < 5; a++) GlobalKey<FlipCardState>()]
  ];

  /// Klavye harflerini ve renklerini tutan map
  Map<String, Color> rowLettersMap = {
    "E": grey,
    "R": grey,
    "T": grey,
    "Y": grey,
    "U": grey,
    "I": grey,
    "O": grey,
    "P": grey,
    "Ğ": grey,
    "Ü": grey,
    "A": grey,
    "S": grey,
    "D": grey,
    "F": grey,
    "G": grey,
    "H": grey,
    "J": grey,
    "K": grey,
    "L": grey,
    "Ş": grey,
    "İ": grey,
    "Z": grey,
    "C": grey,
    "V": grey,
    "B": grey,
    "N": grey,
    "M": grey,
    "Ö": grey,
    "Ç": grey,
  };

  bool isWordExist = false;
  bool isAnimationCompleted = true;
  Map<String, int>? newChosenWordColors;
  ConfettiController confettiController = ConfettiController();
  List<String> userWords = [];
  late AnimationController winController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: grey,
                    width: 0.5,
                  ),
                ),
              ),
              height: height * 9.4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: () {},
                    iconSize: height * 5,
                    icon: Icon(
                      Icons.info_outline_rounded,
                      color: Colors.black45,
                    ),
                  ),
                  AutoSizeText(
                    title,
                    style: TextStyle(
                      fontSize: height * 6,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                  ),
                  IconButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const MyAlertDialog(),
                      );
                    },
                    iconSize: height * 6,
                    icon: Icon(
                      Icons.bar_chart,
                      color: Colors.black45,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: height * 5),
              child: Stack(children: [
                createMainSquare(),
                Align(
                  child: AnimatedOpacity(
                    // If the widget is visible, animate to 0.0 (invisible).
                    // If the widget is hidden, animate to 1.0 (fully visible).
                    opacity: isWordExist ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    // The green box must be a child of the AnimatedOpacity widget.
                    child: Padding(
                      padding: EdgeInsets.only(top: height * 29),
                      child: Container(
                        width: width * 75.67,
                        height: height * 10,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'Kelime Listesinde yok',
                          style: TextStyle(
                              fontSize: width * 7, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  child: ConfettiWidget(
                    confettiController: confettiController,
                    maximumSize: Size(height * 3, height * 3),
                    minimumSize: Size(height * 0.5, height * 0.5),
                    blastDirectionality: BlastDirectionality.explosive,
                    particleDrag: 0.09,
                    emissionFrequency: 0.6,
                    numberOfParticles: 2,
                    gravity: 0.02,
                    colors: const [
                      green3,
                      Colors.blue,
                      Colors.pink,
                      Colors.yellow,
                      Colors.purple,
                    ],
                  ),
                ),
                Align(
                  child: Lottie.asset(
                    'assets/win.json',
                    height: height * 50,
                    width: width * 75.67,
                    controller: winController,
                    repeat: false,
                  ),
                ),
              ]),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: height * 1.2, top: height * 3.7),
              child: Column(
                children: [
                  firstRow(),
                  secondRow(),
                  thirdRow(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Ana büyük kutuyu oluşturuyor
  Widget createMainSquare() {
    return Column(
      children: createRows(),
    );
  }

  /// Ana kutunun içerisine 6 tane satır oluşturuyor
  List<Widget> createRows() {
    List<Widget> rows = [];

    for (int i = 0; i < 6; i++) {
      rows.add(Padding(
        padding: EdgeInsets.only(bottom: i != 5 ? height * 0.9 : 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: createLittleSquares(),
        ),
      ));

      squareRowCount += 1;
      if (i == 5) {
        squareRowCount = 0;
      }
    }

    return rows;
  }

  /// Harf girilen Kutucukları oluşturuyor
  List<Widget> createLittleSquares() {
    List<Widget> littleSquares = [];
    choseSquaresColor();
    for (int i = 0; i < 5; i++) {
      var box = Padding(
        padding: EdgeInsets.only(right: i != 20 ? width * 1.2 : 0),
        child: SizedBox(
          width: height * 9,
          height: height * 9,
          child: FlipCard(
            speed: 650,
            key: flipKeys[squareRowCount][i],
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
                style: TextStyle(fontSize: height * 7, color: Colors.black),
                textAlign: TextAlign.center,
              ),
            ),
            back: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: squaresColors[squareRowCount][i],
              ),
              child: Text(
                textBoxes[squareRowCount][i],
                style: TextStyle(fontSize: height * 7, color: Colors.white),
              ),
            ),
          ),
        ),
      );

      littleSquares.add(box);
    }
    return littleSquares;
  }

  /// Klavyenin ilk satırını oluşturuyor
  Widget firstRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...createFirstRowButtons(),
      ],
    );
  }

  /// Klavyenin 2. satırını oluşturuyor
  Widget secondRow() {
    return Padding(
      padding: EdgeInsets.only(
        top: height * 0.7,
        bottom: height * 0.7,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...createSecondRowButtons(),
        ],
      ),
    );
  }

  /// Klavyenin 3. satırını oluşturuyor
  Widget thirdRow() {
    return Padding(
      padding: EdgeInsets.only(
        left: width * 1.1,
        right: width * 1.1,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          enterButton(),
          ...createThirdRowButtons(),
          deleteButton(),
        ],
      ),
    );
  }

  /// Klavye Birinci satırın butonlarını oluşturuyoruz
  List<Widget> createFirstRowButtons() {
    return [
      for (int i = 0; i < 10; i++) ...[
        Padding(
          padding: EdgeInsets.only(right: i != 9 ? width : 0),
          child: SizedBox(
            height: height * 10,
            width: width * 8.9,
            child: ElevatedButton(
                style: ButtonStyle(
                  enableFeedback: false,
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                      rowLettersMap[rowLettersMap.keys.toList()[i]]),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  ),
                ),
                child: Text(
                  rowLettersMap.keys.toList()[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: width * 3.9,
                  ),
                ),
                onPressed: () => letterButtonFunc(i, rowLettersMap)),
          ),
        ),
      ],
    ];
  }

  /// Klavye 2. satırın butonlarını oluşturuyoruz
  List<Widget> createSecondRowButtons() {
    return [
      for (int i = 10; i < 21; i++) ...[
        Padding(
          padding: EdgeInsets.only(right: i != 20 ? width : 0),
          child: SizedBox(
            height: height * 10,
            width: width * 7.6,
            child: ElevatedButton(
                style: ButtonStyle(
                  enableFeedback: false,
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                      rowLettersMap[rowLettersMap.keys.toList()[i]]),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  ),
                ),
                child: Text(
                  rowLettersMap.keys.toList()[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: width * 3.9,
                  ),
                ),
                onPressed: () => letterButtonFunc(i, rowLettersMap)),
          ),
        ),
      ],
    ];
  }

  /// Klavye 3. satırın butonlarını oluşturuyoruz
  List<Widget> createThirdRowButtons() {
    return [
      for (int i = 21; i < 29; i++) ...[
        Padding(
          padding: EdgeInsets.only(right: width),
          child: SizedBox(
            height: height * 10,
            width: width * 7.785,
            child: ElevatedButton(
                style: ButtonStyle(
                  enableFeedback: false,
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(
                      rowLettersMap[rowLettersMap.keys.toList()[i]]),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                  ),
                ),
                child: Text(
                  rowLettersMap.keys.toList()[i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: width * 3.9,
                  ),
                ),
                onPressed: () => letterButtonFunc(i, rowLettersMap)),
          ),
        ),
      ],
    ];
  }

  /// Enter butonu oluşturuyoruz
  Widget enterButton() {
    return Padding(
      padding: EdgeInsets.only(right: width * 1.2),
      child: SizedBox(
        height: height * 10,
        width: width * 14.584,
        child: ElevatedButton(
            style: ButtonStyle(
              enableFeedback: false,
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
              ),
              backgroundColor: MaterialStateProperty.all(grey),
            ),
            onPressed: enterButtonFunc,
            child: Text(
              "ENTER",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: width * 3.9,
              ),
            )),
      ),
    );
  }

  /// Delete buttonu oluşturuyoruz
  Widget deleteButton() {
    return SizedBox(
      height: height * 10,
      width: width * 11.153,
      child: ElevatedButton(
          style: ButtonStyle(
            enableFeedback: false,
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            ),
            backgroundColor: MaterialStateProperty.all(grey),
          ),
          onPressed: deleteButtonFunc,
          child: Icon(Icons.backspace, size: width * 5.5)),
    );
  }

  /// Delete butonu için fonksiyon
  void deleteButtonFunc() {
    if (chosenLetter != 0 && isGameEnd == null && isAnimationCompleted) {
      setState(() {
        chosenLetter -= 1;
        textBoxes[chosenWord][chosenLetter] = "";
      });
    }
  }

  /// Enter butonuna basıldığında çalışacak fonksiyon
  Future<void> enterButtonFunc() async {
    showDialog(
      context: context,
      builder: (context) => const GeneralStatistic(),
    );
    if (isGameEnd == null &&
        isAnimationCompleted &&
        chosenLetter % 5 == 0 &&
        chosenLetter != 0) {
      bool isConnected = await checkInternet();
      if (!isConnected) {
        showDialog(context: context, builder: (context) => ConnectionDialog());
        return;
      }
      if (chosenWord == 0) {
        try {
          var now = await NTP.now();
          prefs.setString('startTime', now.toString());
        } catch (e) {
          return;
        }
      }

      String wordOfUser = "";
      textBoxes[chosenWord].forEach((letter) {
        wordOfUser += turkish.toLowerCase(letter);
      });

      if (!words.contains(wordOfUser)) {
        setState(() {
          isWordExist = true;
        });
        Future.delayed(const Duration(seconds: 1)).then((_) {
          setState(() {
            isWordExist = false;
          });
        });
      } else {
        isAnimationCompleted = false;
        userWords.add(turkish.toUpperCase(wordOfUser));
        prefs.setStringList('userWords', userWords);

        for (int i = 0; i < 5; i++) {
          setState(() {
            flipKeys[chosenWord][i].currentState.toggleCard();
          });
          await Future.delayed(const Duration(milliseconds: 200));
        }
        await Future.delayed(const Duration(milliseconds: 300));
        setState(() {
          choseButtonsColor();
        });

        if (wordOfUser == wordOfDay) {
          _gameEnd(true);
        } else if ((wordOfUser != wordOfDay) && (chosenWord == 5)) {
          _gameEnd(false);
        } else {
          chosenLetter = 0;
          chosenWord += 1;
        }
        isAnimationCompleted = true;
      }
    }
  }

  /// Harf butunlarına basınca gerçeklleşek işlemler
  void letterButtonFunc(int i, Map<String, Color> rowLettersMap) {
    if (chosenLetter < 5 && isGameEnd == null && isAnimationCompleted) {
      setState(() {
        textBoxes[chosenWord][chosenLetter] = rowLettersMap.keys.toList()[i];
        chosenLetter += 1;
      });
    }
  }

  /// Kutucukların rengini kontrol eden fonksiyon
  void choseSquaresColor() {
    for (int i = 0; i < 5; i++) {
      if (i == 0) {
        newChosenWordColors = {for (int i = 0; i < 5; i++) wordOfDay[i]: 0};
      }
      String chosenLetter = turkish.toLowerCase(textBoxes[squareRowCount][i]);
      String wordOfUser = turkish.toLowerCase(textBoxes[squareRowCount].join());

      if (chosenLetter == wordOfDay[i]) {
        newChosenWordColors![chosenLetter] =
            newChosenWordColors![chosenLetter]! + 1;
        squaresColors[squareRowCount][i] = green;
      } else if (isYellow(wordOfUser, chosenLetter)) {
        newChosenWordColors![chosenLetter] =
            newChosenWordColors![chosenLetter]! + 1;
        squaresColors[squareRowCount][i] = yellow;
      } else {
        squaresColors[squareRowCount][i] = Colors.black54;
      }
    }
  }

  void choseButtonsColor() {
    newChosenWordColors = {for (int i = 0; i < 5; i++) wordOfDay[i]: 0};

    String wordOfUser = turkish.toLowerCase(textBoxes[chosenWord].join());

    for (int i = 0; i < 5; i++) {
      String chosenLetter = turkish.toLowerCase(textBoxes[chosenWord][i]);

      if (rowLettersMap[turkish.toUpperCase(chosenLetter)] != green) {
        if (chosenLetter == wordOfDay[i]) {
          newChosenWordColors![chosenLetter] =
              newChosenWordColors![chosenLetter]! + 1;

          rowLettersMap[turkish.toUpperCase(chosenLetter)] = green;
        } else if (isYellow(wordOfUser, chosenLetter)) {
          newChosenWordColors![chosenLetter] =
              newChosenWordColors![chosenLetter]! + 1;
          rowLettersMap[turkish.toUpperCase(chosenLetter)] = yellow;
        } else {
          if (rowLettersMap[turkish.toUpperCase(chosenLetter)] == grey) {
            rowLettersMap[turkish.toUpperCase(chosenLetter)] = Colors.black45;
          }
        }
      }
    }
  }

  /// Girilen harfin renginin sarı olup olmayacağını kontrol ediyor
  bool isYellow(String wordOfUser, String chosenLetter) {
    if (wordOfUser.length != 5) {
      return false;
    }

    List<int> allIndexes = [];
    int startIndex = 0;
    Iterable allMatches = chosenLetter.allMatches(wordOfUser);
    for (int i = 0; i < allMatches.length ; i ++) {
      int index = wordOfUser.indexOf(chosenLetter, startIndex);
      allIndexes.add(index);
      startIndex = index + 1;
    }

    List<bool> isThereGreen = [for (int i = 0; i < allIndexes.length; i ++) wordOfUser[allIndexes[i]] == wordOfDay[allIndexes[i]]];

    if (wordOfDay.contains(chosenLetter) &&
        newChosenWordColors![chosenLetter]! <
            chosenLetter.allMatches(wordOfDay).length && !isThereGreen.contains(true)) {
      return true;
    }
    return false;
  }

  /// Win ve Lose ekranının gösterilmesi
  showDataAlert(bool isWon) {
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: AlertDialog(
                contentPadding: EdgeInsets.all(0),
                insetPadding: EdgeInsets.zero,
                backgroundColor: Colors.transparent,
                content: finalColumn(isWon)),
          );
        }));
  }

  /// Win ve Lose ekranının içeriği
  Widget finalColumn(bool isWon) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            !isWon
                ? Colors.red.withOpacity(0.5)
                : Colors.green.withOpacity(0.5),
            Colors.white.withOpacity(0.1),
          ],
        ),
      ),
      width: width * 100,
      height: height * 125,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          isWon
              ? AnimatedTextKit(
                  animatedTexts: [
                    ScaleAnimatedText(
                      'Tebrikler !',
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: width * 16,
                      ),
                      duration: Duration(seconds: 4),
                    ),
                  ],
                  totalRepeatCount: 1,
                  onFinished: () {},
                  isRepeatingAnimation: false,
                  repeatForever: false,
                )
              : ShowUp(
                  delay: 3,
                  milliseconds: 1000,
                  child: Container(
                    width: width * 75.67,
                    height: height * 10,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      turkish.toUpperCase(wordOfDay),
                      style: TextStyle(
                        fontSize: width * 16,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
          if (isWon)
            ConfettiWidget(
              confettiController: confettiController,
              maximumSize: Size(height * 3, height * 3),
              minimumSize: Size(height * 0.5, height * 0.5),
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.04,
              emissionFrequency: 0.6,
              numberOfParticles: 2,
              gravity: 0.08,
              colors: const [
                green3,
                Colors.blue,
                Colors.pink,
                Colors.yellow,
                Colors.purple,
              ],
            ),
          Padding(
            padding: EdgeInsets.only(top: height * 44, bottom: height * 6),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: Transform.rotate(
                      angle: 180 * pi / 180,
                      child: Icon(
                        Icons.exit_to_app_rounded,
                        size: width * 10,
                      )),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(green3),
                    fixedSize: MaterialStateProperty.all(
                      Size(width * 20, width * 15),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    prefs.remove('isGameEnd');
                    prefs.remove('userWords');
                    prefs.remove('isWin');
                    isFirstBuild = true;
                    Phoenix.rebirth(context);
                  },
                  child: Icon(Icons.refresh, size: width * 10),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(green3),
                    fixedSize: MaterialStateProperty.all(
                      Size(width * 20, width * 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _afterBuild() async {
    /// checks internet connection
    bool isConnected = await checkInternet();
    if (!isConnected) {
      _showInternetAlert();
      return;
    }
    var snapshot = await database.ref('word/word').get();
    wordOfDay = snapshot.value.toString();
    String? lastWordInLocal = prefs.getString('lastWordInLocal');
    userName = prefs.getString('userName');
    if (userName == null) {
      _registerScreen();
    }
    if (lastWordInLocal != wordOfDay) {
      _startNewGame();
      prefs.setString('lastWordInLocal', wordOfDay);
    }

    database.ref('word').onChildChanged.listen((event) {
      isFirstBuild = true;
      if (mounted) {
        _showTimeIsUpAlert();
      }
    });

    List<String> userSavedWords = prefs.getStringList('userWords') ?? [];
    isGameEnd = prefs.getBool('isGameEnd');
    if (userSavedWords.length != 0) {
      for (int i = 0; i < userSavedWords.length; i++) {
        for (int j = 0; j < 5; j++) {
          textBoxes[i][j] = userSavedWords[i][j];
        }
      }

      setState(() {
        for (int a = 0; a < userSavedWords.length; a++) {
          for (int i = 0; i < 5; i++) {
            flipKeys[a][i].currentState.toggleCard();
          }
        }
      });
      await Future.delayed(const Duration(milliseconds: 400));
      setState(() {
        for (int a = 0; a < userSavedWords.length; a++) {
          choseButtonsColor();
          chosenWord += 1;
        }
      });
    }
    await Future.delayed(const Duration(milliseconds: 400));
    if (isGameEnd != null) {
      totalSeconds = prefs.getInt('totalSeconds')!;
      userScore = prefs.getInt('userScore')!;
      whichWordUserFound = prefs.getInt('whichWordUserFound')!;
      bool? isWin = prefs.getBool('isWin');
      if (isWin!) {
        confettiController.play();
        await _controlThwWinAnimation();
        confettiController.stop();
        _goEndPage();
/*        await Future.delayed(const Duration(seconds: 1));
        confettiController.play();
        await Future.delayed(const Duration(seconds: 3));
        confettiController.stop();*/
      } else {
        _goEndPage();
      }
    }

    isFirstBuild = false;
  }

  void _goEndPage() {
    showDialog(context: context, builder: (context) => EndGame());
  }

  Future<void> _gameEnd(bool isWon) async {
    if (isWon) {
      await _controlThwWinAnimation();
      await _updateDatabase(true);
      prefs.setBool('isGameEnd', true);
      prefs.setBool('isWin', true);
      isGameEnd = true;
      _goEndPage();
/*      await Future.delayed(const Duration(seconds: 1));
      confettiController.play();
      await Future.delayed(const Duration(seconds: 3));
      confettiController.stop();*/
    } else {
      await _updateDatabase(false);
      prefs.setBool('isGameEnd', true);
      prefs.setBool('isWin', false);
      _goEndPage();
    }
  }

  _registerScreen() {
    showDialog(context: context, builder: (context) => AddPlayer());
  }

  void _startNewGame() {
    prefs.remove('isGameEnd');
    prefs.remove('userWords');
    prefs.remove('isWin');
  }

  Future<void> _updateDatabase(bool isWon) async {
    late int seconds;
    int dayScore = 0;
    whichWordUserFound = chosenWord;
    prefs.setInt('whichWordUserFound', whichWordUserFound);

    /// Calculate finish time
    try {
      DateTime now = await NTP.now();
      String? startTime = await prefs.getString('startTime');
      seconds = await now.difference(DateTime.parse(startTime!)).inSeconds;
      totalSeconds = seconds;
      await prefs.setInt("totalSeconds", seconds);
    } catch (e) {
      throw e;
    }

    /// Choose the day score
    if (isWon) {
      switch (chosenWord) {
        case 0:
          dayScore += 10;
          break;
        case 1:
          dayScore += 7;
          break;
        case 2:
          dayScore += 6;
          break;
        case 3:
          dayScore += 5;
          break;
        case 4:
          dayScore += 4;
          break;
        case 5:
          dayScore += 3;
          break;
      }
    }
    userScore = dayScore;
    prefs.setInt("userScore", dayScore);

    String? userName = prefs.getString('userName');

    /// Update user's general info
    database.ref('users/$userName').once().then((event) {
      Map<dynamic, dynamic> user = event.snapshot.value as Map;
      int totalGame = user['totalGame'] as int;
      int totalWin = user['totalWin'] as int;
      int score = user['score'] as int;
      int totalSeconds = user['totalSeconds'] as int;
      if (isWon) {
        totalWin += 1;
      }

      totalGame += 1;
      totalSeconds += seconds;

      database.ref('users/$userName').update({
        'totalGame': totalGame,
        'totalWin': totalWin,
        'score': score + dayScore,
        'totalSeconds': totalSeconds,
      });
    });

    /// Update user's series
    database.ref('series/$userName').once().then((event) {
      Map<dynamic, dynamic> series = event.snapshot.value as Map;
      int gameSeries = series['gameSeries'] as int;
      int winSeries = series['winSeries'] as int;
      int seriesRecord = series['seriesRecord'] as int;
      int winSeriesRecord = series['winSeriesRecord'] as int;

      if (isWon) {
        winSeries += 1;
        gameSeries += 1;
      }

      if (gameSeries > seriesRecord) {
        seriesRecord = gameSeries;
      }

      if (winSeries > winSeriesRecord) {
        winSeriesRecord = winSeries;
      }

      if (!isWon) {
        winSeries = 0;
      }

      database.ref('series/$userName').update({
        'gameSeries': gameSeries,
        'winSeries': winSeries,
        'seriesRecord': seriesRecord,
        'winSeriesRecord': winSeriesRecord,
      });
    });

    /// Set isSeries to true
    database.ref('isSeries/$userName').set(true);

    /// Update dailyRank

    database.ref('dailyRank/$userName').set({
      'score': dayScore,
      'seconds': seconds,
    });

    /// Update user total win row

    if (isWon) {
      database.ref('whichWord/$userName').once().then((event) {
        late String key;
        switch (chosenWord) {
          case 0:
            key = 'first';
            break;
          case 1:
            key = 'second';
            break;
          case 2:
            key = 'third';
            break;
          case 3:
            key = 'fourth';
            break;
          case 4:
            key = 'fifth';
            break;
          case 5:
            key = 'sixth';
            break;
        }
        Map<dynamic, dynamic> whichWord = event.snapshot.value as Map;
        int word = whichWord[key] as int;

        database.ref('whichWord/$userName').update({
          key: word + 1,
        });
      });
    }

    /// Update weeklyRank
    database.ref('weeklyRank/$userName').once().then((event) {
      int score = 0;
      int seconds = 0;
      int totalGame = 0;
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic> weeklyRank = event.snapshot.value as Map;
        score = weeklyRank['score'] as int;
        seconds = weeklyRank['totalSeconds'] as int;
        totalGame = weeklyRank['totalGame'] as int;
      }

      database.ref('weeklyRank/$userName').set({
        'score': score + dayScore,
        'totalSeconds': totalSeconds + seconds,
        'totalGame': totalGame + 1,
      });
    });

    return;
  }

  void _showTimeIsUpAlert() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0))),
            contentPadding: EdgeInsets.only(
                top: height * 5,
                bottom: height * 5,
                left: width * 10,
                right: width * 10),
            insetPadding: EdgeInsets.all(0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(bottom: height * 2, top: height * 2),
                  height: height * 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: green,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Süre Doldu!",
                          style:
                              TextStyle(fontSize: height * 4.86, color: white),
                          textAlign: TextAlign.center),
                      Text("Yeni kelimeyle oyuna devam edebilirsiniz.",
                          style:
                              TextStyle(fontSize: height * 3.64, color: white),
                          textAlign: TextAlign.center),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              Phoenix.rebirth(context);
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(white),
                          ),
                          child: Text("Tamam",
                              style: TextStyle(
                                  fontSize: height * 3.64, color: green)))
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

  Future<void> _controlThwWinAnimation() async {
    winController.forward();
    await Future.delayed(Duration(milliseconds: 1500), () {
      winController.reverse();
    });
    await Future.delayed(Duration(milliseconds: 1500), () {
      winController.dispose();
    });
  }

  void _showInternetAlert() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        bool showAnimation = false;
        return WillPopScope(
          onWillPop: () async => false,
          child: StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(0))),
              contentPadding: EdgeInsets.only(
                  top: height * 5,
                  bottom: height * 5,
                  left: width * 10,
                  right: width * 10),
              insetPadding: EdgeInsets.all(0),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding:
                        EdgeInsets.only(bottom: height * 4, top: height * 4),
                    height: height * 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: green,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Lütfen internet bağlantınızı kontrol ediniz.",
                            style: TextStyle(
                                fontSize: height * 3.64, color: white),
                            textAlign: TextAlign.center),
                        showAnimation
                            ? Padding(
                                padding: EdgeInsets.only(bottom: height),
                                child: LoadingAnimationWidget.inkDrop(
                                  color: white,
                                  size: height * 5,
                                ),
                              )
                            : Container(
                                height: height * 7,
                                child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        showAnimation = true;
                                        checkInternet().then((internet) {
                                          if (internet) {
                                            setState(() {
                                              Navigator.pop(context);
                                              _afterBuild();
                                            });
                                          } else {
                                            setState(() {
                                              showAnimation = false;
                                            });
                                          }
                                        });
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: white,
                                    ),
                                    child: Text("Tekrar Dene",
                                        style: TextStyle(
                                            fontSize: height * 3.64,
                                            color: green))),
                              )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

const starPoints = 5;

class StarClipper extends CustomClipper<Path> {
  // use : StarClipper().getClip
  @override
  Path getClip(Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;

    var path = Path();

    var radius = size.width / 2;
    var inner = radius / 2;
    var rotation = math.pi / 2 * 3;
    var step = math.pi / starPoints;

    path.lineTo(centerX, centerY - radius);

    for (var i = 0; i < starPoints; i++) {
      var x = centerX + math.cos(rotation) * radius;
      var y = centerY + math.sin(rotation) * radius;
      path.lineTo(x, y);
      rotation += step;

      x = centerX + math.cos(rotation) * inner;
      y = centerY + math.sin(rotation) * inner;
      path.lineTo(x, y);
      rotation += step;
    }

    path.lineTo(centerX, centerY - radius);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ShowUp extends StatefulWidget {
  final Widget child;
  final int delay;
  final int milliseconds;

  ShowUp(
      {required this.child, required this.delay, required this.milliseconds});

  @override
  _ShowUpState createState() => _ShowUpState();
}

class _ShowUpState extends State<ShowUp> with TickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<Offset> _animOffset;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
        vsync: this, duration: Duration(milliseconds: widget.milliseconds));
    final curve =
        CurvedAnimation(curve: Curves.decelerate, parent: _animController);
    _animOffset =
        Tween<Offset>(begin: const Offset(0.0, 0.35), end: Offset.zero)
            .animate(curve);

    if (widget.delay.isNaN) {
      _animController.forward();
    } else {
      Timer(Duration(milliseconds: widget.delay), () {
        _animController.forward();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _animController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      child: SlideTransition(
        position: _animOffset,
        child: widget.child,
      ),
      scale: _animController,
    );
  }
}
