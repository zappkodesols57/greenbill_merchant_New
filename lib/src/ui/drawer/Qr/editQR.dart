import 'dart:convert';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditQR extends StatefulWidget {
  final String id, mobileNo, dec, vehicleNo, vehicleType;
  EditQR(this.id, this.mobileNo, this.dec, this.vehicleNo, this.vehicleType);
  @override
  EditQRState createState() => EditQRState();
}

class EditQRState extends State<EditQR> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String token, id;
  bool _isButtonDisabled = true;
  bool _isButtonDisabledColor = true;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    mobController.text = widget.mobileNo;
    // dropdownValueType = widget.qrType;
    nameController.text = widget.dec;
    // emailController.text = widget.cEmail;
    vehicleNumController.text = widget.vehicleNo;
    dropdownValue = widget.vehicleType;
    _isButtonDisabled = true;
    _isButtonDisabledColor = true;
    getCredentials();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    mobController.dispose();
    emailController.dispose();
    vehicleNumController.dispose();
  }

  String dropdownValue = "Select Vehicle Type";
  String dropdownValueType = "Select Qr for";

  TextEditingController nameController = new TextEditingController();
  TextEditingController mobController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController vehicleNumController = new TextEditingController();

  getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
    });
  }

  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  capture() async {
    print("capturing...........................");
    screenshotController.capture(pixelRatio: 2).then((File image) {
      Share.shareFiles([image.path], text: nameController.text);
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('View QR'),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {Navigator.pop(context, false);},
        ),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              capture();
            },
            child: Icon(Icons.share),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
          FlatButton(
            textColor: _isButtonDisabledColor ? Colors.grey : Colors.white,
            onPressed: () {
              _isButtonDisabled ? null : validate();
            },
            child: Text("SAVE"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Screenshot(
              controller: screenshotController,
              child: Column(
                children: [
                  Container(
                    width: size.width * 0.99,
                    padding: EdgeInsets.only(
                        top: 20.0, bottom: 20.0, left: 20.0, right: 25.0),
                    child: Text(
                      "Show this QR Code to Cashier",
                      style: TextStyle(
                        color: Colors.black,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        fontFamily: "PoppinsMedium",
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Card(
                    elevation: 5.0,
                    shadowColor: kPrimaryColor,
                    child: QrImage(
                      data: "${widget.mobileNo}~${widget.vehicleType}~${widget.vehicleNo}~GreenBill",
                      version: QrVersions.auto,
                      size: 250.0,
                      // gapless: false,
                      foregroundColor: kPrimaryColorBlue,
                      embeddedImage: AssetImage('assets/icon.png'),
                      embeddedImageStyle: QrEmbeddedImageStyle(
                        size: Size(40, 40),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0,),
                ],
              ),
            ),
            Container(
              width: size.width * 0.99,
              padding: EdgeInsets.only(
                  top: 10.0, bottom: 0.0, left: 20.0, right: 25.0),
              child: Text(
                "Edit QR Code",
                style: TextStyle(
                  color: Colors.black,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              width: size.width * 0.95,
              padding: EdgeInsets.only(
                  top: 20.0, bottom: 10.0, left: 0.0, right: 0.0),
              child: TextField(
                controller: nameController,
                inputFormatters: [new LengthLimitingTextInputFormatter(15),],
                // inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[a-z A-Z]")),],
                onChanged: (value){
                  setState(() {
                    _isButtonDisabledColor = false;
                    _isButtonDisabled = false;
                  });
                },
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
                onChanged: (value){
                  setState(() {
                    _isButtonDisabledColor = false;
                    _isButtonDisabled = false;
                  });
                },
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
                child: DropdownButton<String>(
                  iconEnabledColor: Colors.black,
                  dropdownColor: Colors.white,
                  value: dropdownValue,
                  isExpanded: true,
                  style: TextStyle(
                    //fontFamily: "PoppinsBold",
                      fontSize: 17.0,
                      color: Colors.black87),
                  // icon: Icon(Icons.add_business),
                  // iconSize: 24,
                  // elevation: 1,
                  // style: TextStyle(color: Colors.black54, fontSize: 16),
                  underline: Container(
                    height: 0,
                    width: 0,
                    color: Colors.transparent,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                      _isButtonDisabledColor = false;
                      _isButtonDisabled = false;
                    });
                  },
                  items: <String>[
                    'Select Vehicle Type',
                    '2 Wheeler',
                    '3 Wheeler',
                    '4 Wheeler',
                    'Other'
                  ]
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
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
                onChanged: (value){
                  setState(() {
                    _isButtonDisabledColor = false;
                    _isButtonDisabled = false;
                  });
                },
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
                    FontAwesomeIcons.motorcycle,
                    color: kPrimaryColorBlue,
                    size: 23.0,
                  ),
                  labelText: "Vehicle No. *",
                  labelStyle: TextStyle(
                      fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                ),
              ),
            ),

            // Container(
            //     width: size.width * 0.99,
            //     padding: EdgeInsets.only(
            //         top: 10.0, bottom: 0.0, left: 20.0, right: 25.0),
            //     child: RichText(
            //       text: TextSpan(
            //           text: 'Description ',
            //           style: TextStyle(
            //             color: Colors.black45,
            //             fontStyle: FontStyle.normal,
            //             fontWeight: FontWeight.w600,
            //           ),
            //           children: <TextSpan>[
            //             TextSpan(text: '*',
            //               style: TextStyle(
            //                 color: Colors.red,
            //                 fontStyle: FontStyle.normal,
            //                 fontWeight: FontWeight.w600,
            //               ),
            //               // recognizer: TapGestureRecognizer()
            //               //   ..onTap = () {
            //               //     // open desired screen
            //               //   }
            //             ),
            //           ]
            //       ),
            //     )
            // ),
            // Container(
            //   width: size.width * 0.99,
            //   padding: EdgeInsets.only(
            //       top: 0.0, bottom: 0.0, left: 20.0, right: 25.0),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(5),
            //   ),
            //   child: new TextField(
            //     controller: nameController,
            //     onChanged: (value){
            //       setState(() {
            //         _isButtonDisabledColor = false;
            //         _isButtonDisabled = false;
            //       });
            //     },
            //     inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[a-z A-Z]")),],
            //     style: TextStyle(
            //       color: Colors.black,
            //       fontSize: 17,
            //       fontStyle: FontStyle.normal,
            //       fontWeight: FontWeight.w400,
            //     ),
            //   ),
            // ),
            // Container(
            //     width: size.width * 0.99,
            //     padding: EdgeInsets.only(
            //         top: 10.0, bottom: 0.0, left: 20.0, right: 25.0),
            //     child: RichText(
            //       text: TextSpan(
            //           text: 'Mobile No. ',
            //           style: TextStyle(
            //             color: Colors.black45,
            //             fontStyle: FontStyle.normal,
            //             fontWeight: FontWeight.w600,
            //           ),
            //           children: <TextSpan>[
            //             TextSpan(text: '*',
            //               style: TextStyle(
            //                 color: Colors.red,
            //                 fontStyle: FontStyle.normal,
            //                 fontWeight: FontWeight.w600,
            //               ),
            //               // recognizer: TapGestureRecognizer()
            //               //   ..onTap = () {
            //               //     // open desired screen
            //               //   }
            //             ),
            //           ]
            //       ),
            //     )
            // ),
            // Container(
            //   width: size.width * 0.99,
            //   padding: EdgeInsets.only(
            //       top: 0.0, bottom: 10.0, left: 20.0, right: 25.0),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(5),
            //   ),
            //   child: new TextField(
            //     controller: mobController,
            //     keyboardType: TextInputType.phone,
            //     onChanged: (value){
            //       setState(() {
            //         _isButtonDisabledColor = false;
            //         _isButtonDisabled = false;
            //       });
            //     },
            //     inputFormatters: <TextInputFormatter>[
            //       FilteringTextInputFormatter.digitsOnly
            //     ],
            //     maxLength: 10,
            //     style: TextStyle(
            //       color: Colors.black,
            //       fontSize: 17,
            //       fontStyle: FontStyle.normal,
            //       fontWeight: FontWeight.w400,
            //     ),
            //     decoration: InputDecoration(
            //       counterStyle: TextStyle(height: double.minPositive,),
            //       counterText: "",
            //     ),
            //   ),
            // ),
            // // Container(
            // //   width: size.width * 0.99,
            // //   padding: EdgeInsets.only(
            // //       top: 10.0, bottom: 0.0, left: 20.0, right: 25.0),
            // //   child: Text(
            // //     "Email",
            // //     style: TextStyle(
            // //       color: Colors.black45,
            // //       fontStyle: FontStyle.normal,
            // //       fontWeight: FontWeight.w600,
            // //     ),
            // //   ),
            // // ),
            // // Container(
            // //   width: size.width * 0.99,
            // //   padding: EdgeInsets.only(
            // //       top: 0.0, bottom: 10.0, left: 20.0, right: 25.0),
            // //   decoration: BoxDecoration(
            // //     borderRadius: BorderRadius.circular(5),
            // //   ),
            // //   child: new TextField(
            // //     controller: emailController,
            // //     keyboardType: TextInputType.emailAddress,
            // //     onChanged: (value){
            // //       setState(() {
            // //         _isButtonDisabledColor = false;
            // //         _isButtonDisabled = false;
            // //       });
            // //     },
            // //     style: TextStyle(
            // //       color: Colors.black,
            // //       fontSize: 17,
            // //       fontStyle: FontStyle.normal,
            // //       fontWeight: FontWeight.w400,
            // //     ),
            // //   ),
            // // ),
            // // Container(
            // //     width: size.width * 0.99,
            // //     padding: EdgeInsets.only(
            // //         top: 10.0, bottom: 0.0, left: 20.0, right: 25.0),
            // //     child:RichText(
            // //       text: TextSpan(
            // //           text: 'QR Type ',
            // //           style: TextStyle(
            // //             color: Colors.black45,
            // //             fontStyle: FontStyle.normal,
            // //             fontWeight: FontWeight.w600,
            // //           ),
            // //           children: <TextSpan>[
            // //             TextSpan(text: '*',
            // //               style: TextStyle(
            // //                 color: Colors.red,
            // //                 fontStyle: FontStyle.normal,
            // //                 fontWeight: FontWeight.w600,
            // //               ),
            // //               // recognizer: TapGestureRecognizer()
            // //               //   ..onTap = () {
            // //               //     // open desired screen
            // //               //   }
            // //             ),
            // //           ]
            // //       ),
            // //     )
            // // ),
            // // Container(
            // //   width: size.width * 0.99,
            // //   padding: EdgeInsets.only(
            // //       top: 0.0, bottom: 10.0, left: 20.0, right: 25.0),
            // //   child: new DropdownButton<String>(
            // //     iconEnabledColor: Colors.black,
            // //     dropdownColor: Colors.white,
            // //     value: dropdownValueType,
            // //     isExpanded: true,
            // //     style: TextStyle(
            // //       color: Colors.black,
            // //       fontSize: 17,
            // //       fontStyle: FontStyle.normal,
            // //       fontWeight: FontWeight.w400,
            // //     ),
            // //     // icon: Icon(Icons.add_business),
            // //     // iconSize: 24,
            // //     // elevation: 1,
            // //     // style: TextStyle(color: Colors.black54, fontSize: 16),
            // //     underline: Container(
            // //       height: 1,
            // //       width: 50,
            // //       color: Colors.black38,
            // //     ),
            // //     onChanged: (String newValue) {
            // //       setState(() {
            // //         dropdownValueType = newValue;
            // //         _isButtonDisabledColor = false;
            // //         _isButtonDisabled = false;
            // //       });
            // //     },
            // //     items: <String>['Select Qr for','Petrol Pump', 'Parking Lot']
            // //         .map<DropdownMenuItem<String>>((String value) {
            // //       return DropdownMenuItem<String>(
            // //         value: value,
            // //         child: Text(value),
            // //       );
            // //     }).toList(),
            // //   ),
            // // ),
            // Container(
            //     width: size.width * 0.99,
            //     padding: EdgeInsets.only(
            //         top: 10.0, bottom: 0.0, left: 20.0, right: 25.0),
            //     child:RichText(
            //       text: TextSpan(
            //           text: 'Vehicle Type ',
            //           style: TextStyle(
            //             color: Colors.black45,
            //             fontStyle: FontStyle.normal,
            //             fontWeight: FontWeight.w600,
            //           ),
            //           children: <TextSpan>[
            //             TextSpan(text: '*',
            //               style: TextStyle(
            //                 color: Colors.red,
            //                 fontStyle: FontStyle.normal,
            //                 fontWeight: FontWeight.w600,
            //               ),
            //               // recognizer: TapGestureRecognizer()
            //               //   ..onTap = () {
            //               //     // open desired screen
            //               //   }
            //             ),
            //           ]
            //       ),
            //     )
            // ),
            // Container(
            //   width: size.width * 0.99,
            //   padding: EdgeInsets.only(
            //       top: 0.0, bottom: 10.0, left: 20.0, right: 25.0),
            //   child: new DropdownButton<String>(
            //     iconEnabledColor: Colors.black,
            //     dropdownColor: Colors.white,
            //     value: dropdownValue,
            //     isExpanded: true,
            //     style: TextStyle(
            //       color: Colors.black,
            //       fontSize: 17,
            //       fontStyle: FontStyle.normal,
            //       fontWeight: FontWeight.w400,
            //     ),
            //     // icon: Icon(Icons.add_business),
            //     // iconSize: 24,
            //     // elevation: 1,
            //     // style: TextStyle(color: Colors.black54, fontSize: 16),
            //     underline: Container(
            //       height: 1,
            //       width: 50,
            //       color: Colors.black38,
            //     ),
            //     onChanged: (String newValue) {
            //       setState(() {
            //         dropdownValue = newValue;
            //         _isButtonDisabledColor = false;
            //         _isButtonDisabled = false;
            //       });
            //     },
            //     items: <String>['Select Vehicle Type','2 Wheeler', '3 Wheeler', '4 Wheeler', 'Other']
            //         .map<DropdownMenuItem<String>>((String value) {
            //       return DropdownMenuItem<String>(
            //         value: value,
            //         child: Text(value),
            //       );
            //     }).toList(),
            //   ),
            // ),
            // Container(
            //   width: size.width * 0.99,
            //   padding: EdgeInsets.only(
            //       top: 0.0, bottom: 0.0, left: 20.0, right: 25.0),
            //   child: RichText(
            //     text: TextSpan(
            //         text: 'Vehicle No. ',
            //         style: TextStyle(
            //           color: Colors.black45,
            //           fontStyle: FontStyle.normal,
            //           fontWeight: FontWeight.w600,
            //         ),
            //         children: <TextSpan>[
            //           TextSpan(text: '*',
            //             style: TextStyle(
            //               color: Colors.red,
            //               fontStyle: FontStyle.normal,
            //               fontWeight: FontWeight.w600,
            //             ),
            //             // recognizer: TapGestureRecognizer()
            //             //   ..onTap = () {
            //             //     // open desired screen
            //             //   }
            //           ),
            //         ]
            //     ),
            //   )
            // ),
            // Container(
            //   width: size.width * 0.99,
            //   padding: EdgeInsets.only(
            //       top: 0.0, bottom: 10.0, left: 20.0, right: 25.0),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(5),
            //   ),
            //   child: new TextField(
            //     controller: vehicleNumController,
            //     textCapitalization: TextCapitalization.characters,
            //     onChanged: (value){
            //       setState(() {
            //         _isButtonDisabledColor = false;
            //         _isButtonDisabled = false;
            //       });
            //     },
            //     inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[a-zA-Z 0-9]")),],
            //     style: TextStyle(
            //       color: Colors.black,
            //       fontSize: 17,
            //       fontStyle: FontStyle.normal,
            //       fontWeight: FontWeight.w400,
            //     ),
            //   ),
            // ),
            // SizedBox(height: 30.0,),
          ],
        ),
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
    if(vehicleNumController.text.isEmpty){
      showInSnackBar("Please enter Vehicle Number");
      return null;
    }

    _showLoaderDialog(context);

    final param = {
      "id": id,
      "description": nameController.text,
      "mobile_no": mobController.text,
      // "c_email": emailController.text,
      // "qr_type": dropdownValueType,
      "vehicle_type": dropdownValue,
      "vehicle_no": vehicleNumController.text,
    };

    final response = await http.post(
      "http://157.230.228.250/edit-customer-qr-api/",
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