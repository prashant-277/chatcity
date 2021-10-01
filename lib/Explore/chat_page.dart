import 'package:chatcity/Explore/roomInfo_page.dart';
import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_filter.dart';
import 'package:quickblox_sdk/models/qb_message.dart';
import 'package:quickblox_sdk/models/qb_sort.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class chat_page extends StatefulWidget {
  var roomData;

  chat_page(this.roomData);

  @override
  _chat_pageState createState() => _chat_pageState();
}

class _chat_pageState extends State<chat_page> {
  TextEditingController chat_controller = TextEditingController();
  ScrollController _scrollController = ScrollController();

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  List message = [];
  String chatmessage = "";
  String userId, _messageId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    print("hhhh ----- " + widget.roomData.toString());
    getuserId();
    getDialogMessages();
  }

  getuserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("quickboxid").toString();
    });
  }

  Future<List> getDialogMessages() async {
    QBSort sort = QBSort();
    sort.field = QBChatDialogSorts.LAST_MESSAGE_DATE_SENT;
    sort.ascending = true;

    try {
      List<QBMessage> messages = await QB.chat
          .getDialogMessages(widget.roomData["dialogId"].toString());
      int countMessages = messages.length;

      if (countMessages > 0) {
        _messageId = messages[0].id;
        print("_messageId " + _messageId);
      }
//      print("_messageId " + countMessages.toString());
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
        appbartext: widget.roomData["name"].toString(),
        groupImage: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: FadeInImage(
                  image: NetworkImage(widget.roomData["image"].toString()),
                  fit: BoxFit.cover,
                  width: 20.sp,
                  height: 20.sp,
                  placeholder: AssetImage("Assets/Images/giphy.gif"))),
        ),
        imageIcon: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            widget.roomData["type"].toString() == "0"
                ? "Assets/Icons/public.png"
                : "Assets/Icons/private.png",
            height: 2.h,
            color: cwhite,
          ),
        ),
        fontsize: medium,
        widgets: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            alignment: Alignment.bottomCenter,
                            duration: Duration(milliseconds: 300),
                            child: roomInfo_page(widget.roomData["id"],widget.roomData["dialogId"])));
                  },
                  icon: Image.asset("Assets/Icons/info.png", width: 6.w))),
        ],
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
                                left: 12, right: 12, top: 5, bottom: 5),
                            child: Align(
                              alignment:
                                  (snapshot.data[index].senderId.toString() ==
                                          userId.toString()
                                      ? Alignment.topRight
                                      : Alignment.topLeft),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: snapshot.data[index].senderId
                                              .toString() ==
                                          userId.toString()
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
                                      color: snapshot.data[index].senderId
                                                  .toString() ==
                                              userId.toString()
                                          ? cwhite
                                          : cBlack),
                                ),
                              ),
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
                    textCapitalization: TextCapitalization.words,
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
                  onTap: () {
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

  void sendMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      Map<String, String> properties = Map();
      properties["testProperty1"] = "testPropertyValue1";
      properties["testProperty2"] = "testPropertyValue2";
      properties["testProperty3"] = "testPropertyValue3";
      print(prefs.getString("_dialogId").toString());
      await QB.chat.sendMessage(widget.roomData["dialogId"],
          body: chatmessage, saveToHistory: true, properties: properties);
      print("rec -------------");
    } on PlatformException catch (e) {
      print("send " + e.toString());
    }
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
}