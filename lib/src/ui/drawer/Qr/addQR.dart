import 'dart:convert';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddQR extends StatefulWidget {
  @override
  AddQRState createState() => AddQRState();
}

class AddQRState extends State<AddQR> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String token, id;

  @override
  void initState() {
    super.initState();
    getCredentials();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    mobController.dispose();
    // emailController.dispose();
    vehicleNumController.dispose();
  }

  String dropdownValue = "Select Vehicle Type";
  // String dropdownValueType = "Select Qr for";

  TextEditingController nameController = new TextEditingController();
  TextEditingController mobController = new TextEditingController();
  // TextEditingController emailController = new TextEditingController();
  TextEditingController vehicleNumController = new TextEditingController();

  getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      id = prefs.getInt("userID").toString();
      // nameController.text = "${prefs.getString("fName")} ${prefs.getString("lName")}";
      mobController.text = prefs.getString("mobile");
      // emailController.text = prefs.getString("email");
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Add QR'),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {Navigator.pop(context, false);},
        ),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              validate();
            },
            child: Text("Save"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(
                    top: 20.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: TextField(
                  controller: nameController,
                  inputFormatters: [new LengthLimitingTextInputFormatter(15),],
                  style: TextStyle(
                      //fontFamily: "PoppinsBold",
                      fontSize: 17.0,
                      color: Colors.black87),


                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterStyle: TextStyle(height: double.minPositive,),
                    counterText: "",
                    contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kPrimaryColorBlue,
                          width: 0.5
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kPrimaryColorBlue,
                          width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      FontAwesomeIcons.commentAlt,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Description *",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(
                    top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: TextField(
                  controller: mobController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  maxLength: 10,
                  style: TextStyle(
                      //fontFamily: "PoppinsBold",
                      fontSize: 17.0,
                      color: Colors.black87),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterStyle: TextStyle(height: double.minPositive,),
                    counterText: "",
                    contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kPrimaryColorBlue,
                          width: 0.5
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kPrimaryColorBlue,
                          width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      FontAwesomeIcons.mobileAlt,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Mobile No. *",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(
                    top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: InputDecorator(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      FontAwesomeIcons.car,
                      color: kPrimaryColorBlue,
                    ),
                    labelText: "Vehicle Type *",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight",
                        fontSize: 13.0,
                        color: kPrimaryColorBlue),
                    border: InputBorder.none,
                    counterStyle: TextStyle(
                      height: double.minPositive,
                    ),
                    counterText: "",
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: .0, horizontal: 5),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kPrimaryColorBlue,
                          width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kPrimaryColorBlue,
                          width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: new DropdownButton<String>(
                      iconEnabledColor: Colors.black,
                      dropdownColor: Colors.white,
                      value: dropdownValue,
                      isExpanded: true,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.w400,
                      ),
                      // icon: Icon(Icons.add_business),
                      // iconSize: 24,
                      // elevation: 1,
                      // style: TextStyle(color: Colors.black54, fontSize: 16),
                      underline: Container(
                        height: 1,
                        width: 50,
                        color: Colors.black38,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          dropdownValue = newValue;
                        });
                      },
                      items: <String>[
                        'Select Vehicle Type',
                        '2 Wheeler',
                        '3 Wheeler',
                        '4 Wheeler',
                        'Others'
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(
                    top: 10.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: TextField(
                  controller: vehicleNumController,
                  textCapitalization: TextCapitalization.characters,
                  inputFormatters: [
                    new WhitelistingTextInputFormatter(RegExp("[a-z A-Z0-9]")),
                    LengthLimitingTextInputFormatter(13),
                  ],
                  style: TextStyle(
                      //fontFamily: "PoppinsBold",
                      fontSize: 17.0,
                      color: Colors.black87),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterStyle: TextStyle(height: double.minPositive,),
                    counterText: "",
                    contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kPrimaryColorBlue,
                          width: 0.5
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kPrimaryColorBlue,
                          width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      FontAwesomeIcons.creditCard,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Vehicle No. *",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }

  bool validateEmail(String value){
    String  pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  _showLoaderDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
              content: SingleChildScrollView(
                  padding: new EdgeInsets.only(top: 0.0, bottom: 0.0),
                  child: new Container(
                    height: 40.0,
                    child: Center(
                      child: SpinKitWave(
                        color: kPrimaryColorBlue,
                        size: 40.0,
                      ),
                    ),
                  )
              )
          );
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
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "PoppinsMedium"),
      ),
      backgroundColor: kPrimaryColorBlue,
      duration: Duration(seconds: 2),
    ));
  }

  validate() async {
    if(nameController.text.isEmpty){
      showInSnackBar("Please enter Description");
      return null;
    }
    if(nameController.text.length >15){
      showInSnackBar("Maximum Character Limit Exceeded");
      return null;
    }

    if(mobController.text.isEmpty){
      showInSnackBar("Please enter Number");
      return null;
    }
    if(mobController.text.length < 10){
      showInSnackBar("Please enter valid Number");
      return null;
    }
    // if(emailController.text.isNotEmpty){
    //   if(emailController.text.contains('com') || emailController.text.contains('net') ||
    //       emailController.text.contains('edu') || emailController.text.contains('org') ||
    //       emailController.text.contains('mil') || emailController.text.contains('gov')){
    //
    //     if(validateEmail(emailController.text) == false){
    //       showInSnackBar("Invalid Email");
    //       return null;
    //     }
    //
    //   } else{
    //     showInSnackBar("Invalid Email");
    //     return null;
    //   }
    // }
    // if(dropdownValueType == "Select Qr for"){
    //   showInSnackBar("Please Select Qr Type");
    //   return null;
    // }
    if(dropdownValue == "Select Vehicle Type"){
      showInSnackBar("Please Select Vehicle Type");
      return null;
    }
    // if(dropdownValueType == "Select Qr for"){
    //   showInSnackBar("Please Select Qr Type");
    //   return null;
    // }
    if(vehicleNumController.text.isEmpty){
      showInSnackBar("Please enter Vehicle Number");
      return null;
    }

    _showLoaderDialog(context);

    final param = {
      "user_id": id,
      "description": nameController.text,
      "mobile_no": mobController.text,
      // "c_email": emailController.text,
      // "qr_type": dropdownValueT
      "vehicle_type": dropdownValue,
      "vehicle_no": vehicleNumController.text,
    };

    final response = await http.post(
      "http://157.230.228.250/generate-customer-qr-api/",
      body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(response.statusCode);
    CommonData data;
    var responseJson = json.decode(response.body);
    print(response.body);

    if (response.statusCode == 200) {
      data = new CommonData.fromJson(jsonDecode(response.body));
      print(responseJson);
      print("Submit Successful");
      print(data.status);
      if(data.status == "success"){
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pop(context, true);
      } else showInSnackBar(data.status);
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      print(data.status);
      print(data.message);
      showInSnackBar(data.message);
      return null;
    }

  }

}