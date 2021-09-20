import 'dart:convert';
import 'dart:io';

import 'package:chatcity/Explore/chat_page.dart';
import 'package:chatcity/Explore/filter_page.dart';
import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:chatcity/url.dart';

class Explore_page extends StatefulWidget {
  @override
  _Explore_pageState createState() => _Explore_pageState();
}

class _Explore_pageState extends State<Explore_page> {
  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text('Do you want to exit an app?',
            style: TextStyle(
                fontFamily: "SFPro",
                fontWeight: FontWeight.w600,
                color: cBlack,
                fontSize: 14.sp)),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No',
                style: TextStyle(
                    fontFamily: "SFPro",
                    fontWeight: FontWeight.w600,
                    color: cBlack,
                    fontSize: 14.sp)),
          ),
          FlatButton(
            onPressed: () {
              if (Platform.isAndroid) {
                SystemNavigator.pop();
              } else if (Platform.isIOS) {
                exit(0);
              }
            },
            child: Text('Yes',
                style: TextStyle(
                    fontFamily: "SFPro",
                    fontWeight: FontWeight.w600,
                    color: cBlack,
                    fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }

  final url1 = url.basicUrl;
  List roomData = [];
  int search = 0;
  TextEditingController search_ctrl = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getAllRooms();
  }

  Future<void> getAllRooms() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = "$url1/getAllRooms";

    var map = new Map<String, dynamic>();
    map["userid"] = prefs.getString("userId").toString();

    Map<String, String> headers = {
      "API-token": prefs.getString("api_token").toString()
    };

    final response = await http.post(url, body: map, headers: headers);
    final responseJson = json.decode(response.body);
    print("res getAllRooms  " + responseJson.toString());
    setState(() {
      roomData = responseJson["data"];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          backgroundColor: cwhite,
          appBar: search == 0
              ? commanAppBar(
                  appBar: AppBar(),
                  colorImage: cwhite,
                  fontsize: header,
                  imageBack: false,
                  appbartext: "ChatCity",
                  imageIcon: Container(),
                  groupImage: Container(),
                  leadingIcon: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Image.asset("Assets/Icons/logo2.png"),
                  ),
                  widgets: [
                    FlatButton(
                        highlightColor: Colors.transparent,
                        color: Colors.transparent,
                        splashColor: Colors.transparent,
                        onPressed: () {
                          setState(() {
                            search = 1;
                          });
                        },
                        child: Image.asset(
                          "Assets/Icons/search.png",
                          height: 15.sp,
                        ))
                  ],
                )
              : AppBar(
                  automaticallyImplyLeading: false,
                  title: TextField(
                    controller: search_ctrl,
                    maxLines: 1,
                    autofocus: true,
                    cursorColor: cwhite,
                    style: TextStyle(
                        fontFamily: "SFPro", fontSize: medium, color: cwhite),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: EdgeInsets.only(
                            left: 25, bottom: 11, top: 11, right: 15),
                        hintText: "Search...",
                        hintStyle: TextStyle(
                            fontFamily: "SFPro",
                            color: cwhite,
                            fontSize: medium,
                            decoration: TextDecoration.none)),
                    cursorHeight: 20.sp,
                    onChanged: (value) {
                      setState(() {
                        searchData();
                      });
                    },
                  ),
                  actions: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            search = 0;
                            getAllRooms();
                            search_ctrl.text = "";
                          });
                        },
                        icon: Icon(Icons.cancel_outlined))
                  ],
                ),
          body: Scaffold(
            backgroundColor: cwhite,
            appBar: AppBar(
              backgroundColor: cwhite,
              automaticallyImplyLeading: false,
              elevation: 0,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Explore rooms",
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontSize: medium,
                      color: cBlack,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  FlatButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      color: cButtoncolor,
                      onPressed: () {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                alignment: Alignment.bottomCenter,
                                duration: Duration(milliseconds: 300),
                                child: filter_page())).then((value) => getAllRooms());
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text("Filter",
                            style: TextStyle(
                              fontFamily: "SFPro",
                              fontSize: medium,
                              color: cwhite,
                              fontWeight: FontWeight.w400,
                            )),
                      ))
                ],
              ),
            ),
            body: RefreshIndicator(
              onRefresh: getAllRooms,
              color: cButtoncolor,
              child: _isLoading == true
                  ? SpinKitRipple(color: cfooterpurple)
                  : Container(
                      height: query.height,
                      width: query.width,
                      child: ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: roomData.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: ListTile(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.fade,
                                          alignment: Alignment.bottomCenter,
                                          duration: Duration(milliseconds: 300),
                                          child: chat_page(roomData[index])));
                                },
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(roomData[index]["name"].toString(),
                                            style: TextStyle(
                                              fontFamily: "SFPro",
                                              fontSize: medium,
                                              color: cBlack,
                                              fontWeight: FontWeight.w600,
                                            )),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image.asset(
                                              roomData[index]["type"]
                                                          .toString() ==
                                                      "0"
                                                  ? "Assets/Icons/public.png"
                                                  : "Assets/Icons/private.png",
                                              color: cfooterGray,
                                              height: 2.h),
                                        ),
                                      ],
                                    ),
                                    Text("Time",
                                        style: TextStyle(
                                          fontFamily: "SFPro",
                                          fontSize: small,
                                          color: cGray,
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ],
                                ),
                                leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(100.0),
                                    child: FadeInImage(
                                        image: NetworkImage(roomData[index]
                                                ["image"]
                                            .toString()),
                                        fit: BoxFit.cover,
                                        width: 40.sp,
                                        height: 40.sp,
                                        placeholder: AssetImage(
                                            "Assets/Images/giphy.gif"))),
                                subtitle:
                                    Text("Hi, Julian! see you after work?",
                                        style: TextStyle(
                                          fontFamily: "SFPro",
                                          fontSize: small,
                                          color: cGray,
                                          fontWeight: FontWeight.w500,
                                        )),
                              ),
                            );
                          }),
                    ),
            ),
          )),
    );
  }

  Future<void> searchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = "$url1/searchRooms";
    var map = new Map<String, dynamic>();
    map["userid"] = prefs.getString("userId").toString();
    map["search"] = search_ctrl.text.toString();

    Map<String, String> headers = {
      "API-token": prefs.getString("api_token").toString()
    };

    final response = await http.post(url, body: map, headers: headers);
    final responseJson = json.decode(response.body);
    print("res searchRooms  " + responseJson.toString());

    if (responseJson["status"].toString() == "success") {
      setState(() {
        roomData = responseJson["data"];

        if (search_ctrl.text.toString() == "") {
          getAllRooms();
        }
      });
      //displayToast(responseJson["message"].toString());

    }
  }
}
