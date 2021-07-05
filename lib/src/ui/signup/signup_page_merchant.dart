import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/Services/generateOTP_services.dart';
import 'package:greenbill_merchant/src/Services/postalApi_services.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:greenbill_merchant/src/models/model_generateOTP.dart';
import 'package:greenbill_merchant/src/models/postApi_model.dart';
import 'package:greenbill_merchant/src/ui/signup/validateRegister.dart';
import 'package:greenbill_merchant/src/ui/widgets/background.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../constants.dart';
import '../login/login_Page_Merchant.dart';
import 'package:http/http.dart' as http;

class SignUp_Merchant extends StatefulWidget {
  SignUp_Merchant({Key key}) : super(key: key);
  @override
  SignUp_MerchantState createState() => SignUp_MerchantState();
}

class SignUp_MerchantState extends State<SignUp_Merchant> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String signCode = "";
  List<PinCode> pin;

  @override
  void initState() {
    _alert = true;
    _alertMob = true;
    super.initState();
    this.getCategory();
  }

  @override
  void dispose() {
    myFocusNodeNumber.dispose();
    myFocusNodeEmail.dispose();
    myFocusNodeName.dispose();
    myFocusNodeCategory.dispose();
    myFocusNodePinCode.dispose();
    myFocusNodeArea.dispose();
    myFocusNodeState.dispose();
    myFocusNodeDistrict.dispose();
    myFocusNodeCity.dispose();
    myFocusNodePassword.dispose();
    myFocusNodePasswordConfirm.dispose();

    myFocusNodeOtp.dispose();

    signupMobileController.dispose();
    signupEmailController.dispose();
    signupNameController.dispose();
    signupPinController.dispose();
    signupAreaController.dispose();
    signupStateController.dispose();
    signupDistrictController.dispose();
    signupCityController.dispose();
    signupPasswordController.dispose();
    signupConfirmPasswordController.dispose();
    signupReferralCodeController.dispose();

    otpController.dispose();
    super.dispose();
  }

  final String url =
      "http://157.230.228.250/get-merchant-business-category-api/";
  List data = List();
  Future<String> getCategory() async {
    var res = await http
        .get(Uri.encodeFull(url), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);
    setState(() {
      data = resBody;
    });
    print(resBody);
    return "Success";
  }

  getUserData(String pinCodes) {
    Services.getUserLocation(pinCodes).then((value) {
      pin = value;
      PinCode code;
      for (int i = 0; i < pin.length; i++) {
        code = pin[i];
        signupStateController.text = code.postOffice.first.circle;
        signupDistrictController.text = code.postOffice.first.district;
        signupCityController.text = code.postOffice.first.region;
      }
    });
  }

  final FocusNode myFocusNodeNumber = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();
  final FocusNode myFocusNodeCategory = FocusNode();
  final FocusNode myFocusNodePinCode = FocusNode();
  final FocusNode myFocusNodeArea = FocusNode();
  final FocusNode myFocusNodeState = FocusNode();
  final FocusNode myFocusNodeDistrict = FocusNode();
  final FocusNode myFocusNodeCity = FocusNode();
  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodePasswordConfirm = FocusNode();

  final FocusNode myFocusNodeOtp = FocusNode();

  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  TextEditingController signupMobileController = new TextEditingController();
  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupPinController = new TextEditingController();
  TextEditingController signupAreaController = new TextEditingController();
  TextEditingController signupStateController = new TextEditingController();
  TextEditingController signupDistrictController = new TextEditingController();
  TextEditingController signupCityController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupConfirmPasswordController = new TextEditingController();
  TextEditingController signupReferralCodeController = new TextEditingController();

  TextEditingController otpController = new TextEditingController();

  String _chosenValue;
  bool _alert = true;
  bool _alertMob = true;
  String warn = 'Password must contain Minimum eight characters, at least one '
      'uppercase letter, one lowercase letter, one number and one special character\nEx: Jhon@007';

  String email = 'Invalid Email';
  bool rememberMe = false;

  void _onRememberMeChanged(bool newValue) {
    setState(() {
      rememberMe = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        body: SafeArea(
            child: Background(
                child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  width: size.width * 0.9,
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                        "Registration",
                        style: TextStyle(
                            color: kPrimaryColorBlue,
                            fontSize: 30.0,
                            fontFamily: "PoppinsBold"),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.transparent,
                            size: 25.0,
                          ),
                          onPressed: null),
                    ],
                  )),
              Container(
                width: size.width * 0.9,
                padding: EdgeInsets.only(
                    top: 5.0, bottom: 0.0, left: 15.0, right: 0.0),
                child: Text(
                  'Mandatory Fields *',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              Container(
                width: size.width * 0.9,
                padding: EdgeInsets.only(
                    top: 5.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: TextField(
                  focusNode: myFocusNodeNumber,
                  controller: signupMobileController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  onChanged: (value) {
                    if (value.length == 10) validateMob(value);
                  },
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 13.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              _alertMob ? kPrimaryColorBlue : kPrimaryColorRed,
                          width: 0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              _alertMob ? kPrimaryColorBlue : kPrimaryColorRed,
                          width: 0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      FontAwesomeIcons.mobileAlt,
                      color: kPrimaryColorBlue,
                      size: 20.0,
                    ),
                    suffixIcon: Icon(
                      _alertMob ? null : Icons.error,
                      color: kPrimaryColorRed,
                      size: 20.0,
                    ),
                    labelText: "Mobile Number *",
                    // suffixText: '*',
                    // suffixStyle: TextStyle(
                    //   color: Colors.red,
                    // ),
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight",
                        fontSize: 13.0,
                        color: kPrimaryColorBlue),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.9,
                padding: EdgeInsets.only(
                    top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                child: TextField(
                  focusNode: myFocusNodeEmail,
                  controller: signupEmailController,
                  keyboardType: TextInputType.emailAddress,
                  // onSubmitted: (value){
                  //   if(value.isNotEmpty)
                  //     validateEmail(value) ? showInSnackBar('Valid Email', 2) : showInSnackBar(email, 2);
                  //   else showInSnackBar("Please enter the Email ID", 2);
                  // },
                  style: TextStyle(
                      fontFamily: "PoppinsLight",
                      fontSize: 13.0,
                      color: kPrimaryColorBlue),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 13.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      FontAwesomeIcons.envelope,
                      color: kPrimaryColorBlue,
                      size: 20.0,
                    ),
                    labelText: "Email *",
                    // suffixText: '*',
                    // suffixStyle: TextStyle(
                    //   color: Colors.red,
                    // ),
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight",
                        fontSize: 13.0,
                        color: kPrimaryColorBlue),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.9,
                padding: EdgeInsets.only(
                    top: 10.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: TextField(
                  focusNode: myFocusNodeName,
                  controller: signupNameController,
                  style: TextStyle(
                      fontFamily: "PoppinsLight",
                      fontSize: 13.0,
                      color: kPrimaryColorBlue),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 13.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      FontAwesomeIcons.businessTime,
                      color: kPrimaryColorBlue,
                      size: 20.0,
                    ),
                    labelText: "Business Name *",
                    // suffixText: '*',
                    // suffixStyle: TextStyle(
                    //   color: Colors.red,
                    // ),
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight",
                        fontSize: 13.0,
                        color: kPrimaryColorBlue),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.9,
                padding: EdgeInsets.only(
                    top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        width: size.width * 0.4,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: kPrimaryColorBlue, width: 0.5),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Center(
                          child: new DropdownButton(
                            focusNode: myFocusNodeCategory,
                            iconEnabledColor: kPrimaryColorBlue,
                            //elevation: 5,
                            isExpanded: false,
                            style: TextStyle(
                                color: kPrimaryColorBlue,
                                fontFamily: "PoppinsLight",
                                fontSize: 13.0),
                            underline: Container(
                                height: 2,
                                width: 50,
                                color: Colors.transparent),
                            items: data.map((item) {
                              return DropdownMenuItem(
                                child: new Text(item['business_category_name']),
                                value: item['id'].toString(),
                              );
                            }).toList(),
                            hint: Text(
                              "Category*",
                              style: TextStyle(
                                color: kPrimaryColorBlue,
                                fontSize: 13.0,
                                fontFamily: "PoppinsLight",
                              ),
                            ),
                            onChanged: (String value) {
                              setState(() {
                                _chosenValue = value;
                              });
                            },
                            value: _chosenValue,
                          ),
                        )),
                    SizedBox(
                      width: size.width * 0.1,
                    ),
                    Container(
                      width: size.width * 0.4,
                      child: TextField(
                        focusNode: myFocusNodePinCode,
                        controller: signupPinController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        onChanged: (value) {
                          getUserData(signupPinController.text);
                        },
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
                            borderRadius:
                                const BorderRadius.all(Radius.circular(35.0)),
                          ),
                          focusedBorder: new OutlineInputBorder(
                            borderSide: BorderSide(
                                color: kPrimaryColorBlue, width: 0.5),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(35.0)),
                          ),
                          prefixIcon: Icon(
                            FontAwesomeIcons.searchLocation,
                            color: kPrimaryColorBlue,
                            size: 20.0,
                          ),
                          labelText: "Pin Code",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight",
                              fontSize: 13.0,
                              color: kPrimaryColorBlue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: size.width * 0.1,
              ),
              Container(
                width: size.width * 0.9,
                padding: EdgeInsets.only(
                    top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: size.width * 0.4,
                      child: TextField(
                        focusNode: myFocusNodeArea,
                        controller: signupAreaController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            fontFamily: "PoppinsLight",
                            fontSize: 13.0,
                            color: kPrimaryColorBlue),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 13),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: kPrimaryColorBlue, width: 0.5),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(35.0)),
                          ),
                          focusedBorder: new OutlineInputBorder(
                            borderSide: BorderSide(
                                color: kPrimaryColorBlue, width: 0.5),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(35.0)),
                          ),
                          prefixIcon: Icon(
                            FontAwesomeIcons.mapPin,
                            color: kPrimaryColorBlue,
                            size: 20.0,
                          ),
                          labelText: "Area",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight",
                              fontSize: 13.0,
                              color: kPrimaryColorBlue),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.1,
                    ),
                    Container(
                      width: size.width * 0.4,
                      child: TextField(
                        focusNode: myFocusNodeCity,
                        controller: signupCityController,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                            fontFamily: "PoppinsLight",
                            fontSize: 13.0,
                            color: kPrimaryColorBlue),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 13),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: kPrimaryColorBlue, width: 0.5),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(35.0)),
                          ),
                          focusedBorder: new OutlineInputBorder(
                            borderSide: BorderSide(
                                color: kPrimaryColorBlue, width: 0.5),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(35.0)),
                          ),
                          prefixIcon: Icon(
                            FontAwesomeIcons.city,
                            color: kPrimaryColorBlue,
                            size: 20.0,
                          ),
                          labelText: "City",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight",
                              fontSize: 13.0,
                              color: kPrimaryColorBlue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: size.width * 0.9,
                padding: EdgeInsets.only(
                    top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: size.width * 0.4,
                      child: TextField(
                        focusNode: myFocusNodeDistrict,
                        controller: signupDistrictController,
                        keyboardType: TextInputType.text,
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
                                color: kPrimaryColorBlue, width: 0.5),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(35.0)),
                          ),
                          focusedBorder: new OutlineInputBorder(
                            borderSide: BorderSide(
                                color: kPrimaryColorBlue, width: 0.5),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(35.0)),
                          ),
                          prefixIcon: Icon(
                            FontAwesomeIcons.mapMarkedAlt,
                            color: kPrimaryColorBlue,
                            size: 20.0,
                          ),
                          labelText: "District",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight",
                              fontSize: 13.0,
                              color: kPrimaryColorBlue),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.1,
                    ),
                    Container(
                      width: size.width * 0.4,
                      child: TextField(
                        focusNode: myFocusNodeState,
                        controller: signupStateController,
                        keyboardType: TextInputType.text,
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
                                color: kPrimaryColorBlue, width: 0.5),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(35.0)),
                          ),
                          focusedBorder: new OutlineInputBorder(
                            borderSide: BorderSide(
                                color: kPrimaryColorBlue, width: 0.5),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(35.0)),
                          ),
                          prefixIcon: Icon(
                            FontAwesomeIcons.map,
                            color: kPrimaryColorBlue,
                            size: 20.0,
                          ),
                          labelText: "State",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight",
                              fontSize: 13.0,
                              color: kPrimaryColorBlue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: size.width * 0.9,
                padding: EdgeInsets.only(
                    top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: TextField(
                  controller: signupReferralCodeController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                      fontFamily: "PoppinsLight",
                      fontSize: 13.0,
                      color: kPrimaryColorBlue),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 13.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      FontAwesomeIcons.bullhorn,
                      color: kPrimaryColorBlue,
                      size: 20.0,
                    ),
                    labelText: "Referral Code",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight",
                        fontSize: 13.0,
                        color: kPrimaryColorBlue),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.9,
                padding: EdgeInsets.only(
                    top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                child: TextField(
                  focusNode: myFocusNodePassword,
                  controller: signupPasswordController,
                  obscureText: _obscureTextSignup,
                  onSubmitted: (value) {
                    // validatePassword(value) ? showInSnackBar('Valid Password', 2) : showInSnackBar(warn, 8);
                    if (value.length < 8)
                      showInSnackBar(
                          "Password must contain at least 8 characters", 2);
                  },
                  style: TextStyle(
                      fontFamily: "PoppinsLight",
                      fontSize: 13.0,
                      color: kPrimaryColorBlue),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 13.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      FontAwesomeIcons.lock,
                      color: kPrimaryColorBlue,
                      size: 20.0,
                    ),
                    labelText: "Enter Password *",
                    // suffixText: '*',
                    // suffixStyle: TextStyle(
                    //   color: Colors.red,
                    // ),
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight",
                        fontSize: 13.0,
                        color: kPrimaryColorBlue),
                    suffixIcon: GestureDetector(
                      onTap: _toggleSignup,
                      child: Icon(
                        _obscureTextSignup
                            ? FontAwesomeIcons.eyeSlash
                            : FontAwesomeIcons.eye,
                        size: 13.0,
                        color: kPrimaryColorBlue,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.9,
                padding: EdgeInsets.only(
                    top: 10.0, bottom: 0.0, left: 0.0, right: 0.0),
                child: TextField(
                  controller: signupConfirmPasswordController,
                  obscureText: _obscureTextSignupConfirm,
                  style: TextStyle(
                      fontFamily: "PoppinsLight",
                      fontSize: 13.0,
                      color: kPrimaryColorBlue),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 13.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: _alert ? kPrimaryColorBlue : kPrimaryColorRed,
                          width: 0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: _alert ? kPrimaryColorBlue : kPrimaryColorRed,
                          width: 0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      FontAwesomeIcons.lock,
                      color: kPrimaryColorBlue,
                      size: 20.0,
                    ),
                    labelText: "Confirm Password *",
                    // suffixText: '*',
                    // suffixStyle: TextStyle(
                    //   color: Colors.red,
                    // ),
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight",
                        fontSize: 13.0,
                        color: kPrimaryColorBlue),
                    suffixIcon: GestureDetector(
                      onTap: _toggleSignupConfirm,
                      child: Icon(
                        _obscureTextSignupConfirm
                            ? FontAwesomeIcons.eyeSlash
                            : FontAwesomeIcons.eye,
                        size: 13.0,
                        color: kPrimaryColorBlue,
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Checkbox(
                      value: rememberMe,
                      activeColor: kPrimaryColorBlue,
                      onChanged: _onRememberMeChanged,
                    ),
                    Container(
                        child: Center(
                            child: RichText(
                      text: TextSpan(
                          text: 'I accept the ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text: 'Terms of service',
                                style: TextStyle(
                                    color: kPrimaryColorBlue,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // open desired screen
                                  }),
                            TextSpan(
                                text: ' and ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13,
                                )),
                            TextSpan(
                                text: 'Privacy Policy',
                                style: TextStyle(
                                    color: kPrimaryColorBlue,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    // open desired screen
                                  }),
                          ]),
                    ))),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20.0),
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
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        "Register",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                            fontFamily: "PoppinsBold"),
                      ),
                    ),
                    onPressed: () {
                      validates();
                    }),
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Already on Green Bill?",
                    style: TextStyle(
                        color: kPrimaryColorBlue,
                        fontSize: 13.0,
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
                              return Login_Merchant();
                            },
                          ),
                        );
                      },
                      child: Text(
                        "Login Now",
                        style: TextStyle(
                            color: kPrimaryColorGreen,
                            fontSize: 20.0,
                            fontFamily: "PoppinsBold"),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ))));
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

  void showInSnackBar(String value, int sec) {
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
      duration: Duration(seconds: sec),
    ));
  }

  // bool validatePassword(String value){
  //   String  pattern = r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$";
  //   RegExp regExp = new RegExp(pattern);
  //   return regExp.hasMatch(value);
  // }

  bool validateEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  Future<void> validates() async {
    if (signupMobileController.text.isEmpty) {
      showInSnackBar("Please enter Number", 2);
      return null;
    }
    if (signupMobileController.text.length < 10) {
      showInSnackBar("Please enter Valid Number", 2);
      return null;
    }
    if (signupEmailController.text.isEmpty) {
      showInSnackBar("Please enter the Email ID", 2);
      return null;
    }
    if (signupEmailController.text.isNotEmpty) {
      if (signupEmailController.text.contains('com') ||
          signupEmailController.text.contains('net') ||
          signupEmailController.text.contains('edu') ||
          signupEmailController.text.contains('org') ||
          signupEmailController.text.contains('mil') ||
          signupEmailController.text.contains('gov')) {
        if (validateEmail(signupEmailController.text) == false) {
          showInSnackBar(email, 2);
          return null;
        }
      } else {
        showInSnackBar("Invalid Email", 2);
        return null;
      }
    }
    if (signupNameController.text.isEmpty) {
      showInSnackBar("Please enter Business Name", 2);
      return null;
    }
    if (_chosenValue == null) {
      showInSnackBar("Please enter Business Category", 2);
      return null;
    }
    if (signupPinController.text.isNotEmpty) {
      if (signupPinController.text.length < 6) {
        showInSnackBar("Please enter valid Pin Code", 2);
        return null;
      }
    }
    // if(signupPinController.text.isEmpty){
    //   showInSnackBar("Please enter Pin Code", 2);
    //   return null;
    // }
    // if(signupPinController.text.length < 6){
    //   showInSnackBar("Please enter valid Pin Code", 2);
    //   return null;
    // }
    // if(signupStateController.text.isEmpty){
    //   showInSnackBar("Please enter State", 2);
    //   return null;
    // }
    // if(signupDistrictController.text.isEmpty){
    //   showInSnackBar("Please enter District", 2);
    //   return null;
    // }
    // if(signupCityController.text.isEmpty){
    //   showInSnackBar("Please enter City", 2);
    //   return null;
    // }
    if (signupPasswordController.text.isEmpty) {
      showInSnackBar("Please enter Password", 2);
      return null;
    }
    if (signupConfirmPasswordController.text.isEmpty) {
      showInSnackBar("Please confirm your password", 2);
      return null;
    }
    if (signupPasswordController.text.length < 8) {
      showInSnackBar("Password must contain at least 8 characters", 8);
      return null;
    }
    if (signupPasswordController.text != signupConfirmPasswordController.text) {
      setState(() {
        _alert = false;
      });
      showInSnackBar("Password not match", 2);
      return null;
    }
    if (signupPasswordController.text == signupConfirmPasswordController.text) {
      setState(() {
        _alert = true;
      });
    }
    if (rememberMe == false) {
      showInSnackBar("Please accept Terms of Service", 2);
      return null;
    }

    if (Platform.isAndroid) {
      signCode = await SmsAutoFill().getAppSignature;
      print(signCode);
    }

    OtpService.generateOTP(signupMobileController.text, signCode).then((value) {
      GenerateOTP generateOTP;
      generateOTP = value;
      if (generateOTP.status == "success") {
        print(generateOTP.status);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return ValidateRegistration(
                  signupMobileController.text,
                  signupEmailController.text,
                  signupPasswordController.text,
                  signupNameController.text,
                  _chosenValue,
                  signupCityController.text,
                  signupDistrictController.text,
                  signupStateController.text,
                  signupPinController.text,
                  signupReferralCodeController.text,
                  signCode,
                  signupAreaController.text);
            },
          ),
        );
      } else {
        print(generateOTP.message);
        showInSnackBar(generateOTP.message, 2);
      }
    });
  }

  validateMob(mob) async {
    final param = {
      "mobile_no": mob,
    };

    final response = await http.post(
      "http://157.230.228.250/validate-merchant-mobile-number-api/",
      body: param,
    );

    var responseJson = json.decode(response.body);
    print(response.body);

    CommonData commonData;
    commonData = new CommonData.fromJson(jsonDecode(response.body));
    print(responseJson);

    if (response.statusCode != 200) {
      print("Number already exist");
      print(commonData.status);
      if (commonData.status == "error") {
        showInSnackBar(commonData.message, 2);
        setState(() {
          _alertMob = false;
        });
      } else
        print(commonData.message);
    } else {
      print(commonData.message);
      setState(() {
        _alertMob = true;
      });
    }
  }

  // void _showBottomOtp(){
  //
  //   showModalBottomSheet(
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
  //       backgroundColor: Colors.white,
  //       context: context,
  //       isScrollControlled: true,
  //       builder: (context) => Padding(
  //         padding: const EdgeInsets.symmetric(horizontal:18 ),
  //         child: Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: <Widget>[
  //             new Image(
  //                 width: 250.0,
  //                 height: 220.0,
  //                 fit: BoxFit.fill,
  //                 image: new AssetImage('assets/img/otp.png')),
  //             new Padding(
  //               padding: EdgeInsets.only(
  //                   top: 20.0, bottom: 20.0, left: 20.0, right: 20.0),
  //               child: TextField(
  //                 focusNode: myFocusNodeOtp,
  //                 controller: otpController,
  //                 textAlign: TextAlign.center,
  //                 maxLength: 6,
  //                 maxLengthEnforced: true,
  //                 keyboardType: TextInputType.number,
  //                 style: TextStyle(
  //                     fontFamily: "PoppinsBold",
  //                     fontSize: 16.0,
  //                     color: Color(0xFF63B90B)),
  //                 decoration: InputDecoration(
  //                   border: InputBorder.none,
  //                   contentPadding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 13.0),
  //                   enabledBorder: OutlineInputBorder(
  //                     borderSide: BorderSide(color: Color(0xFF63B90B), width: 0.5),
  //                     borderRadius: const BorderRadius.all(Radius.circular(35.0)),
  //                   ),
  //                   prefixIcon: Icon(
  //                     FontAwesomeIcons.mobileAlt,
  //                     size: 22.0,
  //                     color: Color(0xFF63B90B),
  //                   ),
  //                   hintText: "Enter OTP",
  //                   hintStyle: TextStyle(
  //                       fontFamily: "PoppinsBold", fontSize: 17.0, color: Color(0xFF63B90B)),
  //                 ),
  //               ),
  //             ),
  //             new Container(
  //               margin: EdgeInsets.only(bottom: 30.0),
  //               decoration: new BoxDecoration(
  //                 borderRadius: BorderRadius.all(Radius.circular(5.0)),
  //                 boxShadow: <BoxShadow>[
  //                   BoxShadow(
  //                     color: Colors.white,
  //                     offset: Offset(1.0, 6.0),
  //                     blurRadius: 20.0,
  //                   ),
  //                   BoxShadow(
  //                     color: Colors.white,
  //                     offset: Offset(1.0, 6.0),
  //                     blurRadius: 20.0,
  //                   ),
  //                 ],
  //                 gradient: new LinearGradient(
  //                     colors: [
  //                       kPrimaryColorBlue,
  //                       kPrimaryColorBlue,
  //                     ],
  //                     begin: const FractionalOffset(0.2, 0.2),
  //                     end: const FractionalOffset(1.0, 1.0),
  //                     stops: [0.0, 1.0],
  //                     tileMode: TileMode.clamp),
  //               ),
  //               child: MaterialButton(
  //                   highlightColor: Colors.transparent,
  //                   splashColor: Colors.white,
  //                   //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
  //                   child: Padding(
  //                     padding: const EdgeInsets.symmetric(
  //                         vertical: 10.0, horizontal: 42.0),
  //                     child: Text(
  //                       "Submit",
  //                       style: TextStyle(
  //                           color: Colors.white,
  //                           fontSize: 20.0,
  //                           fontFamily: "WorkSansBold"),
  //                     ),
  //                   ),
  //                   onPressed: () {
  //                     if(otpController.text.isNotEmpty){
  //                       ValidateService.otpValidate(otpController.text, signupMobileController.text).then((value){
  //                         ValidateOTP otp;
  //                         otp = value;
  //                         if(otp.status == "success"){
  //                           Navigator.pop(context);
  //                           signUpCallApi();
  //                         } else{
  //                           Navigator.pop(context);
  //                           showInSnackBar(otp.message, 2);
  //                           setState(() {
  //                             otpController.clear();
  //                           });
  //                         }
  //                       });
  //                     }
  //                   }
  //               ),
  //             ),
  //             Container(
  //               margin: EdgeInsets.only(top: 20.0),
  //               child: Row(
  //                 children: [
  //                   Padding(padding: EdgeInsets.all(10.0),),
  //                   Icon(Icons.message,
  //                     color: Colors.black,
  //                   ),
  //                   Row(
  //                     // mainAxisAlignment: MainAxisAlignment.center,
  //                     children: <Widget>[
  //
  //                       FlatButton(
  //                         //color: Color(0xFF00569D),
  //                         onPressed: () {
  //                           Navigator.pop(context);
  //                           validates();
  //                         },
  //                         child: Text('Re-Send OTP',
  //                           style: TextStyle(
  //                             color: Colors.black,
  //                           ),
  //                         ),
  //                         //shape: RoundedRectangleBorder(
  //                         // borderRadius: BorderRadius.circular(50.0),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ));
  //
  // }

}
