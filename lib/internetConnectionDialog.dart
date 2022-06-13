import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'main.dart';

class ConnectionDialog extends StatefulWidget {
  const ConnectionDialog({Key? key}) : super(key: key);

  @override
  State<ConnectionDialog> createState() => _ConnectionDialogState();
}

class _ConnectionDialogState extends State<ConnectionDialog> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(0))),
          contentPadding: EdgeInsets.only(
              top: height * 5,
              bottom: height * 5,
              left: width * 10,
              right: width * 10),
          insetPadding: EdgeInsets.all(0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(bottom: height * 4, top: height * 4, left: width * 2, right: width * 2),
                height: height * 30,
                width: width * 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(width *3),
                  color: Color(0xffbbe7bb),
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
                  children: <Widget>[
                    Text("Lütfen internet bağlantınızı kontrol ediniz.",
                        style:
                            TextStyle(fontSize: height * 3, color: colorBlack),
                        textAlign: TextAlign.center),
                    Container(
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
      ),
    );
  }
}
