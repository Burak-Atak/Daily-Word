import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'design.dart';
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
  bool _showWarning = false;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
        builder: (context, setState) => WillPopScope(
        onWillPop: () async => false,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child:  AlertDialog(
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(0))),
                backgroundColor: Colors.transparent,
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
                            height: height * 8,
                            width: width * 80,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: white.withOpacity(0.3),
                                  blurRadius: 25,
                                  spreadRadius: 1,
                                ),
                              ],
                              color: green,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(width * 3),
                                topRight: Radius.circular(width * 3),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Kayıt Ol",
                                  style: TextStyle(
                                      color: colorBlack,
                                      fontSize: height * 4,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(width * 3),
                            width: width * 80,
                            height: height * 32,
                            decoration: BoxDecoration(
                              color: lightGreen,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.zero,
                                topRight: Radius.zero,
                                bottomLeft: Radius.circular(width * 3),
                                bottomRight: Radius.circular(width * 3),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(),
                                Column(
                                  children: [
                                    Container(
                                      height: height * 7,
                                      width: width * 64,
                                      decoration: BoxDecoration(
                                        color: white,
                                        borderRadius:
                                            BorderRadius.circular(width * 2),
                                      ),
                                      child: SizedBox(
                                        width: width * 60,
                                        height: height * 7,
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
                                          style: TextStyle(fontSize: height * 3.5),
                                          controller: _controller,
                                          decoration: InputDecoration(
                                            hintText: "Kullanıcı Adı",
                                            hintStyle:
                                                TextStyle(fontSize: height * 3.5),
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.all(0),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Visibility(
                                      visible: _showWarning,
                                      child: SizedBox(
                                        width: width * 64,
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            Text("*Bu kullanıcı adı kullanılıyor.",
                                                style: TextStyle(
                                                    fontSize: height * 2.5,
                                                    color: Colors.red)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: height),
                                  child: SizedBox(
                                    width: width * 28,
                                    height: height * 7,
                                    child: ElevatedButton(
                                      style: ButtonStyle(
                                        overlayColor: MaterialStateProperty.all(
                                            Colors.black12),
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
                                                    barrierColor: Colors.black
                                                        .withOpacity(0.5),
                                                    context: context,
                                                    builder: (context) =>
                                                        ConnectionDialog());
                                                return;
                                              }
                                              database
                                                  .ref('userNames')
                                                  .get()
                                                  .then((value) {
                                                    if (value.value == null) {
                                                      _RegisterUser(
                                                          _controller.text);
                                                      Navigator.of(context).pop();
                                                      showDialog(
                                                        barrierColor: Colors.black
                                                            .withOpacity(0.5),
                                                        context: context,
                                                        builder: (context) =>
                                                        const HowToPlay(),
                                                      );
                                                      return;
                                                    }
                                                Map userName =
                                                    value.value as Map;
                                                if (userName.keys.contains(
                                                    _controller.text)) {
                                                  setState( () {
                                                    _showWarning = true;
                                                  });

                                                  ;
                                                } else {
                                                  _RegisterUser(
                                                      _controller.text);
                                                  Navigator.of(context).pop();
                                                  showDialog(
                                                    barrierColor: Colors.black
                                                        .withOpacity(0.5),
                                                    context: context,
                                                    builder: (context) =>
                                                        const HowToPlay(),
                                                  );
                                                }
                                              });
                                            },
                                      child: AutoSizeText("Kaydet",
                                          style: TextStyle(
                                              fontSize: height * 3.64,
                                              color: green)),
                                    ),
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
        ));
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
