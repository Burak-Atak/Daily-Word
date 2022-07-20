import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'design.dart';
import 'main.dart';

class BadConnection extends StatefulWidget {
  @override
  _BadConnectionState createState() => _BadConnectionState();
}


class _BadConnectionState extends State<BadConnection> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child:          Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: height * 8,
              width: width * 70,
              decoration: BoxDecoration(
                color: green,
                boxShadow: [
                  BoxShadow(
                    color: white.withOpacity(0.3),
                    blurRadius: 25,
                    spreadRadius: 1,
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(width * 3),
                  topRight: Radius.circular(width *3),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: width * 10,
                  ),
                  SizedBox(
                    width: width * 50,
                    child: AutoSizeText("Bağlantı Hatası",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: colorBlack,
                            fontSize: height * 4,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    width: width * 10,
                    child: IconButton(
                      icon: Icon(
                        Icons.cancel_rounded,
                        shadows: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 25,
                            spreadRadius: 1,
                          ),
                        ],
                        color: white,
                        size: height * 5,
                      ),
                      onPressed: () {

                        Navigator.pop(context);

                      },
                      padding: EdgeInsets.all(0),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: height, bottom: height, left: width * 2, right: width * 2),
              width: width * 70,
              height: height * 35,
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
                  SizedBox(
                    height: height * 6,
                  ),
                  SizedBox(
                    height: height * 10,
                    child: AutoSizeText("Lütfen daha sonra tekrar deneyiniz.",
                        style: TextStyle(
                            fontSize: height * 3, color: colorBlack),
                        maxLines: 2,
                        textAlign: TextAlign.center),

                  ),
                  SizedBox(
                    height: height * 6,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: white,
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