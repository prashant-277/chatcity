import 'dart:convert';
import 'dart:io';

import 'package:chatcity/Explore/privateChat_page.dart';
import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/Widgets/buttons.dart';
import 'package:chatcity/Widgets/toastDisplay.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'chat_page.dart';
import 'package:http/http.dart' as http;
import 'package:chatcity/url.dart';

class userProfile_page extends StatefulWidget {
  var userList;

  var roomdata;

  userProfile_page(this.userList, this.roomdata);


  @override
  _userProfile_pageState createState() => _userProfile_pageState();
}

class _userProfile_pageState extends State<userProfile_page> {
  final url1 = url.basicUrl;
  String name,
      image,
      email,
      quickboxid,is_Friend,userid = "";
  var userData;
  bool _isLoading = true;
  String _dialogId;

  @override
  void initState() {
    super.initState();
    getUserDetails();
    print("ddd " + widget.userList.toString());
    print("ddd roomdata " + widget.roomdata.toString());
  }

  Future<void> getUserDetails() async {
    final ProgressDialog pr = _getProgress(context);
    pr.show();

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
      userData = responseJson["data"];
      name = responseJson["data"]["username"].toString();
      image = responseJson["data"]["image"].toString();
      email = responseJson["data"]["email"].toString();
      quickboxid = responseJson["data"]["quickboxid"];
      is_Friend = responseJson["data"]["is_Friend"].toString();
      userid = prefs.getString("userId").toString();
      _isLoading = false;
      pr.hide();
    });
  }

  @override
  Widget build(BuildContext context) {
    var query = MediaQuery
        .of(context)
        .size;
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
              userid == widget.userList["id"].toString() ? Container() : Container(
                  width: 90.w,
                  height: 7.5.h,
                  child:
                  basicButton(cwhite, () async {
                    if(is_Friend=="0"){
                      addfriend();

                    }else{
                      displayToast(name.toString()+" is already your friend");
                    }


                  }, "+ Add friend", cgreen)),
              SizedBox(height: 2.h),
              userid == widget.userList["id"].toString() ? Container() : Container(
                  width: 90.w,
                  height: 7.5.h,
                  child: basicButton(
                      cwhite, () async {

                    if(userData["dialogId"].toString()=="null"){

                      createDialog();

                    }else{
                      _dialogId = userData["dialogId"].toString();
                      updateDialog();

                    }


                  }, "Open private chat", cButtoncolor)),
              SizedBox(height: 2.h),
              /*userid == widget.userList["id"].toString() ? Container() :   Container(
                  width: 90.w,
                  height: 7.5.h,
                  child: basicButton(cwhite, () async {}, "Block", cOrange)),*/
            ],
          ),
        ),
      ),
    );
  }

  Future<void>  addfriend() async {
    final ProgressDialog pr = _getProgress(context);
    pr.show();

    SharedPreferences prefs =
        await SharedPreferences.getInstance();
    var url = "$url1/addRemoveFriends";

    var map = new Map<String, dynamic>();

    map["login_id"] = prefs.getString("userId").toString();
    map["join_user"] =widget.userList["id"].toString();
    map["join_status"] ="1";


    final response = await http.post(url, body: map);

    final responseJson = json.decode(response.body);
    print("addRemoveFriends-- " + responseJson.toString());

    if (responseJson["status"].toString() == "success") {
      displayToast("Add friend successfully");

      pr.hide().then((value) => getUserDetails());
    }else{
      pr.hide();
    }
  }

  void createDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<int> occupantsIds = [int.parse(prefs.getString("quickboxid")), int.parse(quickboxid)];

    int dialogType = QBChatDialogTypes.CHAT;
    print("occupantsIds ======= "+ occupantsIds.toString());

    try {
      QBDialog createdDialog = await QB.chat
          .createDialog(occupantsIds, name, dialogType: dialogType);

      if (createdDialog != null) {
        _dialogId = createdDialog.id;
        print("_dialogId   "+_dialogId);

        updateDialog();
        /* Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                alignment: Alignment.bottomCenter,
                duration: Duration(milliseconds: 300),
                child: privateChat_page(widget.userList)));*/

      } else {
        print("Else--------");
      }
    } on PlatformException catch (e) {
      print("qberror--- " + e.toString());
    }
  }

  Future<void> updateDialog() async {
    final ProgressDialog pr = _getProgress(context);
    pr.show();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = "$url1/updateDialogid";


    var map = new Map<String, dynamic>();

    print("get_user_id " + widget.userList["id"].toString());
    print("user_id "+prefs.getString("userId").toString());
    print("_dialogId "+_dialogId.toString());

    map["get_user_id"] = widget.userList["id"].toString();
    map["user_id"] = prefs.getString("userId").toString();
    map["dialogId"] = _dialogId.toString();

    Map<String, String> headers = {
      "API-token": prefs.getString("api_token").toString()
    };

    final response = await http.post(url, body: map, headers: headers);

    final responseJson = json.decode(response.body);

    print("updateDialogid-- " + responseJson.toString());

    if (responseJson["status"].toString() == "success") {
      pr.hide();

      Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                alignment: Alignment.bottomCenter,
                duration: Duration(milliseconds: 300),
                child: privateChat_page(userData)));
    }else{
      pr.hide();
    }
  }
}
  ProgressDialog _getProgress(BuildContext context) {
    return ProgressDialog(context);
  }