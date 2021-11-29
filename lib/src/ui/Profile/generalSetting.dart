import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/models/model_getGeneralSetting.dart';
import 'package:greenbill_merchant/src/ui/drawer/Settings/cancelledCheck.dart';
import 'package:greenbill_merchant/src/ui/values/values.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import 'Edit/generalSettingEdit.dart';

class GeneralSetting extends StatefulWidget {
  GeneralSetting({Key key}) : super(key: key);


  @override
  _MyGeneralSettingState createState() => _MyGeneralSettingState();
}

class _MyGeneralSettingState extends State<GeneralSetting> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool value = false;
  String cancelCheque;
  String udyogAAdhar;
  String addressProof;
  String attestedPAN;
  String signatureProof;
  String compRegCertificate;
  String scedulePdf;
  String mGstinCertificate;
  String mCinCertificate;
  String mBusinessLogo;
  String mBusinessStamp;
  String mDigitalSignature;

  @override
  void initState() {
    super.initState();
    setDetails();
  }

  Future<void> setDetails() async {
    SchedulerBinding.instance
        .addPostFrameCallback((_) => _showLoaderDialog(context));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    String storeID = prefs.getString("businessID");
    print('$storeID  $token');

    final param = {
      "m_business_id": storeID,
    };

    final response = await http.post(
      "http://157.230.228.250/get-merchant-general-setting-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(response.statusCode);
    GetSetting setting;
    var responseJson = json.decode(response.body);
    print(response.body);
    setting = new GetSetting.fromJson(jsonDecode(response.body));
    print(responseJson);

    if (response.statusCode == 200) {
      if (setting.status == "success") {
        print("Setting fetch Successful");
        print(setting.data.mBusinessName);
        nameController.text = setting.data.mBusinessName;
        catController.text = setting.data.mBusinessCategoryName;
        catIDController.text = setting.data.mBusinessCategoryId.toString();
        pinController.text = setting.data.mPinCode;
        cityController.text = setting.data.mCity;
        areaController.text = setting.data.mArea;
        districtController.text = setting.data.mDistrict;
        stateController.text = setting.data.mState;
        addressController.text = setting.data.mAddress;
        teleController.text = setting.data.mLandlineNumber;
        mobController.text = setting.data.mAlternateMobileNumber;
        cemailController.text = setting.data.mCompanyEmail;
        emailController.text = setting.data.mAlternateEmail;
        panController.text = setting.data.mPanNumber;
        gstController.text = setting.data.mGstin;
        cinController.text = setting.data.mCin;
        accController.text = setting.data.mBankAccountNumber;
        ifscController.text = setting.data.mBankIfscCode;
        bnameController.text = setting.data.mBankName;
        branchController.text = setting.data.mBankBranch;
        logoController.text = setting.data.mBusinessLogo;
        stampController.text = setting.data.mBusinessStamp;
        sigController.text = setting.data.mDigitalSignature;

        companyController.text = setting.data.busNameBilling;
        addController.text = setting.data.billingAdd;
        phoneController.text = setting.data.billingPhone;
        emailBController.text = setting.data.billingEmail;
        firstController.text = setting.data.firstName;
        lastController.text = setting.data.lastName;
        tinController.text = setting.data.vatNo;
        siteController.text = setting.data.webSiteUrl;
        adharController.text = setting.data.aadharNo;
        nleController.text = setting.data.entityAccount;
        aleController.text = setting.data.entityBankAc;

        cancelCheque = setting.data.cancelCheque;
        udyogAAdhar = setting.data.udyogAAdhar;
        addressProof = setting.data.addressProof;
        attestedPAN = setting.data.attestedPAN;
        signatureProof = setting.data.signatureProof;
        compRegCertificate = setting.data.compRegCertificate;
        scedulePdf = setting.data.scedulePdf;
        mGstinCertificate = setting.data.mGstinCertificate;
        mCinCertificate = setting.data.mCinCertificate;
        mBusinessLogo = setting.data.mBusinessLogo;
        mBusinessStamp = setting.data.mBusinessStamp;
        mDigitalSignature = setting.data.mDigitalSignature;


        setState(() {});
        Navigator.of(context, rootNavigator: true).pop();
      } else
        print(setting.status);
    } else
      print(setting.status);
  }

  @override
  void dispose() {
    super.dispose();
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
    catIDController.dispose();

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

  TextEditingController nameController = new TextEditingController();
  TextEditingController catController = new TextEditingController();
  TextEditingController catIDController = new TextEditingController();
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
  // int _index = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Business Settings"),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GeneralSettingEdit(
                        nameController.text,
                        catController.text,
                        pinController.text,
                        cityController.text,
                        areaController.text,
                        districtController.text,
                        stateController.text,
                        addressController.text,
                        teleController.text,
                        mobController.text,
                        cemailController.text,
                        emailController.text,
                        panController.text,
                        gstController.text,
                        cinController.text,
                        accController.text,
                        ifscController.text,
                        bnameController.text,
                        branchController.text,
                        logoController.text,
                        stampController.text,
                        sigController.text,
                        catIDController.text,

                        companyController.text,
                        addController.text,
                        phoneController.text,
                        emailBController.text,
                        firstController.text,
                        lastController.text,
                        tinController.text,
                        siteController.text,
                        adharController.text,
                        nleController.text,
                        aleController.text,

                      ))).then((value) => value ? updateDetails() : null);
            },
          )
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
                          enableInteractiveSelection: false, // will disable paste operation
                          focusNode: new AlwaysDisabledFocusNode(),
                          controller: companyController,
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
                          enableInteractiveSelection:
                          false, // will disable paste operation
                          focusNode: new AlwaysDisabledFocusNode(),
                          controller: gstController,
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
                      //     inputFormatters: [FilteringTextInputFormatter.deny(RegExp("[ ]")),
                      //       LengthLimitingTextInputFormatter(40)],
                      //     enableInteractiveSelection: false, // will disable paste operation
                      //     focusNode: new AlwaysDisabledFocusNode(),
                      //     controller: cinController,
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
                      //     enableInteractiveSelection: false, // will disable paste operation
                      //     focusNode: new AlwaysDisabledFocusNode(),
                      //     controller: tinController,
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
                          inputFormatters: [FilteringTextInputFormatter.deny(RegExp("[ ]")),
                            LengthLimitingTextInputFormatter(40)],
                          enableInteractiveSelection: false, // will disable paste operation
                          focusNode: new AlwaysDisabledFocusNode(),
                          controller: phoneController,
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
                          enableInteractiveSelection:
                          false, // will disable paste operation
                          focusNode: new AlwaysDisabledFocusNode(),
                          controller: addController,
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
                          enableInteractiveSelection:
                          false, // will disable paste operation
                          focusNode: new AlwaysDisabledFocusNode(),
                          controller: emailBController,
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
                          enableInteractiveSelection:
                          false, // will disable paste operation
                          focusNode: new AlwaysDisabledFocusNode(),
                          controller: panController,
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
                          enableInteractiveSelection: false, // will disable paste operation
                          focusNode: new AlwaysDisabledFocusNode(),
                          controller: nameController,
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
                          focusNode: new AlwaysDisabledFocusNode(),
                          controller: catController,
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
                            LengthLimitingTextInputFormatter(40)],
                          enableInteractiveSelection: false, // will disable paste operation
                          focusNode: new AlwaysDisabledFocusNode(),
                          controller: cemailController,
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
                          enableInteractiveSelection: false, // will disable paste operation
                          focusNode: new AlwaysDisabledFocusNode(),
                          controller: mobController,
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
                          enableInteractiveSelection: false, // will disable paste operation
                          focusNode: new AlwaysDisabledFocusNode(),
                          controller: siteController,
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
                            LengthLimitingTextInputFormatter(40)],
                          enableInteractiveSelection: false, // will disable paste operation
                          focusNode: new AlwaysDisabledFocusNode(),
                          controller: emailController,
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
                            child: new TextField(
                              enableInteractiveSelection: false, // will disable paste operation
                              focusNode: new AlwaysDisabledFocusNode(),
                              controller: stateController,
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
                                labelText: "State *",
                                labelStyle: TextStyle(
                                    fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                              ),
                            ),
                          ),
                          Container(
                            width: size.width * 0.95,
                            padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                            child: new TextField(
                              enableInteractiveSelection: false, // will disable paste operation
                              focusNode: new AlwaysDisabledFocusNode(),
                              controller: cityController,
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
                                labelText: "City *",
                                labelStyle: TextStyle(
                                    fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                              ),
                            ),
                          ),

                          Container(
                            width: size.width * 0.95,
                            padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                            child: new TextField(
                              inputFormatters: [LengthLimitingTextInputFormatter(60)],
                              enableInteractiveSelection: false, // will disable paste operation
                              focusNode: new AlwaysDisabledFocusNode(),
                              controller: addressController,
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
                              enableInteractiveSelection: false, // will disable paste operation
                              focusNode: new AlwaysDisabledFocusNode(),
                              controller: areaController,
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
                              enableInteractiveSelection: false, // will disable paste operation
                              focusNode: new AlwaysDisabledFocusNode(),
                              controller: districtController,
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
                            padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: size.width * 0.95,
                                  child: new TextField(
                                    enableInteractiveSelection:
                                    false, // will disable paste operation
                                    focusNode: new AlwaysDisabledFocusNode(),
                                    controller: pinController,
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
                                      labelText: "Pincode *",
                                      labelStyle: TextStyle(
                                          fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                                    ),
                                  ),
                                ),
                              ],
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
                              inputFormatters: [LengthLimitingTextInputFormatter(60)],
                              enableInteractiveSelection: false, // will disable paste operation
                              focusNode: new AlwaysDisabledFocusNode(),
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
                              enableInteractiveSelection: false, // will disable paste operation
                              focusNode: new AlwaysDisabledFocusNode(),
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
                              enableInteractiveSelection: false, // will disable paste operation
                              focusNode: new AlwaysDisabledFocusNode(),
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
                          enableInteractiveSelection: false, // will disable paste operation
                          focusNode: new AlwaysDisabledFocusNode(),
                          controller: accController,
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
                          enableInteractiveSelection: false, // will disable paste operation
                          focusNode: new AlwaysDisabledFocusNode(),
                          controller: ifscController,
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
                          enableInteractiveSelection: false, // will disable paste operation
                          focusNode: new AlwaysDisabledFocusNode(),
                          controller: bnameController,
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
                          enableInteractiveSelection: false, // will disable paste operation
                          focusNode: new AlwaysDisabledFocusNode(),
                          controller: branchController,
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
                          enableInteractiveSelection: false, // will disable paste operation
                          focusNode: new AlwaysDisabledFocusNode(),
                          controller: nleController,
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
                          enableInteractiveSelection: false, // will disable paste operation
                          focusNode: new AlwaysDisabledFocusNode(),
                          controller: aleController,
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
                                fontFamily: "PoppinsLight", fontSize: 15.0, color: kPrimaryColorBlue),
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
                      child: Text("Business Documents",textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0,),
                Card(
                    child: Column(
                        children: [
                          Container(
                            width: size.width * 0.95,
                            child: new CheckboxListTile(
                                title: Text("Required Payment Integration",style: TextStyle(fontWeight: FontWeight.bold),),
                                controlAffinity: ListTileControlAffinity.leading,
                                value: value,
                                onChanged: (bool valu){
                                  setState(() {
                                    value = valu;
                                  });
                                }
                            ),
                          ),
                          // Container(
                          //   padding: EdgeInsets.all(10.0),
                          //   width: size.width * 0.95,
                          //   child: Column(
                          //     children: [
                          //       Row(
                          //         children: [
                          //           Icon(
                          //             FontAwesomeIcons.image,
                          //             color: kPrimaryColorBlue,
                          //             size: 23.0,
                          //           ),
                          //           Container(
                          //             padding: EdgeInsets.only(left: 10.0),
                          //               child: Text("Cancelled Cheque",style: TextStyle(
                          //                   fontFamily: "PoppinsLight",
                          //                   fontSize: 13.0,
                          //                   color: kPrimaryColorBlue),)
                          //           ),
                          //         ],
                          //       ),
                          //     SizedBox(height: 5.0,),
                          //     Padding(
                          //       padding: const EdgeInsets.only(top: 5.0,bottom: 5.0),
                          //       child: Image.asset("assets/empty.jpg",height: 110.0,),
                          //     ),
                          //       // Image.network(),
                          //       MaterialButton(
                          //           color: kPrimaryColorBlue,
                          //           shape: RoundedRectangleBorder(
                          //             borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                          //             side: BorderSide(color: kPrimaryColorBlue,),
                          //           ),
                          //           child: Padding(
                          //             padding: const EdgeInsets.all(4.0),
                          //             child: Text(
                          //               "Upload Image",
                          //               style: TextStyle(
                          //                   color: Colors.white,
                          //                   fontSize: 11.0,
                          //                   fontWeight: FontWeight.w500),
                          //             ),
                          //           ),
                          //           onPressed: () {
                          //             {
                          //               Navigator.push(context,
                          //                   MaterialPageRoute(
                          //                       builder: (context) => CancelledCheck("Cancelled Cheque")));
                          //             }
                          //           }
                          //       ),
                          //     ],
                          //   ),
                          //   decoration: BoxDecoration(
                          //     border: Border.all(
                          //       width: 0.5,
                          //       color: kPrimaryColorBlue
                          //     ),
                          //     borderRadius: BorderRadius.all(Radius.circular(15.0))
                          //   ),
                          // ),
                          SizedBox(height: 10.0,),
                          Container(
                            width: size.width * 0.95,
                            child: new TextField(
                              enableInteractiveSelection: false, // will disable paste operation
                              focusNode: new AlwaysDisabledFocusNode(),
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
                                  FontAwesomeIcons.image,
                                  color: kPrimaryColorBlue,
                                  size: 23.0,
                                ),
                                labelText: "Cancelled Cheque",
                                labelStyle: TextStyle(
                                    fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),

                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                      color: kPrimaryColorBlue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                                        side: BorderSide(color: kPrimaryColorBlue,),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          "Upload Image",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      onPressed: ()
                                      {
                                        Navigator.of(context).push(
                                          new MaterialPageRoute(
                                              builder: (_) => CancelledCheck("Cancelled Cheque",cancelCheque)),)
                                            .then((value) => { setDetails() });
                                      }
                                      ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          Container(
                            width: size.width * 0.95,
                            child: new TextField(
                              enableInteractiveSelection: false, // will disable paste operation
                              focusNode: new AlwaysDisabledFocusNode(),
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
                                  FontAwesomeIcons.image,
                                  color: kPrimaryColorBlue,
                                  size: 23.0,
                                ),
                                labelText: "GSTIN Certificate",
                                labelStyle: TextStyle(
                                    fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),

                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                      color: kPrimaryColorBlue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                                        side: BorderSide(color: kPrimaryColorBlue,),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          "Upload Image",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      onPressed: () {
                                        {
                                          Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (_) => CancelledCheck("GSTIN Certificate",mGstinCertificate)),)
                                              .then((value) => { setDetails() });
                                        }
                                      }
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          Container(
                            width: size.width * 0.95,
                            child: new TextField(
                              enableInteractiveSelection: false, // will disable paste operation
                              focusNode: new AlwaysDisabledFocusNode(),
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
                                  FontAwesomeIcons.image,
                                  color: kPrimaryColorBlue,
                                  size: 23.0,
                                ),
                                labelText: "CIN Certificate",
                                labelStyle: TextStyle(
                                    fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),

                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                      color: kPrimaryColorBlue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                                        side: BorderSide(color: kPrimaryColorBlue,),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          "Upload Image",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      onPressed: () {
                                        {
                                          Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (_) => CancelledCheck("CIN Certificate",mCinCertificate)),)
                                              .then((value) => { setDetails() });
                                        }
                                      }
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          Container(
                            width: size.width * 0.95,
                            child: new TextField(
                              enableInteractiveSelection: false, // will disable paste operation
                              focusNode: new AlwaysDisabledFocusNode(),
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
                                  FontAwesomeIcons.image,
                                  color: kPrimaryColorBlue,
                                  size: 23.0,
                                ),
                                labelText: "Udyog Aadhaar\nCertificate",
                                labelStyle: TextStyle(
                                    fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),

                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                      color: kPrimaryColorBlue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                                        side: BorderSide(color: kPrimaryColorBlue,),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          "Upload Image",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      onPressed: () {
                                        {
                                          Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (_) => CancelledCheck("Udyog Aadhaar Certificate",udyogAAdhar)),)
                                              .then((value) => { setDetails() });
                                        }
                                      }
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          Container(
                            width: size.width * 0.95,
                            child: new TextField(
                              enableInteractiveSelection: false, // will disable paste operation
                              focusNode: new AlwaysDisabledFocusNode(),
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
                                  FontAwesomeIcons.image,
                                  color: kPrimaryColorBlue,
                                  size: 23.0,
                                ),
                                labelText: "Address Proof",
                                labelStyle: TextStyle(
                                    fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),

                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                      color: kPrimaryColorBlue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                                        side: BorderSide(color: kPrimaryColorBlue,),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          "Upload Image",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      onPressed: () {
                                        {
                                          Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (_) => CancelledCheck("Address Proof",addressProof)),)
                                              .then((value) => { setDetails() });
                                        }
                                      }
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          Container(
                            width: size.width * 0.95,
                            child: new TextField(
                              enableInteractiveSelection: false, // will disable paste operation
                              focusNode: new AlwaysDisabledFocusNode(),
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
                                  FontAwesomeIcons.image,
                                  color: kPrimaryColorBlue,
                                  size: 23.0,
                                ),
                                labelText: "Attested copy of Pan\nCard of Legal Entity",
                                labelStyle: TextStyle(
                                    fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),

                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                      color: kPrimaryColorBlue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                                        side: BorderSide(color: kPrimaryColorBlue,),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          "Upload Image",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      onPressed: () {
                                        {
                                          Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (_) => CancelledCheck("Attested copy of Pan Card of Legal Entity",attestedPAN)),)
                                              .then((value) => { setDetails() });
                                        }
                                      }
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          Container(
                            width: size.width * 0.95,
                            child: new TextField(
                              enableInteractiveSelection: false, // will disable paste operation
                              focusNode: new AlwaysDisabledFocusNode(),
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
                                  FontAwesomeIcons.image,
                                  color: kPrimaryColorBlue,
                                  size: 23.0,
                                ),
                                labelText: "Signature proof of\nAuthorized Signatory",
                                labelStyle: TextStyle(
                                    fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),

                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                      color: kPrimaryColorBlue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                                        side: BorderSide(color: kPrimaryColorBlue,),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          "Upload Image",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      onPressed: () {
                                        {
                                          Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (_) => CancelledCheck("Signature proof of Authorized Signatory",signatureProof)),)
                                              .then((value) => { setDetails() });
                                        }
                                      }
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          Container(
                            width: size.width * 0.95,
                            child: new TextField(
                              enableInteractiveSelection: false, // will disable paste operation
                              focusNode: new AlwaysDisabledFocusNode(),
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
                                  FontAwesomeIcons.image,
                                  color: kPrimaryColorBlue,
                                  size: 23.0,
                                ),
                                labelText: "Company Registration\nCertificate",
                                labelStyle: TextStyle(
                                    fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),

                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                      color: kPrimaryColorBlue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                                        side: BorderSide(color: kPrimaryColorBlue,),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          "Upload Image",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      onPressed: () {
                                        {
                                          Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (_) => CancelledCheck("Company Registration Certificate",compRegCertificate)),)
                                              .then((value) => { setDetails() });
                                        }
                                      }
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if(value)
                          SizedBox(height: 10.0,),
                          if(value)
                          Container(
                            width: size.width * 0.95,
                            child: new TextField(
                              enableInteractiveSelection: false, // will disable paste operation
                              focusNode: new AlwaysDisabledFocusNode(),
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
                                  FontAwesomeIcons.image,
                                  color: kPrimaryColorBlue,
                                  size: 23.0,
                                ),
                                labelText: "PayU Schedule Upload *",
                                labelStyle: TextStyle(
                                    fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),

                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                      color: kPrimaryColorBlue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                                        side: BorderSide(color: kPrimaryColorBlue,),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          "Upload Image",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      onPressed: () {
                                        {
                                          Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (_) => CancelledCheck("PayU Schedule Upload",scedulePdf)),)
                                              .then((value) => { setDetails() });
                                        }
                                      }
                                  ),
                                ),
                              ),
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
                                child: Text("Uploads",textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          Container(
                            width: size.width * 0.95,
                            child: new TextField(
                              enableInteractiveSelection: false, // will disable paste operation
                              focusNode: new AlwaysDisabledFocusNode(),
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
                                  FontAwesomeIcons.image,
                                  color: kPrimaryColorBlue,
                                  size: 23.0,
                                ),
                                labelText: "Business Logo",
                                labelStyle: TextStyle(
                                    fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),

                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                      color: kPrimaryColorBlue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                                        side: BorderSide(color: kPrimaryColorBlue,),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          "Upload Image",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      onPressed: () {
                                        {
                                          Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                  builder: (_) => CancelledCheck("Business Logo",mBusinessLogo)),)
                                              .then((value) => { setDetails() });
                                        }
                                      }
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          Container(
                            width: size.width * 0.95,
                            child: new TextField(
                              enableInteractiveSelection: false, // will disable paste operation
                              focusNode: new AlwaysDisabledFocusNode(),
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
                                  FontAwesomeIcons.image,
                                  color: kPrimaryColorBlue,
                                  size: 23.0,
                                ),
                                labelText: "Authorised Signature",
                                labelStyle: TextStyle(
                                    fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),

                                suffixIcon: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: MaterialButton(
                                      color: kPrimaryColorBlue,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: const BorderRadius.all(Radius.circular(12.0)),
                                        side: BorderSide(color: kPrimaryColorBlue,),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Text(
                                          "Upload Image",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      onPressed: () {
                                        {
                                          Navigator.of(context).push(
                                            new MaterialPageRoute(
                                                builder: (_) => CancelledCheck("Authorised Signature",mDigitalSignature)),)
                                              .then((value) => { setDetails() });
                                        }
                                      }
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0,),
                        ])),
              ],
            ),
          )
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

  updateDetails() {
    setDetails();
    showInSnackBar("Business Settings updated successfully");
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
