import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/Widgets/buttons.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';

import 'chat_page.dart';

class userProfile_page extends StatefulWidget {
  const userProfile_page({Key key}) : super(key: key);

  @override
  _userProfile_pageState createState() => _userProfile_pageState();
}

class _userProfile_pageState extends State<userProfile_page> {
  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context).size;
    return Scaffold(
      appBar: commanAppBar(
        appBar: AppBar(),
        colorImage: cwhite,
        appbartext: "User's Profile",
        imageBack: true,
        fontsize: medium,
        groupImage: Container(),
        imageIcon: Container(),
      ),
      body: Container(
        height: query.height,
        width: query.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                "Assets/Icons/img5.png",
                height: 18.h,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text("London Boys",
                    style: TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.w700,
                        color: cBlack,
                        fontSize: medium)),
              ),
              SizedBox(height: 2.h),
              Container(
                height: 45.sp,
                width: query.width,
                decoration: BoxDecoration(
                    color: cChatbackground,
                    border: Border.all(color: gray, width: 0),
                    borderRadius: BorderRadius.circular(10.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 10),
                      child: Image.asset(
                        "Assets/Icons/email.png",
                        width: 7.w,
                      ),
                    ),
                    Container(
                      width: 200.sp,
                      child: Text("prashan@gmail.com",
                          style: TextStyle(
                              fontFamily: "SFPro",
                              fontWeight: FontWeight.w400,
                              color: cBlack,
                              fontSize: medium)),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 4.h),
              Container(
                  width: 90.w,
                  height: 7.5.h,
                  child:
                      basicButton(cwhite, () async {}, "+ Add friend", cgreen)),
              SizedBox(height: 2.h),
              Container(
                  width: 90.w,
                  height: 7.5.h,
                  child: basicButton(
                      cwhite, () async {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            alignment: Alignment.bottomCenter,
                            duration: Duration(milliseconds: 300),
                            child: chat_page()));
                  }, "Open private chat", cButtoncolor)),
              SizedBox(height: 2.h),
              Container(
                  width: 90.w,
                  height: 7.5.h,
                  child: basicButton(cwhite, () async {}, "Block", cOrange)),
            ],
          ),
        ),
      ),
    );
  }
}
