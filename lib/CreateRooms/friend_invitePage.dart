import 'dart:convert';

import 'package:chatcity/Explore/chat_page.dart';
import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
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
  var roomData;

  friend_invitePage(this.roomData);

  @override
  _friend_invitePageState createState() => _friend_invitePageState();
}

class _friend_invitePageState extends State<friend_invitePage> {
  List select = [];
  List oopID = [];
  List userList = [];
  final url1 = url.basicUrl;
  String _dialogId;
  bool _isLoading = true;

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

    final response = await http.post(url, body: map, headers: headers);
    final responseJson = json.decode(response.body);
    print("res getUserList  " + responseJson.toString());

    setState(() {
      userList = responseJson["data"];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var query = MediaQuery
        .of(context)
        .size;
    return Scaffold(
        backgroundColor: cwhite,
        floatingActionButton: FloatingActionButton(
          child: Image.asset("Assets/Icons/create1.png"),
          elevation: 0,
          onPressed: () {
            login();
          },
        ),
        appBar: commanAppBar(
          appBar: AppBar(),
          fontsize: medium,
          appbartext: "Invite your friend",
          imageBack: true,
          colorImage: cwhite,
          groupImage: Container(),
          imageIcon: Container(),
          widgets: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: () {},
                  icon: Image.asset(
                    "Assets/Icons/search.png",
                    width: 5.w,
                  )),
            )
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
                  return ListTile(
                    //selectedTileColor: Color(0xFFD1C4E9),
                    contentPadding: EdgeInsets.zero,
                    onTap: () {
                      setState(() {
                        if (select.contains(index)) {
                          select.remove(index);
                          oopID.remove(int.parse(
                              userList[index]["quickboxid"].toString()));
                        } else {
                          select.add(index);
                          oopID.add(int.parse(
                              userList[index]["quickboxid"].toString()));
                        }
                        print(oopID);
                      });
                    },
                    title: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(userList[index]["username"].toString(),
                              style: TextStyle(
                                fontFamily: "SFPro",
                                fontSize: medium,
                                color: cBlack,
                                fontWeight: FontWeight.w400,
                              )),
                          Padding(
                            padding: const EdgeInsets.only(right: 20.0),
                            child: select.contains(index)
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

      print("user id login"+qbUser.id.toString());
      isConnected();
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void isConnected() async {
    try {
      bool connected = await QB.chat.isConnected();
      connected==true? createDialog():connect();

    } on PlatformException catch (e) {
      print("false");
    }
  }
  void connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      await QB.chat.connect(int.parse(prefs.getString("quickboxid")), USER_PASSWORD);

      print(int.parse(prefs.getString("quickboxid")));
      createDialog();
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  void createDialog() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<int> occupantsIds = new List<int>.from(oopID);
    String dialogName = "Private Room" + DateTime.now().millisecond.toString();


    int dialogType = QBChatDialogTypes.GROUP_CHAT;

    try {
      QBDialog createdDialog = await QB.chat.createDialog(
          occupantsIds, dialogName,
          dialogType: dialogType);

      if (createdDialog != null) {
        _dialogId = createdDialog.id;
        prefs.setString("_dialogId", _dialogId);


        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.fade,
                alignment: Alignment.bottomCenter,
                duration: Duration(milliseconds: 300),
                child: chat_page(widget.roomData)));
        print("Dialog id"+_dialogId);
      }else{
        print("Else");
      }

    } on PlatformException catch (e) {
      print(e);
    }
  }

}
