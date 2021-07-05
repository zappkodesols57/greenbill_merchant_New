import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../constants.dart';

class AddUser extends StatefulWidget {
  @override
  AddUserState createState() => AddUserState();
}

class AddUserState extends State<AddUser> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, id, storeID;
  String _chosenValue;
  final ScrollController _controller = ScrollController();

  TextEditingController fNameController = new TextEditingController();
  TextEditingController lNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();

  @override
  void initState() {
    getCredentials();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    fNameController.dispose();
    lNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
  }

  getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      id = prefs.getInt("userID").toString();
      storeID = prefs.getString("businessID");
    });
    print('$token\n$id');
    this.getRoles(id);
  }

  final String url = "http://157.230.228.250/merchant-user-role-api/";
  List data = List();
  Future<String> getRoles(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token");
    final param = {
      "m_user_id": id,
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

  bool validateEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  void addUser() async {

    if(fNameController.text.isEmpty){
      showInSnackBar("Please enter First Name");
      return null;
    }
    if(lNameController.text.isEmpty){
      showInSnackBar("Please enter Last Name");
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
    if (mobileController.text.isEmpty) {
      showInSnackBar("Please enter Mobile No.");
      return null;
    }
    if (mobileController.text.length < 10) {
      showInSnackBar("Please enter valid Mobile No.");
      return null;
    }
    if (_chosenValue == null) {
      showInSnackBar("Please Select Role");
      return null;
    }

    final param = {
      "user_id": id,
      "m_business_id": storeID,
      "mobile_no": mobileController.text,
      "email": emailController.text,
      "first_name": fNameController.text,
      "last_name": lNameController.text,
      "role_id": _chosenValue,
    };

    final response = await http.post(
      "http://157.230.228.250/create-merchant-user-api/",
      body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(response.statusCode);
    CommonData data;
    var responseJson = json.decode(response.body);
    print(response.body);
    data = new CommonData.fromJson(jsonDecode(response.body));
    print(responseJson);

    if (response.statusCode == 200) {
      print("Added Successful");
      print(data.status);
      if(data.status == "success"){
        fNameController.clear();
        lNameController.clear();
        emailController.clear();
        mobileController.clear();
        _chosenValue = null;
        Navigator.pop(context, true);
      } else showInSnackBar(data.message);
    } else {
      print(data.status);
      print(data.message);
      showInSnackBar(data.message);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Add User'),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {Navigator.pop(context, false);},
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                addUser();
              },
              child: Text("Add", style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                  top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
              child: TextField(
                controller: fNameController,
                inputFormatters: [
                  new WhitelistingTextInputFormatter(RegExp("[a-z A-Z]")),
                  LengthLimitingTextInputFormatter(13),
                ],
                style: TextStyle(
                    fontFamily: "PoppinsMedium",
                    fontSize: 13.0,
                    color: Colors.black87
                ),
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
              padding: EdgeInsets.only(
                  top: 0.0, bottom: 10.0, left: 10.0, right: 10.0),
              child: TextField(
                controller: lNameController,
                inputFormatters: [
                  new WhitelistingTextInputFormatter(RegExp("[a-z A-Z]")),
                  LengthLimitingTextInputFormatter(13),
                ],
                style: TextStyle(
                    fontFamily: "PoppinsMedium",
                    fontSize: 13.0,
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
              padding: EdgeInsets.only(
                  top: 0.0, bottom: 10.0, left: 10.0, right: 10.0),
              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                    fontFamily: "PoppinsMedium",
                    fontSize: 13.0,
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
            ),
            Container(
              width: size.width * 0.95,
              padding: EdgeInsets.only(
                  top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
              child: new TextField(
                controller: mobileController,
                keyboardType: TextInputType.phone,
                maxLength: 10,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                style: TextStyle(
                  fontFamily: "PoppinsMedium",
                    fontSize: 13.0,
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
                  fontFamily: "PoppinsMedium",
                    fontSize: 13.0,
                    color: Colors.black87),
                underline: Container(
                  height: 0,
                  width: 0,
                  color: Colors.transparent,
                ),
                items: data.map((item) {
                  return DropdownMenuItem(
                    child: new Text(item['role_name']),
                    value: item['id'].toString(),
                  );
                }).toList(),
                hint: Text(
                  "Select Role",
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
          ],
        )
    );
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

}