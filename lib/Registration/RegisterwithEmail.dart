import 'dart:convert';
import 'dart:io';

import 'package:chatcity/Registration/otpSent_successfully.dart';
import 'package:chatcity/TermsofService.dart';
import 'package:chatcity/Widgets/appbarCustom.dart';
import 'package:chatcity/Widgets/buttons.dart';
import 'package:chatcity/Widgets/textfield.dart';
import 'package:chatcity/Widgets/toastDisplay.dart';
import 'package:chatcity/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:quickblox_sdk/models/qb_user.dart';
import 'package:quickblox_sdk/quickblox_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:sizer/sizer.dart';
import 'package:chatcity/url.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class RegisterwithEmail extends StatefulWidget {
  const RegisterwithEmail({Key key}) : super(key: key);

  @override
  _RegisterwithEmailState createState() => _RegisterwithEmailState();
}

class _RegisterwithEmailState extends State<RegisterwithEmail> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FacebookLogin facebookSignIn = new FacebookLogin();

  final url1 = url.basicUrl;
  final _formKey = GlobalKey<FormState>();
  TextEditingController Email_controller = TextEditingController();

  bool isLoggedIn = false;
  var profileData;


  void onLoginStatusChanged(bool isLoggedIn, {profileData}) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
      this.profileData = profileData;
    });
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
      body: Container(
        height: query.height,
        width: query.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset(
              "Assets/Images/logo.png",
              height: 100.sp,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: cChatbackground,
                ),
                height: 170.sp,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Row(
                        children: [
                          Text(
                            "Enter your email address",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: cBlack,
                              fontSize: medium,
                              fontFamily: "SFPro",
                              height: 1.3.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, top: 10, right: 15),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: textfield(
                            controller: Email_controller,
                            textcapitalization: TextCapitalization.none,
                            textInputType: TextInputType.emailAddress,
                            hintText: "Email",
                            obscureText: false,
                            prefixIcon: new IconButton(
                              icon: new Image.asset(
                                'Assets/Icons/email.png',
                                width: 20.sp,
                                color: cBlack,
                              ),
                              onPressed: null,
                            ),
                            parametersValidate: "Please enter Email",
                            functionValidate: commonValidation,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.sp),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15),
                      child: Container(
                          width: 90.w,
                          height: 7.5.h,
                          child: basicButton(cwhite, () async {
                            if (_formKey.currentState.validate()) {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();

                              isRegistered(Email_controller.text.toString());
                            }
                          }, "Continue", cButtoncolor)),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Image.asset(
                "Assets/Icons/loginwith.png",
                height: 15.sp,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    child:
                        Image.asset("Assets/Icons/google.png", height: 50.sp),
                    onTap: () {
                      _handleSignIn().then((FirebaseUser user) async {
                        print(user.email);
                      });
                    },
                  ),
                  SizedBox(width: 10.sp),
                  InkWell(
                    child: Image.asset("Assets/Icons/fb.png",
                        height: 50.sp),
                    onTap: (){
                      initiateFacebookLogin();
                    },
                  ),
                  SizedBox(width: 10.sp),
                  InkWell(
                      child: Image.asset("Assets/Icons/apple.png",
                          height: 50.sp),
                      onTap: () async {
                        print("Click");
                        {
                          if (Platform.isAndroid) {
                            var redirectURL = "";
                            var clientID = "com.appideas.chatcity";
                            final appleIdCredential = await SignInWithApple
                                .getAppleIDCredential(
                                scopes: [
                                  AppleIDAuthorizationScopes.email,
                                  AppleIDAuthorizationScopes.fullName,
                                ],
                                webAuthenticationOptions: WebAuthenticationOptions(
                                    clientId: clientID,
                                    redirectUri: Uri.parse(redirectURL)));
                            final oAuthProvider = OAuthProvider(
                                providerId: 'apple.com');
                            final credential = oAuthProvider.getCredential(
                              idToken: appleIdCredential.identityToken,
                              accessToken: appleIdCredential.authorizationCode,
                            );
                            print(credential);

                          } else {
                            final credential = await SignInWithApple
                                .getAppleIDCredential(
                              scopes: [
                                AppleIDAuthorizationScopes.email,
                                AppleIDAuthorizationScopes.fullName,
                              ],
                              webAuthenticationOptions: WebAuthenticationOptions(
                                clientId:
                                'com.aboutyou.dart_packages.sign_in_with_apple.example',
                                redirectUri: Uri.parse(
                                  'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
                                ),
                              ),
                              nonce: 'example-nonce',
                              state: 'example-state',
                            );

                            print(credential);

                            final signInWithAppleEndpoint = Uri(
                              scheme: 'https',
                              host: 'flutter-sign-in-with-apple-example.glitch.me',
                              path: '/sign_in_with_apple',
                              queryParameters: <String, String>{
                                'code': credential.authorizationCode,
                                if (credential.givenName != null)
                                  'firstName': credential.givenName,
                                if (credential.familyName != null)
                                  'lastName': credential.familyName,
                                'useBundleId':
                                Platform.isIOS || Platform.isMacOS
                                    ? 'true'
                                    : 'false',
                                if (credential.state != null) 'state': credential
                                    .state,
                              },
                            );

                            final session = await http.Client().post(
                              signInWithAppleEndpoint,
                            );
                            print(session);
                          }
                        }}
                  ),
                ],
              ),
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    style: TextStyle(
                        color: cBlack, fontSize: small, fontFamily: "SFPro"),
                    text: "By creating an account, I accept the",
                  ),
                  WidgetSpan(child: SizedBox(width: 5)),
                  TextSpan(
                    style: TextStyle(
                        color: cBlack,
                        fontSize: small,
                        decoration: TextDecoration.underline,
                        fontFamily: "SFPro"),
                    text: "Terms of Service",
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        Navigator.push(
                            context,
                            PageTransition(
                                type: PageTransitionType.fade,
                                alignment: Alignment.bottomCenter,
                                duration: Duration(milliseconds: 300),
                                child: TermsofService()));
                      },
                  ),
                ],
              ),
            ),
            SizedBox()
          ],
        ),
      ),
    );
  }

  Future<bool> isRegistered(String email) async {
    bool isValid = false;
    final ProgressDialog pr = _getProgress(context);
    pr.show();
    var url = "$url1/verifyEmail";
    var map = new Map<String, dynamic>();
    map["email"] = email.toString();

    final response = await http.post(url, body: map);
    final responseJson = json.decode(response.body);
    print("veryfyEmail -- " + responseJson.toString());
    if (response.statusCode == 200) {
      String status = responseJson["status"].toString();
      if (!status.isEmpty && status == "fail") {
        isValid = true;
        createUser(email.toString());
        print("fail ---- " + responseJson("message").toString());
        pr.hide();
      } else {
        displayToast("The email has already been taken.");
        pr.hide();
        print("not fail ---- " + responseJson("message").toString());
      }
    } else {
      displayToast(response.statusCode.toString());
    }

    return isValid;
  }

  Future<int> createUser(String email) async {
    int userId;
    try {
      QBUser user = await QB.users.createUser(email, USER_PASSWORD);
      userId = user.id;
      registerwithEmail(userId.toString());
    } on PlatformException catch (e) {}
    print("userId " + userId.toString());
    return userId;
  }

  Future<void> registerwithEmail(String qb_Id) async {
    final ProgressDialog pr = _getProgress(context);
    pr.show();
    var url = "$url1/registerWithMail";

    var map = new Map<String, dynamic>();
    map["email"] = Email_controller.text.toString();
    map["quickboxid"] = qb_Id.toString();

    final response = await http.post(url, body: map);

    final responseJson = json.decode(response.body);
    print("registerWithMail-- " + responseJson.toString());

    if (responseJson["status"].toString() == "fail") {
      displayToast(responseJson["message"].toString());
      pr.hide();
    } else {
      displayToast("Please check your mailbox");
      pr.hide();

      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.fade,
              duration: Duration(milliseconds: 300),
              alignment: Alignment.bottomCenter,
              child: otpSent_successfully(responseJson)));
    }
  }

  Future<FirebaseUser> _handleSignIn() async {
    _auth.app.options.catchError((error) {
      print("error---->$error");
    });
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;

    print("signed in " + user.displayName);
    return user;
  }
  Future<void> initiateFacebookLogin() async {
    final facebookLoginResult = await facebookSignIn.logIn(['email']);

    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        onLoginStatusChanged(false);
        print(facebookLoginResult.errorMessage);
        break;
      case FacebookLoginStatus.cancelledByUser:
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${facebookLoginResult.accessToken.token}');

        var profile = json.decode(graphResponse.body);

        print("profile******* " + profile.toString());
        print("user Id +++++ " + profile["id"].toString());
        onLoginStatusChanged(true, profileData: profile);


        /*var url = "$url1/facebook-login";



        Map<String, String> header = {"_token": token};
        print(profile["first_name"].toString());
        var map = new Map<String, dynamic>();
        map["f_name"] = profile["first_name"].toString();
        map["l_name"] = profile["last_name"].toString();
        map["email"] = profile["email"].toString();
        map["imageUrl"] = profile["picture"]["data"]["url"].toString();
        map["gender"] = "";
        map["fb_id"] = profile["id"].toString();

        final response = await http.post(url, body: map, headers: header);

        final responseJson = json.decode(response.body);
        print(responseJson.toString());
        print(responseJson["data"]["api_token"].toString());*/

        break;
    }
  }
}

ProgressDialog _getProgress(BuildContext context) {
  return ProgressDialog(context);
}
