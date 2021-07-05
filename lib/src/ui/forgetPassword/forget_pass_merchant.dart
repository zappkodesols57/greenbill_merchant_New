import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/Services/forgetPass_services.dart';
import 'package:greenbill_merchant/src/models/model_forgetPass.dart';
import 'package:greenbill_merchant/src/ui/widgets/background.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../constants.dart';
import 'otp_merchant.dart';

class Forget_Merchant extends StatefulWidget {
  Forget_Merchant({Key key}) : super(key: key);
  @override
  Forget_MerchantState createState() => Forget_MerchantState();
}

class Forget_MerchantState extends State<Forget_Merchant> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String signCode = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    myFocusNodeForgetNumber.dispose();
    forgetNumberController.dispose();
    super.dispose();
  }

  final FocusNode myFocusNodeForgetNumber = FocusNode();

  TextEditingController forgetNumberController = new TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        body: Background(
            child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: new Image(
                    width: size.width * 0.8,
                    height: size.height * 0.3,
                    fit: BoxFit.fill,
                    image: new AssetImage('assets/img/merchant_forget.png')),
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
                                Container(
                                    width: size.width * 0.99,
                                    padding: EdgeInsets.only(
                                        top: 0.0,
                                        bottom: 0.0,
                                        left: 0.0,
                                        right: 0.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        IconButton(
                                            icon: Icon(
                                              Icons.arrow_back_ios,
                                              color: Colors.black,
                                              size: 25.0,
                                            ),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            }),
                                        Text(
                                          "Forgot Password",
                                          style: TextStyle(
                                              color: kPrimaryColorBlue,
                                              fontSize: 30.0,
                                              fontFamily: "PoppinsBold"),
                                        ),
                                        SizedBox(width: 0.0),
                                      ],
                                    )),
                                Container(
                                  width: size.width * 0.99,
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(
                                      top: 10.0,
                                      bottom: 0.0,
                                      left: 25.0,
                                      right: 25.0),
                                  child: Text(
                                    "Green Bill will send an SMS message to verify your phone number.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: size.width * 0.99,
                                  padding: EdgeInsets.only(
                                      top: 30.0,
                                      bottom: 15.0,
                                      left: 15.0,
                                      right: 15.0),
                                  child: TextField(
                                    focusNode: myFocusNodeForgetNumber,
                                    controller: forgetNumberController,
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
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 13.0),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: kPrimaryColorBlue,
                                            width: 0.5),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(35.0)),
                                      ),
                                      focusedBorder: new OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: kPrimaryColorBlue,
                                            width: 0.5),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(35.0)),
                                      ),
                                      prefixIcon: Icon(
                                        FontAwesomeIcons.mobileAlt,
                                        color: kPrimaryColorBlue,
                                        size: 20.0,
                                      ),
                                      labelText: "Enter Registered Number",
                                      labelStyle: TextStyle(
                                          fontFamily: "PoppinsLight",
                                          fontSize: 13.0,
                                          color: kPrimaryColorBlue),
                                    ),
                                  ),
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
                                      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10.0, horizontal: 42.0),
                                        child: Text(
                                          "Send OTP",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22.0,
                                              fontFamily: "PoppinsBold"),
                                        ),
                                      ),
                                      onPressed: () async {
                                        if (Platform.isAndroid) {
                                          signCode = await SmsAutoFill()
                                              .getAppSignature;
                                          print(signCode);
                                        }
                                        validate(signCode);
                                      }),
                                ),
                                SizedBox(
                                  height: 15.0,
                                ),
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
        )));
  }

  void validate(String signCode) {
    if (forgetNumberController.text.isEmpty ||
        forgetNumberController.text.length < 10) {
      showInSnackBar("Please enter valid Number");
      return null;
    } else {
      ForgetPass pass;
      ForgetPassServices.forgetPassMethod(forgetNumberController.text, signCode)
          .then((value) {
        pass = value;
        if (pass.status == "success") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Otp_Merchant(forgetNumberController.text, signCode);
              },
            ),
          );
        } else {
          print(pass.status);
          showInSnackBar("User not registered");
        }
      });
    }
  }
}
