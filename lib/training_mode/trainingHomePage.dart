import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:first_project/homePage/homePage.dart';
import 'package:first_project/new_deneme.dart';
import 'package:first_project/training_mode/trainingWordsList.dart';
import 'package:first_project/training_mode/training_controller.dart';
import 'package:first_project/training_mode/training_endgame.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'dart:math';
import 'package:turkish/turkish.dart';
import 'package:confetti/confetti.dart';
import '../design.dart';
import 'package:get/get.dart';
import '../main.dart';

// TODO: oyun sonudna çarpıyı köşeye al
// TODO: Paylaşı storede yayınlandıktan sonra düzenle
// TODO: kÜFÜR FİLTRESİ
// TODO: Kelime çıkma süresini netten çek
// TODO: KullANNIcı kaydolurken aynı isim varsa çıkan dialogu sil

String wordOfDayTraining = "-----";
bool trainingIsBack = false;
List vibrateController = [];
String title = 'Antrenman Modu';
bool trainingIsFirstBuild = true;
bool isFirstBuildCompleted = false;
bool? trainingIsGameEnd;
String? lastWordInLocal;
late int totalSeconds;
late int userScore;
late int whichWordUserFound;
late var trainingController;
late var lastSquaresColors;

/// Uygulama build edilirken hangi kutucuk satırında olduğunu tutuan değişken
int trainingSquareRowCount = 0;

/// Hangi kelimede olduğumuzu tutuyor
int trainingChosenWord = 0;

/// Hangi kutucukta oldğumuzu tutuyor
int trainingChosenLetter = 0;
List<String> trainingUserWords = [];

class TrainingPage extends StatefulWidget {

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    trainingController.initAnimationController();
    winController = trainingController.winController;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (trainingIsBack) {
        List<String> userSavedWords =
            prefs.getStringList('trainingUserWords') ?? [];
        for (int i = 0; i < userSavedWords.length; i++) {
          for (int j = 0; j < 5; j++) {
            flipKeys[i][j].value.currentState.toggleCard();
          }
        }

        if (trainingIsGameEnd == true) {
          await Future.delayed(Duration(milliseconds: 600));
          _goEndPage();
        }
      }

      if (trainingIsFirstBuild) {
        _afterBuild();
      }
    });
  }

  /// Her bir kutucuğun stringini tanımlıyoruz
  List<List<RxString>> textBoxes = trainingController.textBoxes;


  /// Kutucukların animasyonunu kontrol eden keylerin bulundugu liste
  List flipKeys = trainingController.flipKeys;

  /// Klavye harflerini ve renklerini tutan map
  Map<String, dynamic> rowLettersMap = trainingController.rowLettersMap;
  List squaresColors = trainingController.squaresColors;

  RxBool isWordExist = trainingController.isWordExist;
  bool isAnimationCompleted = true;
  Map<String, int>? trainingNewChosenWordColors;
  late Map<String, bool> trainingMapOfSetUserWord;
  ConfettiController trainingConfettiController = ConfettiController();

  late var winController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(left: width, right: width),
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
                  SizedBox(
                    width: width * 25,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          if (isAnimationCompleted && isFirstBuildCompleted) {
                            Navigator.pop(context);
                          }
                        },
                        customBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            height * 2,
                          ),
                        ),
                        child: SizedBox(
                          height: height * 5,
                          width: height * 5,
                          child: Icon(
                            Icons.home_rounded,
                            color: Colors.black45,
                            size: height * 4,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 5.5,
                    width: width * 44,
                    child: Align(
                      child: AutoSizeText(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: height * 5.5,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * 25,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: height * 5),
              child: Stack(children: [
                createMainSquare(),
                Align(
                  child: Obx(
                    () => AnimatedOpacity(
                      // If the widget is visible, animate to 0.0 (invisible).
                      // If the widget is hidden, animate to 1.0 (fully visible).
                      opacity: isWordExist.value ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 500),
                      // The green box must be a child of the AnimatedOpacity widget.
                      child: Padding(
                        padding: EdgeInsets.only(top: height * 25),
                        child: Container(
                          width: width * 60,
                          height: height * 8,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: AutoSizeText(
                            'Kelime listesinde yok.',
                            maxLines: 1,
                            style: TextStyle(
                                fontSize: height * 3.64, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  child: Obx(
                    () => Lottie.asset(
                      'assets/win.json',
                      height: height * 50,
                      width: width * 75.67,
                      controller: winController.value,
                      repeat: false,
                    ),
                  ),
                ),
              ]),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: height * 1.2, top: height * 2.7),
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

  /// Harf girilen Kutucukları oluşturuyor
  Widget createMainSquare() {
    Widget littleSquares = GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          childAspectRatio: 1,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        padding: paddingForSquare,
        itemCount: 30,
        itemBuilder: (BuildContext context, int index) {
          return FlipCard(
            speed: 650,
            key: flipKeys[index ~/ 5][index % 5].value,
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
                child: Obx(
                  () => Text(
                    textBoxes[index ~/ 5][index % 5].value,
                    style: TextStyle(fontSize: height * 7, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                )),
            back: Obx(
              () => Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: squaresColors[index ~/ 5][index % 5].value,
                ),
                child: Obx(
                  () => Text(
                    textBoxes[index ~/ 5][index % 5].value,
                    style: TextStyle(fontSize: height * 7, color: Colors.white),
                  ),
                ),
              ),
            ),
          );
        });

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
            child: Obx(
              () => ElevatedButton(
                  style: ButtonStyle(
                    enableFeedback: false,
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                        rowLettersMap[rowLettersMap.keys.toList()[i]]!.value),
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
                  onPressed: () => letterButtonFunc(i)),
            ),
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
            child: Obx(
              () => ElevatedButton(
                  style: ButtonStyle(
                    enableFeedback: false,
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                        rowLettersMap[rowLettersMap.keys.toList()[i]]!.value),
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
                  onPressed: () => letterButtonFunc(i)),
            ),
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
            child: Obx(
              () => ElevatedButton(
                  style: ButtonStyle(
                    enableFeedback: false,
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                        rowLettersMap[rowLettersMap.keys.toList()[i]]!.value),
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
                  onPressed: () => letterButtonFunc(
                        i,
                      )),
            ),
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
        child: TapDebouncer(
            onTap: () async => await enterButtonFunc(),
            cooldown: const Duration(milliseconds: 200),
            builder: (BuildContext context, TapDebouncerFunc? onTap) {
              return ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.white),
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
                  onPressed: onTap,
                  child: Text(
                    "ENTER",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width * 3.9,
                    ),
                  ));
            }),
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
    if (trainingChosenLetter != 0 && trainingIsGameEnd == null && isAnimationCompleted) {
      trainingChosenLetter -= 1;
      trainingController.setLetter(trainingChosenWord, trainingChosenLetter, "");
    }
  }

  /// Enter butonuna basıldığında çalışacak fonksiyon
  Future<bool> enterButtonFunc() async {
    if (trainingIsGameEnd == null &&
        isAnimationCompleted &&
        trainingChosenLetter % 5 == 0 &&
        trainingChosenLetter != 0) {
      String wordOfUser = "";
      textBoxes[trainingChosenWord].forEach((letter) {
        wordOfUser += turkish.toLowerCase(letter.value);
      });

      if (!words.contains(wordOfUser)) {
        trainingController.changeIsWordExist(true);

        Future.delayed(const Duration(seconds: 1)).then((_) {
          trainingController.changeIsWordExist(false);
        });

        return false;
      } else {
        isAnimationCompleted = false;
        if (trainingChosenWord == 0) {
          try {
            var now = DateTime.now();
            prefs.setString('trainingStartTime', now.toString());
          } catch (e) {
            isAnimationCompleted = true;
            return false;
          }
        }

        trainingUserWords.add(turkish.toUpperCase(wordOfUser));
        prefs.setStringList('trainingUserWords', trainingUserWords);
        await choseSquaresColor();
        for (int i = 0; i < 5; i++) {
          trainingController.flipCard(trainingChosenWord, i);
          await Future.delayed(const Duration(milliseconds: 200));
        }
        await Future.delayed(const Duration(milliseconds: 300));

        await choseButtonsColor();
        if (wordOfUser == wordOfDayTraining) {
          _gameEnd(true);
        } else if ((wordOfUser != wordOfDayTraining) && (trainingChosenWord == 5)) {
          _gameEnd(false);
        } else {
          trainingChosenLetter = 0;
          trainingChosenWord += 1;
          trainingSquareRowCount += 1;
        }
        isAnimationCompleted = true;
        return true;
      }
    } else {
      return true;
    }
  }

  /// Harf butunlarına basınca gerçeklleşek işlemler
  void letterButtonFunc(int i) {
    if (trainingChosenLetter < 5 &&
        trainingIsGameEnd == null &&
        isAnimationCompleted &&
        isFirstBuildCompleted) {
      trainingController.setLetter(
          trainingChosenWord, trainingChosenLetter, rowLettersMap.keys.toList()[i]);
      trainingChosenLetter += 1;
    }
  }

  /// Kutucukların rengini kontrol eden fonksiyon
  Future<void> choseSquaresColor() async {
    for (int i = 0; i < 5; i++) {
      if (i == 0) {
        trainingNewChosenWordColors = {for (int i = 0; i < 5; i++) wordOfDayTraining[i]: 0};
        List<RxString> setUserWord = {...textBoxes[trainingSquareRowCount]}.toList();
        trainingMapOfSetUserWord = {
          for (int i = 0; i < setUserWord.length; i++)
            turkish.toLowerCase(setUserWord[i].value): false
        };
      }
      String chosenLetter =
          turkish.toLowerCase(textBoxes[trainingSquareRowCount][i].value);
      String wordOfUser = turkish.toLowerCase(textBoxes[trainingSquareRowCount].join());

      if (chosenLetter == wordOfDayTraining[i]) {
        trainingNewChosenWordColors![chosenLetter] =
            trainingNewChosenWordColors![chosenLetter]! + 1;
        trainingController.setColorForSquare(trainingSquareRowCount, i, green);
      } else if (isYellow(wordOfUser, chosenLetter, i, true)) {
        trainingNewChosenWordColors![chosenLetter] =
            trainingNewChosenWordColors![chosenLetter]! + 1;
        trainingController.setColorForSquare(trainingSquareRowCount, i, yellow);
      } else {
        trainingController.setColorForSquare(trainingSquareRowCount, i, Colors.black54);
      }
    }
  }

  Future<void> choseButtonsColor() async {
    trainingNewChosenWordColors = {for (int i = 0; i < 5; i++) wordOfDayTraining[i]: 0};

    String wordOfUser = turkish.toLowerCase(textBoxes[trainingChosenWord].join());

    for (int i = 0; i < 5; i++) {
      String chosenLetter = turkish.toLowerCase(textBoxes[trainingChosenWord][i].value);
      String upperChosenLetter = turkish.toUpperCase(chosenLetter);

      if (rowLettersMap[upperChosenLetter] != green) {
        if (chosenLetter == wordOfDayTraining[i]) {
          trainingNewChosenWordColors![chosenLetter] =
              trainingNewChosenWordColors![chosenLetter]! + 1;

          trainingController.setColor(upperChosenLetter, green);
        } else if (isYellow(wordOfUser, chosenLetter, 0, false)) {
          trainingNewChosenWordColors![chosenLetter] =
              trainingNewChosenWordColors![chosenLetter]! + 1;
          trainingController.setColor(upperChosenLetter, yellow);
        } else {
          if (rowLettersMap[upperChosenLetter] == grey) {
            trainingController.setColor(upperChosenLetter, Colors.black45);
          }
        }
      }
    }

    return;
  }

  /// Girilen harfin renginin sarı olup olmayacağını kontrol ediyor
  bool isYellow(
      String wordOfUser, String chosenLetter, int letterIndex, bool isSquare) {
    if (wordOfUser.length != 5 || !wordOfDayTraining.contains(chosenLetter)) {
      return false;
    }

    List<int> allIndexes = [];
    int startIndex = 0;
    Iterable allMatches = chosenLetter.allMatches(wordOfUser);
    for (int i = 0; i < allMatches.length; i++) {
      int index = wordOfUser.indexOf(chosenLetter, startIndex);
      allIndexes.add(index);
      startIndex = index + 1;
    }

    List<bool> isThereGreen = [
      for (int i = 0; i < allIndexes.length; i++)
        wordOfUser[allIndexes[i]] == wordOfDayTraining[allIndexes[i]]
    ];

    if (isSquare) {
      int matchedIndex = allIndexes.toList().indexOf(letterIndex);
      for (int i = 0; i < isThereGreen.length; i++) {
        if (isThereGreen[i] == true &&
            i > matchedIndex &&
            trainingMapOfSetUserWord[chosenLetter] == false) {
          trainingNewChosenWordColors![chosenLetter] =
              trainingNewChosenWordColors![chosenLetter]! + 1;
        }
      }
      trainingMapOfSetUserWord[chosenLetter] = true;
    }

    /// Kelimede harf var ise
    /// && harfin girilen kelimede bilinen yeşil sayısı ile harfin açılan renk
    /// sayısı toplamı günün kelimesindeki
    /// toplam harf sayısından küçük ise
    if (wordOfDayTraining.contains(chosenLetter) &&
        trainingNewChosenWordColors![chosenLetter]! <
            chosenLetter.allMatches(wordOfDayTraining).length) {
      return true;
    }
    return false;
  }

  Future<void> _afterBuild() async {


    String? lastWordInLocal = prefs.getString('trainingLastWordInLocal');
    if (startNewTrainingGame || lastWordInLocal == null) {
      wordOfDayTraining = trainingWords[Random().nextInt(trainingWords.length)];
      prefs.setString('trainingLastWordInLocal', wordOfDayTraining);
    } else {
      wordOfDayTraining = lastWordInLocal;
    }

    List<String> userSavedWords =
        prefs.getStringList('trainingUserWords') ?? [];

    if (userSavedWords.length == 0) {
      isFirstBuildCompleted = true;
    }

    if (userSavedWords.length != 0) {
      for (int i = 0; i < userSavedWords.length; i++) {
        trainingUserWords.add(userSavedWords[i]);
        for (int j = 0; j < 5; j++) {
          trainingController.setLetter(i, j, userSavedWords[i][j]);
        }
      }

      for (int a = 0; a < userSavedWords.length; a++) {
        for (int i = 0; i < 5; i++) {
          trainingController.flipCard(a, i);
        }
      }
      await Future.delayed(const Duration(milliseconds: 400));
      for (int a = 0; a < userSavedWords.length; a++) {
        choseSquaresColor();
        await choseButtonsColor();
        trainingChosenWord += 1;
        trainingSquareRowCount += 1;
      }
    }

    trainingIsGameEnd = prefs.getBool('trainingIsGameEnd');
    await Future.delayed(const Duration(milliseconds: 400));
    if (trainingIsGameEnd != null) {
      bool? isWin = prefs.getBool('trainingIsWin');
      if (isWin!) {
        _goEndPage();
/*        await Future.delayed(const Duration(seconds: 1));
        confettiController.play();
        await Future.delayed(const Duration(seconds: 3));
        confettiController.stop();*/
      } else {
        _goEndPage();
      }
    }

    trainingIsBack = true;
    startNewTrainingGame = false;
    trainingIsFirstBuild = false;
    isFirstBuildCompleted = true;
    return;
  }

  // TODO: DEĞİŞTİR
  void _goEndPage() async {
    await showDialog(
            barrierColor: Colors.black.withOpacity(0.5), context: context, builder: (context) => EndGame());

    if (startNewTrainingGame) {
    _startNewGame();
    }
  }

  Future<void> _gameEnd(bool isWon) async {
    trainingIsGameEnd = true;
    lastSquaresColors = squaresColors;

    if (isWon) {
      prefs.setBool('trainingIsGameEnd', true);
      prefs.setBool('trainingIsWin', true);
      trainingIsGameEnd = true;
      await _controlWinAnimation();
      _goEndPage();
    } else {
      prefs.setBool('trainingIsGameEnd', true);
      prefs.setBool('trainingIsWin', false);
      _goEndPage();
    }
  }



  Future<void> _controlWinAnimation() async {
    isAnimationCompleted = false;
    await trainingController.controlWinAnimation();
    isAnimationCompleted = true;
  }

  void _startNewGame() {
    prefs.remove('trainingIsGameEnd');
    prefs.remove('trainingUserWords');
    prefs.remove('trainingIsWin');
    Get.delete<TrainingController>();
    trainingController = Get.put(TrainingController());
    trainingController.initAnimationController();
    trainingSquareRowCount = 0;
    trainingChosenWord = 0;
    trainingChosenLetter = 0;
    trainingUserWords = [];
    trainingIsGameEnd = null;
    trainingIsFirstBuild = true;
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
        HomePage()), (Route<dynamic> route) => false);
    Get.to(() => TrainingPage());
  }
}
