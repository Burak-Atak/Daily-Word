import 'dart:async';
import 'package:first_project/helper.dart';
import 'package:flutter/material.dart';

class CountdownTimerDemo extends StatefulWidget {
  late Duration remainingTime;
  final TextStyle textStyle;

  CountdownTimerDemo({Key? key, required this.remainingTime, required this.textStyle}) : super(key: key);

  @override
  State<CountdownTimerDemo> createState() => _CountdownTimerDemoState();
}

class _CountdownTimerDemoState extends State<CountdownTimerDemo> {


  // Step 2
  Timer? countdownTimer;
  final reduceSecondsBy = 1;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {

      if (countdownTimer == null) {
        startTimer();
      }
    });
  }
  /// Timer related methods ///
  void startTimer() {
    countdownTimer =
        Timer.periodic(Duration(seconds: 1), (_) => setCountDown());
  }

  void cancelTimer() {
    countdownTimer?.cancel();
    countdownTimer = null;
  }

  void setCountDown() {
    if (mounted) {
      setState(() {
      final seconds = widget.remainingTime.inSeconds - reduceSecondsBy;
      if (seconds < 0) {
        countdownTimer!.cancel();
      } else {
        widget.remainingTime = Duration(seconds: seconds);
      }
    });
    }
  }

  @override
  void dispose() {
    super.dispose();
    cancelTimer();
  }

  @override
  Widget build(BuildContext context) {
    return  Text(
              timeFormat(widget.remainingTime.inSeconds),
              style: widget.textStyle,
            );
  }


}