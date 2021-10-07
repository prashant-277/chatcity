import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/Widgets/buttons.dart';
import 'package:chatcity/constants.dart';
import 'package:custom_radio_grouped_button/CustomButtons/ButtonTextStyle.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomRadioButton.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class filter_page extends StatefulWidget {
  const filter_page({Key key}) : super(key: key);

  @override
  _filter_pageState createState() => _filter_pageState();
}

class _filter_pageState extends State<filter_page> {
  String roomType = "";
  @override
  Widget build(BuildContext context) {
    var query = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: cwhite,
      appBar: commanAppBar(
        appBar: AppBar(),
        imageBack: true,
        appbartext: "Filter",
        fontsize: medium,
        colorImage: cwhite,
        groupImage: Container(),
        imageIcon: Container(),
      ),
      body: Container(
        color: cwhite,
        height: query.height/1,
        width: query.width,
        child: Padding(
          padding:
              const EdgeInsets.only(top: 20.0, left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomRadioButton(
                spacing: 3.0,
                width: 20,
                height: query.height * 0.07,

                autoWidth: false,
                enableButtonWrap: true,
                horizontal: true,
                unSelectedBorderColor: cwhite,
                selectedBorderColor: cwhite,
                elevation: 0,
                absoluteZeroSpacing: false,
                unSelectedColor: cwhite,
                buttonLables: [
                  'All Rooms',
                  'Public Rooms',
                  'Private Rooms',
                ],
                buttonValues: [
                  'All Rooms',
                  'Public Rooms',
                  'Private Rooms',
                ],
                buttonTextStyle: ButtonTextStyle(
                    selectedColor: cwhite,
                    unSelectedColor: cBlack,
                    textStyle: TextStyle(
                      fontSize: medium,
                      fontFamily: "SFPro",
                      fontWeight: FontWeight.w500,
                      color: cBlack,
                    )),
                radioButtonValue: (value) {
                  setState(() {
                    print(value);
                    roomType = value;
                  });
                },
                selectedColor: cfooterGray,
                enableShape: true,
                customShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: BorderSide(width: 1, color: cfooterGray)),
              ),
              Container(
                  width: 85.w,
                  height: 7.5.h,
                  child: basicButton(cwhite, () {
                   if(roomType=="All Rooms"){
                     Navigator.of(context).pop("");
                   }
                      if(roomType=="Public Rooms"){
                        Navigator.of(context).pop("0");
                      }
                   if(roomType=="Private Rooms"){
                     Navigator.of(context).pop("1");
                   }

                  }, "Save", cButtoncolor))
            ],
          ),
        ),
      ),
    );
  }
}
