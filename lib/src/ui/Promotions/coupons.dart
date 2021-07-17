import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class Coupons extends StatefulWidget {

  final String couponName, couponCode, greenPoint, validFrom, validThrough, couponCaption,
      couponValue, couponValidForUser, amountIn, couponID;

  const Coupons( this.couponName, this.couponCode, this.greenPoint, this.validFrom,
      this.validThrough, this.couponCaption, this.couponValue, this.couponValidForUser, this.amountIn, this.couponID, {Key key}) : super(key: key);

  @override
  _CouponsState createState() => _CouponsState( couponName, couponCode, greenPoint, validFrom,
      validThrough, couponCaption, couponValue, couponValidForUser, amountIn);
}

class _CouponsState extends State<Coupons> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  DateTime initDate;
  String token, id, mob, storeID;
  File image;
  bool _isFileAvailable = false, couponType = true, amountType = true;


  final String couponName, couponCode, greenPoint, validFrom, validThrough, couponCaption,
      couponValue, couponValidForUser, amountIn;

  _CouponsState( this.couponName, this.couponCode, this.greenPoint, this.validFrom,
      this.validThrough, this.couponCaption, this.couponValue, this.couponValidForUser, this.amountIn);

  @override
  void initState() {
    super.initState();
    getCredentials();
  }

  @override
  void dispose() {
    super.dispose();
    cnController.dispose();
    ccController.dispose();
    gpController.dispose();
    fDateController.dispose();
    tDateController.dispose();
    captionController.dispose();
    perController.dispose();
    amtController.dispose();
    quantityController.dispose();
  }

  getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      cnController.text = couponName;
      ccController.text = couponCode;
      gpController.text = greenPoint;
      fDateController.text = validFrom;
      tDateController.text = validThrough;
      captionController.text = couponCaption;
      perController.text = (amountIn == "percentage") ? couponValue.split("%").first : "";
      amtController.text = (amountIn == "fix") ? couponValue : "";
      quantityController.text = couponValidForUser;

      couponType = couponCaption.isEmpty ? false : true;
      amountType = amountIn == "fix" ? false : true;
      // _isFileAvailable = file == null ? false : true;

      token = prefs.getString("token");
      id = prefs.getInt("userID").toString();
      mob = prefs.getString("mobile");
      storeID = prefs.getString("businessID");
    });
  }

  TextEditingController cnController = new TextEditingController();
  TextEditingController ccController = new TextEditingController();
  TextEditingController gpController = new TextEditingController();
  TextEditingController fDateController = new TextEditingController();
  TextEditingController tDateController = new TextEditingController();
  TextEditingController captionController = new TextEditingController();
  TextEditingController perController = new TextEditingController();
  TextEditingController amtController = new TextEditingController();
  TextEditingController quantityController = new TextEditingController();

  Future<void> _selectFromDate(BuildContext context) async {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030, 1),
    ).then((pickedDate) {
      fDateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      setState(() {
        initDate = pickedDate;
      });
    });
  }

  Future<void> _selectToDate(BuildContext context) async {
    showDatePicker(
      context: context,
      initialDate: initDate,
      firstDate: initDate,
      lastDate: DateTime(2030, 1),
    ).then((pickedDate) {
      tDateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Add Coupon'),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        actions: <Widget>[
          TextButton(
              onPressed: (){
                create();
              },
              child: Text("CREATE", style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                width: size.width * 0.95,

                padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: TextField(
                  maxLength: 15,
                  controller: cnController,
                  inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[a-z A-Z]")),],
                  style: TextStyle(
                      fontFamily: "PoppinsLight",
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
                      CupertinoIcons.ticket,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Coupon Name *",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: TextField(
                  controller: ccController,
                  maxLength: 8,
                  style: TextStyle(
                      fontFamily: "PoppinsLight",
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
                      CupertinoIcons.tickets,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Coupon Code *",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: TextFormField(initialValue: "1",
                  enabled: false,
                  // controller: gpController,
                  // keyboardType: TextInputType.number,
                  // inputFormatters: <TextInputFormatter>[
                  //   FilteringTextInputFormatter.digitsOnly
                  // ],
                  style: TextStyle(
                      fontFamily: "PoppinsLight",
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
                      CupertinoIcons.gift,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Green Points *",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: size.width * 0.45,
                      padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                      child: TextField(
                        enableInteractiveSelection: false, // will disable paste operation
                        focusNode: new AlwaysDisabledFocusNode(),
                        onTap: () {
                          _selectFromDate(context);
                        },
                        controller: fDateController,
                        style: TextStyle(
                            fontFamily: "PoppinsLight",
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
                            CupertinoIcons.calendar,
                            color: kPrimaryColorBlue,
                            size: 23.0,
                          ),
                          labelText: "From Date *",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.45,
                      padding: EdgeInsets.only(
                          top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                      child: TextField(
                        enableInteractiveSelection: false, // will disable paste operation
                        focusNode: new AlwaysDisabledFocusNode(),
                        onTap: () {
                          if(fDateController.text.isEmpty){
                            showInSnackBar("Please select Initial Date");
                            return null;
                          }
                          _selectToDate(context);
                        },
                        controller: tDateController,
                        style: TextStyle(
                            fontFamily: "PoppinsLight",
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
                            CupertinoIcons.calendar,
                            color: kPrimaryColorBlue,
                            size: 23.0,
                          ),
                          labelText: "To Date *",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: size.width * 0.95,
                decoration:  BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(90),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50.0,
                      width: size.width * 0.47,
                      child: ElevatedButton(
                        child: Text(
                          "Coupon By Caption",
                          style: TextStyle(
                            fontFamily: "PoppinsMedium",
                            fontWeight: FontWeight.bold,
                            color: couponType ? Colors.white : Colors.black
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            elevation: couponType ? 3.0 : 0.0,
                            primary: couponType ? kPrimaryColorBlue : Colors.grey[300],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(90)))),
                        onPressed: () {
                          setState(() {
                            couponType = true;
                          });
                        },
                      ),
                    ),
                    Container(
                      height: 50.0,
                      width: size.width * 0.47,
                      child: ElevatedButton(
                        child: Text(
                            "Coupon By Value",
                          style: TextStyle(
                              fontFamily: "PoppinsMedium",
                              fontWeight: FontWeight.bold,
                              color: couponType ? Colors.black : Colors.white
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          elevation: couponType ? 0.0 : 3.0,
                            primary: couponType ? Colors.grey[300] : kPrimaryColorBlue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(90)))),
                        onPressed: () {
                          setState(() {
                            couponType = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if(couponType)
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(top: 10.0, bottom: 0.0, left: 0.0, right: 0.0),
                child: TextField(
                  maxLength: 20,
                  controller: captionController,
                  style: TextStyle(
                      fontFamily: "PoppinsLight",
                      fontSize: 17.0,
                      color: Colors.black87),
                  onTap: (){
                    perController.clear();
                    amtController.clear();
                  },
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
                      CupertinoIcons.captions_bubble,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Coupon Caption *",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              if(!couponType)
              Container(
                width: size.width * 0.95,
                decoration:  BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(90),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 50.0,
                      width: size.width * 0.47,
                      child: ElevatedButton(
                        child: Text(
                          "Discount in %",
                          style: TextStyle(
                              fontFamily: "PoppinsMedium",
                              fontWeight: FontWeight.bold,
                              color: amountType ? Colors.white : Colors.black
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            elevation: amountType ? 3.0 : 0.0,
                            primary: amountType ? kPrimaryColorBlue : Colors.grey[300],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(90)))),
                        onPressed: () {
                          setState(() {
                            amountType = true;
                          });
                        },
                      ),
                    ),
                    Container(
                      height: 50.0,
                      width: size.width * 0.47,
                      child: ElevatedButton(
                        child: Text(
                          "Discount in Fix ₹",
                          style: TextStyle(
                              fontFamily: "PoppinsMedium",
                              fontWeight: FontWeight.bold,
                              color: amountType ? Colors.black : Colors.white
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                            elevation: amountType ? 0.0 : 3.0,
                            primary: amountType ? Colors.grey[300] : kPrimaryColorBlue,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(90)))),
                        onPressed: () {
                          setState(() {
                            amountType = false;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if(amountType && !couponType)
                Container(
                  width: size.width * 0.95,
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 0.0, right: 0.0),
                  child: TextField(
                    maxLength: 3,
                    controller: perController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    style: TextStyle(
                        fontFamily: "PoppinsLight",
                        fontSize: 17.0,
                        color: Colors.black87),
                    onTap: (){
                      captionController.clear();
                      amtController.clear();
                    },
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
                        CupertinoIcons.percent,
                        color: kPrimaryColorBlue,
                        size: 23.0,
                      ),
                      labelText: "Percentage *",
                      labelStyle: TextStyle(
                          fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                    ),
                  ),
                ),
              if(!amountType && !couponType)
                Container(
                  width: size.width * 0.95,
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 0.0, right: 0.0),
                  child: TextField(
                    maxLength: 8,
                    controller: amtController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    style: TextStyle(
                        fontFamily: "PoppinsLight",
                        fontSize: 17.0,
                        color: Colors.black87),
                    onTap: (){
                      perController.clear();
                      captionController.clear();
                    },
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
                        FontAwesomeIcons.rupeeSign,
                        color: kPrimaryColorBlue,
                        size: 23.0,
                      ),
                      labelText: "Fix Amount *",
                      labelStyle: TextStyle(
                          fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                    ),
                  ),
                ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: TextField(
                  maxLength: 5,
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  style: TextStyle(
                      fontFamily: "PoppinsLight",
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
                      CupertinoIcons.person_2,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Coupon Valid For Users *",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openGallery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 25);
    if (picture != null) {
      _cropImage(picture);
    }
  }

  Future<Null> _cropImage(File picture) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: picture.path,
      compressQuality: 50,
      aspectRatioPresets: Platform.isAndroid
      ? [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio16x9
      ]
      : [
      CropAspectRatioPreset.original,
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio3x2,
      CropAspectRatioPreset.ratio4x3,
      CropAspectRatioPreset.ratio5x3,
      CropAspectRatioPreset.ratio5x4,
      CropAspectRatioPreset.ratio7x5,
      CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop',
          toolbarColor: kPrimaryColorBlue,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: kPrimaryColorGreen,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false),
    );
    if (croppedFile != null) {
      setState(() {
        image = croppedFile;
        _isFileAvailable = true;
      });
    }
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

  Future<void> create() async {

    if(cnController.text.isEmpty){
      showInSnackBar("Please enter Coupon Name");
      return null;
    }
    if(ccController.text.isEmpty){
      showInSnackBar("Please enter Coupon Code");
      return null;
    }
    // if(gpController.text.isEmpty){
    //   showInSnackBar("Please enter Green Points");
    //   return null;
    // }
    if(fDateController.text.isEmpty){
      showInSnackBar("Please select From Date");
      return null;
    }
    if(tDateController.text.isEmpty){
      showInSnackBar("Please select To Date");
      return null;
    }
    if(couponType && captionController.text.isEmpty){
      showInSnackBar("Please enter Coupon Caption");
      return null;
    }
    if(!couponType && amountType && perController.text.isEmpty){
      showInSnackBar("Please enter Percentage");
      return null;
    }
    if(!couponType && !amountType && amtController.text.isEmpty){
      showInSnackBar("Please enter Fix Amount");
      return null;
    }
    if(quantityController.text.isEmpty){
      showInSnackBar("Please enter No. of Users");
      return null;
    }

    _showLoaderDialog(context);

    //open a byteStream
    // var stream = new http.ByteStream(DelegatingStream.typed(image.openRead()));
    // // get file length
    // var length = await image.length();

    var uri = Uri.parse("http://157.230.228.250/merchant-create-and-update-coupon-api/");
    Map<String, String> headers = {"Authorization": "Token $token"};
    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    // var multipartFile = new http.MultipartFile('coupon_logo', stream, length,
    //     filename: path.basename(image.path));

    // add file to multipart
    // request.files.add(multipartFile);

    request.fields['coupon_type'] = couponType ? "coupon_caption" : "coupon_value";
    request.fields['coupon_caption_name'] = captionController.text;
    request.fields['m_user_id'] = id;
    request.fields['m_business_id'] = storeID;
    request.fields['coupon_id'] = widget.couponID.isEmpty ? "" : widget.couponID;
    request.fields['coupon_name'] = cnController.text;
    request.fields['valid_from'] = fDateController.text;
    request.fields['valid_through'] = tDateController.text;
    request.fields['coupon_code'] = ccController.text;
    request.fields['green_point'] = "1";
    request.fields['coupon_valid_for_user'] = quantityController.text;
    request.fields['amount_in'] = couponType ? "" : (amountType ? "percentage" : "fix");
    request.fields['coupon_value_percent'] = (!couponType && amountType) ? perController.text : "";
    request.fields['coupon_value_fixamount'] = (!couponType && !amountType) ? amtController.text : "";

    request.headers.addAll(headers);

    // send
    var response = await request.send();
    print(response.statusCode);
    print(response);
    Navigator.of(context, rootNavigator: true).pop();
    if (response.statusCode == 200) {
      print("***********************************************     Submit     *******************************************************");
      Navigator.pop(context, true);
    } else {
      showInSnackBar("Something went wrong!");
    }

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
