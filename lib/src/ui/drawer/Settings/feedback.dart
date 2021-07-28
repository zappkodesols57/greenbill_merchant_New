import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Feedback1 extends StatefulWidget {
  @override
  _Feedback1State createState() => _Feedback1State();
}

class _Feedback1State extends State<Feedback1> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Color suggestionContainerColor = kPrimaryColorBlue;
  Color suggestionTextColor = Colors.white;
  Color bugsContainerColor = Colors.white;
  Color bugsTextColor = kPrimaryColorBlue;
  String mobile, token;
  bool _isBug;

  TextEditingController cmtController = new TextEditingController();


  @override
  void initState() {
    _isBug = false;
    super.initState();
    getCredentials();
  }

  @override
  void dispose() {
    super.dispose();
    cmtController.dispose();
  }

  getCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mobile = prefs.getString("mobile");
      token = prefs.getString("token");
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Feedback'),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text("Select type of feedback",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                  fontFamily: "PoppinsMedium",
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      suggestionContainerColor = kPrimaryColorBlue;
                      suggestionTextColor = Colors.white;
                      bugsContainerColor = Colors.white;
                      bugsTextColor = kPrimaryColorBlue;
                      _isBug = false;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: size.width * 0.35,
                    decoration: BoxDecoration(
                        border: Border.all(color: kPrimaryColorBlue),
                        color: suggestionContainerColor,
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: Center(
                      child: Text(
                        'Suggestions',
                        style: TextStyle(
                          color: suggestionTextColor,
                          fontSize: 18,
                          fontFamily: "PoppinsBold",
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      suggestionContainerColor = Colors.white;
                      suggestionTextColor = kPrimaryColorBlue;
                      bugsContainerColor = kPrimaryColorBlue;
                      bugsTextColor = Colors.white;
                      _isBug = true;
                    });
                  },
                  child: Container(
                    height: 50,
                    width: size.width * 0.35,
                    decoration: BoxDecoration(
                        border: Border.all(color: kPrimaryColorBlue),
                        color: bugsContainerColor,
                        borderRadius: BorderRadius.all(Radius.circular(25))),
                    child: Center(
                      child: Text(
                        'Bugs',
                        style: TextStyle(
                          color: bugsTextColor,
                          fontSize: 18,
                          fontFamily: "PoppinsBold",
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: cmtController,
                textInputAction: TextInputAction.newline,
                maxLength: 200,
                maxLines: 11,
                decoration: InputDecoration(
                  // prefixIcon: Icon(
                  //   Icons.comment,
                  //   color: kPrimaryColorBlue,
                  // ),
                  border: InputBorder.none,
                  labelText: 'Comments',
                  labelStyle: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 15.0,
                      color: kPrimaryColorBlue),
                  alignLabelWithHint: true,
                  contentPadding:
                  const EdgeInsets.symmetric(vertical: 13.0, horizontal: 30.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColorBlue, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                  ),
                  focusedBorder: new OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColorBlue, width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: size.width,
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
                    color: kPrimaryColorBlue
                ),
                child: MaterialButton(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: "PoppinsMedium"),
                      ),
                    ),
                    onPressed: () {
                      submit();
                    }),
              ),
            ),
          ],
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
              backgroundColor: Colors.white,
              content: new Container(
                height: 40.0,
                width: 40.0,
                child: Center(
                  child: SpinKitWave(
                    color: kPrimaryColorBlue,
                    size: 40.0,
                  ),
                ),
              ));
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

  submit() async {
    if (cmtController.text.isEmpty) {
      showInSnackBar("Please enter you Feedback");
      return null;
    }
    if (_isBug == null) {
      showInSnackBar("Please Select Feedback type");
      return null;
    }
    _showLoaderDialog(context);

    final param = {
      "mobile_no": mobile,
      "bug": _isBug.toString(),
      "suggestion": (!_isBug).toString(),
      "comments": cmtController.text,
    };

    final response = await http.post(
      "http://157.230.228.250/merchant-feedback-api/",
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
      print("Submit Successful");
      print(data.status);
      if (data.status == "success") {
        Navigator.of(context, rootNavigator: true).pop();
        cmtController.clear();
        showInSnackBar("Feedback Submitted Successfully");
      } else showInSnackBar(data.status);
    } else {
      print(data.status);
      Navigator.of(context, rootNavigator: true).pop();
      showInSnackBar(data.status);
      return null;
    }
  }


}
