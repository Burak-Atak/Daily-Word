import 'package:auto_size_text/auto_size_text.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'design.dart';
import 'helper.dart';
import 'homePage/homePage.dart';
import 'main.dart';

/// This page used to create new players

TextEditingController _controller = TextEditingController();

class AddPlayer extends StatefulWidget {
  const AddPlayer({Key? key}) : super(key: key);

  @override
  State<AddPlayer> createState() => _AddPlayerPageState();
}

class _AddPlayerPageState extends State<AddPlayer>
    with SingleTickerProviderStateMixin {
  bool _showWarningForUsername = false;
  bool _showWarningForLength = false;
  bool _isButtonEnabled = false;
  bool _isButtonChildChanged = false;
  bool _isServerError = false;
  bool _showWarningForValidation = false;
  bool _isRegisterCompleted = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 100;
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final bool isKeyboardOpen = keyboardHeight != 0;

    double size = (isKeyboardOpen || _controller.text.isNotEmpty)
        ? height * 1.5
        : height * 2.5;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: isKeyboardOpen
                ? EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  )
                : EdgeInsets.only(
                    bottom: height * 35,
                  ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(height * 1.8),
                  width: width * 70,
                  height: height * 30,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: green,
                    ),
                    color: green,
                    borderRadius: BorderRadius.all(
                      Radius.circular(width * 5),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(""),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: height * 8,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                AnimatedPositioned(
                                  top: (isKeyboardOpen ||
                                          _controller.text.isNotEmpty)
                                      ? 0
                                      : height * 2.6,
                                  left: 0,
                                  duration: Duration(milliseconds: 200),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: AnimatedDefaultTextStyle(
                                      duration: Duration(milliseconds: 200),
                                      style: TextStyle(
                                          fontSize: size, color: white),
                                      child: AutoSizeText(
                                        "Kullanıcı Adı",
                                      ),
                                    ),
                                  ),
                                ),
                                TextField(
                                  onChanged: (value) async {
                                    await _checkLengthAndUsername();
                                    setState(() {});
                                  },
                                  maxLines: 1,
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: height * 3, color: white),
                                  controller: _controller,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(width: 1, color: white),
                                    ),
                                    contentPadding: EdgeInsets.all(0),
                                  ),
                                  showCursor: isKeyboardOpen ? true : false,
                                  cursorColor: white,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * 4,
                            width: width * 60,
                            child: Stack(
                              children: [
                                AnimatedOpacity(
                                  duration: Duration(milliseconds: 100),
                                  opacity: _showWarningForUsername? 1 : 0,
                                  child: Text(
                                      "Kullanıcı adı daha önceden alınmış.",
                                      style: TextStyle(
                                          fontSize: height * 1.5,
                                          color: white)),
                                ),
                                AnimatedOpacity(
                                  duration: Duration(milliseconds: 100),
                                  opacity: _showWarningForLength ? 1 : 0,
                                  child: Text(
                                    "Kullanıcı adı 1-12 karakter uzunluğunda olmalıdır.",
                                    style: TextStyle(
                                        fontSize: height * 1.5,
                                        color: white),
                                    maxLines: 2,
                                  ),
                                ),
                                AnimatedOpacity(
                                  duration: Duration(milliseconds: 100),
                                  opacity: _isServerError ? 1 : 0,
                                  child: Text(
                                    "Opps! Bir hata oluştu.",
                                    style: TextStyle(
                                        fontSize: height * 1.5,
                                        color: white),
                                    maxLines: 2,
                                  ),
                                ),
                                AnimatedOpacity(
                                  duration: Duration(milliseconds: 100),
                                  opacity:  _showWarningForValidation ? 1 : 0,
                                  child: Text(
                                    "Boşluk kullanmayınız.",
                                    style: TextStyle(
                                        fontSize: height * 1.5,
                                        color:white),
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: width * 25,
                        height: height * 5,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            overlayColor:
                                MaterialStateProperty.all(Colors.black12),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(width * 2),
                                ),
                              ),
                            ),
                            backgroundColor: _isButtonEnabled
                                ? MaterialStateProperty.all(white)
                                : MaterialStateProperty.all(Colors.white70),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            ),
                          ),
                          onPressed: _isButtonEnabled
                              ? () async {
                                    _registerUser(_controller.text);
                                  }
                              : null,
                          child: _isButtonChildChanged ?       LoadingAnimationWidget.inkDrop(
                            color: green,
                            size: height * 3,
                          ) : _isRegisterCompleted ? AutoSizeText("✔",
                              style: TextStyle(
                                  fontSize: height * 3, color: green)): AutoSizeText("Kaydet",
                              style: TextStyle(
                                  fontSize: height * 3, color: green)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _registerUser(String chosenName) async {
    setState(() {
      _isButtonChildChanged = true;
      _isButtonEnabled = false;
    });

    bool isConnected = await checkInternet();
    if (!isConnected) {
      setState(() {
        _isButtonChildChanged = false;
        _isServerError = true;
        _isButtonEnabled = true;
      });
      return;
    }

     bool checkAgain = await _checkLengthAndUsername();
      if (!checkAgain) {
        setState(() {
          _isButtonChildChanged = false;
        });
        return;
      }

    prefs.setString('userName', chosenName);

    try {
      await authAndRegisterDb(chosenName).timeout(Duration(seconds: 5));
    } catch (e) {
      setState(() {
        _isServerError = true;
        _isButtonChildChanged = false;
        _isButtonEnabled = true;
      });
      return;
    }

    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _isButtonChildChanged = false;
      _isRegisterCompleted = true;
    });

    await Future.delayed(Duration(seconds: 1));

    userName = chosenName;

    PushPage().pushPage(HomePage());

  }


  Future<bool> _checkLengthAndUsername() async {

    _isServerError = false;
    _showWarningForUsername = false;
    _showWarningForLength = false;
    _showWarningForValidation = false;


    bool isTrue = false;
    await database.ref('userNames').get().then((value) async {
      if (value.value == null) {
        isTrue = true;
        _isButtonEnabled = true;
        return;
      }
      Map userName = value.value as Map;
      if (userName.keys.contains(_controller.text)) {
        _isButtonEnabled = false;
        _showWarningForUsername = true;
        return;
      } else {
        isTrue = true;
      }
    });

    if (_controller.text.contains(" ")) {
      _showWarningForValidation = true;
      _isButtonEnabled = false;
      return false;
    }

    if (_controller.text.isEmpty || _controller.text.length > 12) {
      _showWarningForLength = true;
      _isButtonEnabled = false;
      return false;
    }

    if (isTrue && !_isButtonChildChanged) {
      _isButtonEnabled = true;
      return true;
    }

    return isTrue;
  }

  Future<void> authAndRegisterDb(String chosenName) async {
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
        "uid": chosenName,
      },
    );
    await dotenv.load(fileName: ".env");
    var token = jwt.sign(RSAPrivateKey(dotenv.env["KEY"]!),
        algorithm: JWTAlgorithm.RS256);
    await FirebaseAuth.instance.signInWithCustomToken(token);

    database.ref('userNames/$chosenName').set(true);

    database.ref('users/$chosenName').set({
      'totalGame': 0,
      'totalWin': 0,
      'score': 0,
      'totalSeconds': 0,
    });

    database.ref('series/$chosenName').set({
      'gameSeries': 0,
      'winSeries': 0,
      'seriesRecord': 0,
      'winSeriesRecord': 0,
    });

    database.ref('whichWord/$chosenName').set({
      'first': 0,
      'second': 0,
      'third': 0,
      'fourth': 0,
      'fifth': 0,
      'sixth': 0,
    });

    return;
  }
}
