import 'dart:convert';

import 'package:chatcity/Explore/userProfile_page.dart';
import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/Widgets/toastDisplay.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:chatcity/url.dart';
import 'package:http/http.dart' as http;

class roomInfo_page extends StatefulWidget {
  var roomId;

  var dialogId;

  roomInfo_page(this.roomId, this.dialogId);

  @override
  _roomInfo_pageState createState() => _roomInfo_pageState();
}

class _roomInfo_pageState extends State<roomInfo_page> {
  bool notification = false;
  int join = 0;
  List userList = [];
  final url1 = url.basicUrl;

  var roomdata;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getRoomInfo();
  }

  Future<void> getRoomInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = "$url1/showRoomDetails";

    var map = new Map<String, dynamic>();
    map["userid"] = prefs.getString("userId").toString();
    map["room_id"] = widget.roomId.toString();

    Map<String, String> headers = {
      "API-token": prefs.getString("api_token").toString()
    };

    final response = await http.post(url, body: map, headers: headers);
    final responseJson = json.decode(response.body);
    print("res showRoomDetails  " + responseJson.toString());

    setState(() {
      userList = responseJson["data"]["users"];
      roomdata = responseJson["data"];
      _isLoading = false;
    });


  }
  void leaveDialog() async {
    try {
      await QB.chat.leaveDialog(widget.dialogId);
      print("Success");
      Navigator.pop(context);
      Navigator.pop(context);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: cwhite,
      appBar: commanAppBar(
        appBar: AppBar(),
        imageIcon: Container(),
        groupImage: Container(),
        fontsize: medium,
        imageBack: true,
        appbartext: "Room Info",
        colorImage: cwhite,
        widgets: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0, top: 12, bottom: 12),
            child: InkWell(
              /*onTap: () async {
                if (join == 0) {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();

                  var url = "$url1/joinRoom";

                  var map = new Map<String, dynamic>();
                  map["userid"] = prefs.getString("userId").toString();
                  map["room_id"] = widget.roomId.toString();
                  map["notification"] = notification == true ? "1" : "0";

                  Map<String, String> headers = {
                    "API-token": prefs.getString("api_token").toString()
                  };

                  final response =
                      await http.post(url, body: map, headers: headers);
                  final responseJson = json.decode(response.body);
                  print("res joinRoom  " + responseJson.toString());
                  setState(() {
                    join = 1;
                  });
                } else {
                  //join = 1;
                  displayToast("Exit room");
                }
              },*/
              onTap: (){
                leaveDialog();
              },
              child: Container(
                //width: query.width * 0.17,
                decoration: BoxDecoration(
                  border: Border.all(color: cwhite, width: 1),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: cwhite,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Center(
                    child: Text("EXIT ROOM",
                        style: TextStyle(
                            fontFamily: "SFPro",
                            fontWeight: FontWeight.w600,
                            color: cfooterpurple,
                            fontSize: small)),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
      body: _isLoading == true
          ? SpinKitRipple(color: cfooterpurple)
          : Container(
              height: query.height,
              width: query.width,
              color: cwhite,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: FadeInImage(
                            image: NetworkImage(roomdata["image"].toString()),
                            fit: BoxFit.cover,
                            width: 90.sp,
                            height: 90.sp,
                            placeholder:
                                AssetImage("Assets/Images/giphy.gif"))),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(roomdata["name"].toString(),
                          style: TextStyle(
                              fontFamily: "SFPro",
                              fontWeight: FontWeight.w700,
                              color: cBlack,
                              fontSize: medium)),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Text("NOTIFICATION",
                                  style: TextStyle(
                                      fontFamily: "SFPro",
                                      fontWeight: FontWeight.w600,
                                      color: cfooterpurple,
                                      fontSize: 12.sp)),
                            ),
                          ],
                        ),
                        Container(
                          height: 40.sp,
                          width: query.width,
                          decoration: BoxDecoration(
                              border: Border.all(color: gray, width: 1),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Enable push notification",
                                    style: TextStyle(
                                        fontFamily: "SFPro",
                                        fontWeight: FontWeight.w500,
                                        color: cBlack,
                                        fontSize: medium)),
                              ),
                              Checkbox(
                                value: notification,
                                onChanged: (value) {
                                  setState(() {
                                    setState(() {
                                      notification = value;
                                    });
                                  });
                                },
                                side: BorderSide(color: gray, width: 2),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4)),
                                checkColor: cwhite,
                                activeColor: cfooterpurple,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20.0, bottom: 10),
                              child: Text("ROOM TYPE",
                                  style: TextStyle(
                                      fontFamily: "SFPro",
                                      fontWeight: FontWeight.w600,
                                      color: cfooterpurple,
                                      fontSize: 12.sp)),
                            ),
                          ],
                        ),
                        Container(
                          height: 30.sp,
                          width: query.width,
                          decoration: BoxDecoration(
                              border: Border.all(color: gray, width: 1),
                              borderRadius: BorderRadius.circular(5.0)),
                          child: Center(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                      roomdata["type"].toString() == "0"
                                          ? "Public"
                                          : "Private",
                                      style: TextStyle(
                                          fontFamily: "SFPro",
                                          fontWeight: FontWeight.w500,
                                          color: cBlack,
                                          fontSize: medium)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 10),
                          child: Row(
                            children: [
                              Text("ROOM USERS",
                                  style: TextStyle(
                                      fontFamily: "SFPro",
                                      fontWeight: FontWeight.w600,
                                      color: cfooterpurple,
                                      fontSize: 12.sp)),
                            ],
                          ),
                        ),
                        Container(
                          height: query.height / 4.0,
                          child: ListView.builder(
                              physics: AlwaysScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: userList.length,
                              itemBuilder: (context, index) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                PageTransition(
                                                    type:
                                                        PageTransitionType.fade,
                                                    alignment:
                                                        Alignment.bottomCenter,
                                                    duration: Duration(
                                                        milliseconds: 300),
                                                    child: userProfile_page(
                                                        userList[index])));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        100.0),
                                                child: FadeInImage(
                                                    image: NetworkImage(
                                                        userList[index]["image"]
                                                            .toString()),
                                                    fit: BoxFit.cover,
                                                    width: 25.sp,
                                                    height: 25.sp,
                                                    placeholder: AssetImage(
                                                        "Assets/Images/giphy.gif"))),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                              userList[index]["username"]
                                                  .toString(),
                                              style: TextStyle(
                                                  fontFamily: "SFPro",
                                                  fontWeight: FontWeight.w500,
                                                  color: cBlack,
                                                  fontSize: medium)),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          roomdata["created_by"].toString() ==
                                                  userList[index]["id"]
                                                      .toString()
                                              ? "Admin"
                                              : "",
                                          style: TextStyle(
                                              fontFamily: "SFPro",
                                              fontWeight: FontWeight.w500,
                                              color: cOrange,
                                              fontSize: 12.sp)),
                                    ),
                                  ],
                                );
                              }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
/*
Sign In
- Registration with email - get OTP
- SignUp with quickblox registration
- forget Password(app side completed, sent change password link to user's mailbox successfully)
- terms of service by api
- login with quickblox login
- google, facebook, apple(app side completed, remaining to registere in database)
Explore page
- search
- All group list
  - Chat successfully
  - Room info page
  - Add friend
All rooms page
- MyRooms list
- joined Room list
create Room
- public room
  - chat successfully
- private room
  - send request to friend
  - chat successfully
Request page
- My friend list
  - Unfriend
- join invitaion list
setting page
- My profile(Edit - Update)
- change password
- Terms and condition
- shareApp(Just remain to set store link)
- Logout

- remove join room button and functionality
- need one api - for public room
- explore page -
*/
