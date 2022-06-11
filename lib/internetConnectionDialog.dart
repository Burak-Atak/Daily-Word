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
          backgroundColor: Colors.white.withOpacity(0.8),
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
                padding: EdgeInsets.only(bottom: height * 4, top: height * 4),
                height: height * 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: green,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Lütfen internet bağlantınızı kontrol ediniz.",
                        style:
                            TextStyle(fontSize: height * 3.64, color: white),
                        textAlign: TextAlign.center),
                    Container(
                      height: height * 7,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: white,
                          ),
                          child: Text("Tamam",
                              style: TextStyle(
                                  fontSize: height * 3.64, color: green))),
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
