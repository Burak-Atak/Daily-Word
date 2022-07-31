import 'package:auto_size_text/auto_size_text.dart';
import 'package:first_project/wordsMeanings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'design.dart';
import 'main.dart';

class DictAlertDialog extends StatefulWidget {
  final word;

  DictAlertDialog(this.word);

  @override
  State<DictAlertDialog> createState() => _DictAlertDialogState();
}

class _DictAlertDialogState extends State<DictAlertDialog> {


  var count = 0;

  @override
  Widget build(BuildContext context) {
    count = 0;
    for (int i = 0; i < meanings[widget.word]!.length; i++) {
      count = count + meanings[widget.word]![i]!.length as int;
    }
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: AlertDialog(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(0))),
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.only(
            top: height * 5,
            bottom: height * 5,
        ),
        insetPadding: EdgeInsets.all(0),
        content: Container(
          width: MediaQuery.of(context).size.width,
          height: count > 300 ? height * 33 : count > 250 ? height * 30: count > 200 ? height * 25: height * 20,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.8),
          ),
          child: Padding(
            padding: EdgeInsets.only(left: width * 4, right: width * 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < meanings[widget.word]!.length; i++)
                  AutoSizeText(

                    "${i + 1}.    ${meanings[widget.word]![i]}",
                    style: TextStyle(
                        color: white,
                        fontFamily: "DMSans",
                        fontSize: height * 2.5,
                        fontStyle: FontStyle.italic),

                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
