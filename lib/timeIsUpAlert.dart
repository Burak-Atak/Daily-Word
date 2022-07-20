import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'design.dart';
import 'main.dart';

class TimeIsUpAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: AlertDialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(width * 2))),
        contentPadding: EdgeInsets.only(
            top: height * 5,
            bottom: height * 5,
            left: width * 10,
            right: width * 10),
        insetPadding: EdgeInsets.all(0),
        content: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: width * 100,
            ),
            Container(
              padding: EdgeInsets.all(0),
              height: height * 8,
              width: width * 70,
              decoration: BoxDecoration(
                color: green,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(width * 3),
                  topRight: Radius.circular(width * 3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Süre Doldu!",
                      style: TextStyle(
                          fontSize: height * 3.5,
                          color: colorBlack,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(height * 2),
              height: height * 21,
              width: width * 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(width * 3),
                    bottomRight: Radius.circular(width * 3)),
                color: lightGreen,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Yeni kelimeyle oyuna devam edebilirsiniz.",
                      style: TextStyle(
                          fontSize: height * 3, color: colorBlack),
                      textAlign: TextAlign.center),
                  SizedBox(
                    height: height * 6,
                    width: width * 24,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          overlayColor:
                          MaterialStateProperty.all(Colors.transparent),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(width * 2),
                              ),
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(white),
                          padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                          ),
                        ),
                        child: Text("Tamam",
                            style: TextStyle(
                                fontSize: height * 3, color: green))),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}