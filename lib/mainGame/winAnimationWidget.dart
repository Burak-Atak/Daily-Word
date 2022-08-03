import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:lottie/lottie.dart';

import '../main.dart';

class winAnimationWidget extends StatefulWidget {
  @override
  State<winAnimationWidget> createState() => _winAnimationWidgetState();
}

class _winAnimationWidgetState extends State<winAnimationWidget> with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    mainController.initAnimationController();
    winController = mainController.winController;
  }

  late var winController;


  @override
  Widget build(BuildContext context) {
    return Align(
      child: Obx(
            () => Lottie.asset(
          'assets/win.json',
          height: height * 50,
          width: width * 75.67,
          controller: winController.value,
          repeat: false,
        ),
      ),
    );
  }
}