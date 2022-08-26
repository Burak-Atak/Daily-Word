import 'package:first_project/training_mode/trainingHomePage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:tap_debouncer/tap_debouncer.dart';

import '../design.dart';
import '../main.dart';

class Keyboard extends StatelessWidget {
  final  Function letterButtonFunc;
  final  Function enterButtonFunc;
  final  Function deleteButtonFunc;
  Map<String, dynamic> rowLettersMap;
  Keyboard({
    required this.letterButtonFunc,
    required this.enterButtonFunc,
    required this.deleteButtonFunc,
    required this.rowLettersMap,

  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: height * 1.2),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 10; i++)
              Padding(
                padding: EdgeInsets.only(right: i != 9 ? width : 0),
                child: SizedBox(
                  height: height * 10,
                  width: width * 8.9,
                  child: Obx(
                        () => ElevatedButton(
                        style: ButtonStyle(
                          enableFeedback: false,
                          shape:
                          MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                              rowLettersMap[rowLettersMap.keys.toList()[i]]!
                                  .value),
                          padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(
                                vertical: 0, horizontal: 0),
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
        ),
        Padding(
          padding: EdgeInsets.only(
            top: height * 0.7,
            bottom: height * 0.7,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 10; i < 21; i++)
                Padding(
                  padding: EdgeInsets.only(right: i != 20 ? width : 0),
                  child: SizedBox(
                    height: height * 10,
                    width: width * 7.6,
                    child: Obx(
                          () => ElevatedButton(
                          style: ButtonStyle(
                            enableFeedback: false,
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                                rowLettersMap[rowLettersMap.keys.toList()[i]]!
                                    .value),
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
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
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: width * 1.1,
            right: width * 1.1,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
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
                              enableFeedback: false,
                              foregroundColor: MaterialStateProperty.all(Colors.white),
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
              ),
              for (int i = 21; i < 29; i++)
                Padding(
                  padding: EdgeInsets.only(right: width),
                  child: SizedBox(
                    height: height * 10,
                    width: width * 7.785,
                    child: Obx(
                          () => ElevatedButton(
                          style: ButtonStyle(
                            enableFeedback: false,
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                                rowLettersMap[rowLettersMap.keys.toList()[i]]!
                                    .value),
                            padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 0),
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
              SizedBox(
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
                    onPressed: () => deleteButtonFunc(),
                    child: Icon(Icons.backspace, size: width * 5.5)),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
