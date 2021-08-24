import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/Widgets/buttons.dart';
import 'package:chatcity/Widgets/textfield.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:chatcity/constants.dart';
import 'package:sizer/sizer.dart';

class changePassword extends StatefulWidget {
  const changePassword({Key key}) : super(key: key);

  @override
  _changePasswordState createState() => _changePasswordState();
}

class _changePasswordState extends State<changePassword> {
  bool show = true;
  bool show1 = true;
  bool show2 = true;

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
          child: Column(
            children: [
              Container(
                  width: query.width / 1.15,
                  child: textfield(
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
                  child:
                      basicButton(cwhite, () async {}, "Change", cButtoncolor)),
            ],
          ),
        ),
      ),
    );
  }
}
