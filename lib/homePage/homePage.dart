import 'package:auto_size_text/auto_size_text.dart';
import 'package:first_project/homePage/shadow.dart';
import 'package:first_project/main.dart';
import 'package:flutter/material.dart';
import 'flipCardWidget.dart';
import 'dart:math' as math;


class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image(
              image: AssetImage('assets/images/ezgif-3-c189523e62.gif'),
              alignment: Alignment.center,
              fit: BoxFit.fill,
            ),
          ),
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
}
