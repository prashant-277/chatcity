import 'dart:convert';

import 'package:chatcity/Settings/edit_Profile.dart';
import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/Widgets/buttons.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:chatcity/url.dart';
import 'package:http/http.dart' as http;

class myProfile extends StatefulWidget {
  const myProfile({Key key}) : super(key: key);

  @override
  _myProfileState createState() => _myProfileState();
}

class _myProfileState extends State<myProfile> {

  final url1 = url.basicUrl;
  String name,
      image,
      email,
      phonenumber,
      birthdate = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getUserDetails();
    print("ddd");
  }

  Future<void> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = "$url1/getUserDetails";

    var map = new Map<String, dynamic>();
    map["userid"] = prefs.getString("userId").toString();
    map["get_user_id"] = "";


    Map<String, String> headers = {
      "API-token": prefs.getString("api_token").toString()
    };

    final response = await http.post(Uri.parse(url), body: map, headers: headers);
    final responseJson = json.decode(response.body);
    print("res getUserDetails  " + responseJson.toString());

    setState(() {
      name = responseJson["data"]["username"].toString();
      image = responseJson["data"]["image"].toString();
      email = responseJson["data"]["email"].toString();
      phonenumber = responseJson["data"]["phone"].toString();
      birthdate = responseJson["data"]["dob"].toString();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var query = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: commanAppBar(
        appBar: AppBar(),
        groupImage: Container(),
        imageIcon: Container(),
        colorImage: cwhite,
        imageBack: true,
        appbartext: "My Profile",
        fontsize: medium,
      ),
      backgroundColor: cwhite,
      body: _isLoading == true
          ? SpinKitRipple(color: cfooterpurple)
          : Container(
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
                child: Text(name.toString() == "null" ? "" : name.toString(),
                    style: TextStyle(
                        fontFamily: "SFPro",
                        fontWeight: FontWeight.w600,
                        color: cBlack,
                        fontSize: header)),
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Text("Personal information",
                      style: TextStyle(
                          fontFamily: "SFPro",
                          fontWeight: FontWeight.w600,
                          color: cBlack,
                          fontSize: medium)),
                ],
              ),
              SizedBox(height: 1.5.h),
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
                        width: 5.w,
                      ),
                    ),
                    Container(
                      width: 200.sp,
                      child: Text(
                          email.toString() == "null" ? "" : email.toString(),
                          style: TextStyle(
                              fontFamily: "SFPro",
                              fontWeight: FontWeight.w400,
                              color: cBlack,
                              fontSize: medium)),
                    ),
                  ],
                ),
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
                        "Assets/Icons/phone.png",
                        width: 5.w,
                      ),
                    ),
                    Container(
                      width: 200.sp,
                      child: Text(
                          phonenumber.toString() == "null" ? "" : phonenumber
                              .toString(),
                          style: TextStyle(
                              fontFamily: "SFPro",
                              fontWeight: FontWeight.w400,
                              color: cBlack,
                              fontSize: medium)),
                    ),
                  ],
                ),
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
                        "Assets/Icons/dob.png",
                        width: 5.w,
                      ),
                    ),
                    Container(
                      width: 200.sp,
                      child: Text(birthdate.toString(),
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
                  child: basicButton(
                      cwhite, () async {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            alignment: Alignment.bottomCenter,
                            duration: Duration(milliseconds: 300),
                            child: edit_Profile())).then((value) =>
                        getUserDetails());
                  }, "Edit Profile", cButtoncolor)),
            ],
          ),
        ),
      ),
    );
  }
}
