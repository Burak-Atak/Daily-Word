import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:first_project/endgame.dart';
import 'package:first_project/helper.dart';
import 'package:first_project/homePage/homePage.dart';
import 'package:first_project/howToPlay.dart';
import 'package:first_project/internetConnectionDialog.dart';
import 'package:first_project/mainpage_controller.dart';
import 'package:first_project/my_flutter_app_icons.dart';
import 'package:first_project/scorePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:first_project/timeIsUpAlert.dart';
import 'package:first_project/training_mode/trainingHomePage.dart';
import 'package:first_project/training_mode/training_controller.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:first_project/new_deneme.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:ntp/ntp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tap_debouncer/tap_debouncer.dart';
import 'package:turkish/turkish.dart';
import 'package:confetti/confetti.dart';
import 'package:firebase_core/firebase_core.dart';
import 'ad_helper.dart';
import 'design.dart';
import 'firebase_options.dart';
import 'generalStatistic.dart';
import 'package:get/get.dart';

// TODO: oyun sonudna çarpıyı köşeye al
// TODO: Paylaşı storede yayınlandıktan sonra düzenle
// TODO: kÜFÜR FİLTRESİ
// TODO: Kelime çıkma süresini netten çek
// TODO: KullANNIcı kaydolurken aynı isim varsa çıkan dialogu sil

late SharedPreferences prefs;
String? userName;
String wordOfDay = "-----";
List vibrateController = [];
late double width;
late double height;
String title = 'Daily Word';
bool isFirstBuild = true;
bool isFirstBuildCompleted = false;
bool? isGameEnd;
late FirebaseDatabase database;
String? lastWordInLocal;
late int totalSeconds;
late int userScore;
late int whichWordUserFound;
late var mainController;
late var lastSquaresColors;
bool isBack = false;
late EdgeInsetsGeometry paddingForSquare;

/// Uygulama build edilirken hangi kutucuk satırında olduğunu tutuan değişken
int squareRowCount = 0;

/// Hangi kelimede olduğumuzu tutuyor
int chosenWord = 0;

/// Hangi kutucukta oldğumuzu tutuyor
int chosenLetter = 0;
List<String> userWords = [];

/// Ana renkler

Future<void> main() async {
/*  // TODO:CRAHLİSİTCH AÇ
  WidgetsFlutterBinding.ensureInitialized();
  */ /* await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );*/ /*
  prefs = await SharedPreferences.getInstance();

  /// Read word of day from firebase
  */ /*database = FirebaseDatabase.instance;*/ /*
  // var snapshot = await ref.child('word').get();
  wordOfDay = "burak";

  runApp(Phoenix(child: MyApp()));*/

  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    prefs = await SharedPreferences.getInstance();

    // The following lines are the same as previously explained in "Handling uncaught errors"

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await Future.delayed(Duration(seconds: 1), () {
/*      runApp(
          DevicePreview(
            builder: (context) => MyApp(),
            enabled: true,
            tools: [
              ...DevicePreview.defaultTools,
            ],
          )
      );*/

      runApp(Phoenix(child: MyApp()));
    });
  },
      (error, stack) =>

          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: MaterialColor(0xFF6aaa64, materialColor),
        ),
        title: title,
        home:  Builder(
          builder: (BuildContext context) {
            mainController = Get.put(MainController());

            trainingController = Get.put(TrainingController());

            width = MediaQuery.of(context).size.width / 100;
            double heightWithApp = MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom;
            height = (heightWithApp - heightWithApp * 9.4 / 100) / 100;
            if (height > 12.5) {
              height = height - height * 0.3;
            } else if (height > 6.5) {
              height = height - height * 0.1;
            }
            if (width > 6) {
              width = width - width * 0.1;
            }

            (() {
              if (height / width >= 1.8) {
                paddingForSquare =
                    EdgeInsets.only(left: width * 11, right: width * 11);
              } else if (height / width >= 1.6) {
                paddingForSquare =
                    EdgeInsets.only(left: width * 13, right: width * 13);
              } else if (height / width >= 1.4) {
                paddingForSquare =
                    EdgeInsets.only(left: width * 18, right: width * 18);
              } else {
                paddingForSquare =
                    EdgeInsets.only(left: width * 30, right: width * 30);
              }
            })();

            return HomePage();
          },
        ));
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _initGoogleMobileAds();
    _loadInterstitialAd();

    mainController.initAnimationController();
    winController = mainController.winController;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (isBack) {
        List<String> userSavedWords = prefs.getStringList('userWords') ?? [];
        for (int i = 0; i < userSavedWords.length; i++) {
          for (int j = 0; j < 5; j++) {
            flipKeys[i][j].value.currentState.toggleCard();
          }
        }

        if (isGameEnd == true) {
          await Future.delayed(Duration(milliseconds: 600));
          _goEndPage();
        }
      }

      if (isFirstBuild) {
        _afterBuild();
      }
    });



   BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize(width: (width * 100).round(), height:( height * 9).round()),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  InterstitialAd? _interstitialAd;

  Future<void> _loadInterstitialAd() async {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) async {
            },
          );
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (err) {
        },
      ),
    );

    return;
  }

  /// Her bir kutucuğun stringini tanımlıyoruz
  List<List<RxString>> textBoxes = mainController.textBoxes;

  /// Kutucukların animasyonunu kontrol eden keylerin bulundugu liste
  List flipKeys = mainController.flipKeys;

  /// Klavye harflerini ve renklerini tutan map
  Map<String, dynamic> rowLettersMap = mainController.rowLettersMap;
  List squaresColors = mainController.squaresColors;

  RxBool isWordExist = mainController.isWordExist;
  bool isAnimationCompleted = true;
  Map<String, int>? newChosenWordColors;
  late Map<String, bool> mapOfSetUserWord;
  ConfettiController confettiController = ConfettiController();
  late var winController;

  BannerAd? _bannerAd;

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();

    super.dispose();
  }

  Future<InitializationStatus> _initGoogleMobileAds() {
    return MobileAds.instance.initialize();
  }


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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () {
                              if (isAnimationCompleted &&
                                  isFirstBuildCompleted) {
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
                        Align(
                          alignment: Alignment.centerLeft,
                          child: InkWell(
                            onTap: () {
                              if (isAnimationCompleted &&
                                  isFirstBuildCompleted) {
                                showDialog(
                                  barrierColor: Colors.black.withOpacity(0.5),
                                  context: context,
                                  builder: (context) => const HowToPlay(),
                                );
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
                                Icons.info_outline_rounded,
                                color: Colors.black45,
                                size: height * 4,
                              ),
                            ),
                          ),
                        ),
                      ],
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding:
                          EdgeInsets.only(left: width * 2, right: width),
                          child: InkWell(
                            onTap: () {
                              if (isAnimationCompleted &&
                                  isFirstBuildCompleted) {
                                try {
                                  _interstitialAd?.show();
                                } catch (e) {
                                }
                                showDialog(
                                  barrierColor: Colors.black.withOpacity(0.5),
                                  context: context,
                                  builder: (context) =>
                                  const GeneralStatistic(),
                                );
                              }
                            },
                            customBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                height * 2,
                              ),
                            ),
                            child: Icon(
                              Icons.bar_chart_rounded,
                              color: Colors.black45,
                              size: height * 5,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (isAnimationCompleted && isFirstBuildCompleted) {
                              try {
                                _interstitialAd?.show();
                              } catch (e) {
                              }
                              showDialog(
                                barrierColor: Colors.black.withOpacity(0.5),
                                context: context,
                                builder: (context) => const MyAlertDialog(),
                              );
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
                              MyFlutterApp.cup,
                              color: Colors.black45,
                              size: height * 3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_bannerAd != null)
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: _bannerAd!.size.width.toDouble(),
                        height: _bannerAd!.size.height.toDouble(),
                        child: AdWidget(ad: _bannerAd!),
                      ),
                    )
                else
                    SizedBox(
                      height: (height * 9).round().toDouble(),
                    ),
                  Stack(children: [


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
                  Padding(
                    padding: EdgeInsets.only(bottom: height * 1.2),
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
          ],
        ),
      ),
    );
  }

  /// Harf girilen Kutucukları oluşturuyor
  Widget createMainSquare() {
    //1.5 kısa dar ekran
    // 1.66 dar uzun 1.67 dar normal uzun
    // 1.85dar uzun

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
                  () => AutoSizeText(
                    textBoxes[index ~/ 5][index % 5].value,
                    style: TextStyle(fontSize: height * 6, color: Colors.black),
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
                  () => AutoSizeText(
                    textBoxes[index ~/ 5][index % 5].value,
                    style: TextStyle(fontSize: height * 6, color: Colors.white),
                    textAlign: TextAlign.center,
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
    if (chosenLetter != 0 && isGameEnd == null && isAnimationCompleted) {
      chosenLetter -= 1;
      mainController.setLetter(chosenWord, chosenLetter, "");
    }
  }

  /// Enter butonuna basıldığında çalışacak fonksiyon
  Future<bool> enterButtonFunc() async {

    if (isGameEnd == null &&
        isAnimationCompleted &&
        chosenLetter % 5 == 0 &&
        chosenLetter != 0) {
      bool isConnected = await checkInternet();
      if (!isConnected) {
        showDialog(
            barrierColor: Colors.black.withOpacity(0.5),
            barrierDismissible: false,
            context: context,
            builder: (context) => ConnectionDialog());
        return false;
      }

      String wordOfUser = "";
      textBoxes[chosenWord].forEach((letter) {
        wordOfUser += turkish.toLowerCase(letter.value);
      });

      if (!words.contains(wordOfUser)) {
        mainController.changeIsWordExist(true);

        Future.delayed(const Duration(seconds: 1)).then((_) {
          mainController.changeIsWordExist(false);
        });

        return false;
      } else {
        isAnimationCompleted = false;
        if (chosenWord == 0) {
          try {
            var now = await NTP.now();
            prefs.setString('startTime', now.toString());
          } catch (e) {
            isAnimationCompleted = true;
            return false;
          }
        }

        userWords.add(turkish.toUpperCase(wordOfUser));
        prefs.setStringList('userWords', userWords);
        await choseSquaresColor();
        for (int i = 0; i < 5; i++) {
          mainController.flipCard(chosenWord, i);
          await Future.delayed(const Duration(milliseconds: 200));
        }
        await Future.delayed(const Duration(milliseconds: 300));

        await choseButtonsColor();
        if (wordOfUser == wordOfDay) {
          _gameEnd(true);
        } else if ((wordOfUser != wordOfDay) && (chosenWord == 5)) {
          _gameEnd(false);
        } else {
          chosenLetter = 0;
          chosenWord += 1;
          squareRowCount += 1;
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
    if (chosenLetter < 5 &&
        isGameEnd == null &&
        isAnimationCompleted &&
        isFirstBuildCompleted) {
      mainController.setLetter(
          chosenWord, chosenLetter, rowLettersMap.keys.toList()[i]);
      chosenLetter += 1;
    }
  }

  /// Kutucukların rengini kontrol eden fonksiyon
  Future<void> choseSquaresColor() async {
    for (int i = 0; i < 5; i++) {
      if (i == 0) {
        newChosenWordColors = {for (int i = 0; i < 5; i++) wordOfDay[i]: 0};
        List<RxString> setUserWord = {...textBoxes[squareRowCount]}.toList();
        mapOfSetUserWord = {
          for (int i = 0; i < setUserWord.length; i++)
            turkish.toLowerCase(setUserWord[i].value): false
        };
      }
      String chosenLetter =
          turkish.toLowerCase(textBoxes[squareRowCount][i].value);
      String wordOfUser = turkish.toLowerCase(textBoxes[squareRowCount].join());

      if (chosenLetter == wordOfDay[i]) {
        newChosenWordColors![chosenLetter] =
            newChosenWordColors![chosenLetter]! + 1;
        mainController.setColorForSquare(squareRowCount, i, green);
      } else if (isYellow(wordOfUser, chosenLetter, i, true)) {
        newChosenWordColors![chosenLetter] =
            newChosenWordColors![chosenLetter]! + 1;
        mainController.setColorForSquare(squareRowCount, i, yellow);
      } else {
        mainController.setColorForSquare(squareRowCount, i, Colors.black54);
      }
    }
  }

  Future<void> choseButtonsColor() async {
    newChosenWordColors = {for (int i = 0; i < 5; i++) wordOfDay[i]: 0};

    String wordOfUser = turkish.toLowerCase(textBoxes[chosenWord].join());

    for (int i = 0; i < 5; i++) {
      String chosenLetter = turkish.toLowerCase(textBoxes[chosenWord][i].value);
      String upperChosenLetter = turkish.toUpperCase(chosenLetter);

      if (rowLettersMap[upperChosenLetter] != green) {
        if (chosenLetter == wordOfDay[i]) {
          newChosenWordColors![chosenLetter] =
              newChosenWordColors![chosenLetter]! + 1;

          mainController.setColor(upperChosenLetter, green);
        } else if (isYellow(wordOfUser, chosenLetter, 0, false)) {
          newChosenWordColors![chosenLetter] =
              newChosenWordColors![chosenLetter]! + 1;
          mainController.setColor(upperChosenLetter, yellow);
        } else {
          if (rowLettersMap[upperChosenLetter] == grey) {
            mainController.setColor(upperChosenLetter, Colors.black45);
          }
        }
      }
    }

    return;
  }

  /// Girilen harfin renginin sarı olup olmayacağını kontrol ediyor
  bool isYellow(
      String wordOfUser, String chosenLetter, int letterIndex, bool isSquare) {
    if (wordOfUser.length != 5 || !wordOfDay.contains(chosenLetter)) {
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
        wordOfUser[allIndexes[i]] == wordOfDay[allIndexes[i]]
    ];

    if (isSquare) {
      int matchedIndex = allIndexes.toList().indexOf(letterIndex);
      for (int i = 0; i < isThereGreen.length; i++) {
        if (isThereGreen[i] == true &&
            i > matchedIndex &&
            mapOfSetUserWord[chosenLetter] == false) {
          newChosenWordColors![chosenLetter] =
              newChosenWordColors![chosenLetter]! + 1;
        }
      }
      mapOfSetUserWord[chosenLetter] = true;
    }

    /// Kelimede harf var ise
    /// && harfin girilen kelimede bilinen yeşil sayısı ile harfin açılan renk
    /// sayısı toplamı günün kelimesindeki
    /// toplam harf sayısından küçük ise
    if (wordOfDay.contains(chosenLetter) &&
        newChosenWordColors![chosenLetter]! <
            chosenLetter.allMatches(wordOfDay).length) {
      return true;
    }
    return false;
  }

  Future<void> _afterBuild() async {


    if (FirebaseAuth.instance.currentUser == null) {
      var jwt = JWT(
        {
          "iss": "firebase-adminsdk-yq4yd@wordle-5a28f.iam.gserviceaccount.com",
          "sub": "firebase-adminsdk-yq4yd@wordle-5a28f.iam.gserviceaccount.com",
          "aud":
              "https://identitytoolkit.googleapis.com/google.identity.identitytoolkit.v1.IdentityToolkit",
          "iat": DateTime.now().millisecondsSinceEpoch ~/ 1000,
          "exp": DateTime.now()
                  .add(Duration(seconds: 1800))
                  .millisecondsSinceEpoch ~/
              1000,
          "uid": userName,
        },
      );
      await dotenv.load(fileName: ".env");
      var token = jwt.sign(RSAPrivateKey(dotenv.env["KEY"]!),
          algorithm: JWTAlgorithm.RS256);
      FirebaseAuth.instance.signInWithCustomToken(token);
    }

    var snapshot = await database.ref('word/word').get();
    wordOfDay = snapshot.value.toString();

    String? lastWordInLocal = prefs.getString('lastWordInLocal');

    if ((lastWordInLocal != wordOfDay) && !isBack) {
      prefs.remove('isGameEnd');
      prefs.remove('userWords');
      prefs.remove('isWin');
      prefs.setString('lastWordInLocal', wordOfDay);
    }
    List<String> userSavedWords = prefs.getStringList('userWords') ?? [];

    if (userSavedWords.length == 0 && userName != null) {
      isFirstBuildCompleted = true;
    }

    /// checks internet connection

    try {
      AppUpdateInfo isThereUpdate = await InAppUpdate.checkForUpdate();
      if (isThereUpdate.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        InAppUpdate.performImmediateUpdate();
      }
    } catch (e) {}

    database.ref('word').onChildChanged.listen((event) async {
      _startNewGame();

      if ((Get.currentRoute == "/MyHomePage")) {
        await Get.dialog(TimeIsUpAlert());
        Get.offAll(HomePage());
        Get.to(() => MyHomePage());
      }
    });

    if (userSavedWords.length != 0) {
      for (int i = 0; i < userSavedWords.length; i++) {
        userWords.add(userSavedWords[i]);
        for (int j = 0; j < 5; j++) {
          mainController.setLetter(i, j, userSavedWords[i][j]);
        }
      }

      for (int a = 0; a < userSavedWords.length; a++) {
        for (int i = 0; i < 5; i++) {
          mainController.flipCard(a, i);
        }
      }
      await Future.delayed(const Duration(milliseconds: 400));
      for (int a = 0; a < userSavedWords.length; a++) {
        choseSquaresColor();
        await choseButtonsColor();
        chosenWord += 1;
        squareRowCount += 1;
      }
    }

    isGameEnd = prefs.getBool('isGameEnd');
    await Future.delayed(const Duration(milliseconds: 400));
    if (isGameEnd != null) {
      lastSquaresColors = squaresColors;
      totalSeconds = prefs.getInt('totalSeconds')!;
      userScore = prefs.getInt('userScore')!;
      whichWordUserFound = prefs.getInt('whichWordUserFound')!;
      bool? isWin = prefs.getBool('isWin');
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

    isFirstBuild = false;
    isFirstBuildCompleted = true;
    isBack = true;
  }

  void _goEndPage() {
    showDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        context: context,
        builder: (context) => EndGame());
  }

  Future<void> _gameEnd(bool isWon) async {
    isGameEnd = true;
    lastSquaresColors = squaresColors;
    if (isWon) {
      await _updateDatabase(true);
      prefs.setBool('isGameEnd', true);
      prefs.setBool('isWin', true);
      isGameEnd = true;
      await _controlWinAnimation();
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




  void _startNewGame() async {
    prefs.remove('isGameEnd');
    prefs.remove('userWords');
    prefs.remove('isWin');
    Get.delete<MainController>();
    mainController = Get.put(MainController());
    mainController.initAnimationController();
    squareRowCount = 0;
    chosenWord = 0;
    chosenLetter = 0;
    userWords = [];
    isGameEnd = null;
    isFirstBuild = true;
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
//////////////////
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

  Future<void> _controlWinAnimation() async {
    isAnimationCompleted = false;
    await mainController.controlWinAnimation();
    isAnimationCompleted = true;
  }

  void _showInternetAlert() {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      barrierDismissible: false,
      builder: (BuildContext context) {
        bool showAnimation = false;
        return WillPopScope(
          onWillPop: () async => false,
          child: StatefulBuilder(
            builder: (context, setState) => AlertDialog(
              elevation: 0,
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

/*const starPoints = 5;

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
}*/

/*
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
        ],
*/
