import 'dart:convert';
import 'dart:io';

import 'package:chatcity/Explore/chat_page.dart';
import 'package:chatcity/Explore/privateChat_page.dart';
import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/Widgets/toastDisplay.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';
import 'package:sizer/sizer.dart';
import 'package:chatcity/url.dart';
import 'package:http/http.dart' as http;

class requestPage extends StatefulWidget {
  const requestPage({Key key}) : super(key: key);

  @override
  _requestPageState createState() => _requestPageState();
}

class _requestPageState extends State<requestPage>{
  int current_tab = 0;
  final url1 = url.basicUrl;
  List requestDetail = [];
  List myfriendlist = [];
  bool _isLoading = true;
  String _dialogId;

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

  @override
  void initState() {
    super.initState();
    getInvitaionList();
    getMyfriednList();
  }

  Future<void> getInvitaionList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = "$url1/myinvitationList";

    var map = new Map<String, dynamic>();
    map["userid"] = prefs.getString("userId").toString();

    Map<String, String> headers = {
      "API-token": prefs.getString("api_token").toString()
    };

    final response = await http.post(url, body: map, headers: headers);
    final responseJson = json.decode(response.body);
    print("res myinvitationList  " + responseJson.toString());

    setState(() {
      requestDetail = responseJson["data"];
      _isLoading = false;
    });
  }

  Future<void> getMyfriednList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = "$url1/getFriendList";

    var map = new Map<String, dynamic>();
    map["login_id"] = prefs.getString("userId").toString();

    Map<String, String> headers = {
      "API-token": prefs.getString("api_token").toString()
    };

    final response = await http.post(url, body: map, headers: headers);
    final responseJson = json.decode(response.body);
    print("res getFriendList  " + responseJson.toString());

    setState(() {
      myfriendlist = responseJson["data"];
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
                          child: Text("My friends",
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
                          child: Text("Join invitation",
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
                    _isLoading == true
                        ? SpinKitRipple(color: cfooterpurple)
                        : Container(
                      child: RefreshIndicator(
                        onRefresh: getMyfriednList,
                        child: myfriendlist.toString()=="[]" ?
                        Container(
                          height: query.height,
                          width: query.width,
                          child: ListView(
                            children: [
                              SizedBox(height: query.height/3.5,),
                              Center(
                                child: Text("No Data",
                                  style: TextStyle(
                                    fontFamily: "SFPro",
                                  fontSize: medium,
                                  color: cBlack,
                                  fontWeight: FontWeight.w400,),),
                              ),
                            ],
                          ),
                        ): ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: myfriendlist == []? "": myfriendlist.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  onTap: () async {

                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    List<int> occupantsIds = [
                                      int.parse(prefs.getString("quickboxid")),
                                      int.parse(myfriendlist[index]["quickboxid"])
                                    ];

                                    int dialogType = QBChatDialogTypes.CHAT;
                                    print("occupantsIds ======= " + occupantsIds.toString());

                                    try {
                                      QBDialog createdDialog = await QB.chat
                                          .createDialog(occupantsIds, myfriendlist[index]["username"], dialogType: dialogType);

                                      if (createdDialog != null) {
                                        _dialogId = createdDialog.id;
                                        print("_dialogId   " + _dialogId);

                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType.fade,
                                                alignment: Alignment.bottomCenter,
                                                duration: Duration(milliseconds: 300),
                                                child: privateChat_page(myfriendlist[index],_dialogId)));
                                      } else {
                                        print("Else--------");
                                      }
                                    } on PlatformException catch (e) {
                                      print("qberror--- " + e.toString());
                                    }
                                  },
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [

                                      Text(
                                          myfriendlist[index]["username"].toString().length <= 14 ?
                                          myfriendlist[index]["username"].toString() :
                                          myfriendlist[index]["username"].toString().substring(0,14) + "..." ,
                                          style: TextStyle(
                                            fontFamily: "SFPro",
                                            fontSize: medium,
                                            color: cBlack,
                                            fontWeight: FontWeight.w400,
                                          )),
                                      FlatButton(
                                        height: 23.sp,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        color: cChatbackground,
                                        onPressed: () async {
                                          final ProgressDialog pr =
                                              _getProgress(context);
                                          pr.show();

                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          var url = "$url1/addRemoveFriends";

                                          var map = new Map<String, dynamic>();
                                          map["login_id"] = prefs
                                              .getString("userId")
                                              .toString();
                                          map["join_user"] = myfriendlist[index]
                                                  ["id"]
                                              .toString();
                                          map["join_status"] = "0";

                                          final response =
                                              await http.post(url, body: map);

                                          final responseJson =
                                              json.decode(response.body);
                                          print("login-- " +
                                              responseJson.toString());

                                          if (responseJson["status"]
                                                  .toString() ==
                                              "success") {
                                            displayToast(
                                                "Remove friend successfully");
                                            pr.hide().then(
                                                (value) => getMyfriednList());
                                          }
                                        },
                                        child: Text("Unfriend",
                                            style: TextStyle(
                                              fontFamily: "SFPro",
                                              fontSize: small,
                                              color: cBlack,
                                              fontWeight: FontWeight.w400,
                                            )),
                                      ),
                                    ],
                                  ),
                                  leading: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      child: FadeInImage(
                                          image: NetworkImage(
                                              myfriendlist[index]["image"]
                                                  .toString()),
                                          fit: BoxFit.cover,
                                          width: 30.sp,
                                          height: 30.sp,
                                          placeholder: AssetImage(
                                              "Assets/Images/giphy.gif"))),
                                ),
                              );
                            }),
                      ),
                    ),
                    _isLoading == true
                        ? SpinKitRipple(color: cfooterpurple)
                        : Container(
                      child: RefreshIndicator(
                        onRefresh: getInvitaionList,
                        color: cButtoncolor,
                        child: requestDetail.toString()=="[]" ?
                        Container(
                          height: query.height,
                          width: query.width,
                          child: ListView(
                            children: [
                              SizedBox(height: query.height/3.5,),
                              Center(
                                child: Text("No Data",
                                  style: TextStyle(
                                    fontFamily: "SFPro",
                                    fontSize: medium,
                                    color: cBlack,
                                    fontWeight: FontWeight.w400,),),
                              ),
                            ],
                          ),
                        ): ListView.builder(
                            physics: AlwaysScrollableScrollPhysics(),
                            itemCount: requestDetail==[]?"":requestDetail.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  onTap: () {},
                                  title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(width: 30.w,
                                            child: Text(requestDetail[index]["name"].toString().length <= 12 ?
                                            requestDetail[index]["name"].toString() :
                                            requestDetail[index]["name"].toString().substring(0,12) + "..." ,

                                                style: TextStyle(
                                                  fontFamily: "SFPro",
                                                  fontSize: medium,
                                                  color: cBlack,
                                                  fontWeight: FontWeight.w400,
                                                )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Image.asset(
                                                "Assets/Icons/private.png",
                                                color: cfooterGray,
                                                height: 2.h),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            onPressed: () {
                                              requestAction(0, index);
                                            },
                                            icon: Image.asset(
                                                "Assets/Icons/reject.png",
                                                width: 20.sp),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              requestAction(1, index);
                                            },
                                            icon: Image.asset(
                                                "Assets/Icons/accept.png",
                                                width: 20.sp),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  leading: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(100.0),
                                      child: FadeInImage(
                                          image: NetworkImage(
                                              requestDetail[index]["image"]
                                                  .toString()),
                                          fit: BoxFit.cover,
                                          width: 30.sp,
                                          height: 30.sp,
                                          placeholder: AssetImage(
                                              "Assets/Images/giphy.gif"))),
                                ),
                              );
                            }),
                      ),
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

  void joinDialog(int index) async {
    try {
      await QB.chat.joinDialog(requestDetail[index]["dialogId"]);

      requestAction(1, index);
      /*Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => chat_page(requestDetail[index])));*/
    } on PlatformException catch (e) {
      print("false " + e.toString());
    }
  }

  Future<void> requestAction(int status, int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final ProgressDialog pr = _getProgress(context);
    pr.show();
    var url = "$url1/invitationResponse";

    print(prefs.getString("userId").toString());
    print(requestDetail[index]["id"].toString());
    print(status.toString());
    var map = new Map<String, dynamic>();
    map["userid"] = prefs.getString("userId").toString();
    map["room_id"] = requestDetail[index]["id"].toString();
    map["req_response"] = status.toString();

    Map<String, String> headers = {
      "API-token": prefs.getString("api_token").toString()
    };

    final response = await http.post(url, body: map, headers: headers);
    final responseJson = json.decode(response.body);
    print("res invitationResponse  " + responseJson.toString());

    if (responseJson["status"].toString() == "success") {
      displayToast(responseJson["message"].toString());
      pr.hide().then((value) => getInvitaionList());

      if (status.toString() == "1") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => chat_page(requestDetail[index])));
      }
    }
  }
}
//1 1
ProgressDialog _getProgress(BuildContext context) {
  return ProgressDialog(context);
}
