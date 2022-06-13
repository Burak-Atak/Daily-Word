import 'dart:io';

import 'package:flutter/cupertino.dart';

void main() {

}



String timeFormat(int time) {
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
  if (hour != null) {
    return "+${hour}s";
  }
  return "${min == null ? "00" : min.toString().length < 2 ? "0${min}" : min}:${sec.toString().length < 2 ? "0${sec}" : sec}";
}

Future<bool> checkInternet() async {
  try {
    final result = await InternetAddress.lookup('www.google.com').timeout(Duration(seconds: 5));
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    }
  }  catch (_) {
    return false;
  }

  return false;
}