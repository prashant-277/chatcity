
import 'dart:io';

import 'package:chatcity/Registration/login_Screen.dart';
import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/Widgets/buttons.dart';
import 'package:chatcity/Widgets/textfield.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
import 'package:permission_handler/permission_handler.dart';

class emailRegistration_signUp extends StatefulWidget {
  const emailRegistration_signUp({Key key}) : super(key: key);

  @override
  _emailRegistration_signUpState createState() => _emailRegistration_signUpState();
}

class _emailRegistration_signUpState extends State<emailRegistration_signUp> {

  File _image1;
  String urlimg1;
  String document_path1;
  PermissionStatus _status;
  TextEditingController dob_controller = TextEditingController();

  bool show = true;

  String gender;

  void onTap() {
    show = !show;
    setState(() {});
  }


  @override
  void initState() {
    super.initState();

    PermissionHandler()
        .checkPermissionStatus(PermissionGroup.camera)
        .then(_updateStatus);
  }

  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: cwhite,
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
                        height: query.height / 7,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            icon: _image1 == null
                                ? Image.asset(
                                "Assets/Icons/profile2.png")
                                : Container(
                              width: query.width /1,
                              child: ClipRRect(
                                borderRadius:
                                new BorderRadius.circular(50.0),
                                child: _image1 == null
                                    ? Image.network(urlimg1 == null
                                    ? "" : urlimg1,
                                  fit: BoxFit.fill,
                                )
                                    : Image.file(_image1,
                                    height: MediaQuery.of(context).size.height / 1,
                                    width: MediaQuery.of(context).size.width / 6,
                                    fit: BoxFit.fill),
                              ),
                            ),
                            iconSize: 75.sp,
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) =>
                                  new AlertDialog(
                                    title: Text("Upload photo"),
                                    elevation: 1,
                                    contentPadding:
                                    EdgeInsets.all(5.0),
                                    content:
                                    new SingleChildScrollView(
                                      child: new ListBody(
                                        children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context).size.width,
                                            child: FlatButton(
                                              onPressed: _askPermissionD1,
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
                                            width: MediaQuery.of(context).size.width,
                                            child: FlatButton(
                                              onPressed: imageSelectorGalleryD1,
                                              child: Row(
                                                children: <Widget>[
                                                  Text("Gallery"),
                                                ],
                                              ),
                                            ),
                                            decoration:
                                            BoxDecoration(
                                              border: BorderDirectional(
                                                bottom: BorderSide(
                                                    width: 0.5,
                                                    color: Colors.black12),
                                              ),
                                            ),
                                          ),

                                          Container(
                                            width: MediaQuery.of(context).size.width,
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
                                            decoration:
                                            BoxDecoration(
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
                      ),
                    ),

                    textfield(
                      obscureText: false,
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
                      obscureText: false,
                      hintText: "Phone number",
                      textcapitalization: TextCapitalization.words,
                      functionValidate: commonValidation,
                      suffixIcon: null,
                      prefixIcon: new IconButton(
                        icon: new Image.asset(
                          'Assets/Icons/phone.png',
                          width: 15.sp,
                          color: cBlack,
                        ),
                        onPressed: null,
                      ),
                      parametersValidate: "Please enter User Name",
                      textInputType: TextInputType.number,
                    ),
                    SizedBox(height: 10.sp),
                    GestureDetector(
                      onTap: () async {
                        DateTime date =
                        await DatePicker.showDatePicker(
                          context,
                          showTitleActions: true,
                          minTime: DateTime.now(),
                          maxTime:
                          DateTime.now().add(Duration(days: 280)),
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
                                fontFamily: "SFPro",
                                color: cwhite),
                            cancelStyle: TextStyle(
                                fontFamily: "SFPro",
                                color: cwhite),
                          ),
                        );

                        setState(() {
                          date = date;
                          dob_controller.text = date.year.toString() +
                              "-" +
                              date.day.toString() +
                              "-" +
                              date.month.toString();
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
              SizedBox(height: 15),
              Container(
                  width: 90.w,
                  height: 7.5.h,
                  child: basicButton(cwhite, () {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            alignment: Alignment.bottomCenter,
                            duration: Duration(milliseconds: 300),
                            child: login_Screen()));
                  }, "Register",cButtoncolor)),
              Text(""),

            ],
          ),
        ),
      ),
    );
  }
  void _askPermissionD1() {
    PermissionHandler().requestPermissions([PermissionGroup.camera]).then(
        _onStatusRequestedD1);
  }

  void _onStatusRequestedD1(Map<PermissionGroup, PermissionStatus> value) {
    final status = value[PermissionGroup.camera];
    if (status == PermissionStatus.granted) {
      imageSelectorCameraD1();
    } else {
      _updateStatus(status);
    }
  }

  _updateStatus(PermissionStatus value) {
    if (value != _status) {
      setState(() {
        _status = value;
      });
    }
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
