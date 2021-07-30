import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:greenbill_merchant/src/models/model_getStore.dart';
import 'package:greenbill_merchant/src/models/model_login.dart';
import 'package:greenbill_merchant/src/ui/HomeScreen/Home.dart';
import 'package:greenbill_merchant/src/ui/signup/signup_page_merchant.dart';
import 'package:greenbill_merchant/src/ui/widgets/background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import '../forgetPassword/forget_pass_merchant.dart';
import 'package:http/http.dart' as http;

class Login_Merchant extends StatefulWidget {
  Login_Merchant({Key key}) : super(key: key);
  @override
  Login_MerchantState createState() => Login_MerchantState();
}

class Login_MerchantState extends State<Login_Merchant> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String pass;

  @override
  void initState() {
    super.initState();
    autoFill();
  }

  @override
  void dispose() {
    myFocusNodeNumberLogin.dispose();
    myFocusNodePasswordLogin.dispose();

    loginNumberController.dispose();
    loginPasswordController.dispose();
    super.dispose();
  }

  Future<void> autoFill() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loginNumberController.text = prefs.getString("mob");
    loginPasswordController.text = prefs.getString("password");
  }

  final FocusNode myFocusNodeNumberLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  TextEditingController loginNumberController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;
  bool rememberMe = false;

  void _onRememberMeChanged(bool newValue) async {
    setState(() {
      rememberMe = newValue;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (newValue) {
      prefs.setString("mob", loginNumberController.text);
      prefs.setString("password", loginPasswordController.text);
      print("Okay i remember");
    } else {
      prefs.getKeys();
      prefs.remove("mob");
      prefs.remove("password");
      print("Okay i removed");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Background(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20.0),
                  child: new Image(
                      width: size.width * 0.7,
                      height: size.height * 0.25,
                      fit: BoxFit.fill,
                      image: new AssetImage('assets/img/merchant_login.png')),
                ),
                Card(
                  elevation: 2.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: Container(
                    width: 350.0,
                    height: 320.0,
                    child: Column(
                      children: <Widget>[
                        // SizedBox(height: 10.0,),
                        // Text(
                        //   "Login",
                        //   style: TextStyle(
                        //       color: kPrimaryColorBlue,
                        //       fontSize: 40.0,
                        //       fontFamily: "PoppinsBold"),
                        // ),
                        Container(
                          width: size.width * 0.99,
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 10.0, left: 25.0, right: 25.0),
                          child: TextField(
                            focusNode: myFocusNodeNumberLogin,
                            controller: loginNumberController,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            style: TextStyle(
                                fontFamily: "PoppinsLight",
                                fontSize: 13.0,
                                color: kPrimaryColorBlue),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              counterStyle: TextStyle(
                                height: double.minPositive,
                              ),
                              counterText: "",
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 13.0),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: kPrimaryColorBlue, width: 0.5),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(35.0)),
                              ),
                              focusedBorder: new OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: kPrimaryColorBlue, width: 0.5),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(35.0)),
                              ),
                              prefixIcon: Icon(
                                FontAwesomeIcons.mobileAlt,
                                color: kPrimaryColorBlue,
                                size: 20.0,
                              ),
                              labelText: "Phone Number",
                              labelStyle: TextStyle(
                                  fontFamily: "PoppinsLight",
                                  fontSize: 13.0,
                                  color: kPrimaryColorBlue),
                            ),
                          ),
                        ),
                        Container(
                          width: size.width * 0.99,
                          padding: EdgeInsets.only(
                              top: 0.0, bottom: 0.0, left: 25.0, right: 25.0),
                          child: TextField(
                            focusNode: myFocusNodePasswordLogin,
                            controller: loginPasswordController,
                            obscureText: _obscureTextLogin,
                            style: TextStyle(
                                fontFamily: "PoppinsLight",
                                fontSize: 13.0,
                                color: kPrimaryColorBlue),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 13.0),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: kPrimaryColorBlue,
                                  width: 0.5,
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(35.0)),
                              ),
                              focusedBorder: new OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: kPrimaryColorBlue, width: 0.5),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(35.0)),
                              ),
                              prefixIcon: Icon(
                                FontAwesomeIcons.lock,
                                size: 20.0,
                                color: kPrimaryColorBlue,
                              ),
                              labelText: "Password",
                              labelStyle: TextStyle(
                                  fontFamily: "PoppinsLight",
                                  fontSize: 13.0,
                                  color: kPrimaryColorBlue),
                              suffixIcon: GestureDetector(
                                onTap: _toggleLogin,
                                child: Icon(
                                  _obscureTextLogin
                                      ? FontAwesomeIcons.eyeSlash
                                      : FontAwesomeIcons.eye,
                                  size: 15.0,
                                  color: kPrimaryColorBlue,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Checkbox(
                              value: rememberMe,
                              activeColor: kPrimaryColorBlue,
                              onChanged: _onRememberMeChanged,
                            ),
                            Text(
                              "Remember Me",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            FlatButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) {
                                        return Forget_Merchant();
                                      },
                                    ),
                                  );
                                },
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: kPrimaryColorGreen,
                                  ),
                                )),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10.0),
                          decoration: new BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(35.0)),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.white,
                                offset: Offset(1.0, 6.0),
                                blurRadius: 20.0,
                              ),
                              BoxShadow(
                                color: Colors.white,
                                offset: Offset(1.0, 6.0),
                                blurRadius: 20.0,
                              ),
                            ],
                            gradient: new LinearGradient(
                                colors: [
                                  kPrimaryColorBlue,
                                  kPrimaryColorBlue,
                                ],
                                begin: const FractionalOffset(0.2, 0.2),
                                end: const FractionalOffset(1.0, 1.0),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp),
                          ),
                          child: MaterialButton(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 42.0),
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22.0,
                                      fontFamily: "PoppinsBold"),
                                ),
                              ),
                              onPressed: () {
                                validate();
                              }),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Not on Green Bill yet?",
                              style: TextStyle(
                                  color: kPrimaryColorBlue,
                                  fontSize: 12.0,
                                  fontFamily: "PoppinsMedium"),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 0.0),
                              child: FlatButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return SignUp_Merchant();
                                        },
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Register Now",
                                    style: TextStyle(
                                        color: kPrimaryColorGreen,
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "PoppinsMedium"),
                                  )),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> validate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if ((loginNumberController.text.isEmpty ||
        loginNumberController.text.length < 10)) {
      showInSnackBar("Please enter valid Number");
      return null;
    }
    if (loginPasswordController.text.isEmpty) {
      showInSnackBar("Please enter valid Password");
      return null;
    }

    _showBottomLoader();

    if (!rememberMe) {
      prefs.getKeys();
      prefs.remove("mob");
      prefs.remove("password");
      print("Okay i removed");
    }

    final param = {
      "mobile_no": loginNumberController.text,
      "password": loginPasswordController.text,
    };

    final response = await http.post(
      "http://157.230.228.250/merchant-login-api/",
      body: param,
    );

    LoginData data;
    var responseJson = json.decode(response.body);

    Navigator.pop(context);

    if (response.statusCode == 200) {
      data = new LoginData.fromJson(jsonDecode(response.body));
      print(responseJson);

      if (data.status == "success") {
        print("Login Successful");
        print(data.status);
        prefs.setString("token", data.token);
        prefs.setInt("userID", data.data.id);
        prefs.setString("email", data.data.mEmail);
        prefs.setString("mobile", data.data.mobileNo);
        prefs.setString("fName", data.data.firstName);
        prefs.setString("PassaWorda", loginPasswordController.text);
        prefs.setString("isLogin", "1");

        getBusiness(data.data.id.toString(), data.token);
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(builder: (context) => MainPage()),
        //       (Route<dynamic> route) => false,
        // );
      } else
        showInSnackBar(data.status);
    } else {
      CommonData commonData;
      commonData = new CommonData.fromJson(jsonDecode(response.body));
      print(commonData.status);
      print(commonData.message);
      showInSnackBar(commonData.message);
      return null;
    }
  }

  void _showBottomLoader() {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, state) {
            return SingleChildScrollView(
                padding: new EdgeInsets.only(top: 50.0, bottom: 50.0),
                child: new Container(
                  height: 50.0,
                  child: Center(
                    child: SpinKitSquareCircle(
                      color: kPrimaryColorBlue,
                      size: 50.0,
                    ),
                  ),
                ));
          });
        });
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white, fontSize: 16.0, fontFamily: "PoppinsMedium"),
      ),
      backgroundColor: kPrimaryColorBlue,
      duration: Duration(seconds: 2),
    ));
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  Future<void> getBusiness(String userID, String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final param = {
      "user_id": userID,
    };

    final res = await http.post(
      "http://157.230.228.250/get-merchant-businesses-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );
    List<StoreList> list;
    list = storeListFromJson(res.body);

    print(res.body);
    if (200 == res.statusCode) {
      prefs.setString("businessName", list.first.mBusinessName);
      prefs.setString("businessID", list.first.id.toString());
      prefs.setString("businessLogo", list.first.mBusinessLogo.toString());
      prefs.setString("businessCategoryID", list.first.mBusinessCategory.toString());
      print("${list.first.mBusinessName} ${list.first.id}");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeActivity()),
        (Route<dynamic> route) => false,
      );
    } else {
      print(res.statusCode);
    }
  }
}
