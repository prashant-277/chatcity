import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickblox_sdk/auth/module.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/models/qb_session.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants.dart';
import 'data_holder.dart';

class testPage extends StatefulWidget {
  const testPage({Key key}) : super(key: key);

  @override
  _testPageState createState() => _testPageState();
}

class _testPageState extends State<testPage> {
  String _dialogId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("test"),
        ),
        body: Container(
          height: 500,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              /*FlatButton(onPressed: (){init();}, child: Text("Init")),
            FlatButton(onPressed: (){createUser();}, child: Text("createUser")),
            FlatButton(onPressed: (){login();}, child: Text("Login")),
            FlatButton(onPressed: (){connect();}, child: Text("Connect")),*/
              FlatButton(
                  onPressed: () {
                    createDialog();
                  },
                  child: Text("create dialog")),
              // FlatButton(onPressed: (){sendMessage();}, child: Text("send message")),
              // FlatButton(onPressed: (){logout();}, child: Text("logout")),
            ],
          ),
        ));
  }

  void init() async {
    try {
      await QB.settings.init(APP_ID, AUTH_KEY, AUTH_SECRET, ACCOUNT_KEY);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<int> createUser() async {
    int userId;
    try {
      QBUser user = await QB.users.createUser("test2@gmail.com", USER_PASSWORD);
      userId = user.id;
    } on PlatformException catch (e) {}
    print("userId " + userId.toString());
    return userId;
  }

  Future<void> login() async {
    try {
      QBLoginResult result =
          await QB.auth.login("abc@gmail.com", USER_PASSWORD);

      QBUser qbUser = result.qbUser;
      QBSession qbSession = result.qbSession;

      qbSession.applicationId = int.parse(APP_ID);

      DataHolder.getInstance().setSession(qbSession);
      DataHolder.getInstance().setUser(qbUser);
      print(qbUser.id.toString());
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void connect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      await QB.chat.connect(130787759, USER_PASSWORD);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void createDialog() async {
    List<int> occupantsIds = List.from([132079020,132078978]);
    String dialogName = "Test" + DateTime.now().millisecond.toString();
    String dialogPhoto = "some photo url";

    int dialogType = QBChatDialogTypes.CHAT;

    try {
      QBDialog createdDialog = await QB.chat.createDialog(
          occupantsIds, dialogName,
          dialogType: dialogType, dialogPhoto: dialogPhoto);

      if (createdDialog != null) {
        _dialogId = createdDialog.id;
      }
      print(_dialogId);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void sendMessage() async {
    String messageBody = "Hello from flutter prashant" + "\n From user: ";

    try {
      Map<String, String> properties = Map();
      properties["testProperty1"] = "testPropertyValue1";
      properties["testProperty2"] = "testPropertyValue2";
      properties["testProperty3"] = "testPropertyValue3";

      await QB.chat.sendMessage(_dialogId,
          body: messageBody, saveToHistory: true, properties: properties);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> logout() async {
    try {
      await QB.auth.logout();
    } on PlatformException catch (e) {
      print(e);
    }
  }
}
