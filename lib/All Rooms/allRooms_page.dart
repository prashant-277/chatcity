import 'dart:convert';
import 'dart:io';

import 'package:chatcity/Explore/Explore_page.dart';
import 'package:chatcity/Explore/chat_page.dart';
import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:chatcity/url.dart';


class allRooms_page extends StatefulWidget {
  const allRooms_page({Key key}) : super(key: key);

  @override
  _allRooms_pageState createState() => _allRooms_pageState();
}

class _allRooms_pageState extends State<allRooms_page> {
  int current_tab = 0;
  String userId;
  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            content: Text('Do you want to exit an app?', style: TextStyle(
                fontFamily: "SFPro",
                fontWeight: FontWeight.w600,
                color: cBlack,
                fontSize: 14.sp)),
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('No', style: TextStyle(
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
                child: Text('Yes', style: TextStyle(
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
  List myroomList = [];
  List joinedroomList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getmyRoomsList();
    getjoinedRoomsList();
    getUserId();
  }
  getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("userId").toString();
    });
  }
  Future<void> getmyRoomsList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = "$url1/myRoomsList";

    var map = new Map<String, dynamic>();
    map["userid"] = prefs.getString("userId").toString();

    Map<String, String> headers = {
      "API-token": prefs.getString("api_token").toString()
    };

    final response = await http.post(url, body: map, headers: headers);
    final responseJson = json.decode(response.body);
    print("res getmyRoomsList  " + responseJson.toString());
    setState(() {
      myroomList = responseJson["data"];
      _isLoading = false;
    });
  }

  Future<void> getjoinedRoomsList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = "$url1/joinedRoomsList";

    var map = new Map<String, dynamic>();
    map["userid"] = prefs.getString("userId").toString();

    Map<String, String> headers = {
      "API-token": prefs.getString("api_token").toString()
    };

    final response = await http.post(url, body: map, headers: headers);
    final responseJson = json.decode(response.body);
    print("res joinedRoomsList  " + responseJson.toString());
    setState(() {
      joinedroomList = responseJson["data"];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var query = MediaQuery
        .of(context)
        .size;
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: cwhite,
        appBar: commanAppBar(
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
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Image.asset(
                "Assets/Icons/search.png",
                width: 5.w,
                color: Colors.transparent,
              ),
            ),
          ],
        ),
        body: DefaultTabController(
          length: 2,
          child: Column(
            children: <Widget>[
              Container(
                height: 7.h,
                color: cwhite,
                child: TabBar(
                  automaticIndicatorColorAdjustment: true,
                  labelPadding: EdgeInsets.zero,
                  indicatorColor: cfooterpurple,
                  indicatorWeight: 1.0,
                  onTap: (page) {
                    print(page);
                    setState(() {
                      current_tab = page;
                    });
                  },
                  tabs: [
                    Container(
                      padding: EdgeInsets.zero,
                      width: query.width,
                      color: cwhite,
                      child: Tab(
                          child: Text("My rooms",
                              style: TextStyle(
                                  fontFamily: "SFPro",
                                  fontWeight: FontWeight.w600,
                                  color: current_tab == 0 ? cBlack : cGray,
                                  fontSize: medium))),
                    ),
                    Container(
                      padding: EdgeInsets.zero,
                      width: query.width,
                      color: cwhite,
                      child: Tab(
                          child: Text("Joined rooms",
                              style: TextStyle(
                                  fontFamily: "SFPro",
                                  fontWeight: FontWeight.w600,
                                  color: current_tab == 1 ? cBlack : cGray,
                                  fontSize: medium))),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    RefreshIndicator(
                      onRefresh: getmyRoomsList,
                      color: cButtoncolor,
                      child: _isLoading == true
                          ? SpinKitRipple(color: cfooterpurple)
                          : Container(
                        child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: myroomList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            type: PageTransitionType.fade,
                                            alignment: Alignment.bottomCenter,
                                            duration: Duration(
                                                milliseconds: 300),
                                            child: chat_page(myroomList[index])));
                                  },
                                  title: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                              myroomList[index]["name"].toString(),
                                              style: TextStyle(
                                                fontFamily: "SFPro",
                                                fontSize: medium,
                                                color: cBlack,
                                                fontWeight: FontWeight.w600,
                                              )
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset(
                                                myroomList[index]["type"]
                                                    .toString() == "0" ?
                                                "Assets/Icons/public.png"
                                                    : "Assets/Icons/private.png",
                                                color: cfooterGray,
                                                height: 2.h),
                                          ),
                                        ],
                                      ),
                                      Text(myroomList[index]["MessageCreatedTime"].toString()==""?"":
                                      TimeAgo.timeAgoSinceDate(myroomList[index]["MessageCreatedTime"].toString()),
                                          style: TextStyle(
                                            fontFamily: "SFPro",
                                            fontSize: small,
                                            color: cGray,
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ],
                                  ),
                                  leading: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(100.0),
                                      child: FadeInImage(
                                          image: NetworkImage(
                                              myroomList[index]["image"]
                                                  .toString()),
                                          fit: BoxFit.cover,
                                          width: 40.sp,
                                          height: 40.sp,
                                          placeholder: AssetImage(
                                              "Assets/Images/giphy.gif"))),
                                  subtitle: Text(myroomList[index]["Message"].toString(),
                                      style: TextStyle(
                                        fontFamily: "SFPro",
                                        fontSize: small,
                                        color: myroomList[index]["created_by"].toString()
                                            == userId.toString() ? cButtoncolor : cGray,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ),
                              );
                            }),
                      ),
                    ),
                    RefreshIndicator(
                      onRefresh: getjoinedRoomsList,
                      color: cButtoncolor,
                      child: _isLoading == true
                          ? SpinKitRipple(color: cfooterpurple)
                          : Container(
                        child: ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: joinedroomList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ListTile(
                                  onTap: () {
                                    print("click");
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            type: PageTransitionType.fade,
                                            alignment: Alignment.bottomCenter,
                                            duration: Duration(
                                                milliseconds: 300),
                                            child: chat_page(joinedroomList[index])));
                                  },
                                  title: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(joinedroomList[index]["name"]
                                              .toString(),
                                              style: TextStyle(
                                                fontFamily: "SFPro",
                                                fontSize: medium,
                                                color: cBlack,
                                                fontWeight: FontWeight.w600,
                                              )
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset(
                                                joinedroomList[index]["type"]
                                                    .toString() == "0" ?
                                                "Assets/Icons/public.png"
                                                    : "Assets/Icons/private.png",
                                                color: cfooterGray,
                                                height: 2.h),
                                          ),
                                        ],
                                      ),
                                      Text(joinedroomList[index]["MessageCreatedTime"].toString()==""?"":
                                      TimeAgo.timeAgoSinceDate(joinedroomList[index]["MessageCreatedTime"].toString()),
                                          style: TextStyle(
                                            fontFamily: "SFPro",
                                            fontSize: small,
                                            color: cGray,
                                            fontWeight: FontWeight.w500,
                                          )),
                                    ],
                                  ),
                                  leading: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(100.0),
                                      child: FadeInImage(
                                          image: NetworkImage(
                                              joinedroomList[index]["image"]
                                                  .toString()),
                                          fit: BoxFit.cover,
                                          width: 40.sp,
                                          height: 40.sp,
                                          placeholder: AssetImage(
                                              "Assets/Images/giphy.gif"))),
                                  subtitle: Text(joinedroomList[index]["Message"].toString(),
                                      style: TextStyle(
                                        fontFamily: "SFPro",
                                        fontSize: small,
                                        color: joinedroomList[index]["created_by"].toString()
                                            == userId.toString() ? cButtoncolor : cGray,
                                        fontWeight: FontWeight.w500,
                                      )),
                                ),
                              );
                            }),
                      ),
                    ),
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
