import 'dart:async';
import 'dart:convert';

import 'package:chatcity/Explore/chat_page.dart';
import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/Widgets/toastDisplay.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quickblox_sdk/auth/module.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:chatcity/url.dart';
import 'package:http/http.dart' as http;

import '../data_holder.dart';

class friend_invitePage extends StatefulWidget {
  var groupImage;
  var groupName;

  friend_invitePage(this.groupName, this.groupImage);

  /*var roomData;

  friend_invitePage(this.roomData);*/

  @override
  _friend_invitePageState createState() => _friend_invitePageState();
}

class _friend_invitePageState extends State<friend_invitePage>{
  List select = [];
  List oopID = [];
  List userIDs = [];
  List userList = [];
  var roomData;
  final url1 = url.basicUrl;
  String _dialogId;
  bool _isLoading = true;
  TextEditingController search_ctrl = TextEditingController();
  int search = 0;


  @override
  void initState() {
    super.initState();
    getFriendlist();
  }

  Future<void> getFriendlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = "$url1/getUserList";

    var map = new Map<String, dynamic>();
    map["userid"] = prefs.getString("userId").toString();

    Map<String, String> headers = {
      "API-token": prefs.getString("api_token").toString()
    };

    final response = await http.post(Uri.parse(url), body: map, headers: headers);
    final responseJson = json.decode(response.body);
    print("res getUserList  " + responseJson.toString());

    setState(() {
      userList = responseJson["data"];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: cwhite,
        floatingActionButton: FloatingActionButton(
          child: Image.asset("Assets/Icons/create1.png"),
          elevation: 0,
          onPressed: () {
            //login();
            final ProgressDialog pr = _getProgress(context);
            pr.show();
            isConnected();

          },
        ),
        appBar: search == 0? commanAppBar(
          appBar: AppBar(),
          fontsize: medium,
          appbartext: "Invite your friend",
          imageBack: true,
          colorImage: cwhite,
          groupImage: Container(),
          imageIcon: Container(),
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
        ): AppBar(
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
                    getFriendlist();
                    search_ctrl.text = "";
                  });
                },
                icon: Icon(Icons.cancel_outlined))
          ],
        ),
        body: Scaffold(
          appBar: AppBar(
            backgroundColor: cwhite,
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Row(
              children: [
                Text(
                    oopID.length.toString() +
                        " of " +
                        userList.length.toString() +
                        " selected",
                    style: TextStyle(
                      fontFamily: "SFPro",
                      fontSize: 12.sp,
                      color: cBlack,
                      fontWeight: FontWeight.w400,
                    )),
              ],
            ),
          ),
          body: RefreshIndicator(
            onRefresh: getFriendlist,
            color: cButtoncolor,
            child: _isLoading == true
                ? SpinKitRipple(color: cfooterpurple)
                : Container(
                    height: query.height,
                    width: query.width,
                    color: cwhite,
                    child: ListView.builder(
                      physics: AlwaysScrollableScrollPhysics(),
                      itemCount: userList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              tileColor: select.contains(userList[index]["id"]) ? Colors.green[200] : cwhite,
                              contentPadding: EdgeInsets.zero,
                              onTap: () {
                                setState(() {
                                  if (select.contains(userList[index]["id"])) {
                                    select.remove(userList[index]["id"]);
                                    oopID.remove(int.parse(
                                        userList[index]["quickboxid"].toString()));
                                    userIDs.remove(int.parse(
                                        userList[index]["id"].toString()));


                                  } else {
                                    select.add(userList[index]["id"]);
                                    oopID.add(int.parse(
                                        userList[index]["quickboxid"].toString()));
                                    userIDs.add(int.parse(
                                        userList[index]["id"].toString()));
                                  }
                                  print(oopID);
                                  print(userIDs);
                                });
                              },
                              title: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(userList[index]["username"].toString(),
                                          style: TextStyle(
                                            fontFamily: "SFPro",
                                            fontSize: medium,
                                            color: cBlack,
                                            fontWeight: FontWeight.w400,
                                          )),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20.0),
                                      child: select.contains(userList[index]["id"])
                                          ? Image.asset("Assets/Icons/selected.png",
                                              width: 16.sp)
                                          : Container(),
                                    )
                                  ],
                                ),
                              ),
                              leading: Padding(
                                  padding: const EdgeInsets.only(left: 30.0),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100.0),
                                      child: FadeInImage(
                                          image: NetworkImage(
                                              userList[index]["image"].toString()),
                                          fit: BoxFit.cover,
                                          width: 30.sp,
                                          height: 30.sp,
                                          placeholder: AssetImage(
                                              "Assets/Images/giphy.gif")))),
                            ),
                            SizedBox(height: 0.2.h,)
                          ],
                        );
                      },
                    ),
                  ),
          ),
        ));
  }

  Future<void> login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      QBLoginResult result = await QB.auth
          .login(prefs.getString("userEmail").toString(), USER_PASSWORD);

      QBUser qbUser = result.qbUser;
      QBSession qbSession = result.qbSession;

      qbSession.applicationId = int.parse(APP_ID);

      DataHolder.getInstance().setSession(qbSession);
      DataHolder.getInstance().setUser(qbUser);

      print("user id login" + qbUser.id.toString());
      isConnected();
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void isConnected() async {
    try {
      bool connected = await QB.chat.isConnected();
      connected == true ? createDialog() : connect();
    } on PlatformException catch (e) {
      print("false");
    }
  }

  void connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      await QB.chat
          .connect(int.parse(prefs.getString("quickboxid")), USER_PASSWORD);

      print(int.parse(prefs.getString("quickboxid")));
      createDialog();
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  void createDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<int> occupantsIds = new List<int>.from(oopID);
    String dialogName = widget.groupName.toString();

    int dialogType = QBChatDialogTypes.GROUP_CHAT;

    try {
      QBDialog createdDialog = await QB.chat
          .createDialog(occupantsIds, dialogName, dialogType: dialogType);

      if (createdDialog != null) {
        _dialogId = createdDialog.id;
        prefs.setString("_dialogId", _dialogId);

        createPrivateRoom(_dialogId);
        /*Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                alignment: Alignment.bottomCenter,
                duration: Duration(milliseconds: 300),
                child: chat_page(widget.roomData)));*/
        print("Dialog id" + _dialogId);
      } else {
        print("Else");
      }
    } on PlatformException catch (e) {
      print(e);
      displayToast("Room is not creating, Try after sometime");
    }
  }

  Future<void> createPrivateRoom(String dialogId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final ProgressDialog pr = _getProgress(context,);

    pr.show();
    print(prefs.getString("userId").toString());
    print(widget.groupName.toString());
    print(_dialogId.toString());
    print(oopID.toString());
    print(widget.groupImage.toString());
    print(userIDs.toString());

    var postUri = Uri.parse("$url1/createRoom");
    var request = new http.MultipartRequest("POST", postUri);
    request.fields['userid'] = prefs.getString("userId").toString();
    request.fields['name'] = widget.groupName.toString();
    request.fields['type'] = "1";
    request.fields['dialogId'] = _dialogId.toString();
    request.fields['occupantsId'] = oopID.toString();
    request.fields['requestUser'] = userIDs.toString();


    request.headers["API-token"] = prefs.getString("api_token").toString();

    widget.groupImage != null
        ? request.files
            .add(await MultipartFile.fromPath('image', widget.groupImage))
        : request.fields["image"] = "";

    request.send().then((response) async {
      if (response.statusCode == 200) {
        print("Uploaded!");

        print("--------> " + response.statusCode.toString());

        final responseStream = await response.stream.bytesToString();
        final responseJson = json.decode(responseStream);

        print("createRoom -- " + responseJson.toString());
        if (responseJson["status"].toString() == "success") {
          displayToast(responseJson["message"].toString());

          setState(() {
            roomData = responseJson["data"];

          });

          pr.hide();
          Timer(
              Duration(seconds: 1),
              () => Navigator.pushReplacement(
                  context,
                  PageTransition(
                      type: PageTransitionType.fade,
                      alignment: Alignment.bottomCenter,
                      duration: Duration(milliseconds: 300),
                      child: chat_page(roomData))));
        } else {
          pr.hide();
          displayToast(responseJson["message"].toString());
        }
      } else {
        final responseStream = await response.stream.bytesToString();
        final responseJson = json.decode(responseStream);
        displayToast("Room is not creating, Try after sometime");
        pr.hide();
        print("Not Uploaded");
      }
    });
  }
  Future<void> searchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = "$url1/SearchFriend";
    var map = new Map<String, dynamic>();
    map["userid"] = prefs.getString("userId").toString();
    map["search"] = search_ctrl.text.toString();

    Map<String, String> headers = {
      "API-token": prefs.getString("api_token").toString()
    };

    final response = await http.post(Uri.parse(url), body: map, headers: headers);
    final responseJson = json.decode(response.body);
    print("res SearchFriend  " + responseJson.toString());

    if (responseJson["status"].toString() == "success") {
      setState(() {
        userList = responseJson["data"];

        if (search_ctrl.text.toString() == "") {
          getFriendlist();
        }
      });
      //displayToast(responseJson["message"].toString());

    }
  }
}

ProgressDialog _getProgress(BuildContext context) {
  return ProgressDialog(context,isDismissible: false);
}
