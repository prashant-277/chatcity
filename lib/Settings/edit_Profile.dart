import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/Widgets/buttons.dart';
import 'package:chatcity/Widgets/textfield.dart';
import 'package:chatcity/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:sizer/sizer.dart';

class edit_Profile extends StatefulWidget {
  const edit_Profile({Key key}) : super(key: key);

  @override
  _edit_ProfileState createState() => _edit_ProfileState();
}

class _edit_ProfileState extends State<edit_Profile> {
  TextEditingController _usernameCtrl = TextEditingController();
  TextEditingController _emailCtrl = TextEditingController();
  TextEditingController _phoneCtrl = TextEditingController();
  TextEditingController _dobCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _usernameCtrl.text = "John Ibrahim";
    _emailCtrl.text = "prashant.theappideas@gmail.com";
    _phoneCtrl.text = "+1 0123456789";
    _dobCtrl.text = "20-05-1989";
  }

  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: cwhite,
      appBar: commanAppBar(
        appBar: AppBar(),
        fontsize: medium,
        appbartext: "Edit profile",
        imageBack: true,
        colorImage: cwhite,
        imageIcon: Container(),
        groupImage: Container(),
      ),
      body: Container(
        height: query.height,
        width: query.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 1.h),
              Image.asset(
                "Assets/Icons/img5.png",
                height: 12.h,
              ),
              SizedBox(height: 3.h),
              Container(
                height: 40.sp,
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
                      height: 20.0,                    ),
                  ),
                  hintText: "",
                ),
              ),
              SizedBox(height: 2.h),
              Container(
                height: 40.sp,
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
                      height: 20.0,                    ),
                  ),
                  hintText: "",
                ),
              ),
              SizedBox(height: 2.h),
              Container(
                height: 45.sp,
                width: query.width,
                decoration: BoxDecoration(
                    color: cwhite,
                    border: Border.all(color: Colors.white, width: 0),
                    borderRadius: BorderRadius.circular(10.0)),
                child: textfield(
                  controller: _phoneCtrl,
                  textcapitalization: TextCapitalization.words,
                  textInputType: TextInputType.name,
                  obscureText: false,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Image.asset(
                      "Assets/Icons/phone.png",
                      width: 20.0,
                      height: 20.0,                    ),
                  ),
                  hintText: "",
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                height: 45.sp,
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
                      minTime: DateTime.now(),
                      maxTime: DateTime.now().add(Duration(days: 280)),
                      onChanged: (date) {},
                      onConfirm: (date) {},
                      locale: LocaleType.en,
                      theme: DatePickerTheme(
                        backgroundColor: cwhite,
                        headerColor: cButtoncolor,
                        containerHeight: 150,
                        itemStyle:
                            TextStyle(fontFamily: "SFPro", fontSize: small),
                        doneStyle:
                            TextStyle(fontFamily: "SFPro", color: cwhite),
                        cancelStyle:
                            TextStyle(fontFamily: "SFPro", color: cwhite),
                      ),
                    );
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
                  child:
                      basicButton(cwhite, () async {}, "Save", cButtoncolor)),
            ],
          ),
        ),
      ),
    );
  }
}
