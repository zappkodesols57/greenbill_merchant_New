import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_BulkSMS.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:greenbill_merchant/src/models/model_area.dart';
import 'package:greenbill_merchant/src/models/model_checkPayU.dart';
import 'package:greenbill_merchant/src/models/model_city.dart';
import 'package:greenbill_merchant/src/models/model_header.dart';
import 'package:greenbill_merchant/src/models/model_state.dart';
import 'package:greenbill_merchant/src/models/model_template.dart';
import 'package:greenbill_merchant/src/ui/BillInfo/ViewBill.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PaymentSetting extends StatefulWidget {
  @override
  PaymentSettingState createState() => PaymentSettingState();
}

class PaymentSettingState extends State<PaymentSetting> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, id, storeID;
  String key, salt;
  final ScrollController _controller = ScrollController();
  TextEditingController query = new TextEditingController();


  @override
  void initState() {
    getCredentials();
    super.initState();
  }

  TextEditingController keyController = new TextEditingController();
  TextEditingController saltController = new TextEditingController();

  getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      id = prefs.getInt("userID").toString();
      storeID = prefs.getString("businessID");
      check();
    });
  }

  check() async {

    final params = {
      "m_business_id":storeID,
    };
    print(">>>>$params");

    final response = await http.post("http://157.230.228.250/show-merchant-payment-setting-api/",
        body: params, headers: {HttpHeaders.authorizationHeader: "Token $token"});

    print(response.statusCode);
    var responseJson = json.decode(response.body);
    print(response.body);
    print(responseJson);
    if(response.statusCode == 200) {
      setState(() {
        keyController.text = checkPayUFromJson(response.body).payuKey;
        saltController.text = checkPayUFromJson(response.body).payuSalt;
      });
    }
    else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Payment Settings'),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              Image.asset('assets/payments.png'),
              SizedBox(
                height: 50.0,
              ),

              Container(
                width: size.width * 0.65,
                padding: EdgeInsets.only(
                    top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: new TextField(
                  controller: keyController,
                  inputFormatters: [LengthLimitingTextInputFormatter(6),
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]"))],
                  style: TextStyle(
                      fontFamily: "PoppinsBold",
                      fontSize: 17.0,
                      color: kPrimaryColorBlue),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterStyle: TextStyle(height: double.minPositive,),
                    counterText: "",
                    contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      FontAwesomeIcons.key,
                      color: kPrimaryColorBlue,
                      size: 20.0,
                    ),
                    labelText: "PayU Key *",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0,color: kPrimaryColorBlue),
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),

              Container(
                width: size.width * 0.65,
                padding: EdgeInsets.only(
                    top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: new TextField(
                  controller: saltController,
                  inputFormatters: [LengthLimitingTextInputFormatter(8),
                    FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]"))],
                  style: TextStyle(
                      fontFamily: "PoppinsBold",
                      fontSize: 17.0,
                      color: kPrimaryColorBlue),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterStyle: TextStyle(height: double.minPositive,),
                    counterText: "",
                    contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      FontAwesomeIcons.tag,
                      color: kPrimaryColorBlue,
                      size: 20.0,
                    ),
                    labelText: "PayU Salt *",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0,color: kPrimaryColorBlue),
                  ),
                ),
              ),
              SizedBox(height: 20.0,),

              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text("Submit",style: TextStyle(
                      fontFamily: "PoppinsBold",
                      fontSize: 22.0,
                      color: Colors.white),),
                ),
                color: kPrimaryColorBlue,
                onPressed:(){
                  submit();
                } ,
              ),
            ],
          ),
        ),
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
            color: Colors.white, fontSize: 16.0, fontFamily: "PoppinsMedium"),
      ),
      backgroundColor: kPrimaryColorBlue,
      duration: Duration(seconds: 2),
    ));
  }

  submit() async {

    if(keyController.text.isEmpty){
      showInSnackBar("Please Enter PayU Key");
      return null;
    }

    if(saltController.text.isEmpty){
      showInSnackBar("Please Enter Salt Key");
      return null;
    }


    final params = {
      "m_business_id":storeID,
      "payu_key":keyController.text,
      "payu_salt":saltController.text,
    };
    print(">>>>$params");


    final response = await http.post("http://157.230.228.250/merchant-create-and-update-payment-setting-api/",
      body: params, headers: {HttpHeaders.authorizationHeader: "Token $token"});

    print(response.statusCode);
    CommonData data;
    var responseJson = json.decode(response.body);
    print(response.body);
    print(responseJson);
    data = new CommonData.fromJson(jsonDecode(response.body));

    if (response.statusCode == 200) {
      if(data.status == "success"){
        showInSnackBar(data.message);
      } else {
        showInSnackBar(data.message);
      }
    } else {
      showInSnackBar("Something Went Wrong");
      }
  }
}