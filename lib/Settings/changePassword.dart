import 'dart:convert';

import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/Widgets/buttons.dart';
import 'package:chatcity/Widgets/textfield.dart';
import 'package:chatcity/Widgets/toastDisplay.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:chatcity/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:chatcity/url.dart';
import 'package:http/http.dart' as http;

class changePassword extends StatefulWidget {
  const changePassword({Key key}) : super(key: key);

  @override
  _changePasswordState createState() => _changePasswordState();
}

class _changePasswordState extends State<changePassword> {
  bool show = true;
  bool show1 = true;
  bool show2 = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _oldpswdCtrl = TextEditingController();
  TextEditingController _newpswdCtrl = TextEditingController();
  TextEditingController _confirmpswdCtrl = TextEditingController();
  String password = '';
  final url1 = url.basicUrl;

  void onTap() {
    show = !show;
    setState(() {});
  }

  void onTap1() {
    show1 = !show1;
    setState(() {});
  }

  void onTap2() {
    show2 = !show2;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: cwhite,
      resizeToAvoidBottomInset: false,
      appBar: commanAppBar(
        appBar: AppBar(),
        groupImage: Container(),
        imageIcon: Container(),
        colorImage: cwhite,
        imageBack: true,
        appbartext: "Change password",
        fontsize: medium,
      ),
      body: Container(
        height: query.height,
        width: query.width,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                    width: query.width / 1.15,
                    child: textfield(
                      controller: _oldpswdCtrl,
                      obscureText: show,
                      hintText: "Old password",
                      textcapitalization: TextCapitalization.none,
                      functionValidate: commonValidation,
                      suffixIcon: IconButton(
                        color: gray,
                        icon: !show
                            ? Image.asset(
                                'Assets/Icons/visible.png',
                                width: 25.0,
                                height: 25.0,
                              )
                            : Image.asset(
                                'Assets/Icons/invisible.png',
                                width: 25.0,
                                height: 25.0,
                              ),
                        onPressed: () {
                          onTap();
                        },
                      ),
                      prefixIcon: IconButton(
                        icon: new Image.asset(
                          'Assets/Icons/password.png',
                          width: 20.0,
                          height: 20.0,
                          color: cBlack,
                        ),
                        onPressed: null,
                      ),
                      parametersValidate: "Please enter old password",
                      textInputType: TextInputType.name,
                    )),
                SizedBox(height: 10),
                Container(
                    width: query.width / 1.15,
                    child: textfield(
                      controller: _newpswdCtrl,
                      obscureText: show1,
                      hintText: "New password",
                      textcapitalization: TextCapitalization.none,
                      functionValidate: commonValidation,
                      suffixIcon: IconButton(
                        color: gray,
                        icon: !show1
                            ? Image.asset(
                                'Assets/Icons/visible.png',
                                width: 25.0,
                                height: 25.0,
                              )
                            : Image.asset(
                                'Assets/Icons/invisible.png',
                                width: 25.0,
                                height: 25.0,
                              ),
                        onPressed: () {
                          onTap1();
                        },
                      ),
                      prefixIcon: IconButton(
                        icon: new Image.asset(
                          'Assets/Icons/password.png',
                          width: 20.0,
                          height: 20.0,
                          color: cBlack,
                        ),
                        onPressed: null,
                      ),
                      parametersValidate: "Please enter new password",
                      textInputType: TextInputType.text,
                    )),
                SizedBox(height: 10),
                Container(
                  width: query.width / 1.15,
                  child: textfield(
                    controller: _confirmpswdCtrl,
                    obscureText: show2,
                    hintText: "Confirm password",
                    functionValidate: commonValidation,
                    textcapitalization: TextCapitalization.none,
                    suffixIcon: IconButton(
                      color: gray,
                      icon: !show2
                          ? Image.asset(
                              'Assets/Icons/visible.png',
                              width: 25.0,
                              height: 25.0,
                            )
                          : Image.asset(
                              'Assets/Icons/invisible.png',
                              width: 25.0,
                              height: 25.0,
                            ),
                      onPressed: () {
                        onTap2();
                      },
                    ),
                    prefixIcon: IconButton(
                      icon: new Image.asset(
                        'Assets/Icons/password.png',
                        width: 20.0,
                        height: 20.0,
                        color: cBlack,
                      ),
                      onPressed: null,
                    ),
                    parametersValidate: "Please enter confirm password",
                    textInputType: TextInputType.text,
                  ),
                ),
                SizedBox(height: 30),
                Container(
                    width: 90.w,
                    height: 7.5.h,
                    child: basicButton(cwhite, () async {
                      if (_formKey.currentState.validate()) {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();

                        if (_newpswdCtrl.text.toString() == _confirmpswdCtrl.text.toString()) {

                          var url = "$url1/changePassword";

                          Map<String, String> header = {
                            "API-token": prefs.getString("api_token").toString()
                          };

                          var map = new Map<String, dynamic>();
                          map["userid"] = prefs.getString("userId").toString();
                          map["current_password"] = _oldpswdCtrl.text.toString();
                          map["new_password"] = _newpswdCtrl.text.toString();
                          map["confirm_pwd"] = _confirmpswdCtrl.text.toString();

                          final response = await http.post(Uri.parse(url),
                              body: map, headers: header);

                          final responseJson = json.decode(response.body);
                          print(responseJson.toString());

                          if (responseJson["status"].toString() == "success") {
                            displayToast(responseJson["message"].toString());
                          }else{
                            displayToast(responseJson["message"].toString());

                          }
                        } else {
                          displayToast("Password not match");
                        }
                      }
                    }, "Change", cButtoncolor)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
