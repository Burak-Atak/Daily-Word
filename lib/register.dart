import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'helper.dart';
import 'howToPlay.dart';
import 'internetConnectionDialog.dart';
import 'main.dart';

/// This page used to create new players

TextEditingController _controller = TextEditingController();

class AddPlayer extends StatefulWidget {
  const AddPlayer({Key? key}) : super(key: key);

  @override
  State<AddPlayer> createState() => _AddPlayerPageState();
}

class _AddPlayerPageState extends State<AddPlayer> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: SingleChildScrollView(
        child: AlertDialog(
            elevation: 0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0))),
            backgroundColor: Colors.white.withOpacity(0.8),
            contentPadding: EdgeInsets.only(
                top: height * 9,
                bottom: height * 10,
                left: width * 10,
                right: width * 10),
            insetPadding: EdgeInsets.all(0),
            content: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: width * 100,
                  height: height * 100,
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      Container(
                        width: width * 70,
                        height: height * 40,
                        decoration: BoxDecoration(
                          color: green,
                          borderRadius: BorderRadius.circular(width * 5),
                          boxShadow: [
                            BoxShadow(
                              color: white.withOpacity(0.3),
                              blurRadius: 25,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("Kullanıcı Adı",
                                style: TextStyle(
                                    color: white,
                                    fontSize: height * 4,
                                    fontWeight: FontWeight.bold)),
                            Container(
                              height: height * 7,
                              width: width * 62,
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.circular(width * 2),
                              ),
                              child: Align(
                                child: SizedBox(
                                  width: width * 60,
                                  height: height * 6,
                                  child: TextField(
                                    maxLength: 12,
                                    onChanged: (value) {
                                      setState(() {});
                                    },
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    maxLines: 1,
                                    autofocus: true,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: height * 4),
                                    controller: _controller,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.all(0),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width * 30,
                              height: height * 7,
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(
                                      Colors.transparent),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(width * 2),
                                      ),
                                    ),
                                  ),
                                  backgroundColor:
                                      MaterialStateProperty.all(white),
                                  padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        horizontal: 0, vertical: 0),
                                  ),
                                ),
                                onPressed: _controller.text.isEmpty
                                    ? null
                                    : () async {
                                        bool isConnected =
                                            await checkInternet();
                                        if (!isConnected) {
                                          showDialog(
                                              barrierColor: Colors.transparent,
                                              context: context,
                                              builder: (context) =>
                                                  ConnectionDialog());
                                          return;
                                        }
                                        database
                                            .ref('userNames')
                                            .get()
                                            .then((value) {
                                          Map userName = value.value as Map;
                                          if (userName.keys
                                              .contains(_controller.text)) {
                                            showDialog(
                                              barrierColor: Colors.transparent,
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  elevation: 0,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  0))),
                                                  backgroundColor: Colors.white.withOpacity(0.8),
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          top: height * 5,
                                                          bottom: height * 5,
                                                          left: width * 10,
                                                          right: width * 10),
                                                  insetPadding:
                                                      EdgeInsets.all(0),
                                                  content: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(width: width * 100,),
                                                      Container(
                                                        padding: EdgeInsets.all(
                                                            width * 3),
                                                        width: width * 70,
                                                        height: height * 30,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: green,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                width * 5),
                                                          ),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: white
                                                                  .withOpacity(
                                                                      0.3),
                                                              blurRadius: 25,
                                                              spreadRadius: 1,
                                                            ),
                                                          ],
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              width: width * 40,
                                                              child: AutoSizeText(
                                                                  "Bu kullanıcı adı kullanılıyor.",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: TextStyle(
                                                                      color:
                                                                          colorBlack,
                                                                      fontSize:
                                                                          height *
                                                                              3.64)),
                                                            ),
                                                            ElevatedButton(
                                                              style: ButtonStyle(
                                                                overlayColor: MaterialStateProperty.all(
                                                                    Colors.transparent),
                                                                shape: MaterialStateProperty.all(
                                                                  RoundedRectangleBorder(
                                                                    borderRadius: BorderRadius.all(
                                                                      Radius.circular(width * 2),
                                                                    ),
                                                                  ),
                                                                ),
                                                                backgroundColor:
                                                                MaterialStateProperty.all(white),
                                                                padding: MaterialStateProperty.all(
                                                                  EdgeInsets.symmetric(
                                                                      horizontal: 0, vertical: 0),
                                                                ),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: SizedBox(
                                                                width:
                                                                    width * 20,
                                                                child:
                                                                    AutoSizeText(
                                                                  "Tamam",
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyle(
                                                                      color:
                                                                          green,
                                                                      fontSize:
                                                                          height *
                                                                              3.64),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                            );
                                          } else {
                                            _RegisterUser(_controller.text);
                                            Navigator.of(context).pop();
                                            showDialog(
                                              barrierColor: Colors.transparent,
                                              context: context,
                                              builder: (context) =>
                                              const HowToPlay(),
                                            );
                                          }
                                        });
                                      },
                                child: AutoSizeText("Kaydol",
                                    style: TextStyle(
                                        fontSize: height * 3.64, color: green)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }


  Future<void> _RegisterUser(String chosenName) async {
    prefs.setString('userName', chosenName);

    database.ref('userNames/$chosenName').set(true);
    userName = chosenName;

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
  }
}

/*WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: height * 9.4,
          centerTitle: true,
          title: Text(
            'W O R D L E',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: height * 7),
          ),
        ),
        body: RegisterScreen(),
      ),
    );*/
