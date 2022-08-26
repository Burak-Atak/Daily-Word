import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'design.dart';
import 'main.dart';

class BadConnection extends StatefulWidget {
  @override
  State<BadConnection> createState() => _BadConnectionState();
}


class _BadConnectionState extends State<BadConnection> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child:          Container(
          padding: EdgeInsets.only(bottom: height * 2, left: width * 2, right: width * 2),
          width: width * 70,
          height: height * 35,
          decoration: BoxDecoration(
            color: green,
            borderRadius: BorderRadius.all(
             Radius.circular(width * 5),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: width * 10,
                  ),
                  SizedBox(
                    width: width * 46,
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
              SizedBox(
                height: height * 10,
                child: AutoSizeText("Oops! Bir sorun oluştu. Lütfen daha sonra tekrar deneyiniz.",
                    style: TextStyle(
                        fontSize: height * 3, color: white),
                    maxLines: 2,
                    textAlign: TextAlign.center),

              ),
              SizedBox(
                height: height * 7,
                width: width * 20,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: roundedButtonStyle,
                    child: Text("Tamam",
                        style: TextStyle(
                            fontSize: height * 3, color: green))),
              ),
            ],
          ),
        ),

      ),
    );
  }

}