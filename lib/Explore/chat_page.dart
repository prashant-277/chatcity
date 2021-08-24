import 'package:chatcity/Explore/roomInfo_page.dart';
import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

class chat_page extends StatefulWidget {
  const chat_page({Key key}) : super(key: key);

  @override
  _chat_pageState createState() => _chat_pageState();
}

class _chat_pageState extends State<chat_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cChatbackground,
      appBar: commanAppBar(
        appBar: AppBar(),
        imageBack: true,
        colorImage: cwhite,
        appbartext: "London Boys",
        groupImage: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset("Assets/Icons/img5.png", height: 4.h),
        ),
        imageIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            "Assets/Icons/public.png",
            height: 2.h,
            color: cwhite,
          ),
        ),
        fontsize: medium,
        widgets: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            alignment: Alignment.bottomCenter,
                            duration: Duration(milliseconds: 300),
                            child: roomInfo_page()));
                  },
                  icon: Image.asset("Assets/Icons/info.png", width: 6.w))),
        ],
      ),
      bottomSheet: Container(
          color: cwhite,
          height: 60.sp,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 1.25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0)
                  ),
                  height: 35.sp,
                  child: TextField(
                    style: TextStyle(
                        fontFamily: "SFPro", color: cBlack, fontSize: medium),
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide:
                                BorderSide(color: cChatbackground, width: 1)),
                        contentPadding:
                            EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(50.0)),
                            borderSide:
                                BorderSide(color: cChatbackground, width: 1)),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide: BorderSide(
                            color: cChatbackground,
                            width: 2.0,
                          ),
                        ),
                        filled: true,
                        hintStyle: TextStyle(
                            color: cGray,
                            fontFamily: "SFPro",
                            fontSize: medium),
                        hintText: "Type a Message...",

                        fillColor: Colors.white,

                    ),
                  ),
                ),
                Image.asset(
                  "Assets/Icons/send.png",
                  height: 5.0.h,
                )
              ],
            ),
          )),
    );
  }
}
