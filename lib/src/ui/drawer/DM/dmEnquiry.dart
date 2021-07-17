import 'dart:convert';
import 'dart:io';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DmEnquiry extends StatefulWidget {
  final String name, mob;
  DmEnquiry(this.name, this.mob);


  @override
  DmEnquiryState createState() => DmEnquiryState();
}
class Courses {
  final int id;
  final String name;

  Courses({
    this.id,
    this.name,
  });
}

class DmEnquiryState extends State<DmEnquiry> {


  static List<Courses> _plans = [
    Courses(id: 1, name: "Search Engine Optimization (SEO)"),
    Courses(id: 2, name: "Pay-Per Click Advertising (PPC)"),
    Courses(id: 3, name: "Social Media Marketing (SMM)"),
    Courses(id: 4, name: "Startup Digital Marketing Plan"),
    Courses(id: 5, name: "Enterprise Digital Marketing Plan"),

  ];

  final _items = _plans
      .map((plans) => MultiSelectItem<Courses>(plans, plans.name))
      .toList();
  List<Courses> _selectedAnimals = [];



  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String id, token;
  String dropdownInt;
  String _chosenName, _chosenValue;

  @override
  void initState() {
    super.initState();
    setData();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    mobController.dispose();
    emailController.dispose();
  }

  setData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getInt("userID").toString();
      token = prefs.getString("token");
    });
    nameController.text = widget.name;
    mobController.text = widget.mob;
    getStore(prefs.getInt("userID").toString());
  }

  final String url = "http://157.230.228.250/get-merchant-businesses-api/";
  List data = List();
  Future<String> getStore(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    final param = {
      "user_id": id,
    };
    var res = await http.post(Uri.encodeFull(url), body: param, headers: {
      "Accept": "application/json",
      HttpHeaders.authorizationHeader: "Token $token"
    });
    var resBody = json.decode(res.body);
    setState(() {
      data = resBody;
    });
    print(res.body);
    return "Success";
  }

  TextEditingController nameController = new TextEditingController();
  TextEditingController mobController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController cmtController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Digital Marketing"),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Center(
          child: Column(
            children: [
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(
                    top: 20.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: new TextField(
                  controller: nameController,
                  style: TextStyle(
                      //fontFamily: "PoppinsBold",
                      fontSize: 17.0,
                      color: Colors.black87),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterStyle: TextStyle(
                      height: double.minPositive,
                    ),
                    counterText: "",
                    contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      FontAwesomeIcons.user,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Name *",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight",
                        fontSize: 13.0,
                        color: kPrimaryColorBlue),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(
                    top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: new TextField(
                  controller: mobController,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  style: TextStyle(
                      //fontFamily: "PoppinsBold",
                      fontSize: 17.0,
                      color: Colors.black87),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterStyle: TextStyle(
                      height: double.minPositive,
                    ),
                    counterText: "",
                    contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      FontAwesomeIcons.mobileAlt,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Mobile No. *",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight",
                        fontSize: 13.0,
                        color: kPrimaryColorBlue),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(
                    top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: new TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                      //fontFamily: "PoppinsBold",
                      fontSize: 17.0,
                      color: Colors.black87),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterStyle: TextStyle(
                      height: double.minPositive,
                    ),
                    counterText: "",
                    contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      FontAwesomeIcons.envelope,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Email *",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight",
                        fontSize: 13.0,
                        color: kPrimaryColorBlue),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.95,
                decoration: BoxDecoration(
                  border: Border.all(color: kPrimaryColorBlue, width: 0.5),
                  borderRadius: BorderRadius.circular(40),
                ),
                padding: EdgeInsets.only(
                    top: 0.0, bottom: 0.0, left: 10.0, right: 10.0),
                child: DropdownButton(
                  iconEnabledColor: Colors.black45,
                  isExpanded: true,
                  style: TextStyle(
                      //fontFamily: "PoppinsBold",
                      fontSize: 17.0,
                      color: Colors.black87),
                  underline: Container(
                    height: 0,
                    width: 0,
                    color: Colors.transparent,
                  ),
                  items: data.map((item) {
                    return DropdownMenuItem(
                      child: new Text(item['m_business_name']),
                      value: item['id'].toString(),
                      onTap: () {
                        setState(() {
                          _chosenName = item['m_business_name'];
                        });
                      },
                    );
                  }).toList(),
                  hint: Text(
                    "Select Business",
                    style: TextStyle(
                        fontFamily: "PoppinsLight",
                        fontSize: 13.0,
                        color: kPrimaryColorBlue),
                  ),
                  onChanged: (String value) {
                    setState(() {
                      _chosenValue = value;
                    });
                  },
                  value: _chosenValue,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),

              Container(
                width: size.width * 0.95,
                decoration: BoxDecoration(
                  border: Border.all(color: kPrimaryColorBlue, width: 0.5),
                  borderRadius: BorderRadius.circular(40),
                ),
                padding: EdgeInsets.only(
                    top: 0.0, bottom: 5.0, left: 15.0, right: 15.0),
                child: MultiSelectDialogField(
                  height:size.width * 0.75,
                  items: _items,
                  title: Text("Select Interest"),
                  selectedColor: kPrimaryColorBlue,


                  buttonText: Text(
                    "Select  Interest",
                    style: TextStyle(
                      fontFamily: "PoppinsLight",
                      fontSize: 13.0,
                      color: kPrimaryColorBlue,
                    ),
                  ),
                  onConfirm: (results) {
                   //_selectedAnimals = results;
                  // print(_selectedAnimals.toString());

                  },
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(
                    top: 10.0, bottom: 0.0, left: 0.0, right: 0.0),
                child: new TextField(
                  controller: cmtController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(
                      //fontFamily: "PoppinsBold",
                      fontSize: 17.0,
                      color: Colors.black87),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterStyle: TextStyle(
                      height: double.minPositive,
                    ),
                    counterText: "",
                    contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      FontAwesomeIcons.commentAlt,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Comments *",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight",
                        fontSize: 13.0,
                        color: kPrimaryColorBlue),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10.0),
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(35.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(1.0, 6.0),
                      blurRadius: 20.0,
                    ),
                  ],
                  gradient: new LinearGradient(
                      colors: [
                        kPrimaryColorBlue,
                        kPrimaryColorBlue,
                      ],
                      begin: const FractionalOffset(0.2, 0.2),
                      end: const FractionalOffset(1.0, 1.0),
                      stops: [0.0, 1.0],
                      tileMode: TileMode.clamp),
                ),
                child: MaterialButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        "Send",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.0,
                            fontFamily: "PoppinsBold"),
                      ),
                    ),
                    onPressed: () {
                      submit();
                    }),
              ),
            ],
          ),
        )));
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

  bool validateEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  submit() async {
    if (nameController.text.isEmpty) {
      showInSnackBar("Please enter Name");
      return null;
    }
    if (mobController.text.isEmpty) {
      showInSnackBar("Please enter Mobile No.");
      return null;
    }
    if (emailController.text.isEmpty) {
      showInSnackBar("Please enter Email");
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
          showInSnackBar("Invalid Email");
          return null;
        }
      } else {
        showInSnackBar("Invalid Email");
        return null;
      }
    }
    if (_chosenName == null) {
      showInSnackBar("Please Select Business");
      return null;
    }
    if (dropdownInt == "Select Interest") {
      showInSnackBar("Please Select Interest");
      return null;
    }
    if (cmtController.text.isEmpty) {
      showInSnackBar("Please enter Comments");
      return null;
    }
    print(_items);

    _showLoaderDialog(context);
    final param = {
      "user_id": id,
      "name": nameController.text,
      "bissiness_name": _chosenName,
      "contact_no": mobController.text,
      "email_id": emailController.text,
      "intrested_in": _items.toString(),
      "comments": cmtController.text,
    };

    final response = await http.post(
      "http://157.230.228.250/add-dm-enquiry-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );
    print(response.statusCode);
    CommonData data;
    var responseJson = json.decode(response.body);
    print(response.body);
    data = new CommonData.fromJson(jsonDecode(response.body));
    print(responseJson);
    Navigator.of(context, rootNavigator: true).pop();
    if (response.statusCode == 200) {
      if (data.status == "success") {
        print("Submit Successful");
        showInSnackBar(data.message);
        print(data.message);
        nameController.clear();
        mobController.clear();
        _items.clear();
        emailController.clear();
        _chosenName = null;
        _chosenValue = null;
        dropdownInt = "Select Interest";
        cmtController.clear();
      } else {
        print(data.status);
        showInSnackBar(data.message);
      }
    } else {
      print(data.status);
      showInSnackBar(data.message);
    }
  }
}
