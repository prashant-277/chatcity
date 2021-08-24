import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../constants.dart';

class basicButton extends StatelessWidget {
  final Color textcolor;
  final Function onPressed;
  final String text;

  final Color colorButton;

  const basicButton(this.textcolor, this.onPressed, this.text, this.colorButton);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      color: colorButton,
      child: Text(
        text,
        style: TextStyle(
            fontSize: medium,
            fontFamily: "SFPro",
            fontWeight: FontWeight.w400,
            color: textcolor),
      ),
      onPressed: onPressed,
      padding: EdgeInsets.fromLTRB(40, 10, 40, 10)
    );
  }
}
