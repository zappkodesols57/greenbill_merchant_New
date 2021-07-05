import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:greenbill_merchant/src/Services/forgetPass_services.dart';
import 'package:greenbill_merchant/src/Services/validateOTP_services.dart';
import 'package:greenbill_merchant/src/models/model_forgetPass.dart';
import 'package:greenbill_merchant/src/models/model_validateOTP.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../constants.dart';
import 'createPass_mrchant.dart';

class Otp_Merchant extends StatefulWidget {
  final String number, signCode;
  Otp_Merchant(this.number, this.signCode);

  @override
  Otp_MerchantState createState() => Otp_MerchantState(number, signCode);
}

class Otp_MerchantState extends State<Otp_Merchant> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isColorOff;
  final String num, signCode;

  Otp_MerchantState(this.num, this.signCode);

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
    super.dispose();
    _timer.cancel();
  }

  Future<void> _listenOtp() async {
    await SmsAutoFill().listenForCode;
  }

  final FocusNode myFocusNodeOtp = FocusNode();

  TextEditingController otpController = new TextEditingController();


  int _counter = 15;
  Timer _timer ;

  void _startTimer(){
    _counter = 15;
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
                          if(value.length == 6){
                            validateOTP();
                          }
                        },
                        codeLength: 6,
                        controller: otpController,
                        focusNode: myFocusNodeOtp,
                        autofocus: false,
                        onCodeSubmitted: (value){
                          validateOTP();
                        },
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
    ValidateService.otpValidate(otpController.text, num).then((value){
      ValidateOTP otp;
      otp = value;
      if(otp.status == "success"){
        print('OTP Validated');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) {
              return CreatePass_Merchant(num);
            },
          ),
        );
      } else{
        showInSnackBar(otp.message);
        otpController.clear();
      }
    });
  }

  void resendOTP() {
    ForgetPass pass;
    ForgetPassServices.forgetPassMethod(num, signCode).then((value){
      pass = value;
      if(pass.status == "success"){
        showInSnackBar("OTP Send Successfully");
        _startTimer();
        setState(() {
          _isColorOff = false;
        });
      } else{
        print(pass.status);
        showInSnackBar(pass.status);
      }
    });
  }

}