import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:greenbill_merchant/src/models/model_getPersonalInfo.dart';
import 'package:greenbill_merchant/src/models/model_getProfileImage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class PersonalInfo extends StatefulWidget {
  final String profile, profileUid;
  PersonalInfo(this.profile, this.profileUid);

  @override
  _MyPersonalInfoState createState() => _MyPersonalInfoState(profile);
}

class _MyPersonalInfoState extends State<PersonalInfo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isButtonDisabled = true;
  bool _isButtonDisabledColor = true;

  String number, token;
  int id;
  final String pic;

  bool _verified = false;
  bool _PHverified = false;

  _MyPersonalInfoState(this.pic);

  @override
  void initState() {
    profile.text = pic;
    super.initState();
    setDetails();
  }

  Future<void> setDetails() async {
    SchedulerBinding.instance
        .addPostFrameCallback((_) => _showLoaderDialog(context));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    number = prefs.getString("mobile");
    id = prefs.getInt("userID");
    token = prefs.getString("token");
    print('$number $id $token');

    final param = {
      "mobile_no": number,
    };

    final response = await http.post(
      "http://157.230.228.250/get-merchant-details-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(response.statusCode);
    GetPersonalInfo info;
    var responseJson = json.decode(response.body);
    print(response.body);
    info = new GetPersonalInfo.fromJson(jsonDecode(response.body));
    print(responseJson);

    if (response.statusCode == 200) {
      if (info.status == "success") {
        print("Profile fetch Successful");
        print(info.profileData.mEmail);
        fnameController.text = info.profileData.firstName;
        lnameController.text = info.profileData.lastName;
        nameController.text = '${fnameController.text} ${lnameController.text}';
        emailController.text = info.profileData.mEmail;
        dobController.text = info.profileData.mDob;
        mobController.text = info.profileData.mobileNo;
        degiController.text = info.profileData.mDesignation;
        aadharController.text = info.profileData.mAdhaarNumber;
        panController.text = info.profileData.mPanNumber;
        _verified = info.verified;
        _PHverified = true;

        setData(id, token);
        Navigator.of(context, rootNavigator: true).pop();
      } else
        print(info.status);
    } else
      print(info.status);
  }

  Future<void> setData(int id, String token) async {
    final param = {
      "user_id": id.toString(),
    };

    final response = await http.post(
      "http://157.230.228.250/get-merchant-profile-image-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    GetProfileImage profileImage;
    var responseJson = json.decode(response.body);
    print(response.body);
    profileImage = new GetProfileImage.fromJson(jsonDecode(response.body));
    print(responseJson);

    if (response.statusCode == 200) {
      if (profileImage.status == "success") {
        print("Profile fetch Successful");
        print(profileImage.data.firstName);
        profile.text = profileImage.data.profileImage;

        setState(() {});
      } else
        print(profileImage.status);
    } else
      print(profileImage.status);
  }

  @override
  @override
  void dispose() {
    super.dispose();
    myFocusNodeFname.dispose();
    myFocusNodeLname.dispose();
    myFocusNodeMob.dispose();
    myFocusNodeEmail.dispose();
    myFocusNodeDob.dispose();
    myFocusNodeDegi.dispose();
    myFocusNodeAadhar.dispose();
    myFocusNodePan.dispose();

    fnameController.dispose();
    lnameController.dispose();
    mobController.dispose();
    emailController.dispose();
    dobController.dispose();
    degiController.dispose();
    aadharController.dispose();
    panController.dispose();
  }

  final FocusNode myFocusNodeFname = FocusNode();
  final FocusNode myFocusNodeLname = FocusNode();
  final FocusNode myFocusNodeMob = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeDob = FocusNode();
  final FocusNode myFocusNodeDegi = FocusNode();
  final FocusNode myFocusNodeAadhar = FocusNode();
  final FocusNode myFocusNodePan = FocusNode();
  // void dispose() {
  //   super.dispose();
  //   fnameController.dispose();
  //   lnameController.dispose();
  //   nameController.dispose();
  //   mobController.dispose();
  //   emailController.dispose();
  //   dobController.dispose();
  //   degiController.dispose();
  //   aadharController.dispose();
  //   panController.dispose();
  //   profile.dispose();
  // }

  TextEditingController fnameController = new TextEditingController();
  TextEditingController lnameController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController mobController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController dobController = new TextEditingController();
  TextEditingController degiController = new TextEditingController();
  TextEditingController aadharController = new TextEditingController();
  TextEditingController panController = new TextEditingController();
  TextEditingController profile = new TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950, 1),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      dobController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double headerHeight = 130.0;
    // double headerHeight = 150.0;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Profile"),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
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
        child: Column(
          children: <Widget>[
            new Container(
              height: headerHeight,
              decoration: new BoxDecoration(
                color: Colors.transparent,
                borderRadius: new BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)),
                boxShadow: <BoxShadow>[
                  new BoxShadow(
                      spreadRadius: 0.0,
                      blurRadius: 0.0,
                      offset: new Offset(0.0, 0.0),
                      color: Colors.black26),
                ],
              ),
              child: new Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  // linear gradient
                  new Container(
                    height: headerHeight,
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.only(
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0)),
                      gradient: new LinearGradient(colors: <Color>[
                        //7928D1
                        kPrimaryColorBlue, kPrimaryColorBlue
                      ], stops: <double>[
                        0.5,
                        0.5
                      ], begin: Alignment.topRight, end: Alignment.bottomLeft),
                    ),
                  ),
                  // radial gradient
                  new CustomPaint(
                    painter: new HeaderGradientPainter(),
                  ),
                  new Padding(
                    padding: new EdgeInsets.only(
                        top: 0.0, left: 15.0, right: 15.0, bottom: 0.0),
                    child: new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Padding(
                            padding: const EdgeInsets.only(bottom: 0.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                _buildAvatar(size),
                                SizedBox(
                                  height: 10.0,
                                ),
                                // Text(
                                //   'Your GreenBill Pin for Checkout',
                                //   style: TextStyle(color: Colors.white),
                                // ),
                                // Text(
                                //   widget.profileUid,
                                //   style: TextStyle(
                                //       fontWeight: FontWeight.bold,
                                //       fontSize: 20.0,
                                //       color: Colors.white),
                                // )
                              ],
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Container(
              width: size.width * 0.95,
              padding: EdgeInsets.only(
                  top: 20.0, bottom: 10.0, left: 0.0, right: 0.0),
              child: TextField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                  LengthLimitingTextInputFormatter(15)],
                focusNode: myFocusNodeFname,
                controller: fnameController,
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
                    FontAwesomeIcons.user,
                    color: kPrimaryColorBlue,
                    size: 20.0,
                  ),
                  labelText: "First Name *",
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
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                  LengthLimitingTextInputFormatter(15)],
                focusNode: myFocusNodeLname,
                controller: lnameController,
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
                    FontAwesomeIcons.user,
                    color: kPrimaryColorBlue,
                    size: 20.0,
                  ),
                  labelText: "Last Name *",
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
                enableInteractiveSelection:
                false, // will disable paste operation
                focusNode: new AlwaysDisabledFocusNode(),
                controller: mobController,
                keyboardType: TextInputType.number,
                onTap: () {
                  showInSnackBar("Unauthorized action! Permission Denied", 2);
                },
                onChanged: (value) {
                  setState(() {
                    _isButtonDisabledColor = false;
                    _isButtonDisabled = false;
                  });
                },
                style: TextStyle(
                  //fontFamily: "PoppinsBold",
                    fontSize: 17.0,
                    color: Colors.black54),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: (){},
                    icon:(_PHverified)?Icon(Icons.verified,color:kPrimaryColorBlue):Icon(Icons.verified,color:Colors.grey),
                    tooltip:("Verified"),
                     ),
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
                    size: 20.0,
                  ),
                  labelText: "Mobile Number *",
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
                    enableInteractiveSelection: false,
                    inputFormatters: [FilteringTextInputFormatter.deny(RegExp("[ ]"))],
                    focusNode: new AlwaysDisabledFocusNode(),
                    controller: emailController,
                    onChanged: (value) {
                      setState(() {
                        _isButtonDisabledColor = false;
                        _isButtonDisabled = false;
                      });
                    },
                    onTap: () {
                      showInSnackBar("Unauthorized action! Permission Denied", 2);
                    },
                    style: TextStyle(
                      //fontFamily: "PoppinsBold",
                        fontSize: 17.0,
                        color: Colors.black54),
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: (){},
                        icon: (_verified)?Icon(Icons.verified,color:kPrimaryColorBlue):Icon(Icons.verified,color:Colors.grey),
                        tooltip: (_verified)?("Verified"):("Not Verified"),
                      ),
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
                        size: 20.0,
                      ),
                      labelText: "Email *",
                      labelStyle: TextStyle(
                          fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                    ),
                  ),
            ),
            Container(
              width: size.width * 0.95,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: size.width * 0.46,
                    padding: EdgeInsets.only(
                        top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                    child: TextField(
                      enableInteractiveSelection:
                      false, // will disable paste operation
                      focusNode: new AlwaysDisabledFocusNode(),
                      controller: dobController,
                      onTap: () {
                        _selectDate(context);
                        setState(() {
                          _isButtonDisabledColor = false;
                          _isButtonDisabled = false;
                        });
                      },
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
                          CupertinoIcons.calendar,
                          color: kPrimaryColorBlue,
                          size: 23.0,
                        ),
                        labelText: "Date of Birth *",
                        labelStyle: TextStyle(
                            fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * 0.46,
                    padding: EdgeInsets.only(
                        top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                    child: TextField(
                      focusNode: myFocusNodeDegi,
                      controller: degiController,
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
                          CupertinoIcons.briefcase,
                          color: kPrimaryColorBlue,
                          size: 23.0,
                        ),
                        labelText: "Designation *",
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
              padding: EdgeInsets.only(
                  top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
              child: TextField(
                focusNode: myFocusNodeAadhar,
                controller: aadharController,
                keyboardType: TextInputType.number,
                maxLength: 12,
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
                    CupertinoIcons.creditcard,
                    color: kPrimaryColorBlue,
                    size: 23.0,
                  ),
                  labelText: "Aadhar Number *",
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
                focusNode: myFocusNodePan,
                controller: panController,
                keyboardType: TextInputType.text,
                maxLength: 10,
                textCapitalization: TextCapitalization.characters,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                ],
                onChanged: (value) {
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
                    CupertinoIcons.creditcard,
                    color: kPrimaryColorBlue,
                    size: 23.0,
                  ),
                  labelText: "Pan Number *",
                  labelStyle: TextStyle(
                      fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(Size size) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Center(
          child: Stack(
            children: <Widget>[
              ClipOval(
                child: new Image.network(
                  '${profile.text}',
                  // height: size.height * 0.1,
                  height: 90.0,
                  width: 90.0,
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                bottom: 3.0,
                right: 0.0,
                child: InkWell(
                  onTap: () {
                    _showSelectionDialog(context);
                  },
                  child: CircleAvatar(
                    radius: size.width * 0.035,
                    backgroundColor: Colors.blue,
                    child: Icon(
                      FontAwesomeIcons.camera,
                      color: Colors.white,
                      size: 13.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showSelectionDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text("Choose Image Source"),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    GestureDetector(
                      child: Text("Gallery"),
                      onTap: () {
                        _openGallery(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Camera"),
                      onTap: () {
                        _openCamera(context);
                      },
                    ),
                    Padding(padding: EdgeInsets.all(8.0)),
                    GestureDetector(
                      child: Text("Remove Photo"),
                      onTap: () {
                        Navigator.of(context).pop();
                        removeProfile();
                      },
                    )
                  ],
                ),
              ));
        });
  }

  void _openCamera(BuildContext context) async {
    Navigator.of(context).pop();
    var picture = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 25);
    if (picture != null) {
      _cropImage(picture);
    }
  }

  void _openGallery(BuildContext context) async {
    var picture = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 25);
    Navigator.of(context).pop();
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
      sendData(croppedFile);
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
                  )));
        });
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

  bool validatePan(String value) {
    String pattern = r"[A-Z]{5}[0-9]{4}[A-Z]{1}";
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  Future<void> save() async {
    if (fnameController.text.isEmpty) {
      showInSnackBar("Please enter First Name", 2);
      return null;
    }
    if (lnameController.text.isEmpty) {
      showInSnackBar("Please enter Last Name", 2);
      return null;
    }

    if (emailController.text.isEmpty) {
      showInSnackBar("Please enter Email", 2);
      return null;
    }
    if (emailController.text.isNotEmpty) {
      if (emailController.text.contains('com') ||
          emailController.text.contains('net') ||
          emailController.text.contains('edu') ||
          emailController.text.contains('org') ||
          emailController.text.contains('mil') ||
          emailController.text.contains('gov')) {
        if (validateEmail(emailController.text) == false) {
          showInSnackBar("Invalid Email", 2);
          return null;
        }
      } else {
        showInSnackBar("Invalid Email", 2);
        return null;
      }
    }
    if (dobController.text.isEmpty) {
      showInSnackBar("Please enter Date of Birth", 2);
      return null;
    }
    if (degiController.text.isEmpty) {
      showInSnackBar("Please enter Designation", 2);
      return null;
    }
    if (aadharController.text.isEmpty) {
      showInSnackBar("Please enter Aadhar Number", 2);
      return null;
    }
    if (aadharController.text.length < 12) {
      showInSnackBar("Please enter valid Aadhar Number", 2);
      return null;
    }
    if (panController.text.isEmpty) {
      showInSnackBar("Please enter Pan Number", 2);
      return null;
    }
    if (panController.text.length < 10) {
      showInSnackBar("Please enter valid Pan Number", 2);
      return null;
    }
    if (panController.text.length > 10) {
      showInSnackBar("Please enter valid Pan Number", 2);
      return null;
    }
    if (validatePan(panController.text) == false) {
      showInSnackBar("Invalid Pan Number", 2);
      return null;
    }

    SchedulerBinding.instance
        .addPostFrameCallback((_) => _showLoaderDialog(context));
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String token = prefs.getString("token");
    int id = prefs.getInt("userID");
    print('$id $token');

    final param = {
      "user_id": id.toString(),
      "m_email": emailController.text,
      "first_name": fnameController.text,
      "last_name": lnameController.text,
      "m_dob": dobController.text,
      "m_designation": degiController.text,
      "m_adhaar_number": aadharController.text,
      "m_pan_number": panController.text,
    };

    final response = await http.post(
      "http://157.230.228.250/set-merchant-profile-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(response.statusCode);
    CommonData data;
    var responseJson = json.decode(response.body);
    print(response.body);
    data = new CommonData.fromJson(jsonDecode(response.body));
    print(responseJson);

    if (response.statusCode == 200) {
      if (data.status == "success") {
        print("Profile update Successful");
        print(data.message);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("fName", fnameController.text);
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pop(context, true);
      } else {
        print(data.status);
        showInSnackBar(data.message, 2);
      }
    } else {
      print(data.status);
      showInSnackBar(data.message, 2);
    }
  }

  bool validateEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  Future<void> removeProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int userid = prefs.getInt("userID");
    print(userid);

    final param = {
      "user_id": userid.toString(),
    };

    final response = await http.post(
      "http://157.230.228.250/remove-merchant-profile-image-api/",
      body: param,
    );

    CommonData remove;
    print(response.statusCode);
    print(response.body);
    remove = new CommonData.fromJson(jsonDecode(response.body));

    if (response.statusCode == 200) {
      if (remove.status == "success") {
        print(remove.status);
        showInSnackBar("Profile Picture removed successfully.",2);
        setData(id, token);
      } else
        showInSnackBar(remove.message,2);
    } else {
      print(remove.status);
      showInSnackBar(remove.message,2);
      return null;
    }
  }

  Future<void> sendData(File imageFile) async {
    // open a bytestream
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));

    // get file length
    var length = await imageFile.length();

    print('$id   $token');

    // string to uri
    var uri =
        Uri.parse("http://157.230.228.250/set-merchant-profile-image-api/");
    Map<String, String> headers = {"Authorization": "Token $token"};
    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile(
        'm_profile_image', stream, length,
        filename: path.basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    request.fields['user_id'] = id.toString();

    request.headers.addAll(headers);

    // send
    var response = await request.send();
    print(response.statusCode);
    print(response);

    if (response.statusCode == 200) {
      print(
          "***********************************************     Submit     *******************************************************");
      showInSnackBar("Profile Updated",2);
      setData(id, token);
      setState(() {});
    } else {
      showInSnackBar("Something went wrong!",2);
    }

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  updateProfile() {
    setDetails();
    showInSnackBar("Profile updated successfully",2);
  }
}

class HeaderGradientPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: paint background radial gradient
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
