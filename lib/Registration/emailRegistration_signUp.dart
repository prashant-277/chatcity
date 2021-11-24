import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chatcity/Registration/login_Screen.dart';
import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/Widgets/buttons.dart';
import 'package:chatcity/Widgets/textfield.dart';
import 'package:chatcity/Widgets/toastDisplay.dart';
import 'package:chatcity/constants.dart';
import 'package:chatcity/dashboard_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:chatcity/url.dart';

class emailRegistration_signUp extends StatefulWidget {
  var responseJson;

  String social;

  emailRegistration_signUp(this.responseJson, this.social);

  @override
  _emailRegistration_signUpState createState() =>
      _emailRegistration_signUpState();
}

class _emailRegistration_signUpState extends State<emailRegistration_signUp> {
  final _formKey = GlobalKey<FormState>();
  File _image1;
  String urlimg1;
  String document_path1;
  final url1 = url.basicUrl;
  TextEditingController username_controller = TextEditingController();
  TextEditingController phonenum_controller = TextEditingController();
  TextEditingController dob_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();

  bool show = true;
  String username;
  String gender;

  void onTap() {
    show = !show;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

  //  username = widget.responseJson["username"].toString()=="null"? "" : widget.responseJson["username"].toString();

    username_controller.text = widget.social == "social" ? username : "" ;
    password_controller.text = widget.social == "social" ? "00000" : null;
  }

  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: cwhite,
      resizeToAvoidBottomInset: false,
      appBar: BaseAppBar(
        appBar: AppBar(),
        backgroundColor: cwhite,
        appbartext: "",
      ),
      body: SingleChildScrollView(
        child: Container(
          height: query.height,
          width: query.width,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    Text("Complete your profile",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                            fontFamily: "SFPro",
                            fontSize: header)),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
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
                                              //onPressed: imageSelectorCameraD1,
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
                                              //onPressed: imageSelectorGalleryD1,
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
                                            width: query.width,
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
                                          ),
                                        ],
                                      ),
                                    ),
                                  )).then((value) => null);
                        },
                        child: Container(
                          height: query.height / 6,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: IconButton(
                              icon: _image1 == null
                                  ? Image.asset("Assets/Icons/profile2.png")
                                  : Container(
                                      width: query.width / 1,
                                      child: ClipRRect(
                                        borderRadius:
                                            new BorderRadius.circular(50.0),
                                        child: _image1 == null
                                            ? Image.network(
                                                urlimg1 == null ? "" : urlimg1,
                                                fit: BoxFit.fill,
                                              )
                                            : Image.file(_image1,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    1,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    6,
                                                fit: BoxFit.fill),
                                      ),
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
                                                    onPressed:
                                                        imageSelectorCameraD1,
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
                                                          color:
                                                              Colors.black12),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  child: FlatButton(
                                                    onPressed:
                                                        imageSelectorGalleryD1,
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
                                                          color:
                                                              Colors.black12),
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
                                                          color:
                                                              Colors.black12),
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
                        ),
                      ),
                      textfield(
                        obscureText: false,
                        controller: username_controller,
                        hintText: "User name",
                        textcapitalization: TextCapitalization.words,
                        functionValidate: commonValidation,
                        suffixIcon: null,
                        prefixIcon: new IconButton(
                          icon: new Image.asset(
                            'Assets/Icons/user.png',
                            width: 15.sp,
                            color: cBlack,
                          ),
                          onPressed: null,
                        ),
                        parametersValidate: "Please enter User Name",
                        textInputType: TextInputType.name,
                      ),
                      SizedBox(height: 10.sp),
                      textfield(
                        controller: phonenum_controller,
                        obscureText: false,
                        hintText: "Phone number",
                        textcapitalization: TextCapitalization.words,
                        functionValidate: commonValidation,
                        suffixIcon: null,
                        textlength: 10,
                        prefixIcon: new IconButton(
                          icon: new Image.asset(
                            'Assets/Icons/phone.png',
                            width: 15.sp,
                            color: cBlack,
                          ),
                          onPressed: null,
                        ),
                        parametersValidate: "Please enter Phone number",
                        textInputType: TextInputType.number,
                      ),
                      SizedBox(height: 10.sp),
                      GestureDetector(
                        onTap: () async {
                          DateTime date = await DatePicker.showDatePicker(
                            context,
                            showTitleActions: true,
                            minTime: DateTime(1950, 1, 1),
                            maxTime: DateTime.now(),
                            onChanged: (date) {},
                            onConfirm: (date) {
                              print(date);
                            },
                            locale: LocaleType.en,
                            theme: DatePickerTheme(
                              backgroundColor: cwhite,
                              headerColor: cButtoncolor,
                              containerHeight: 150,
                              itemStyle: TextStyle(
                                  fontFamily: "SFPro", fontSize: small),
                              doneStyle:
                                  TextStyle(fontFamily: "SFPro", color: cwhite),
                              cancelStyle:
                                  TextStyle(fontFamily: "SFPro", color: cwhite),
                            ),
                          );

                          setState(() {
                            date = date;
                            dob_controller.text = date.year.toString() +
                                "-" +
                                date.month.toString() +
                                "-" +
                                date.day.toString();
                          });
                        },
                        child: AbsorbPointer(
                          child: textfield(
                            controller: dob_controller,
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
                                color: cButtoncolor,
                              ),
                              onPressed: null,
                            ),
                            parametersValidate: "Please select EDOB",
                            textInputType: TextInputType.number,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.sp),
                      textfield(
                        controller: password_controller,
                        obscureText: show,
                        hintText: "Password",
                        functionValidate: commonValidation,
                        textcapitalization: TextCapitalization.none,
                        suffixIcon: IconButton(
                          color: Colors.grey,
                          icon: !show
                              ? Image.asset(
                                  'Assets/Icons/visible.png',
                                  width: 18.sp,
                                )
                              : Image.asset(
                                  'Assets/Icons/invisible.png',
                                  width: 18.sp,
                                ),
                          onPressed: () {
                            onTap();
                          },
                        ),
                        prefixIcon: IconButton(
                          icon: new Image.asset(
                            'Assets/Icons/password.png',
                            width: 15.sp,
                            color: cBlack,
                          ),
                          onPressed: null,
                        ),
                        parametersValidate: "Please enter Password",
                        textInputType: TextInputType.name,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15),
              Container(
                  width: 90.w,
                  height: 7.5.h,
                  child: basicButton(cwhite, () async {
                    if (_formKey.currentState.validate()) {
                      final ProgressDialog pr = _getProgress(context);
                      pr.show();

                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();

                      print(prefs.getString("userEmail").toString());
                      print(prefs.getString("api_token").toString());

                      var postUri = Uri.parse("$url1/completeProfile");
                      var request = new http.MultipartRequest("POST", postUri);
                      request.fields['email'] =
                          prefs.getString("userEmail").toString();
                      request.fields['username'] =
                          username_controller.text.toString();
                      request.fields['phone'] =
                          phonenum_controller.text.toString();
                      request.fields['dob'] = dob_controller.text.toString();
                      request.fields['password'] =
                          password_controller.text.toString();
                      request.fields['userid'] =
                          prefs.getString("userId").toString();

                      request.headers["API-token"] =
                          prefs.getString("api_token").toString();

                      document_path1 != null
                          ? request.files.add(await MultipartFile.fromPath(
                              'image', document_path1))
                          : request.fields["image"] = "";

                      request.send().then((response) async {
                        if (response.statusCode == 200) {
                          print("Uploaded!");
                          print("--------> " + response.statusCode.toString());

                          final responseStream =
                              await response.stream.bytesToString();
                          final responseJson = json.decode(responseStream);

                          print("updateProfile -- " + responseJson.toString());
                          if (responseJson["status"].toString() == "success") {
                            displayToast(responseJson["message"].toString());
                            Timer(
                                Duration(seconds: 1),
                                () => widget.social == "social"
                                    ? Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                            type: PageTransitionType.fade,
                                            alignment: Alignment.bottomCenter,
                                            duration:
                                                Duration(milliseconds: 300),
                                            child: dashboard_page()))
                                    : Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                            type: PageTransitionType.fade,
                                            alignment: Alignment.bottomCenter,
                                            duration:
                                                Duration(milliseconds: 300),
                                            child: login_Screen(""))));
                            pr.hide();
                          } else {
                            displayToast(responseJson["message"].toString());
                            pr.hide();
                          }
                        } else {
                          final responseStream =
                              await response.stream.bytesToString();
                          final responseJson = json.decode(responseStream);
                          print("Not Uploaded" + responseJson.toString());
                          print("Not Uploaded");
                          pr.hide();
                        }
                      });
                    } else {
                      //displayToast(responseJson["message"].toString());
                    }
                  }, "Register", cButtoncolor)),
              Text(""),
            ],
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
