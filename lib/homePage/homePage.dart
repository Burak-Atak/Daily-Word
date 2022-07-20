import 'package:firebase_database/firebase_database.dart';
import 'package:first_project/main.dart';
import 'package:flutter/material.dart';
import '../register.dart';
import 'flipCardWidget.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  void initState() {
    super.initState();
    database = FirebaseDatabase.instance;
    userName = prefs.getString("userName");
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (userName == null) {
        await _registerScreen();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image(
              image: AssetImage('assets/images/bgForHomeScreen.png'),
              alignment: Alignment.center,
              fit: BoxFit.fill,
            ),
          ),
          if (userName != null)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FlipCardWidget(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _registerScreen() async {
    await showDialog(
        barrierColor: Colors.transparent,
        barrierDismissible: false,
        context: context,
        builder: (context) => AddPlayer());
    return;
  }
}
