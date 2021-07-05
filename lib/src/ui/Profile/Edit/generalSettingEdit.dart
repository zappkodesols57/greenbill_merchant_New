import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/Services/postalApi_services.dart';
import 'package:greenbill_merchant/src/models/postApi_model.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';

class GeneralSettingEdit extends StatefulWidget {
  final String businessName,
      businessCategory,
      pin,
      city,
      area,
      district,
      state,
      add,
      landLine,
      mob,
      cemail,
      email,
      pan,
      gst,
      cin,
      account,
      ifsc,
      bank,
      branch,
      logo,
      stamp,
      signature,
      id;
  GeneralSettingEdit(
      this.businessName,
      this.businessCategory,
      this.pin,
      this.city,
      this.area,
      this.district,
      this.state,
      this.add,
      this.landLine,
      this.mob,
      this.cemail,
      this.email,
      this.pan,
      this.gst,
      this.cin,
      this.account,
      this.ifsc,
      this.bank,
      this.branch,
      this.logo,
      this.stamp,
      this.signature,
      this.id,
      {Key key})
      : super(key: key);

  @override
  _MyGeneralSettingEditState createState() => _MyGeneralSettingEditState(
      businessName,
      businessCategory,
      pin,
      city,
      area,
      district,
      state,
      add,
      landLine,
      mob,
      cemail,
      email,
      pan,
      gst,
      cin,
      account,
      ifsc,
      bank,
      branch,
      logo,
      stamp,
      signature,
      id);
}

class _MyGeneralSettingEditState extends State<GeneralSettingEdit> {
  bool _alertMob = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final String businessName,
      businessCategory,
      pin,
      city,
      area,
      district,
      state,
      add,
      landLine,
      mob,
      cemail,
      email,
      pan,
      gst,
      cin,
      account,
      ifsc,
      bank,
      branch,
      logo,
      stamp,
      signature,
      id;
  _MyGeneralSettingEditState(
      this.businessName,
      this.businessCategory,
      this.pin,
      this.city,
      this.area,
      this.district,
      this.state,
      this.add,
      this.landLine,
      this.mob,
      this.cemail,
      this.email,
      this.pan,
      this.gst,
      this.cin,
      this.account,
      this.ifsc,
      this.bank,
      this.branch,
      this.logo,
      this.stamp,
      this.signature,
      this.id);

  bool _isButtonDisabled = true;
  bool _isButtonDisabledColor = true;
  String textIfsc = ""; // empty string to carry what was there before it
  String textPan = ""; // empty string to carry what was there before it
  String textGst = ""; // empty string to carry what was there before it
  String textCin = ""; // empty string to carry what was there before it
  int maxIfsc = 11;
  int maxPan = 10;
  int maxGst = 15;
  int maxCin = 21;
  // String j2pValue = "no";
  // String _chosenValue;
  // File _logo;
  // File _stamp;
  // File _signature;

  @override
  void initState() {
    super.initState();
    // this.getCategory();
    _isButtonDisabled = true;
    _isButtonDisabledColor = true;
    // j2pValue = "no";
    setDetails();
  }

  void setDetails() {
    nameController.text = businessName;
    catController.text = businessCategory;
    pinController.text = pin;
    cityController.text = city;
    areaController.text = area;
    districtController.text = district;
    stateController.text = state;
    addressController.text = add;
    teleController.text = landLine;
    mobController.text = mob;
    cemailController.text = cemail;
    emailController.text = email;
    panController.text = pan;
    gstController.text = gst;
    cinController.text = cin;
    accController.text = account;
    ifscController.text = ifsc;
    bnameController.text = bank;
    branchController.text = branch;
    logoController.text = logo;
    stampController.text = stamp;
    sigController.text = signature;
  }

  @override
  void dispose() {
    super.dispose();

    myFocusNodeName.dispose();
    myFocusNodeCat.dispose();
    myFocusNodePin.dispose();
    myFocusNodeCity.dispose();
    myFocusNodeArea.dispose();
    myFocusNodeDistrict.dispose();
    myFocusNodeState.dispose();
    myFocusNodeAddress.dispose();
    myFocusNodeTele.dispose();
    myFocusNodeMob.dispose();
    myFocusNodeCemail.dispose();
    myFocusNodeEmail.dispose();
    myFocusNodePan.dispose();
    myFocusNodeGst.dispose();
    myFocusNodeCin.dispose();
    myFocusNodeAccount.dispose();
    myFocusNodeIfsc.dispose();
    myFocusNodeBank.dispose();
    myFocusNodeBranch.dispose();
    myFocusNodeLogo.dispose();
    myFocusNodeStamp.dispose();
    myFocusNodeSignature.dispose();

    nameController.dispose();
    catController.dispose();
    pinController.dispose();
    cityController.dispose();
    areaController.dispose();
    districtController.dispose();
    stateController.dispose();
    addressController.dispose();
    teleController.dispose();
    mobController.dispose();
    cemailController.dispose();
    emailController.dispose();
    panController.dispose();
    gstController.dispose();
    cinController.dispose();
    accController.dispose();
    ifscController.dispose();
    bnameController.dispose();
    branchController.dispose();
    logoController.dispose();
    stampController.dispose();
    sigController.dispose();
  }

  final FocusNode myFocusNodeName = FocusNode();
  final FocusNode myFocusNodeCat = FocusNode();
  final FocusNode myFocusNodePin = FocusNode();
  final FocusNode myFocusNodeCity = FocusNode();
  final FocusNode myFocusNodeArea = FocusNode();
  final FocusNode myFocusNodeDistrict = FocusNode();
  final FocusNode myFocusNodeState = FocusNode();
  final FocusNode myFocusNodeAddress = FocusNode();
  final FocusNode myFocusNodeTele = FocusNode();
  final FocusNode myFocusNodeMob = FocusNode();
  final FocusNode myFocusNodeCemail = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodePan = FocusNode();
  final FocusNode myFocusNodeGst = FocusNode();
  final FocusNode myFocusNodeCin = FocusNode();
  final FocusNode myFocusNodeAccount = FocusNode();
  final FocusNode myFocusNodeIfsc = FocusNode();
  final FocusNode myFocusNodeBank = FocusNode();
  final FocusNode myFocusNodeBranch = FocusNode();
  final FocusNode myFocusNodeLogo = FocusNode();
  final FocusNode myFocusNodeStamp = FocusNode();
  final FocusNode myFocusNodeSignature = FocusNode();

  TextEditingController nameController = new TextEditingController();
  TextEditingController catController = new TextEditingController();
  TextEditingController pinController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController areaController = new TextEditingController();
  TextEditingController districtController = new TextEditingController();
  TextEditingController stateController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController teleController = new TextEditingController();
  TextEditingController mobController = new TextEditingController();
  TextEditingController cemailController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController panController = new TextEditingController();
  TextEditingController gstController = new TextEditingController();
  TextEditingController cinController = new TextEditingController();
  TextEditingController accController = new TextEditingController();
  TextEditingController ifscController = new TextEditingController();
  TextEditingController bnameController = new TextEditingController();
  TextEditingController branchController = new TextEditingController();
  TextEditingController logoController = new TextEditingController();
  TextEditingController stampController = new TextEditingController();
  TextEditingController sigController = new TextEditingController();

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

  List<PinCode> pins;

  getUserData(String pinCodes) {
    Services.getUserLocation(pinCodes).then((value) {
      pins = value;
      PinCode code;
      for (int i = 0; i < pins.length; i++) {
        code = pins[i];
        stateController.text = code.postOffice.first.circle;
        districtController.text = code.postOffice.first.district;
        cityController.text = code.postOffice.first.region;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("General Settings"),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        actions: <Widget>[
          FlatButton(
            textColor: _isButtonDisabledColor ? Colors.grey : Colors.white,
            onPressed: () {
              _isButtonDisabled ? null : save();
            },
            child: Text("SAVE"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(top: 20.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: new TextField(
                  focusNode: myFocusNodeName,
                  controller: nameController,
                  onChanged: (value) {
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
                      FontAwesomeIcons.store,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Business Name",
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: size.width * 0.45,
                      child: new TextField(
                        focusNode: myFocusNodePin,
                        controller: pinController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) {
                          getUserData(pinController.text);
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
                            FontAwesomeIcons.mapPin,
                            color: kPrimaryColorBlue,
                            size: 23.0,
                          ),
                          labelText: "Pincode",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.45,
                      child: new TextField(
                        focusNode: myFocusNodeCity,
                        controller: cityController,
                        onChanged: (value) {
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
                            FontAwesomeIcons.city,
                            color: kPrimaryColorBlue,
                            size: 23.0,
                          ),
                          labelText: "City",
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
                padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: size.width * 0.45,
                      child: new TextField(
                        focusNode: myFocusNodeArea,
                        controller: areaController,
                        onChanged: (value) {
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
                            FontAwesomeIcons.map,
                            color: kPrimaryColorBlue,
                            size: 23.0,
                          ),
                          labelText: "Area",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.45,
                      child: new TextField(
                        focusNode: myFocusNodeDistrict,
                        controller: districtController,
                        onChanged: (value) {
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
                            FontAwesomeIcons.locationArrow,
                            color: kPrimaryColorBlue,
                            size: 23.0,
                          ),
                          labelText: "District",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: new TextField(
                  focusNode: myFocusNodeState,
                  controller: stateController,
                  onChanged: (value) {
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
                      FontAwesomeIcons.mapSigns,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "State",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: new TextField(
                  focusNode: myFocusNodeAddress,
                  controller: addressController,
                  onChanged: (value) {
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
                      FontAwesomeIcons.solidMap,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Address",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: new TextField(
                  focusNode: myFocusNodeTele,
                  controller: teleController,
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value) {
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
                      FontAwesomeIcons.phoneAlt,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Landline No.",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: new TextField(
                  focusNode: myFocusNodeMob,
                  controller: mobController,
                  keyboardType: TextInputType.number,
                  maxLength: 10,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value) {
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
                    labelText: "Alternate Mobile No.",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: new TextField(
                  focusNode: myFocusNodeCemail,
                  controller: cemailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
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
                      FontAwesomeIcons.envelope,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Company Email",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: new TextField(
                  focusNode: myFocusNodeEmail,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged: (value) {
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
                      FontAwesomeIcons.envelope,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Alternate Email",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: new TextField(
                  focusNode: myFocusNodePan,
                  controller: panController,
                  keyboardType: TextInputType.text,
                  maxLength: 10,
                  textCapitalization: TextCapitalization.characters,
                  onChanged: (value) {
                    if (value.length <= maxPan) {
                      textPan = value;
                    } else {
                      panController.value = new TextEditingValue(
                          text: textPan,
                          selection: new TextSelection(
                              baseOffset: maxPan,
                              extentOffset: maxPan,
                              affinity: TextAffinity.downstream,
                              isDirectional: false),
                          composing: new TextRange(start: 0, end: maxPan));
                      panController.text = textPan;
                    }

                    setState(() {
                      _isButtonDisabledColor = false;
                      _isButtonDisabled = false;
                    });
                    if (value.length == 10) {
                      validatePan(value)
                          ? showInSnackBar('Valid Pan Number', 2)
                          : showInSnackBar("Invalid Pan Number", 2);
                    }
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
                      FontAwesomeIcons.idCard,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Pan No.",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: new TextField(
                  focusNode: myFocusNodeGst,
                  controller: gstController,
                  keyboardType: TextInputType.text,
                  maxLength: 15,
                  textCapitalization: TextCapitalization.characters,
                  onChanged: (value) {
                    if (value.length <= maxGst) {
                      textGst = value;
                    } else {
                      gstController.value = new TextEditingValue(
                          text: textGst,
                          selection: new TextSelection(
                              baseOffset: maxGst,
                              extentOffset: maxGst,
                              affinity: TextAffinity.downstream,
                              isDirectional: false),
                          composing: new TextRange(start: 0, end: maxGst));
                      gstController.text = textGst;
                    }

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
                      FontAwesomeIcons.creditCard,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "GSTIN",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: new TextField(
                  focusNode: myFocusNodeCin,
                  controller: cinController,
                  keyboardType: TextInputType.text,
                  maxLength: 21,
                  textCapitalization: TextCapitalization.characters,
                  onChanged: (value) {
                    setState(() {
                      if (value.length <= maxCin) {
                        textCin = value;
                      } else {
                        cinController.value = new TextEditingValue(
                            text: textCin,
                            selection: new TextSelection(
                                baseOffset: maxCin,
                                extentOffset: maxCin,
                                affinity: TextAffinity.downstream,
                                isDirectional: false),
                            composing: new TextRange(start: 0, end: maxCin));
                        cinController.text = textCin;
                      }

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
                      FontAwesomeIcons.creditCard,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "CIN",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: new TextField(
                  focusNode: myFocusNodeAccount,
                  controller: accController,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (value) {
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
                      FontAwesomeIcons.university,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Bank Account No.",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: new TextField(
                  focusNode: myFocusNodeIfsc,
                  controller: ifscController,
                  maxLength: 11,
                  textCapitalization: TextCapitalization.characters,
                  onChanged: (value) {
                    if (value.length <= maxIfsc) {
                      textIfsc = value;
                    } else {
                      gstController.value = new TextEditingValue(
                          text: textIfsc,
                          selection: new TextSelection(
                              baseOffset: maxIfsc,
                              extentOffset: maxIfsc,
                              affinity: TextAffinity.downstream,
                              isDirectional: false),
                          composing: new TextRange(start: 0, end: maxIfsc));
                      ifscController.text = textIfsc;
                    }

                    setState(() {
                      _isButtonDisabledColor = false;
                      _isButtonDisabled = false;
                    });
                    if (value.length == 11) {
                      validateIFSC(value)
                          ? showInSnackBar('Valid IFSC Code', 2)
                          : showInSnackBar("Invalid IFSC Code", 2);
                    }
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
                      FontAwesomeIcons.university,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Bank IFSC Code",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: new TextField(
                  focusNode: myFocusNodeBank,
                  controller: bnameController,
                  onChanged: (value) {
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
                      FontAwesomeIcons.university,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Bank Name",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: new TextField(
                  focusNode: myFocusNodeBranch,
                  controller: branchController,
                  onChanged: (value) {
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
                      FontAwesomeIcons.university,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Branch Name",
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

  // Future<File> _openGallery(BuildContext context) async {
  //   var picture = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 25, maxHeight: 480, maxWidth: 640);
  //   this.setState(() {
  //     _logo = picture;
  //   });
  // }
  // Future<File> _openGallery1(BuildContext context) async {
  //   var picture = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 25, maxHeight: 480, maxWidth: 640);
  //   this.setState(() {
  //     _stamp = picture;
  //   });
  // }
  // Future<File> _openGallery2(BuildContext context) async {
  //   var picture = await ImagePicker.pickImage(source: ImageSource.gallery, imageQuality: 25, maxHeight: 480, maxWidth: 640);
  //   this.setState(() {
  //     _signature = picture;
  //   });
  // }

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
                  )));
        });
  }

  bool validateEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool validatePan(String value) {
    String pattern = r"[A-Z]{5}[0-9]{4}[A-Z]{1}";
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool validateIFSC(String value) {
    String pattern = r"^[A-Z]{4}0[A-Z0-9]{6}$";
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
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

  Future<void> save() async {
    if (nameController.text.isEmpty) {
      showInSnackBar("Please enter Business Name", 2);
      return null;
    }
    // if(_chosenValue == null){
    //   showInSnackBar("Please select Business Category", 2);
    //   return null;
    // }
    if (pinController.text.isEmpty) {
      showInSnackBar("Please enter valid Pin Code", 2);
      return null;
    }
    if (cityController.text.isEmpty) {
      showInSnackBar("Please enter City", 2);
      return null;
    }
    if (areaController.text.isEmpty) {
      showInSnackBar("Please enter Area", 2);
      return null;
    }
    if (districtController.text.isEmpty) {
      showInSnackBar("Please enter District", 2);
      return null;
    }
    if (stateController.text.isEmpty) {
      showInSnackBar("Please enter State", 2);
      return null;
    }
    if (addressController.text.isEmpty) {
      showInSnackBar("Please enter Address", 2);
      return null;
    }
    if (cemailController.text.isEmpty) {
      showInSnackBar("Please enter Company Email", 2);
      return null;
    }
    if (cemailController.text.isNotEmpty) {
      if (cemailController.text.contains('com') ||
          cemailController.text.contains('net') ||
          cemailController.text.contains('edu') ||
          cemailController.text.contains('org') ||
          cemailController.text.contains('mil') ||
          cemailController.text.contains('gov')) {
        if (validateEmail(cemailController.text) == false) {
          showInSnackBar("Invalid Company Email", 2);
          return null;
        }
      } else {
        showInSnackBar("Invalid Email", 2);
        return null;
      }
    }
    if (emailController.text.isNotEmpty) {
      if (emailController.text.contains('com') ||
          emailController.text.contains('net') ||
          emailController.text.contains('edu') ||
          emailController.text.contains('org') ||
          emailController.text.contains('mil') ||
          emailController.text.contains('gov')) {
        if (validateEmail(emailController.text) == false) {
          showInSnackBar("Invalid Alternate Email", 2);
          return null;
        }
      } else {
        showInSnackBar("Invalid Email", 2);
        return null;
      }
    }
    if (panController.text.isEmpty) {
      showInSnackBar("Please enter Pan Number", 2);
      return null;
    }
    if (validatePan(panController.text) == false) {
      showInSnackBar("Invalid Pan Number", 2);
      return null;
    }
    if (accController.text.isEmpty) {
      showInSnackBar("Please enter Account Number", 2);
      return null;
    }
    if (ifscController.text.isEmpty) {
      showInSnackBar("Please enter IFSC Code", 2);
      return null;
    }
    if (validateIFSC(ifscController.text) == false) {
      showInSnackBar("Invalid IFSC Code", 2);
      return null;
    }
    if (bnameController.text.isEmpty) {
      showInSnackBar("Please enter Bank Name", 2);
      return null;
    }
    if (branchController.text.isEmpty) {
      showInSnackBar("Please enter Branch Name", 2);
      return null;
    }

    SchedulerBinding.instance
        .addPostFrameCallback((_) => _showLoaderDialog(context));

    // if(_logo == null){
    //   urlToFile(logoController.text);
    // }
    // if(_stamp == null){
    //   urlToFile1(stampController.text);
    // }
    // if(_signature == null){
    //   urlToFile2(sigController.text);
    // }

    // open a bytestream
    // var stream = new http.ByteStream(DelegatingStream.typed(_logo.openRead()));
    // var stream1 = new http.ByteStream(DelegatingStream.typed(_stamp.openRead()));
    // var stream2 = new http.ByteStream(DelegatingStream.typed(_signature.openRead()));
    //
    // // get file length
    // var length = await _logo.length();
    // var length1 = await _stamp.length();
    // var length2 = await _signature.length();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String storeID = prefs.getString("businessID");
    String token = prefs.getString("token");

    print('$storeID   $token');

    // string to uri
    var uri = Uri.parse("http://157.230.228.250/set-merchant-general-setting-api/");
    Map<String, String> headers = {"Authorization": "Token $token"};
    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // // multipart that takes file
    // var multipartFile = new http.MultipartFile('m_business_logo', stream, length,
    //     filename: path.basename(_logo.path));
    // var multipartFile1 = new http.MultipartFile('m_profile_image', stream1, length1,
    //     filename: path.basename(_stamp.path));
    // var multipartFile2 = new http.MultipartFile('m_profile_image', stream2, length2,
    //     filename: path.basename(_signature.path));
    //
    // // add file to multipart
    // request.files.add(multipartFile);
    // request.files.add(multipartFile1);
    // request.files.add(multipartFile2);

    request.fields['m_business_id'] = storeID;
    request.fields['m_business_name'] = nameController.text;
    request.fields['m_business_category_id'] = id;
    request.fields['m_pin_code'] = pinController.text;
    request.fields['m_city'] = cityController.text;
    request.fields['m_area'] = areaController.text;
    request.fields['m_district'] = districtController.text;
    request.fields['m_state'] = stateController.text;
    request.fields['m_address'] = addressController.text;
    request.fields['m_landline_number'] = teleController.text;
    request.fields['m_alternate_mobile_number'] = mobController.text;
    request.fields['m_company_email'] = cemailController.text;
    request.fields['m_alternate_email'] = emailController.text;
    request.fields['m_pan_number'] = panController.text;
    request.fields['m_gstin'] = gstController.text;
    request.fields['m_cin'] = cinController.text;
    request.fields['m_bank_account_number'] = accController.text;
    request.fields['m_bank_IFSC_code'] = ifscController.text;
    request.fields['m_bank_name'] = bnameController.text;
    request.fields['m_bank_branch'] = branchController.text;
    request.fields['m_GSTIN_certificate'] = "";
    request.fields['m_CIN_certificate'] = "";
    request.fields['m_business_logo'] = "";
    request.fields['m_profile_image'] = "";
    request.fields['m_profile_image'] = "";

    request.headers.addAll(headers);

    // send
    var response = await request.send();
    Navigator.of(context, rootNavigator: true).pop();
    print(response.statusCode);
    print(response);

    if (response.statusCode == 200) {
      print(
          "***********************************************     Submit     *******************************************************");
      Navigator.pop(context, true);
    } else {
      showInSnackBar("Something went wrong!", 2);
    }

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

//   Future<File> urlToFile(String imageUrl) async {
// // generate random number.
//     var rng = new Random();
// // get temporary directory of device.
//     Directory tempDir = await getTemporaryDirectory();
// // get temporary path from temporary directory.
//     String tempPath = tempDir.path;
// // create a new file in temporary path with random file name.
//     File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
// // call http.get method and pass imageUrl into it to get response.
//     http.Response response = await http.get(imageUrl);
// // write bodyBytes received in response to file.
//     await file.writeAsBytes(response.bodyBytes);
// // now return the file which is created with random name in
// // temporary directory and image bytes from response is written to // that file.
//     setState(() {
//       _logo = file;
//     });
//     return file;
//   }
//
//   Future<File> urlToFile1(String imageUrl) async {
// // generate random number.
//     var rng = new Random();
// // get temporary directory of device.
//     Directory tempDir = await getTemporaryDirectory();
// // get temporary path from temporary directory.
//     String tempPath = tempDir.path;
// // create a new file in temporary path with random file name.
//     File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
// // call http.get method and pass imageUrl into it to get response.
//     http.Response response = await http.get(imageUrl);
// // write bodyBytes received in response to file.
//     await file.writeAsBytes(response.bodyBytes);
//     print(file.path);
// // now return the file which is created with random name in
// // temporary directory and image bytes from response is written to // that file.
//     setState(() {
//       _stamp = file;
//     });
//     return file;
//   }
//
//   Future<File> urlToFile2(String imageUrl) async {
// // generate random number.
//     var rng = new Random();
// // get temporary directory of device.
//     Directory tempDir = await getTemporaryDirectory();
// // get temporary path from temporary directory.
//     String tempPath = tempDir.path;
// // create a new file in temporary path with random file name.
//     File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
// // call http.get method and pass imageUrl into it to get response.
//     http.Response response = await http.get(imageUrl);
// // write bodyBytes received in response to file.
//     await file.writeAsBytes(response.bodyBytes);
// // now return the file which is created with random name in
// // temporary directory and image bytes from response is written to // that file.
//     setState(() {
//       _signature = file;
//     });
//     return file;
//   }

}
