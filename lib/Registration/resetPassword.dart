import 'package:chatcity/Registration/login_Screen.dart';
import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/Widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
import 'package:chatcity/constants.dart';
class resetPassword extends StatefulWidget {
  const resetPassword({Key key}) : super(key: key);

  @override
  _resetPasswordState createState() => _resetPasswordState();
}

class _resetPasswordState extends State<resetPassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _pswdCtrl = TextEditingController();
  TextEditingController _confirmpswdCtrl = TextEditingController();


  String password = '';
  String conffirmpassword = '';

  bool show = true;
  bool confirmshow = true;

  void onTap() {
    show = !show;
    setState(() {});
  }

  void onTap1() {
    confirmshow = !confirmshow;
    setState(() {});
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
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  children: [
                    Text(
                        "Reset password",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: "SFPro",
                            height: 1,
                            fontSize: header)
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: 260.sp,

                        child: TextFormField(
                          controller: _pswdCtrl,
                          textAlign: TextAlign.start,
                          obscureText: show,
                          validator: (value) => value.isEmpty
                              ? 'Please enter new password'
                              : null,
                          onChanged: (value) {
                            setState(() => password = value);
                          },
                          style:
                          TextStyle(fontFamily: "SFPro", color: cBlack),
                          maxLines: 1,
                          decoration: InputDecoration(
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
                            contentPadding:
                            EdgeInsets.fromLTRB(15.0, 20.0, 20.0, 20.0),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(color: cChatbackground, width: 1)),
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(color: cChatbackground, width: 1)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: gray,
                                width: 1.0,
                              ),
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey[500],
                              fontFamily: "SFPro",
                              fontSize: medium
                            ),
                            filled: true,
                            fillColor: cwhite,
                            hintText: 'New password',
                            prefixIcon: new IconButton(
                              icon: new Image.asset(
                                'Assets/Icons/password.png',
                                width: 15.sp,
                                color: cBlack,
                              ),
                              onPressed: null,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: 260.sp,

                        child: TextFormField(
                          controller: _confirmpswdCtrl,
                          textAlign: TextAlign.start,
                          obscureText: confirmshow,
                          validator: (value) => value.isEmpty
                              ? 'Please enter confirm password'
                              : null,
                          onChanged: (value) {
                            setState(() => conffirmpassword = value);
                          },
                          style:
                          TextStyle(fontFamily: "SFPro", color: cBlack),
                          maxLines: 1,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              color: Colors.grey,
                              icon: !confirmshow
                                  ? Image.asset(
                                'Assets/Icons/visible.png',
                                width: 18.sp,
                              )
                                  : Image.asset(
                                'Assets/Icons/invisible.png',
                                width: 18.sp,
                              ),
                              onPressed: () {
                                onTap1();
                              },
                            ),
                            contentPadding:
                            EdgeInsets.fromLTRB(15.0, 20.0, 20.0, 20.0),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(color: cChatbackground, width: 1)),
                            border: OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                                borderSide: BorderSide(color: cChatbackground, width: 1)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: gray,
                                width: 1.0,
                              ),
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey[500],
                              fontFamily: "SFPro",
                              fontSize: medium
                            ),
                            filled: true,
                            fillColor: cwhite,
                            hintText: 'Confirm password',
                            prefixIcon: new IconButton(
                              icon: new Image.asset(
                                'Assets/Icons/password.png',
                                width: 15.sp,
                                color: cBlack,
                              ),
                              onPressed: null,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
              SizedBox(height: 25),
              Container(
                  width: 90.w,
                  height: 7.5.h,
                  child: basicButton(cwhite, (){
                    /*if(_formKey.currentState.validate()){
                      if(_pswdCtrl.text.toString()==_confirmpswdCtrl.text.toString()){

                      }else{
                        print("not matched");
                      }
                    }*/

                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            type: PageTransitionType.fade,
                            alignment: Alignment.bottomCenter,
                            duration: Duration(milliseconds: 300),
                            child: login_Screen()));
                  }, "Reset",cButtoncolor)),
            ],
          ),
        ),
      ),
    );
  }
}
