import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  // Her bir kutucuğun stringini tanımlıyoruz
  List<dynamic> textBoxes = [
    for (int i = 0; i < 6; i++) [for (int a = 0; a < 5; a++) ""]
  ];
  // Uygulama build edilirken hangi kutucuk satırında olduğunu tutuan değişken
  int squareRowCount = 0;
  // Hangi kelimede olduğumuzu tutuyor
  int chosenWord = 0;
  // Hangi kutucukta oldğumuzu tutuyor
  int chosenLetter = 0;
  var myString = "BURAK";
  // Kutucukların animasyonunu kontrol eden keylerin bulundugu liste
  List flipKeys = [
    for (int i = 0; i < 6; i++)
      [for (int a = 0; a < 5; a++) GlobalKey<FlipCardState>()]
  ];

  // Klavye harflerini ve renklerini tutan map
  Map<String, Color> rowLettersMap = {
    "E": GREY,
    "R": GREY,
    "T": GREY,
    "Y": GREY,
    "U": GREY,
    "I": GREY,
    "O": GREY,
    "P": GREY,
    "Ğ": GREY,
    "Ü": GREY,
    "A": GREY,
    "S": GREY,
    "D": GREY,
    "F": GREY,
    "G": GREY,
    "H": GREY,
    "J": GREY,
    "K": GREY,
    "L": GREY,
    "Ş": GREY,
    "İ": GREY,
    "Z": GREY,
    "C": GREY,
    "V": GREY,
    "B": GREY,
    "N": GREY,
    "M": GREY,
    "Ö": GREY,
    "Ç": GREY,
  };

  // Ana renkler
  static const GREY = Color.fromRGBO(120, 124, 126, 1);
  static const GREEN = Color.fromRGBO(106, 170, 100, 1);
  static const YELLOW = Color.fromRGBO(201, 180, 88, 0.8);
  static const WHITE = Color.fromRGBO(211, 214, 218, 0.7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            const Text(
              "WORDLE",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.blue, fontSize: 50),
            ),
            const Spacer(),
            createMainSquare(),
            const Spacer(),
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
      ),
    );
  }

  Widget createMainSquare() {
    return SizedBox(
      width: 225,
      height: 272.5,
      child: Column(
        children: createRows(),
      ),
    );
  }
  // 6 tane satır oluşturuyor
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
  // Kutucukları oluşturuyor
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
            style: const TextStyle(fontSize: 35),
            textAlign: TextAlign.center,
          ),
          decoration: const BoxDecoration(
            color: WHITE,
          ),
        ),
        back: Container(
          width: 40,
          height: 40,
          child: Text(
            textBoxes[squareRowCount][i],
            style: const TextStyle(fontSize: 35),
            textAlign: TextAlign.center,
          ),
          decoration: BoxDecoration(
            color: choseColor(i),
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

  // Klavyenin ilk satırını oluşturuyor
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

  // Klavyenin 2. satırını oluşturuyor
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

  // Klavyenin 3. satırını oluşturuyor
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

  // Birinci satırın butonlarını oluşturuyoruz
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
                backgroundColor: MaterialStateProperty.all(Colors.black26),
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

  // 2. satırın butonlarını oluşturuyoruz
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
                  backgroundColor: MaterialStateProperty.all(Colors.black26),
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

  // 3. satırın butonlarını oluşturuyoruz
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
                backgroundColor: MaterialStateProperty.all(Colors.black26),
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

  // Enter butonu oluşturuyoruz
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
            backgroundColor: MaterialStateProperty.all(Colors.black26),
          ),
          child: const Text(
            "ENTER",
            textAlign: TextAlign.center,
          ),
          onPressed: enterButtonFunc),
    );
  }

  // Delete buttonu oluşturuyoruz
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
            backgroundColor: MaterialStateProperty.all(Colors.black26),
          ),
          child: const Icon(Icons.backspace),
          onPressed: deleteButtonFunc),
    );
  }

  void deleteButtonFunc() {
    if (chosenLetter != 0) {
      setState(() {
        chosenLetter -= 1;
        textBoxes[chosenWord][chosenLetter] = "";
      });
    }
  }

  Future<void> enterButtonFunc() async {
    if (chosenLetter % 5 == 0 && chosenLetter != 0) {
      for (int i = 0; i < 5; i++) {
        setState(() {
          flipKeys[chosenWord][i].currentState.toggleCard();
        });
        await Future.delayed(const Duration(milliseconds: 200));
      }
      chosenLetter = 0;
      chosenWord += 1;
    }
  }

  // Harf butunlarına basınca gerçeklleşek işlemler
  void letterButtonFunc(int i, Map<String, Color> rowLettersMap) {
    if (chosenLetter != 5) {
      setState(() {
        textBoxes[chosenWord][chosenLetter] = rowLettersMap.keys.toList()[i];
        chosenLetter += 1;
      });
    }
  }

  // Kutucukların rengini kontrol eden fonksiyon
  Color choseColor(int i) {
    if (textBoxes[squareRowCount][i] == myString[i]) {
      return GREEN;
    } else if (myString.contains(textBoxes[squareRowCount][i])) {
      return YELLOW;
    } else {
      return GREY;
    }
  }
}
