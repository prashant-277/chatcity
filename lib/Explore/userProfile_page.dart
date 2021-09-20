import 'dart:convert';

import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/Widgets/buttons.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'chat_page.dart';
import 'package:http/http.dart' as http;
import 'package:chatcity/url.dart';

class userProfile_page extends StatefulWidget {
  var userList;

  userProfile_page(this.userList);



  @override
  _userProfile_pageState createState() => _userProfile_pageState();
}

class _userProfile_pageState extends State<userProfile_page> {
  final url1 = url.basicUrl;
  String name, image, email,quickboxid = "";
  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  Future<void> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = "$url1/getUserDetails";

    var map = new Map<String, dynamic>();
    map["userid"] = prefs.getString("userId").toString();
    map["get_user_id"] = widget.userList["id"].toString();

    Map<String, String> headers = {
      "API-token": prefs.getString("api_token").toString()
    };

    final response = await http.post(url, body: map, headers: headers);
    final responseJson = json.decode(response.body);
    print("res getUserDetails  " + responseJson.toString());
    setState(() {
      name = responseJson["data"]["username"].toString();
      image = responseJson["data"]["image"].toString();
      email = responseJson["data"]["email"].toString();
      quickboxid = responseJson["data"]["quickboxid"].toString();
    });
  }

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
              ClipRRect(
                  borderRadius:
                  BorderRadius.circular(100.0),
                  child: FadeInImage(
                      image: NetworkImage(image.toString()),
                      fit: BoxFit.cover,
                      width: 90.sp,
                      height: 90.sp,
                      placeholder: AssetImage(
                          "Assets/Images/giphy.gif"))),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(name.toString(),
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
                    Expanded(
                      child: Text(email.toString(),
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
                            child: chat_page(quickboxid)));
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
