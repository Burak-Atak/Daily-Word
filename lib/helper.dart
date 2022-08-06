import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

String timeFormat(int time, {isEndTime}) {
  int? hour;
  int? min;
  int sec;
  if (time >= 3600) {
    hour = time ~/ 3600;
    time = time % 3600;
  }
  if (time >= 60) {
    min = time ~/ 60;
    time = time % 60;
  }
  sec = time;

  if (isEndTime != null) {
    return "${min == null ? "00" : min.toString().length < 2 ? "0$min" : min}:${sec.toString().length < 2 ? "0$sec" : sec}";
  }

  return "${hour == null ? "00" : hour.toString().length < 2 ? "0$hour" : hour}:${min == null ? "00" : min.toString().length < 2 ? "0$min" : min}:${sec.toString().length < 2 ? "0$sec" : sec}";
}

Future<bool> checkInternet() async {
  try {
    final result = await InternetAddress.lookup('www.google.com')
        .timeout(Duration(seconds: 5));
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  } catch (_) {
    return false;
  }

  return false;
}

Future<Widget> buildPageAsync(Widget page) async {
  return Future.microtask(() {
    return page;
  });
}

class PushPage {
  Future<Widget> chosenPage(Widget page) async {
    Widget chosenPage = await buildPageAsync(page);
    return chosenPage;
  }

  void pushPage(Widget page) async {
    Widget newPage = await chosenPage(page);
    Get.offAll(()  => newPage, transition: Transition.upToDown, duration: Duration(milliseconds: 200));
  }

  void pushDialog(Widget page) async {
    Get.dialog(
      await chosenPage(page),
      transitionCurve: Curves.easeInOut,
      transitionDuration: Duration(milliseconds: 200),
      //barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
    );
  }
}
