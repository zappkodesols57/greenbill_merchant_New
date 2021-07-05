import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../constants.dart';

class PersonalInfoEdit extends StatefulWidget {
  final String fname, lname, mob, email, dob, degi, aadhar, pan;
  PersonalInfoEdit(this.fname, this.lname, this.mob, this.email, this.dob,
      this.degi, this.aadhar, this.pan);

  @override
  _MyPersonalInfoEditState createState() => _MyPersonalInfoEditState(
      fname, lname, mob, email, dob, degi, aadhar, pan);
}

class _MyPersonalInfoEditState extends State<PersonalInfoEdit> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _isButtonDisabled = true;
  bool _isButtonDisabledColor = true;

  final String fname, lname, mob, email, dob, degi, aadhar, pan;
  _MyPersonalInfoEditState(this.fname, this.lname, this.mob, this.email,
      this.dob, this.degi, this.aadhar, this.pan);

  @override
  void initState() {
    super.initState();
    _isButtonDisabled = true;
    _isButtonDisabledColor = true;
    setDetails();
  }

  void setDetails() {
    fnameController.text = fname;
    lnameController.text = lname;
    mobController.text = mob;
    emailController.text = email;
    dobController.text = dob;
    degiController.text = degi;
    aadharController.text = aadhar;
    panController.text = pan;
  }

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

  TextEditingController fnameController = new TextEditingController();
  TextEditingController lnameController = new TextEditingController();
  TextEditingController mobController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController dobController = new TextEditingController();
  TextEditingController degiController = new TextEditingController();
  TextEditingController aadharController = new TextEditingController();
  TextEditingController panController = new TextEditingController();

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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Personal Info"),
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
                padding: EdgeInsets.only(
                    top: 20.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: TextField(
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
                    labelText: "Mobile Number",
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
                  focusNode: myFocusNodeEmail,
                  controller: emailController,
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
                      size: 20.0,
                    ),
                    labelText: "Email",
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
                          labelText: "Date of Birth",
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
                          labelText: "Designation",
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
                    labelText: "Aadhar Number",
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
                    labelText: "Pan Number",
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

  Future<void> save() async {
    if (fnameController.text.isEmpty) {
      showInSnackBar("Please enter First Name", 2);
      return null;
    }
    if (lnameController.text.isEmpty) {
      showInSnackBar("Please enter Last Name", 2);
      return null;
    }
    // if(mobController.text.isEmpty) {
    //   showInSnackBar("Please enter Mobile Number", 2);
    //   return null;
    // }
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
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
