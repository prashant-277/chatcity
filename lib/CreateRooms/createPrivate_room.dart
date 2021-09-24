import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/Widgets/buttons.dart';
import 'package:chatcity/Widgets/textfield.dart';
import 'package:chatcity/Widgets/toastDisplay.dart';
import 'package:chatcity/credentials.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:quickblox_sdk/chat/constants.dart';
import 'package:quickblox_sdk/models/qb_dialog.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:chatcity/constants.dart';
import 'package:chatcity/url.dart';
import 'friend_invitePage.dart';
import 'package:http/http.dart' as http;

class createPrivate_room extends StatefulWidget {


  @override
  _createPrivate_roomState createState() => _createPrivate_roomState();
}

class _createPrivate_roomState extends State<createPrivate_room> {
  final url1 = url.basicUrl;
  final _formKey = GlobalKey<FormState>();
  File _image1;
  String urlimg1;
  String document_path1;
  TextEditingController groupname_controller = TextEditingController();
  String _dialogId;

  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: cwhite,
      resizeToAvoidBottomInset: false,
      appBar: commanAppBar(
        appBar: AppBar(),
        imageIcon: Container(),
        groupImage: Container(),
        imageBack: true,
        colorImage: cwhite,
        appbartext: "Create private room",
        fontsize: medium,
      ),
      body: Container(
        height: query.height,
        width: query.width,
        child: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 110.sp,
                    child: IconButton(
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      icon: _image1 == null
                          ? Image.asset("Assets/Icons/placeholder.png")
                          : Container(
                              width: query.width / 1,
                              child: ClipRRect(
                                borderRadius: new BorderRadius.circular(100.0),
                                child: _image1 == null
                                    ? Image.network(
                                        urlimg1 == null ? "" : urlimg1,
                                        fit: BoxFit.fill,
                                      )
                                    : Image.file(_image1,
                                        height: 100.sp,

                                        fit: BoxFit.fill),
                              ),
                            ),
                      iconSize: 100.sp,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => new AlertDialog(
                                  title: Text("Upload photo"),
                                  elevation: 1,
                                  contentPadding: EdgeInsets.all(5.0),
                                  content: new SingleChildScrollView(
                                    child: new ListBody(
                                      children: <Widget>[
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: FlatButton(
                                            onPressed: imageSelectorCameraD1,
                                            child: Row(
                                              children: <Widget>[
                                                Text("Camera"),
                                              ],
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            border: BorderDirectional(
                                              bottom: BorderSide(
                                                  width: 0.5,
                                                  color: Colors.black12),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: FlatButton(
                                            onPressed: imageSelectorGalleryD1,
                                            child: Row(
                                              children: <Widget>[
                                                Text("Gallery"),
                                              ],
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            border: BorderDirectional(
                                              bottom: BorderSide(
                                                  width: 0.5,
                                                  color: Colors.black12),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: FlatButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Row(
                                              children: <Widget>[
                                                Text("Cancel"),
                                              ],
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            border: BorderDirectional(
                                              bottom: BorderSide(
                                                  width: 0.5,
                                                  color: Colors.black12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                      },
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        textfield(
                          controller: groupname_controller,
                          obscureText: false,
                          hintText: "Group name",
                          textInputType: TextInputType.text,
                          textcapitalization: TextCapitalization.words,
                          functionValidate: commonValidation,
                          parametersValidate: "Please enter group name",
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0.0, vertical: 15),
                          child: Row(
                            children: [
                              Text("Provide a room subject and room icon.",
                                  style: TextStyle(
                                      fontFamily: "SFPro",
                                      fontWeight: FontWeight.w500,
                                      color: cBlack,
                                      fontSize: small)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Container(
                      width: 90.w,
                      height: 7.5.h,
                      child: basicButton(cwhite, () async {
                        if (_formKey.currentState.validate()) {

                          Navigator.pushReplacement(context,
                              PageTransition(
                                  type: PageTransitionType.fade,
                                  alignment: Alignment.bottomCenter,
                                  duration: Duration(milliseconds: 300),
                                  child: friend_invitePage(groupname_controller.text.toString(),document_path1)));

/*                          SharedPreferences prefs = await SharedPreferences.getInstance();

                          print(prefs.getString("userId").toString());
                          print(groupname_controller.text.toString());

                          print(prefs.getString("api_token").toString());

                          var postUri = Uri.parse("$url1/createRoom");
                          var request =
                              new http.MultipartRequest("POST", postUri);
                          request.fields['userid'] =
                              prefs.getString("userId").toString();
                          request.fields['name'] =
                              groupname_controller.text.toString();

                          request.headers["API-token"] =
                              prefs.getString("api_token").toString();

                          document_path1 != null
                              ? request.files.add(await MultipartFile.fromPath(
                                  'image', document_path1))
                              : request.fields["image"] = "";

                          request.send().then((response) async {
                            if (response.statusCode == 200) {
                              print("Uploaded!");

                              print("--------> " +
                                  response.statusCode.toString());

                              final responseStream =
                                  await response.stream.bytesToString();
                              final responseJson = json.decode(responseStream);

                              print("createRoom -- " + responseJson.toString());
                              if (responseJson["status"].toString() ==
                                  "success") {
                                displayToast(
                                    responseJson["message"].toString());

                                Timer(
                                    Duration(seconds: 1),
                                    () => Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                            type: PageTransitionType.fade,
                                            alignment: Alignment.bottomCenter,
                                            duration:
                                                Duration(milliseconds: 300),
                                            child: friend_invitePage(
                                                responseJson["data"]))));
                              } else {
                                displayToast(
                                    responseJson["message"].toString());
                              }
                            } else {
                              final responseStream =
                                  await response.stream.bytesToString();
                              final responseJson = json.decode(responseStream);

                              print("Not Uploaded");
                            }
                          });*/
                        } else {
                          //displayToast(responseJson["message"].toString());
                        }
                      },

                          "Next", cButtoncolor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  void imageSelectorCameraD1() async {
    Navigator.pop(context);
    var imageFile1 = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      print(document_path1);
    });
    document_path1 = imageFile1.path;
    if (document_path1.indexOf('file://') == 0) {
      document_path1 = document_path1.split('file://')[1];
      print(document_path1);
    }
    setState(() {
      _image1 = imageFile1;
      print(document_path1);
    });
  }

  void imageSelectorGalleryD1() async {
    Navigator.pop(context);
    var imageFile1 = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      print(document_path1);
    });
    document_path1 = imageFile1.path;
    if (document_path1.indexOf('file://') == 0) {
      document_path1 = document_path1.split('file://')[1];
      print(document_path1);
      //document_path1 = File(file) as String;
    }
    setState(() {
      _image1 = imageFile1;
    });
  }
}
