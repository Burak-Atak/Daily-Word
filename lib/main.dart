import 'package:first_project/new_deneme.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:turkish/turkish.dart';

late String wordOfDay = "";
List vibrateController = [];

/// Ana renkler
const green = Color.fromRGBO(106, 170, 100, 1);
const yellow = Color.fromRGBO(201, 180, 88, 0.8);
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

void main() {
  var randomIndex = Random().nextInt(words.length);
  wordOfDay = words[randomIndex];
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wordle',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF6aaa64, materialColor),
      ),
      home: const MyHomePage(
        title: 'WORDLE',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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

  bool isEnterPressed = false;
  bool isWordExist = false;
  bool isAnimationCompleted = true;
  Map<String, int>? newChosenWordColors;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 35),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 26.75),
            child: AnimatedOpacity(
              // If the widget is visible, animate to 0.0 (invisible).
              // If the widget is hidden, animate to 1.0 (fully visible).
              opacity: isWordExist ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              // The green box must be a child of the AnimatedOpacity widget.
              child: const Text(
                "Kelime Listesinde Yok",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 26.75, bottom: 76.5),
            child: createMainSquare(),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Column(
              children: [
                firstRow(),
                secondRow(),
                thirdRow(),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Ana büyük kutuyu oluşturuyor
  Widget createMainSquare() {
    return SizedBox(
      width: 225,
      height: 272.5,
      child: Column(
        children: createRows(),
      ),
    );
  }

  /// Ana kutunun içerisine 6 tane satır oluşturuyor
  List<Widget> createRows() {
    List<Widget> rows = [];

    for (int i = 0; i < 6; i++) {
      rows.add(Row(
        children: createLittleSquares(),
      ));

      squareRowCount += 1;
      if (i != 5) {
        rows.add(const Spacer());
      } else if (i == 5) {
        squareRowCount = 0;
      }
    }

    return rows;
  }

  /// Harf girilen Kutucukları oluşturuyor
  List<Widget> createLittleSquares() {
    List<Widget> littleSquares = [];
    for (int i = 0; i < 5; i++) {
      var box = FlipCard(
        speed: 650,
        key: flipKeys[squareRowCount][i],
        flipOnTouch: false,
        front: Container(
          width: 40,
          height: 40,
          child: Text(
            textBoxes[squareRowCount][i],
            style: const TextStyle(fontSize: 35, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          decoration: BoxDecoration(
            color: Colors.white38,
            border: Border.all(
              color: Colors.black,
              width: 0.7,
            ),
          ),
        ),
        back: Container(
          width: 40,
          height: 40,
          child: Text(
            textBoxes[squareRowCount][i],
            style: const TextStyle(fontSize: 35, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          decoration: BoxDecoration(
            color: choseSquaresColor(i),
          ),
        ),
      );

      littleSquares.add(box);
      if (i != 4) {
        littleSquares.add(const Spacer());
      }
    }
    return littleSquares;
  }

  /// Klavyenin ilk satırını oluşturuyor
  Widget firstRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5),
      child: Row(
        children: [
          // createFirstRowButtons fonksiyonu bir liste dönüyor
          //fakat çayldırın :D içerisine liste değilde widget aldığı için
          // ... nokta ile fonksiyondan dönen listeyi açıyoruz [1, 2] > 1, 2
          ...createFirstRowButtons(),
        ],
      ),
    );
  }

  /// Klavyenin 2. satırını oluşturuyor
  Widget secondRow() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 21, right: 21, top: 3.9, bottom: 3.9),
      child: Row(
        children: [
          ...createSecondRowButtons(),
        ],
      ),
    );
  }

  /// Klavyenin 3. satırını oluşturuyor
  Widget thirdRow() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 5,
        right: 5,
      ),
      child: Row(
        children: [
          enterButton(),
          const Spacer(),
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
        SizedBox(
          height: 55,
          width: 36.62,
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
              ),
              onPressed: () => letterButtonFunc(i, rowLettersMap)),
        ),
        if (i != 9) const Spacer()
      ],
    ];
  }

  /// Klavye 2. satırın butonlarını oluşturuyoruz
  List<Widget> createSecondRowButtons() {
    return [
      for (int i = 10; i < 21; i++) ...[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 600),
          child: SizedBox(
            height: 55,
            width: 30,
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
                ),
                onPressed: () => letterButtonFunc(i, rowLettersMap)),
          ),
        ),
        if (i != 20) const Spacer()
      ],
    ];
  }

  /// Klavye 3. satırın butonlarını oluşturuyoruz
  List<Widget> createThirdRowButtons() {
    return [
      for (int i = 21; i < 29; i++) ...[
        SizedBox(
          height: 55,
          width: 32,
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
              ),
              child: Text(
                rowLettersMap.keys.toList()[i],
                textAlign: TextAlign.center,
              ),
              onPressed: () => letterButtonFunc(i, rowLettersMap)),
        ),
        const Spacer(),
      ],
    ];
  }

  /// Enter butonu oluşturuyoruz
  Widget enterButton() {
    return SizedBox(
      height: 55,
      width: 60,
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
          child: const Text(
            "ENTER",
            textAlign: TextAlign.center,
          ),
          onPressed: enterButtonFunc),
    );
  }

  /// Delete buttonu oluşturuyoruz
  Widget deleteButton() {
    return SizedBox(
      height: 55,
      width: 50,
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
          child: const Icon(Icons.backspace),
          onPressed: deleteButtonFunc),
    );
  }

  /// Delete butonu için fonksiyon
  void deleteButtonFunc() {
    if (chosenLetter != 0) {
      setState(() {
        chosenLetter -= 1;
        textBoxes[chosenWord][chosenLetter] = "";
      });
    }
  }

  /// Enter butonuna basıldığında çalışacak fonksiyon
  Future<void> enterButtonFunc() async {
    isEnterPressed = true;
    String wordOfUser = "";
    textBoxes[chosenWord].forEach((letter) {
      if (letter == "I") {
        letter = "ı";
      }
      wordOfUser += turkish.toLowerCase(letter);
    });
    if (chosenLetter % 5 == 0 && chosenLetter != 0) {
      if (!words.contains(wordOfUser)) {
        setState(() {
          isWordExist = true;
        });
        Future.delayed(const Duration(seconds: 2)).then((_) {
          setState(() {
            isWordExist = false;
          });
        });
      } else {
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

        chosenLetter = 0;
        chosenWord += 1;

        if (wordOfUser == wordOfDay) {
          showDataAlert(true);
        } else if ((wordOfUser != wordOfDay) && (chosenWord == 6)) {
          showDataAlert(false);
        }
      }
    }
    isEnterPressed = false;
  }

  /// Harf butunlarına basınca gerçeklleşek işlemler
  void letterButtonFunc(int i, Map<String, Color> rowLettersMap) {
    if (chosenLetter != 5) {
      setState(() {
        textBoxes[chosenWord][chosenLetter] = rowLettersMap.keys.toList()[i];
        chosenLetter += 1;
      });
    }
  }

  /// Kutucukların rengini kontrol eden fonksiyon
  Color choseSquaresColor(int i) {
    if (i == 0) {
      newChosenWordColors = {for (int i = 0; i < 5; i++) wordOfDay[i]: 0};
    }

    String chosenLetter = turkish.toLowerCase(textBoxes[squareRowCount][i]);
    String wordOfUser = turkish.toLowerCase(textBoxes[squareRowCount].join());

    if (chosenLetter == wordOfDay[i]) {
      newChosenWordColors![chosenLetter] =
          newChosenWordColors![chosenLetter]! + 1;

      return green;
    } else if (isYellow(wordOfUser, chosenLetter)) {
      newChosenWordColors![chosenLetter] =
          newChosenWordColors![chosenLetter]! + 1;

      return yellow;
    } else {
      return Colors.black54;
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

          if (isEnterPressed) {
            rowLettersMap[turkish.toUpperCase(chosenLetter)] = green;
          }
        } else if (isYellow(wordOfUser, chosenLetter)) {
          newChosenWordColors![chosenLetter] =
              newChosenWordColors![chosenLetter]! + 1;
          if (isEnterPressed) {
            rowLettersMap[turkish.toUpperCase(chosenLetter)] = yellow;
          }
        } else {
          if (isEnterPressed) {
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

    if (wordOfDay.contains(chosenLetter) &&
        newChosenWordColors![chosenLetter]! <
            chosenLetter.allMatches(wordOfDay).length) {
      return true;
    }
    return false;
  }

  /// Win ve Lose ekranının gösterilmesi
  showDataAlert(bool isWon) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(
                    20.0,
                  ),
                ),
              ),
              contentPadding: const EdgeInsets.only(
                top: 10.0,
              ),
              content: finalColumn(isWon));
        });
  }

  /// Win ve Lose ekranının içeriği
  Widget finalColumn(bool isWon) {
    return SizedBox(
      height: isWon ? 100 : 150,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: isWon
                ? const Text(
                    "Won!",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                    textAlign: TextAlign.center,
                  )
                : const Text(
                    "Lost!",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
          ),
          if (!isWon)
            Text(
              turkish.toUpperCase(wordOfDay),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: grey,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
