import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:greenbill_merchant/src/Services/generateOTP_services.dart';
import 'package:greenbill_merchant/src/Services/validateOTP_services.dart';
import 'package:greenbill_merchant/src/models/model_generateOTP.dart';
import 'package:greenbill_merchant/src/models/model_signup.dart';
import 'package:greenbill_merchant/src/models/model_validateOTP.dart';
import 'package:greenbill_merchant/src/ui/widgets/congrats.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../constants.dart';
import 'package:http/http.dart' as http;

class ValidateRegistration extends StatefulWidget {

  final String mobile, email, pass, business, chosenValue, city, dist, state, pin, signCode, area, referral;

  ValidateRegistration(this.mobile, this.email, this.pass, this.business, this.chosenValue, this.city, this.dist, this.state, this.pin, this.signCode, this.area, this.referral);

  @override
  ValidateRegistrationState createState() => ValidateRegistrationState(mobile, email, pass, business, chosenValue, city, dist, state, pin, signCode, area, referral);
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

class ValidateRegistrationState extends State<ValidateRegistration> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final String mobile, email, pass, business, chosenValue, city, dist, state, pin, signCode, area, referral;
  ValidateRegistrationState(this.mobile, this.email, this.pass, this.business, this.chosenValue, this.city, this.dist, this.state, this.pin, this.signCode, this.area , this.referral);

  bool _isColorOff;

  @override
  void initState(){
    _startTimer();
    _isColorOff = false;
    super.initState();
    _listenOtp();
  }

  @override
  void dispose(){
    myFocusNodeOtp.dispose();
    otpController.dispose();
    _timer.cancel();
    super.dispose();
  }

  Future<void> _listenOtp() async {
    await SmsAutoFill().listenForCode;
  }

  final FocusNode myFocusNodeOtp = FocusNode();

  TextEditingController otpController = new TextEditingController();

  int _counter = 0;
  Timer _timer ;

  void _startTimer(){
    _counter = 0;
    if(_timer != null){
      _timer.cancel();
    }
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if(_counter > 0){
          _counter--;

        }
        else{
          _timer.cancel();
          _isColorOff = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Card(
              elevation: 2.0,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                width: 350.0,
                height: 390.0,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 20.0,),
                    Text(
                      "Enter Your OTP",
                      style: TextStyle(
                          color: kPrimaryColorBlue,
                          fontSize: 30.0,
                          fontFamily: "PoppinsBold"),
                    ),
                    Container(
                      width: size.width * 0.99,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(
                          top: 20.0, bottom: 0.0, left: 25.0, right: 25.0),
                      child: Text(
                        "Green Bill has sent a 6 digit OTP to your registered number. Please enter the OTP",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    // Container(
                    //   margin: EdgeInsets.symmetric(vertical: 30),
                    //   width: MediaQuery.of(context).size.width * 0.8,
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.circular(29),
                    //   ),
                    //   child: TextField(
                    //     focusNode: myFocusNodeOtp,
                    //     controller: otpController,
                    //     keyboardType: TextInputType.number,
                    //     textAlign: TextAlign.center,
                    //     maxLength: 6,
                    //     style: TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //         fontSize: 16.0,
                    //         color: Color(0xFF000000)),
                    //     decoration: InputDecoration(
                    //       border: InputBorder.none,
                    //       contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                    //       enabledBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(color: kPrimaryColorBlue.withOpacity(0.4), width: 3.0),
                    //         borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    //       ),
                    //       focusedBorder: new OutlineInputBorder(
                    //         borderSide: BorderSide(color: kPrimaryColorBlue.withOpacity(0.4), width: 3.0),
                    //         borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    //       ),
                    //       hintText: "Enter OTP",
                    //       hintStyle: TextStyle(fontSize: 16.0, color: Color(0xFF000000), fontWeight: FontWeight.bold),
                    //     ),
                    //   ),
                    // ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 30),
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(29),
                      ),
                      child: PinFieldAutoFill(
                        onCodeChanged: (value){
                          print(value);
                          // if(value.length == 6){
                          //   validateOTP();
                          // }
                        },
                        codeLength: 6,
                        controller: otpController,
                        focusNode: myFocusNodeOtp,
                        autofocus: false,
                        // onCodeSubmitted: (value){
                        //   validateOTP();
                        // },
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 0.0),
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
                              "Verify",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontFamily: "PoppinsBold"),
                            ),
                          ),
                          onPressed: () {
                            validateOTP();
                          }
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.0),
                      child: Row(
                        children: [
                          Padding(padding: EdgeInsets.all(10.0),),
                          Icon(Icons.message,
                            color: _isColorOff ? Colors.black : Colors.grey,
                          ),
                          Row(
                            children: <Widget>[

                              FlatButton(
                                //color: kPrimaryColorBlue,
                                onPressed: _isColorOff ? () {
                                  resendOTP();
                                } : null,
                                child: Text('Re-Send OTP',
                                  style: TextStyle(
                                    color: _isColorOff ? Colors.black : Colors.grey,
                                  ),
                                ),
                              ),
                              Padding(padding: EdgeInsets.only(left: 140),),
                              (_counter > 0) ?Text('0:$_counter') :  Text(""),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.0,),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void showInSnackBar(String value) {
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
      duration: Duration(seconds: 2),
    ));
  }

  void validateOTP() {
    if(otpController.text.isEmpty){
      showInSnackBar('Please enter OTP');
      return null;
    }
    if(otpController.text.length < 6){
      showInSnackBar('Please enter valid OTP');
      return null;
    }

    ValidateService.otpValidate(otpController.text, mobile).then((value){
      ValidateOTP otpValidate;
      otpValidate = value;
      if(otpValidate.status == "success"){
        print('OTP Validated');
        _showBottomLoader();
        signUpCallApi();
      } else{
        showInSnackBar(otpValidate.message);
        otpController.clear();
      }
    });
  }

  Future<void> signUpCallApi() async {
    print('$mobile $email $pass $business $chosenValue $city $referral $dist $state $pin $area');
    final param = {
      "mobile_no": mobile,
      "m_email": email,
      "password": pass,
      "is_merchant": "1",
      "m_business_name": business.capitalize(),
      "m_business_category": chosenValue,
      "m_area": area.capitalize(),
      "m_used_referral_code": referral,
      "m_city": city.capitalize(),
      "m_district": dist.capitalize(),
      "m_state": state.capitalize(),
      "m_pin_code": pin,
      "is_active": "1",
    };

    final response = await http.post(
      "http://157.230.228.250/merchant-register-api/",
      body: param,
    );

    SignupData data;
    var responseJson = json.decode(response.body);
    data = new SignupData.fromJson(jsonDecode(response.body));
    print(responseJson);

    Navigator.pop(context);

    if (response.statusCode == 200) {
      if(data.status == "success"){
        print("SignUp Successful");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return Congrats("Congratulations on becoming a Green Bill Merchant. You can login now.");
            },
          ),
        );
      } else showInSnackBar(data.status);
    } else {
      print(data.status);
      showInSnackBar(data.status);
      return null;
    }
  }

  void _showBottomLoader(){
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context){
          return StatefulBuilder(builder: (context,state){
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
                )
            );
          });
        }
    );
  }


  void resendOTP() {
    OtpService.generateOTP(mobile, signCode).then((value){
      GenerateOTP generateOTP;
      generateOTP = value;
      if(generateOTP.status == "success"){
        showInSnackBar("OTP Send Successfully");
        _startTimer();
        setState(() {
          _isColorOff = false;
        });
      } else{
        print(generateOTP.message);
        showInSnackBar(generateOTP.message);
      }
    });
  }
}