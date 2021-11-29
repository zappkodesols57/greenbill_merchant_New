import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/Services/postalApi_services.dart';
import 'package:greenbill_merchant/src/models/model_States.dart';
import 'package:greenbill_merchant/src/models/postApi_model.dart';
import 'package:greenbill_merchant/src/ui/BillInfo/ViewBill.dart';
import 'package:greenbill_merchant/src/ui/values/values.dart';
import 'package:http/http.dart' as http;

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
      id,

      company,
      billingAdd,
      billingPhone,
      billingEmail,
      firstName,
      lastName,
      tinNo,
      webSiteUrl,
      adharNo,
      nle,
      ale;

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

      this.company,
      this.billingAdd,
      this.billingPhone,
      this.billingEmail,
      this.firstName,
      this.lastName,
      this.tinNo,
      this.webSiteUrl,
      this.adharNo,
      this.nle,
      this.ale,
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
      id,
      company,
      billingAdd,
      billingPhone,
      billingEmail,
      firstName,
      lastName,
      tinNo,
      webSiteUrl,
      adharNo,
      nle,
      ale);
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

class _MyGeneralSettingEditState extends State<GeneralSettingEdit> {
  //bool _alertMob = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final ScrollController _controller = ScrollController();
  String statee,cityy;

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
      id,
      company,
      billingAdd,
      billingPhone,
      billingEmail,
      firstName,
      lastName,
      tinNo,
      webSiteUrl,
      adharNo,
      nle,
      ale;
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
      this.id,
      this.company,
      this.billingAdd,
      this.billingPhone,
      this.billingEmail,
      this.firstName,
      this.lastName,
      this.tinNo,
      this.webSiteUrl,
      this.adharNo,
      this.nle,
      this.ale);

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

    companyController.text = company;
    addController.text = billingAdd;
    phoneController.text = billingPhone;
    emailBController.text = billingEmail;
    firstController.text = firstName;
    lastController.text = lastName;
    tinController.text = tinNo;
    siteController.text = webSiteUrl;
    adharController.text = adharNo;
    nleController.text = nle;
    aleController.text = ale;
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

    companyController.dispose();
    addController.dispose();
    phoneController.dispose();
    emailBController.dispose();
    firstController.dispose();
    lastController.dispose();
    tinController.dispose();
    siteController.dispose();
    adharController.dispose();
    nleController.dispose();
    aleController.dispose();
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

  final FocusNode myFocusNodeCompany = FocusNode();
  final FocusNode myFocusNodeBillingAdd = FocusNode();
  final FocusNode myFocusNodeBillingPhone = FocusNode();
  final FocusNode myFocusNodeBillingEmail = FocusNode();
  final FocusNode myFocusNodeBillingFirstName = FocusNode();
  final FocusNode myFocusNodeBillingLastName = FocusNode();
  final FocusNode myFocusNodeBillingTin = FocusNode();
  final FocusNode myFocusNodeBillingWebSite = FocusNode();
  final FocusNode myFocusNodeBillingAadhar = FocusNode();
  final FocusNode myFocusNodeBillingNle = FocusNode();
  final FocusNode myFocusNodeBillingAle = FocusNode();

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

  TextEditingController companyController = new TextEditingController();
  TextEditingController addController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController emailBController = new TextEditingController();
  TextEditingController firstController = new TextEditingController();
  TextEditingController lastController = new TextEditingController();
  TextEditingController tinController = new TextEditingController();
  TextEditingController siteController = new TextEditingController();
  TextEditingController adharController = new TextEditingController();
  TextEditingController nleController = new TextEditingController();
  TextEditingController aleController = new TextEditingController();

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
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Business Settings"),
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
              SizedBox(height: 10.0,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 45,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: AppColors.kPrimaryColorBlue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 7.0),
                    child: Text("Billing Details",textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),),
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              Card(
                //elevation: 2,
                child:   Column(
                  children: [
                    Container(
                      width: size.width * 0.95,
                      padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                      child: new TextField(
                        inputFormatters: [LengthLimitingTextInputFormatter(30)],
                        focusNode: myFocusNodeCompany,
                        controller: companyController,
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
                          labelText: "Company Name *",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.95,
                      padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                      child: new TextField(
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                      LengthLimitingTextInputFormatter(15)],
                        focusNode: myFocusNodeGst,
                        controller: gstController,
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
                            FontAwesomeIcons.list,
                            color: kPrimaryColorBlue,
                            size: 23.0,
                          ),
                          labelText: "GSTIN",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                        ),
                      ),
                    ),
                    // Container(
                    //   width: size.width * 0.95,
                    //   padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                    //   child: new TextField(
                    //     inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                    //       LengthLimitingTextInputFormatter(21)],
                    //     focusNode: myFocusNodeCin,
                    //     controller: cinController,
                    //     onChanged: (value) {
                    //       setState(() {
                    //         _isButtonDisabledColor = false;
                    //         _isButtonDisabled = false;
                    //       });
                    //     },
                    //     style: TextStyle(
                    //       //fontFamily: "PoppinsBold",
                    //         fontSize: 17.0,
                    //         color: Colors.black87),
                    //     decoration: InputDecoration(
                    //       border: InputBorder.none,
                    //       counterStyle: TextStyle(height: double.minPositive,),
                    //       counterText: "",
                    //       contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                    //       enabledBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(
                    //             color: kPrimaryColorBlue,
                    //             width: 0.5
                    //         ),
                    //         borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    //       ),
                    //       focusedBorder: new OutlineInputBorder(
                    //         borderSide: BorderSide(
                    //             color: kPrimaryColorBlue,
                    //             width: 0.5),
                    //         borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    //       ),
                    //       prefixIcon: Icon(
                    //         FontAwesomeIcons.creditCard,
                    //         color: kPrimaryColorBlue,
                    //         size: 23.0,
                    //       ),
                    //       labelText: "CIN",
                    //       labelStyle: TextStyle(
                    //           fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                    //     ),
                    //   ),
                    // ),
                    // Container(
                    //   width: size.width * 0.95,
                    //   padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                    //   child: new TextField(
                    //     keyboardType: TextInputType.number,
                    //     inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                    //       LengthLimitingTextInputFormatter(11)],
                    //     focusNode: myFocusNodeBillingTin,
                    //     controller: tinController,
                    //     onChanged: (value) {
                    //       setState(() {
                    //         _isButtonDisabledColor = false;
                    //         _isButtonDisabled = false;
                    //       });
                    //     },
                    //     style: TextStyle(
                    //       //fontFamily: "PoppinsBold",
                    //         fontSize: 17.0,
                    //         color: Colors.black87),
                    //     decoration: InputDecoration(
                    //       border: InputBorder.none,
                    //       counterStyle: TextStyle(height: double.minPositive,),
                    //       counterText: "",
                    //       contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                    //       enabledBorder: OutlineInputBorder(
                    //         borderSide: BorderSide(
                    //             color: kPrimaryColorBlue,
                    //             width: 0.5
                    //         ),
                    //         borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    //       ),
                    //       focusedBorder: new OutlineInputBorder(
                    //         borderSide: BorderSide(
                    //             color: kPrimaryColorBlue,
                    //             width: 0.5),
                    //         borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    //       ),
                    //       prefixIcon: Icon(
                    //         FontAwesomeIcons.creditCard,
                    //         color: kPrimaryColorBlue,
                    //         size: 23.0,
                    //       ),
                    //       labelText: "TIN/VAT Number",
                    //       labelStyle: TextStyle(
                    //           fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                    //     ),
                    //   ),
                    // ),
                    Container(
                      width: size.width * 0.95,
                      padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                      child: new TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                          LengthLimitingTextInputFormatter(10)],
                        focusNode: myFocusNodeBillingPhone,
                        controller: phoneController,
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
                            FontAwesomeIcons.phone,
                            color: kPrimaryColorBlue,
                            size: 23.0,
                          ),
                          labelText: "Phone Number",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.95,
                      padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                      child: new TextField(
                        inputFormatters: [LengthLimitingTextInputFormatter(30)],
                        focusNode: myFocusNodeBillingAdd,
                        controller: addController,
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
                            FontAwesomeIcons.building,
                            color: kPrimaryColorBlue,
                            size: 23.0,
                          ),
                          labelText: "Address *",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.95,
                      padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                      child: new TextField(
                        inputFormatters: [LengthLimitingTextInputFormatter(30)],
                        focusNode: myFocusNodeBillingEmail,
                        controller: emailBController,
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
                          labelText: "Email",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                        ),
                      ),
                    ),Container(
                      width: size.width * 0.95,
                      padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                      child: new TextField(
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                          LengthLimitingTextInputFormatter(10)],
                        focusNode: myFocusNodePan,
                        controller: panController,
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
                            FontAwesomeIcons.ccMastercard,
                            color: kPrimaryColorBlue,
                            size: 23.0,
                          ),
                          labelText: "Company PAN Number *",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 45,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: AppColors.kPrimaryColorBlue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 7.0),
                    child: Text("Business Basic Details",textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),),
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              Card(
                //elevation: 2,
                child:   Column(
                  children: [
                    Container(
                      width: size.width * 0.95,
                      padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                      child: new TextField(
                        inputFormatters: [LengthLimitingTextInputFormatter(20)],
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
                          labelText: "Business Name *",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.95,
                      padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                      child: new TextField(
                        enableInteractiveSelection:
                        false, // will disable paste operation
                        focusNode: myFocusNodeCat,
                        controller: catController,
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
                            FontAwesomeIcons.list,
                            color: kPrimaryColorBlue,
                            size: 23.0,
                          ),
                          labelText: "Business Category *",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.95,
                      padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                      child: new TextField(
                        inputFormatters: [FilteringTextInputFormatter.deny(RegExp("[ ]")),
                          LengthLimitingTextInputFormatter(30)],
                        enableInteractiveSelection: false, // will disable paste operation
                        focusNode: myFocusNodeCemail,
                        controller: cemailController,
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
                          labelText: "Business Email *",
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
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10)
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
                        inputFormatters: [LengthLimitingTextInputFormatter(50)],
                        focusNode: myFocusNodeBillingWebSite,
                        controller: siteController,
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
                            FontAwesomeIcons.sitemap,
                            color: kPrimaryColorBlue,
                            size: 23.0,
                          ),
                          labelText: "Website Url *",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.95,
                      padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                      child: new TextField(
                        inputFormatters: [FilteringTextInputFormatter.deny(RegExp("[ ]")),
                          LengthLimitingTextInputFormatter(30)],
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
                  ],
                ),
              ),

              SizedBox(height: 20.0,),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 45,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: AppColors.kPrimaryColorBlue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 7.0),
                    child: Text("Address Details",textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),),
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              Card(
                  child: Column(
                      children: [
                        Container(
                          width: size.width * 0.95,
                          padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                          child: TextField(
                            focusNode: new AlwaysDisabledFocusNode(),
                            controller: stateController,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              //fontFamily: "PoppinsBold",
                                fontSize: 17.0,
                                color: Colors.black87),
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
                              labelText: "State *",
                              labelStyle: TextStyle(
                                  fontFamily: "PoppinsLight",
                                  fontSize: 13.0,
                                  color: kPrimaryColorBlue),
                            ),
                            onTap: (){
                              stateDialog(context);
                            },
                          ),
                        ),

                        Container(
                          width: size.width * 0.95,
                          padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                          child: TextField(
                            focusNode: new AlwaysDisabledFocusNode(),
                            controller: cityController,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                              //fontFamily: "PoppinsBold",
                                fontSize: 17.0,
                                color: Colors.black87),
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
                                FontAwesomeIcons.building,
                                color: kPrimaryColorBlue,
                                size: 20.0,
                              ),
                              labelText: "City *",
                              labelStyle: TextStyle(
                                  fontFamily: "PoppinsLight",
                                  fontSize: 13.0,
                                  color: kPrimaryColorBlue),
                            ),
                            onTap: (){
                              cityDialog(context);
                            },
                          ),
                        ),
                        Container(
                          width: size.width * 0.95,
                          padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                          child: new TextField(
                            inputFormatters: [LengthLimitingTextInputFormatter(50)],
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
                              labelText: "Address *",
                              labelStyle: TextStyle(
                                  fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                            ),
                          ),
                        ),


                        Container(
                          width: size.width * 0.95,
                          padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                          child: new TextField(
                            inputFormatters: [LengthLimitingTextInputFormatter(20)],
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
                              labelText: "Area *",
                              labelStyle: TextStyle(
                                  fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                            ),
                          ),
                        ),

                        Container(
                          width: size.width * 0.95,
                          padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                          child: new TextField(
                            inputFormatters: [LengthLimitingTextInputFormatter(20)],
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
                              labelText: "District *",
                              labelStyle: TextStyle(
                                  fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                            ),
                          ),
                        ),
                        Container(
                          width: size.width * 0.95,
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
                              labelText: "Pincode*",
                              labelStyle: TextStyle(
                                  fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                            ),
                          ),
                        ),
                      ]
                  ),
              ),
              SizedBox(height: 20.0,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 45,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: AppColors.kPrimaryColorBlue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 7.0),
                    child: Text("Owner Details (Contact Person)",textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),),
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              Card(
                  child: Column(
                      children: [
                        Container(
                          width: size.width * 0.95,
                          padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                          child: new TextField(
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                              LengthLimitingTextInputFormatter(12)],
                            focusNode: myFocusNodeBillingFirstName,
                            controller: firstController,
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
                                FontAwesomeIcons.user,
                                color: kPrimaryColorBlue,
                                size: 23.0,
                              ),
                              labelText: "First Name *",
                              labelStyle: TextStyle(
                                  fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                            ),
                          ),
                        ),
                        Container(
                          width: size.width * 0.95,
                          padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                          child: new TextField(
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                              LengthLimitingTextInputFormatter(12)],
                            focusNode:myFocusNodeBillingLastName,
                            controller: lastController,
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
                                FontAwesomeIcons.user,
                                color: kPrimaryColorBlue,
                                size: 23.0,
                              ),
                              labelText: "Last Name *",
                              labelStyle: TextStyle(
                                  fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                            ),
                          ),
                        ),

                        Container(
                          width: size.width * 0.95,
                          padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                          child: new TextField(
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                              LengthLimitingTextInputFormatter(12)],
                            focusNode: myFocusNodeBillingAadhar,
                            controller: adharController,
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
                              labelText: "Aadhaar Number",
                              labelStyle: TextStyle(
                                  fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                            ),
                          ),
                        ),
                      ])),
              SizedBox(height: 20.0,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 45,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    color: AppColors.kPrimaryColorBlue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 7.0),
                    child: Text("Bank Details",textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),),
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              Card(
                child: Column(
                  children: [
                    Container(
                      width: size.width * 0.95,
                      padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                      child: new TextField(
                        maxLength: 20,
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
                        inputFormatters: [FilteringTextInputFormatter.deny('[ ]')],
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
                            FontAwesomeIcons.code,
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
                        maxLength: 20,
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
                            FontAwesomeIcons.solidBuilding,
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
                        maxLength: 20,
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
                            FontAwesomeIcons.city,
                            color: kPrimaryColorBlue,
                            size: 23.0,
                          ),
                          labelText: "Bank Branch",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.95,
                      padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                      child: new TextField(
                        maxLength: 25,
                        focusNode: myFocusNodeBillingNle,
                        controller: nleController,
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
                            FontAwesomeIcons.list,
                            color: kPrimaryColorBlue,
                            size: 23.0,
                          ),
                          labelText: "Name of Legal Entity on Bank Account",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.95,
                      padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                      child: new TextField(
                        maxLength: 25,
                        focusNode: myFocusNodeBillingAle,
                        controller: aleController,
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
                          labelText: "Address of Legal Entity on Bank Account",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ),
      ),
    );
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
                  )));
        });
  }

  stateDialog(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Select State',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w800,
                  fontSize: 15.0,
                  fontFamily: "PoppinsMedium"
              ),
            ),
            content: stateDialoagContainer(),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel', style: TextStyle(color: kPrimaryColorBlue)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Widget stateDialoagContainer() {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: FutureBuilder<List<Datumii>>(
        future: statesSelect(),
        builder: (BuildContext context, AsyncSnapshot<List<Datumii>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),
                  )),
            );
          else if (snapshot.hasError) {
            return Center(
              child: Text("No State Found"),
            );
          } else{
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Scrollbar(
                  radius: Radius.circular(5.0),
                  isAlwaysShown: true,
                  controller: _controller,
                  thickness: 3.0,
                  child: ListView.builder(
                      controller: _controller,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            snapshot.data[index].state,
                            style: TextStyle(fontSize: 15.0,
                            ),
                          ),
                          leading: CircleAvatar(
                            foregroundColor: Colors.white,
                            backgroundColor: kPrimaryColorBlue,
                            child: Text(
                              snapshot.data[index].state.substring(0,1).toUpperCase(),
                              style: TextStyle(fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // trailing: Wrap(
                          //   spacing: 12, // space between two icons
                          //   children: <Widget>[
                          //     Icon(FontAwesomeIcons.rupeeSign, size: 16.0, color: Colors.black,),
                          //     Text('${snapshot.data.data[index].productCost} /Lit', style: TextStyle(fontWeight: FontWeight.bold)),
                          //     // Icon(Icons.message),
                          //   ],
                          // ),
                          onTap: () async {
                            stateController.text = snapshot.data[index].state;
                            setState(() {
                              statee = snapshot.data[index].state;
                              cityController.clear();
                            });
                            Navigator.of(context).pop();
                          },
                        );
                      }
                  )
              );
            } else {
              return Center(child: Text("No state Found"),);
            }
          }

        },
      ),
    );
  }

  cityDialog(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Select City',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w800,
                  fontSize: 15.0,
                  fontFamily: "PoppinsMedium"
              ),
            ),
            content: cityDialoagContainer(),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel', style: TextStyle(color: kPrimaryColorBlue)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Widget cityDialoagContainer() {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: FutureBuilder<List<Datumoo>>(
        future: citiesSelect(),
        builder: (BuildContext context, AsyncSnapshot<List<Datumoo>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),
                  )),
            );
          else if (snapshot.hasError) {
            return Center(
              child: Text("No City Found"),
            );
          } else{
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Scrollbar(
                  radius: Radius.circular(5.0),
                  isAlwaysShown: true,
                  controller: _controller,
                  thickness: 3.0,
                  child: ListView.builder(
                      controller: _controller,
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            snapshot.data[index].city,
                            style: TextStyle(fontSize: 15.0,
                            ),
                          ),
                          leading: CircleAvatar(
                            foregroundColor: Colors.white,
                            backgroundColor: kPrimaryColorBlue,
                            child: Text(
                              snapshot.data[index].city.substring(0,1).toUpperCase(),
                              style: TextStyle(fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // trailing: Wrap(
                          //   spacing: 12, // space between two icons
                          //   children: <Widget>[
                          //     Icon(FontAwesomeIcons.rupeeSign, size: 16.0, color: Colors.black,),
                          //     Text('${snapshot.data.data[index].productCost} /Lit', style: TextStyle(fontWeight: FontWeight.bold)),
                          //     // Icon(Icons.message),
                          //   ],
                          // ),
                          onTap: () async {
                            cityController.text = snapshot.data[index].city;
                            setState(() {
                              cityy = snapshot.data[index].city;
                            });
                            Navigator.of(context).pop();
                          },
                        );
                      }
                  )
              );
            } else {
              return Center(child: Text("No City Found"),);
            }
          }
        },
      ),
    );
  }

  Future<List<Datumii>> statesSelect() async {
    final param = {
      "state": "",
    };

    final res = await http.post(
      "http://157.230.228.250/get-user-cities-by-states-api/",
      body: param,
    );

    print(res.body);
    if (200 == res.statusCode) {
      print(statesFromJson(res.body).stateee.length);
      return statesFromJson(res.body).stateee;
    } else {
      throw Exception('Failed to load Stores List');
    }
  }

  Future<List<Datumoo>> citiesSelect() async {
    final param = {
      "state": state,
    };

    final res = await http.post(
      "http://157.230.228.250/get-user-cities-by-states-api/",
      body: param,
    );

    print(res.body);
    if (200 == res.statusCode) {
      print(statesFromJson(res.body).cityyy.length);
      return statesFromJson(res.body).cityyy;
    } else {
      throw Exception('Failed to load Stores List');
    }
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
    if (companyController.text.isEmpty) {
      showInSnackBar("Please enter Company Name", 2);
      return null;
    }

    if (addController.text.isEmpty) {
      showInSnackBar("Please enter Billing Address", 2);
      return null;
    }

    if (panController.text.isEmpty) {
      showInSnackBar("Please enter Company PAN Number", 2);
      return null;
    }

    if (siteController.text.isEmpty) {
      showInSnackBar("Please enter Website Url", 2);
      return null;
    }

    if (firstController.text.isEmpty) {
      showInSnackBar("Please enter Owners First Name", 2);
      return null;
    }

    if (lastController.text.isEmpty) {
      showInSnackBar("Please enter Owners Last Name", 2);
      return null;
    }

    if (nameController.text.isEmpty) {
      showInSnackBar("Please enter Business Name", 2);
      return null;
    }

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


    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String storeID = prefs.getString("businessID");
    String token = prefs.getString("token");

    print('$storeID   $token');

    // string to uri
    var uri = Uri.parse("http://157.230.228.250/set-merchant-general-setting-api/");
    Map<String, String> headers = {"Authorization": "Token $token"};
    // create multipart request
    var request = new http.MultipartRequest("POST", uri);


    request.fields['m_business_id'] = storeID;
    request.fields['m_business_name'] = nameController.text;
    request.fields['m_business_category_id'] = id;
    request.fields['m_pin_code'] = pinController.text;
    request.fields['m_city'] = cityController.text.capitalize();
    request.fields['m_area'] = areaController.text.capitalize();
    request.fields['m_district'] = districtController.text.capitalize();
    request.fields['m_state'] = stateController.text.capitalize();
    request.fields['m_address'] = addressController.text.capitalize();
    request.fields['m_landline_number'] = teleController.text;
    request.fields['m_alternate_mobile_number'] = mobController.text;
    request.fields['m_company_email'] = cemailController.text;
    request.fields['m_alternate_email'] = emailController.text;
    request.fields['m_pan_number'] = panController.text;
    request.fields['m_gstin'] = gstController.text;
    request.fields['m_cin'] = cinController.text;
    request.fields['m_bank_account_number'] = accController.text;
    request.fields['m_bank_IFSC_code'] = ifscController.text;
    request.fields['m_bank_name'] = bnameController.text.capitalize();
    request.fields['m_bank_branch'] = branchController.text.capitalize();
    request.fields['m_GSTIN_certificate'] = "";
    request.fields['m_CIN_certificate'] = "";
    request.fields['m_business_logo'] = "";
    request.fields['m_profile_image'] = "";
    request.fields['m_website_url'] = siteController.text;
    request.fields['m_business_name_for_billing'] = companyController.text;
    request.fields['m_billing_address'] = addController.text;
    request.fields['m_billing_email'] = emailBController.text;
    request.fields['m_billing_phone'] = phoneController.text;
    request.fields['m_vat_tin_number'] = tinController.text;
    request.fields['Entity_Bank_Account_m'] = aleController.text;
    request.fields['Entity_Account_m'] = nleController.text;
    request.fields['m_aadhaar_number'] = adharController.text;
    request.fields['first_name'] = firstController.text;
    request.fields['last_name'] = lastController.text;

    request.headers.addAll(headers);

    // send
    var response = await request.send();
    Navigator.of(context, rootNavigator: true).pop();
    print(response.statusCode);
    print(response);

    if (response.statusCode == 200) {
      print("***********************************************     Submit     *******************************************************");
      Navigator.pop(context, true);
    } else {
      showInSnackBar("Something went wrong!", 2);
    }

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

}
