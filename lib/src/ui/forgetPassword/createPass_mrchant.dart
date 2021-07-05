import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/models/model_updatePassword.dart';
import 'package:greenbill_merchant/src/ui/widgets/background.dart';
import '../../constants.dart';
import '../widgets/congrats.dart';
import 'package:http/http.dart' as http;

class CreatePass_Merchant extends StatefulWidget {
  final String num;
  CreatePass_Merchant(this.num);

  @override
  CreatePass_MerchantState createState() => CreatePass_MerchantState(num);
}

class CreatePass_MerchantState extends State<CreatePass_Merchant> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final String number;
  CreatePass_MerchantState(this.number);

  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodePasswordConfirm = FocusNode();

  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  String warn = 'Password must contain Minimum eight characters, at least one '
      'uppercase letter, one lowercase letter, one number and one special character\nEx: Jhon@007';

  @override
  void initState() {

    super.initState();
  }


  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();

    myFocusNodePassword.dispose();
    myFocusNodePasswordConfirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: Background(child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: new Image(
                  width: 350.0,
                  height: 300.0,
                  fit: BoxFit.fill,
                  image: new AssetImage('assets/img/merchant_createPass.png')),
            ),
            Container(
              padding: EdgeInsets.only(top: 23.0),
              child: Column(
                children: <Widget>[
                  Stack(
                    alignment: Alignment.topCenter,
                    overflow: Overflow.visible,
                    children: <Widget>[
                      Card(
                        elevation: 2.0,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Container(
                          width: 350.0,
                          height: 330.0,
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 25.0,),
                              Text(
                                "Create Password",
                                style: TextStyle(
                                    color: kPrimaryColorBlue,
                                    fontSize: 30.0,
                                    fontFamily: "PoppinsBold"),
                              ),
                              Container(
                                width: size.width * 0.99,
                                padding: EdgeInsets.only(
                                    top: 20.0, bottom: 10.0, left: 25.0, right: 25.0),
                                child: TextField(
                                  focusNode: myFocusNodePassword,
                                  controller: passwordController,
                                  obscureText: _obscureTextSignup,
                                  onSubmitted: (value){
                                    // validatePassword(value) ? showInSnackBar('Valid Password', 2) : showInSnackBar(warn, 8);
                                    if(value.length < 8)
                                      showInSnackBar("Password must contain at least 8 characters", 2);
                                  },
                                  style: TextStyle(
                                      fontFamily: "PoppinsLight",
                                      fontSize: 15.0,
                                      color: kPrimaryColorBlue),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: kPrimaryColorBlue, width: 0.5),
                                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                                    ),
                                    focusedBorder: new OutlineInputBorder(
                                      borderSide: BorderSide(color: kPrimaryColorBlue, width: 0.5),
                                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                                    ),
                                    prefixIcon: Icon(
                                      FontAwesomeIcons.lock,
                                      color: kPrimaryColorBlue,
                                    ),
                                    hintText: "Enter new password",
                                    hintStyle: TextStyle(
                                        fontFamily: "PoppinsLight", fontSize: 15.0, color: kPrimaryColorBlue),
                                    suffixIcon: GestureDetector(
                                      onTap: _toggleSignup,
                                      child: Icon(
                                        _obscureTextSignup
                                            ? FontAwesomeIcons.eyeSlash
                                            : FontAwesomeIcons.eye,
                                        size: 15.0,
                                        color: kPrimaryColorBlue,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: size.width * 0.99,
                                padding: EdgeInsets.only(
                                    top: 0.0, bottom: 0.0, left: 25.0, right: 25.0),
                                child: TextField(
                                  focusNode: myFocusNodePasswordConfirm,
                                  controller: confirmPasswordController,
                                  obscureText: _obscureTextSignupConfirm,
                                  style: TextStyle(
                                      fontFamily: "PoppinsLight",
                                      fontSize: 15.0,
                                      color: kPrimaryColorBlue),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: kPrimaryColorBlue, width: 0.5),
                                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                                    ),
                                    focusedBorder: new OutlineInputBorder(
                                      borderSide: BorderSide(color: kPrimaryColorBlue, width: 0.5),
                                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                                    ),
                                    prefixIcon: Icon(
                                      FontAwesomeIcons.lock,
                                      color: kPrimaryColorBlue,
                                    ),
                                    hintText: "Confirm new password",
                                    hintStyle: TextStyle(
                                        fontFamily: "PoppinsLight", fontSize: 15.0, color: kPrimaryColorBlue),
                                    suffixIcon: GestureDetector(
                                      onTap: _toggleSignupConfirm,
                                      child: Icon(
                                        _obscureTextSignupConfirm
                                            ? FontAwesomeIcons.eyeSlash
                                            : FontAwesomeIcons.eye,
                                        size: 15.0,
                                        color: kPrimaryColorBlue,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 30.0),
                                decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(35.0)),
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
                                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 42.0),
                                      child: Text(
                                        "Update",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22.0,
                                            fontFamily: "PoppinsBold"),
                                      ),
                                    ),
                                    onPressed: () {
                                      validateData();
                                    }
                                ),
                              ),
                              SizedBox(height: 15.0,),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ))
    );
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }

  // bool validatePassword(String value){
  //   String  pattern = r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$";
  //   RegExp regExp = new RegExp(pattern);
  //   return regExp.hasMatch(value);
  // }

  void showInSnackBar(String value, int sec) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "PoppinsMedium"),
      ),
      backgroundColor: kPrimaryColorBlue,
      duration: Duration(seconds: sec),
    ));
  }

  Future<void> validateData() async {
    if(passwordController.text.isEmpty){
      showInSnackBar("Please enter Password", 2);
      return null;
    }
    if(confirmPasswordController.text.isEmpty){
      showInSnackBar("Please enter confirm password", 2);
      return null;
    }
    if(passwordController.text.length < 8){
      showInSnackBar("Password must contain at least 8 characters", 2);
      return null;
    }
    if(passwordController.text != confirmPasswordController.text){
      showInSnackBar("Password not match", 2);
      return null;
    }

    final param = {
      "mobile_no": number,
      "new_password": passwordController.text,
    };

    final response = await http.post(
      "http://157.230.228.250/forgot-password-merchant-api/",
      body: param,
    );

    UpdatePassword password;
    var responseJson = json.decode(response.body);
    password = new UpdatePassword.fromJson(jsonDecode(response.body));
    print(responseJson);

    if (response.statusCode == 200) {
      if(password.status == "success"){
        print(password.status);
        showInSnackBar("Password Changed Successfully", 2);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Congrats("Password changed successfully");
            },
          ),
        );
      } else showInSnackBar(password.message, 2);
    } else {
      print(password.status);
      showInSnackBar(password.message, 2);
      return null;
    }

  }


}