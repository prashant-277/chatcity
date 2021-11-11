import 'dart:async';
import 'dart:convert';

import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_message.dart';
import 'package:quickblox_sdk/models/qb_sort.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:chatcity/url.dart';

class privateChat_page extends StatefulWidget {
  var userList;

  privateChat_page(this.userList);



  @override
  _privateChat_pageState createState() => _privateChat_pageState();
}

class _privateChat_pageState extends State<privateChat_page> {
  String userId, _messageId;
  String chatmessage = "";
  bool _isLoading = false;
  TextEditingController chat_controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  DateTime now = DateTime.now();
  final url1 = url.basicUrl;
  Timer mytimer;

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }
  @override
  void initState() {
    super.initState();
    mytimer = Timer.periodic(Duration(milliseconds: 3000), (timer) {
    });
    getDialogMessages();
    //createPushSubscription();
  }

  @override
  void dispose() {
    if (mytimer != null) {
      mytimer.cancel();
      mytimer = null;
    }
    super.dispose();
  }

  Future<List> getDialogMessages() async {
    QBSort sort = QBSort();
    sort.field = QBChatDialogSorts.LAST_MESSAGE_DATE_SENT;
    sort.ascending = true;

    try {
      List<QBMessage> messages = await QB.chat
          .getDialogMessages(widget.userList["dialogId"].toString());
      int countMessages = messages.length;

      if (countMessages > 0) {
        _messageId = messages[0].id;
      }
      setState(() {
        _isLoading = false;
      });

      return messages;
    } on PlatformException catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cChatbackground,
      appBar: commanAppBar(
        appBar: AppBar(),
        imageBack: true,
        colorImage: cwhite,

        appbartext: widget.userList["username"].toString().length <= 20 ?
        widget.userList["username"].toString() :
        widget.userList["username"].toString().substring(0,20) + "..." ,
        groupImage: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: FadeInImage(
                  image: NetworkImage(widget.userList["image"].toString()),
                  fit: BoxFit.cover,
                  width: 20.sp,
                  height: 20.sp,
                  placeholder: AssetImage("Assets/Images/giphy.gif"))),
        ),
        imageIcon: Container(),
        fontsize: medium,

      ),
      body: Container(
          child: _isLoading == true
              ? SpinKitRipple(color: cfooterpurple)
              : StreamBuilder(
              stream: Stream.periodic(Duration(seconds: 1))
                  .asyncMap((i) => getDialogMessages()),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => _scrollToBottom());
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: snapshot.data.length,
                    padding: EdgeInsets.only(top: 5, bottom: 75),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.only(
                            left: 13, right: 13, top: 8, bottom: 8),
                        child: Row(
                          mainAxisAlignment:
                          snapshot.data[index].senderId.toString() ==
                              widget.userList["quickboxid"].toString()
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            snapshot.data[index].senderId.toString() ==
                                widget.userList["quickboxid"].toString()
                                ? ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: FadeInImage(
                                image: NetworkImage(widget.userList["image"].toString() == "null"
                                    ? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
                                    : widget.userList["image"].toString()),
                                fit: BoxFit.fill,
                                width: 18.sp,
                                height: 18.sp,
                                placeholder: AssetImage("Assets/Images/giphy.gif")))
                                : Text(""),
                            /*ClipRRect(
                            borderRadius:
                            BorderRadius.circular(100.0),
                            child: FadeInImage(
                                image: NetworkImage(imgUrl),
                                fit: BoxFit.fill,
                                width: 18.sp,
                                height: 18.sp,
                                placeholder: AssetImage(
                                    "Assets/Images/giphy.gif"))),*/

                            SizedBox(
                              width: 2.w,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: snapshot.data[index].senderId
                                    .toString() !=
                                    widget.userList["quickboxid"].toString()
                                    ? BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(1))
                                    : BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    bottomRight: Radius.circular(15),
                                    topLeft: Radius.circular(1),
                                    topRight: Radius.circular(15)),
                                gradient: snapshot.data[index].senderId
                                    .toString() !=
                                    widget.userList["quickboxid"].toString()
                                    ? LinearGradient(colors: [
                                  Color(0xff382177),
                                  Color(0xff9760A4)
                                ])
                                    : LinearGradient(colors: [gray, gray]),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Text(
                                snapshot.data[index].body.toString(),
                                style: TextStyle(
                                    fontSize: small,
                                    color: snapshot.data[index].senderId
                                        .toString() !=
                                        widget.userList["quickboxid"].toString()
                                        ? cwhite
                                        : cBlack),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }
                return Center(
                    child: Text(
                      "Loading...",
                      style: TextStyle(
                          color: cBlack, fontFamily: "SFPro", fontSize: medium),
                    ));
              })),
      bottomSheet: Container(
          color: cwhite,
          height: 55.sp,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 1.25,
                  decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(50.0)),
                  height: 35.sp,
                  child: TextField(
                    controller: chat_controller,
                    onChanged: (value) {
                      setState(() {
                        chatmessage = value;
                      });
                    },
                    style: TextStyle(
                        fontFamily: "SFPro", color: cBlack, fontSize: medium),
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          borderSide:
                          BorderSide(color: cChatbackground, width: 1)),
                      contentPadding:
                      EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),
                          borderSide:
                          BorderSide(color: cChatbackground, width: 1)),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        borderSide: BorderSide(
                          color: cChatbackground,
                          width: 2.0,
                        ),
                      ),
                      filled: true,
                      hintStyle: TextStyle(
                          color: cGray, fontFamily: "SFPro", fontSize: medium),
                      hintText: "Type a Message...",
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                InkWell(
                  onTap: chat_controller.text.length==0 ? (){} :  () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                    setState(() {
                      chat_controller.clear();
                    });
                    isConnected();
                  },
                  child: Image.asset(
                    "Assets/Icons/send.png",
                    height: 5.0.h,
                  ),
                )
              ],
            ),
          )),
    );
  }

  void isConnected() async {
    try {
      bool connected = await QB.chat.isConnected();
      connected == true ? sendMessage() : connect();
    } on PlatformException catch (e) {
      print(e);
    }
  }
  void connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      await QB.chat
          .connect(int.parse(prefs.getString("quickboxid")), USER_PASSWORD);
      sendMessage();
      print("id ---- " + int.parse(prefs.getString("quickboxid")).toString());
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  void sendMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map<String, String> properties = Map();
      properties["testProperty1"] = "testPropertyValue1";
      properties["testProperty2"] = "testPropertyValue2";
      properties["testProperty3"] = "testPropertyValue3";

      await QB.chat.sendMessage(widget.userList["dialogId"],
          body: chatmessage, saveToHistory: true, properties: properties);
      print("rec -------------");
      //createNotification();
      //saveLastMessage();
    } on PlatformException catch (e) {
      print("send " + e.toString());
    }
  }

  Future<void> saveLastMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = "$url1/sendMessage";

    print(prefs.getString("userId").toString());
    print(widget.userList["id"].toString());
    print(chatmessage.toString());
    print("sendMessage ---- " + now.toString());

    var map = new Map<String, dynamic>();
    map["userid"] = prefs.getString("id").toString();
    map["room_id"] = widget.userList["id"].toString();
    map["message"] = chatmessage.toString();
    map["createdTime"] = now.toString();

    Map<String, String> headers = {
      "API-token": prefs.getString("api_token").toString()
    };

    final response = await http.post(url, body: map, headers: headers);
    final responseJson = json.decode(response.body);
    print("res sendMessage  " + responseJson.toString());
  }

  Widget get_Image(String senderId) {
    var url;
      if (widget.userList["quickboxid"].toString() != senderId.toString()) {
        url =widget.userList["image"].toString();

        print("image ---- " + widget.userList["image"].toString());

      }
    return ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: FadeInImage(
            image: NetworkImage(url.toString() == "null"
                ? "https://www.pngitem.com/pimgs/m/146-1468479_my-profile-icon-blank-profile-picture-circle-hd.png"
                : url.toString()),
            fit: BoxFit.fill,
            width: 18.sp,
            height: 18.sp,
            placeholder: AssetImage("Assets/Images/giphy.gif")));
  }

}
