import 'package:chatcity/constants.dart';
import 'package:custom_radio_grouped_button/CustomButtons/ButtonTextStyle.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

import 'createPrivate_room.dart';
import 'createPublic_room.dart';

class createRoom_Dialog extends StatefulWidget {
  const createRoom_Dialog({Key key}) : super(key: key);

  @override
  _createRoom_DialogState createState() => _createRoom_DialogState();
}

class _createRoom_DialogState extends State<createRoom_Dialog> {
  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context).size;
    return Container(
      width: query.width / 1,
      height: query.height * 0.26,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Create new room",
                  style: TextStyle(
                      fontSize: medium,
                      fontFamily: "SFPro",
                      fontWeight: FontWeight.w600,
                      color: cBlack),
                ),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Image.asset(
                      "Assets/Icons/close.png",
                      width: 4.w,
                    ))
              ],
            ),
          ),
          Container(
            width: query.width / 1.3,
            height: query.height * 0.06,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                side: BorderSide(width: 1, color: gray),

              ),

              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade,
                        alignment: Alignment.bottomCenter,
                        duration: Duration(milliseconds: 300),
                        child: createPublic_room()));
              },
              child: Row(
                children: [
                  Image.asset(
                    "Assets/Icons/public.png",
                    color: cBlack,
                    width: 6.w,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    "Public room",
                    style: TextStyle(
                        fontSize: medium,
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.w600,
                        color: cBlack),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            width: query.width / 1.3,
            height: query.height * 0.06,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                side: BorderSide(width: 1, color: gray),

              ),
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.fade,
                        alignment: Alignment.bottomCenter,
                        duration: Duration(milliseconds: 300),
                        child: createPrivate_room()));
              },
              child: Row(
                children: [
                  Image.asset(
                    "Assets/Icons/private.png",
                    color: cBlack,
                    width: 6.w,
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    "Private room",
                    style: TextStyle(
                        fontSize: medium,
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.w600,
                        color: cBlack),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
