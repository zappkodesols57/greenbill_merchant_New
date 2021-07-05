import 'dart:convert';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/models/model_getGeneralSetting.dart';
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

  // int _index = 0;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("General Settings"),
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
                          ))).then((value) => value ? updateDetails() : null);
            },
          )
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
                    labelText: "Business Name",
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
                    labelText: "Business Category",
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
                          labelText: "Pincode",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.45,
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
                          labelText: "Area",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                        ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.45,
                      child: new TextField(
                        enableInteractiveSelection:
                        false, // will disable paste operation
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
                  enableInteractiveSelection:
                  false, // will disable paste operation
                  focusNode: new AlwaysDisabledFocusNode(),
                  controller: teleController,
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
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: new TextField(
                  enableInteractiveSelection: false, // will disable paste operation
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
                  enableInteractiveSelection: false, // will disable paste operation
                  focusNode: new AlwaysDisabledFocusNode(),
                  controller: cinController,
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
              // Container(
              //   width: size.width * 0.99,
              //   padding: EdgeInsets.only(
              //       top: 10.0, bottom: 0.0, left: 20.0, right: 25.0),
              //   child: Text(
              //     "Logo",
              //     style: TextStyle(
              //       color: Colors.black45,
              //       fontStyle: FontStyle.normal,
              //       fontWeight: FontWeight.w600,
              //     ),
              //   ),
              // ),
              // Center(
              //   child: SizedBox(
              //     height: 250,
              //     child: Card(
              //       semanticContainer: true,
              //       clipBehavior: Clip.antiAliasWithSaveLayer,
              //       child: Image.network( '${logoController.text}',
              //         fit: BoxFit.fill,
              //       ),
              //       shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10.0), ),
              //       elevation: 5,
              //       margin: EdgeInsets.all(10),
              //     ),
              //   ),
              // ),
              // Container(
              //   width: size.width * 0.99,
              //   padding: EdgeInsets.only(
              //       top: 10.0, bottom: 0.0, left: 20.0, right: 25.0),
              //   child: Text(
              //     "Stamp",
              //     style: TextStyle(
              //       color: Colors.black45,
              //       fontStyle: FontStyle.normal,
              //       fontWeight: FontWeight.w600,
              //     ),
              //   ),
              // ),
              // Center(
              //   child: SizedBox(
              //     height: 250,
              //     child: Card(
              //       semanticContainer: true,
              //       clipBehavior: Clip.antiAliasWithSaveLayer,
              //       child: Image.network( '${stampController.text}',
              //         fit: BoxFit.fill,
              //       ),
              //       shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10.0), ),
              //       elevation: 5,
              //       margin: EdgeInsets.all(10),
              //     ),
              //   ),
              // ),
              // Container(
              //   width: size.width * 0.99,
              //   padding: EdgeInsets.only(
              //       top: 10.0, bottom: 0.0, left: 20.0, right: 25.0),
              //   child: Text(
              //     "Signature",
              //     style: TextStyle(
              //       color: Colors.black45,
              //       fontStyle: FontStyle.normal,
              //       fontWeight: FontWeight.w600,
              //     ),
              //   ),
              // ),
              // Center(
              //   child: SizedBox(
              //     height: 250,
              //     child: Card(
              //       semanticContainer: true,
              //       clipBehavior: Clip.antiAliasWithSaveLayer,
              //       child: Image.network( '${sigController.text}',
              //         fit: BoxFit.fill,
              //       ),
              //       shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10.0), ),
              //       elevation: 5,
              //       margin: EdgeInsets.all(10),
              //     ),
              //   ),
              // ),

              // Center(
              //   child: SizedBox(
              //     height: 250, // card height
              //     child: PageView.builder(
              //       itemCount: 3,
              //       controller: PageController(viewportFraction: 0.7),
              //       onPageChanged: (int index) => setState(() => _index = index),
              //       itemBuilder: (_, i) {
              //         return Transform.scale(
              //           scale: i == _index ? 1 : 0.9,
              //           child: Column(
              //             children: <Widget>[
              //               Card(
              //                 semanticContainer: true,
              //                 clipBehavior: Clip.antiAliasWithSaveLayer,
              //                 child: (_index == 0) ? Image.network( '${logoController.text}',
              //                   fit: BoxFit.fill,
              //                 ) : (_index == 1) ? Image.network( '${stampController.text}',
              //                   fit: BoxFit.fill,
              //                 ) : Image.network( '${sigController.text}',
              //                   fit: BoxFit.fill,
              //                 ),
              //                 shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(10.0), ),
              //                 elevation: 5,
              //                 margin: EdgeInsets.all(10),
              //               ),
              //               (_index == 0) ? Text('Logo') : (_index == 1) ? Text('Stamp') :Text('Signature'),
              //             ],
              //           )
              //         );
              //       },
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 20.0,
              ),
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
    showInSnackBar("General Settings updated successfully");
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
