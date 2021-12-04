import 'dart:convert';
import 'dart:io';

import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/Widgets/buttons.dart';
import 'package:chatcity/Widgets/textfield.dart';
import 'package:chatcity/Widgets/toastDisplay.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:chatcity/url.dart';
import 'package:http/http.dart' as http;

class edit_Profile extends StatefulWidget {
  const edit_Profile({Key key}) : super(key: key);

  @override
  _edit_ProfileState createState() => _edit_ProfileState();
}

class _edit_ProfileState extends State<edit_Profile> {
  final _formKey = GlobalKey<FormState>();

  final url1 = url.basicUrl;
  bool _isLoading = true;
  File _image1;
  String urlimg1;
  String document_path1;

  TextEditingController _usernameCtrl = TextEditingController();
  TextEditingController _emailCtrl = TextEditingController();
  TextEditingController _phoneCtrl = TextEditingController();
  TextEditingController _dobCtrl = TextEditingController();

  Future<void> getUserDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var url = "$url1/getUserDetails";

    var map = new Map<String, dynamic>();
    map["userid"] = prefs.getString("userId").toString();

    Map<String, String> headers = {
      "API-token": prefs.getString("api_token").toString()
    };

    final response = await http.post(Uri.parse(url), body: map, headers: headers);
    final responseJson = json.decode(response.body);
    print("res getUserDetails  " + responseJson.toString());

    setState(() {
      _usernameCtrl.text = responseJson["data"]["username"].toString();
      urlimg1 = responseJson["data"]["image"].toString();
      _emailCtrl.text = responseJson["data"]["email"].toString();
      _phoneCtrl.text = responseJson["data"]["phone"].toString();
      _dobCtrl.text = responseJson["data"]["dob"].toString();
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    /*_usernameCtrl.text = "John Ibrahim";
    _emailCtrl.text = "prashant.theappideas@gmail.com";
    _phoneCtrl.text = "+1 0123456789";
    _dobCtrl.text = "20-05-1989";*/
    getUserDetails();
  }

  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: cwhite,
      resizeToAvoidBottomInset: false,

      appBar: commanAppBar(
        appBar: AppBar(),
        fontsize: medium,
        appbartext: "Edit profile",
        imageBack: true,
        colorImage: cwhite,
        imageIcon: Container(),
        groupImage: Container(),
      ),
      body: _isLoading == true
          ? SpinKitRipple(color: cfooterpurple)
          : Container(
              height: query.height,
              width: query.width,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 25),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 1.h),
                      IconButton(
                        icon: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: _image1 == null
                              ? Image.network(
                                  urlimg1 == "null"
                                      ? "https://st3.depositphotos.com/23594922/31822/v/600/depositphotos_318221368-stock-illustration-missing-picture-page-for-website.jpg"
                                      : urlimg1,
                                  height: query.height * 0.15,
                                  width: query.height * 0.15,
                                  fit: BoxFit.fill,
                                )
                              : Image.file(_image1,
                                  height: query.height * 0.15,
                                  width: query.height * 0.15,
                                  fit: BoxFit.fill),
                        ),
                        iconSize: 75.sp,
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
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
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
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
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
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
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
                      SizedBox(height: 3.h),
                      Container(
                        width: query.width,
                        decoration: BoxDecoration(
                            color: cChatbackground,
                            border: Border.all(color: cwhite, width: 0),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: textfield(
                          controller: _usernameCtrl,
                          textcapitalization: TextCapitalization.words,
                          textInputType: TextInputType.name,
                          obscureText: false,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset(
                              "Assets/Icons/user.png",
                              width: 20.0,
                              height: 20.0,
                            ),
                          ),
                          hintText: "",
                          parametersValidate: "Please enter Username",
                        ),
                      ),
                      SizedBox(height: 2.h),
                      InkWell(
                        onTap: () {
                          displayToast("You can not edit your email");
                        },
                        child: AbsorbPointer(
                          child: Container(
                            width: query.width,
                            decoration: BoxDecoration(
                                color: cChatbackground,
                                border: Border.all(color: cwhite, width: 0),
                                borderRadius: BorderRadius.circular(10.0)),
                            child: textfield(
                              controller: _emailCtrl,
                              textcapitalization: TextCapitalization.words,
                              textInputType: TextInputType.name,
                              obscureText: false,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Image.asset(
                                  "Assets/Icons/email.png",
                                  width: 20.0,
                                  height: 20.0,
                                ),
                              ),
                              hintText: "",
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Container(
                        width: query.width,
                        decoration: BoxDecoration(
                            color: cwhite,
                            border: Border.all(color: Colors.white, width: 0),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: textfield(
                          textlength: 10,
                          controller: _phoneCtrl,
                          textcapitalization: TextCapitalization.words,
                          textInputType: TextInputType.name,
                          obscureText: false,
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Image.asset(
                              "Assets/Icons/phone.png",
                              width: 20.0,
                              height: 20.0,
                            ),
                          ),
                          hintText: "",
                          parametersValidate: "Please enter phone number",

                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Container(
                        width: query.width,
                        decoration: BoxDecoration(
                            color: cwhite,
                            border: Border.all(color: Colors.white, width: 0),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: GestureDetector(
                          onTap: () async {
                            DateTime date = await DatePicker.showDatePicker(
                              context,
                              showTitleActions: true,
                              minTime: DateTime(1950, 1, 1),
                              maxTime: DateTime.now(),
                              onChanged: (date) {},
                              onConfirm: (date) {},
                              locale: LocaleType.en,
                              theme: DatePickerTheme(
                                backgroundColor: cwhite,
                                headerColor: cButtoncolor,
                                containerHeight: 150,
                                itemStyle: TextStyle(
                                    fontFamily: "SFPro", fontSize: small),
                                doneStyle: TextStyle(
                                    fontFamily: "SFPro", color: cwhite),
                                cancelStyle: TextStyle(
                                    fontFamily: "SFPro", color: cwhite),
                              ),
                            );
                            setState(() {
                              date = date;
                              _dobCtrl.text = date.year.toString() +
                                  "-" +
                                  date.month.toString() +
                                  "-" +
                                  date.day.toString();
                            });
                          },
                          child: AbsorbPointer(
                            child: textfield(
                              controller: _dobCtrl,
                              obscureText: false,
                              hintText: "EDOB",
                              functionValidate: commonValidation,
                              suffixIcon: new IconButton(
                                icon: new Image.asset(
                                  'Assets/Icons/calendar.png',
                                  width: 20.0,
                                  height: 20.0,
                                ),
                                onPressed: null,
                              ),
                              prefixIcon: new IconButton(
                                icon: new Image.asset(
                                  'Assets/Icons/dob.png',
                                  width: 20.0,
                                  height: 20.0,
                                ),
                                onPressed: null,
                              ),
                              parametersValidate: "Please select EDOB",
                              textInputType: TextInputType.number,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                          width: 90.w,
                          height: 7.5.h,
                          child: basicButton(cwhite, () async {
                            if (_formKey.currentState.validate()) {

                              SharedPreferences prefs = await SharedPreferences.getInstance();

                              final ProgressDialog pr = _getProgress(context);
                              pr.show();
                              var postUri = Uri.parse("$url1/updateProfile");
                              var request =
                                  new http.MultipartRequest("POST", postUri);

                              request.fields['email'] = _emailCtrl.text.toString();
                              request.fields['username'] = _usernameCtrl.text.toString();
                              request.fields["phone"] = _phoneCtrl.text.toString();
                              request.fields['dob'] = _dobCtrl.text.toString();
                              request.fields['login_id'] = prefs.getString("userId").toString();

                              request.headers["API-token"] =
                                  prefs.getString("api_token").toString();
                              document_path1 != null
                                  ? request.files.add(
                                      await MultipartFile.fromPath(
                                          'image', document_path1))
                                  : request.fields["image"] = "";

                              request.send().then((response) async {
                                if (response.statusCode == 200) {
                                  print("Uploaded!");

                                  print("--------> " +
                                      response.statusCode.toString());

                                  final responseStream =
                                      await response.stream.bytesToString();
                                  final responseJson =
                                      json.decode(responseStream);

                                  print(responseJson.toString());
                                  if (responseJson["status"].toString() ==
                                      "success") {
                                    displayToast(
                                        responseJson["message"].toString());
                                    Navigator.pop(context);
                                    pr.hide();
                                  } else {
                                    displayToast(
                                        responseJson["message"].toString());
                                    pr.hide();
                                  }
                                } else {
                                  final responseStream =
                                      await response.stream.bytesToString();
                                  final responseJson =
                                      json.decode(responseStream);
                                  print(responseJson);
                                  displayToast(responseJson["message"].toString());
                                  pr.hide();

                                  print("Not Uploaded");
                                }
                              });
                            }
                          }, "Save", cButtoncolor)),
                    ],
                  ),
                ),
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

ProgressDialog _getProgress(BuildContext context) {
  return ProgressDialog(context);
}
