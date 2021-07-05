import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:greenbill_merchant/src/models/model_payLink.dart';
import 'package:greenbill_merchant/src/ui/PayLinks/cardItemsPayLinks.dart';
import 'package:greenbill_merchant/src/ui/PayU_Biz/payu_webView.dart';
import 'package:greenbill_merchant/src/ui/widgets/custom_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import 'package:http/http.dart' as http;

class PayLinks extends StatefulWidget {
  const PayLinks({Key key}) : super(key: key);

  @override
  _PayLinksState createState() => _PayLinksState();
}

class _PayLinksState extends State<PayLinks> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String token, id, mob, storeID;
  bool rememberMe = true;
  final ScrollController _controller = ScrollController();

  TextEditingController mobController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController amountController = new TextEditingController();
  TextEditingController decController = new TextEditingController();

  @override
  void initState() {
    getCredentials();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    mobController.dispose();
    nameController.dispose();
    emailController.dispose();
    amountController.dispose();
    decController.dispose();
  }

  getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      id = prefs.getInt("userID").toString();
      mob = prefs.getString("mobile");
      storeID = prefs.getString("businessID");
    });
  }

  void _onRememberMeChanged(bool newValue) {
    setState(() {
      rememberMe = newValue;
    });
  }

  Future<List<Datum>> getLists() async {

    final param = {
      "m_business_id": storeID,
    };

    final res = await http.post("http://157.230.228.250/merchant-payment-link-list-api/", body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(res.body);
    print(res.statusCode);
    if(200 == res.statusCode){
      print(payLinksFromJson(res.body).data.length);
      return payLinksFromJson(res.body).data;
    } else{
      throw Exception('Failed to load List');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
        children: [
          CustomTextField(
            controller: mobController,
            inputType: TextInputType.phone,
            formatter: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            maxLength: 10,
            prefixIcon: CupertinoIcons.phone,
            hintText: "Mobile No. *",
            padding: EdgeInsets.only(top: 20.0, right: 15.0, left: 15.0, bottom: 10.0),
          ),
          CustomTextField(
            controller: nameController,
            formatter: [new WhitelistingTextInputFormatter(RegExp("[a-z A-Z]")),],
            prefixIcon: CupertinoIcons.person,
            hintText: "Name *",
            padding: EdgeInsets.only(top: 0.0, right: 15.0, left: 15.0, bottom: 10.0),
          ),
          CustomTextField(
            controller: emailController,
            inputType: TextInputType.emailAddress,
            prefixIcon: CupertinoIcons.mail,
            hintText: "Email *",
            padding: EdgeInsets.only(top: 0.0, right: 15.0, left: 15.0, bottom: 10.0),
          ),
          CustomTextField(
            controller: amountController,
            inputType: TextInputType.number,
            formatter: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            prefixIcon: CupertinoIcons.arrow_down_right,
            hintText: "Amount *",
            padding: EdgeInsets.only(top: 0.0, right: 15.0, left: 15.0, bottom: 10.0),
          ),
          CustomTextField(
            controller: decController,
            formatter: [new WhitelistingTextInputFormatter(RegExp("[a-z A-Z]")),],
            prefixIcon: CupertinoIcons.quote_bubble,
            hintText: "Description *",
            padding: EdgeInsets.only(top: 0.0, right: 15.0, left: 15.0, bottom: 10.0),
          ),

          SizedBox(height: 10.0,),
          Container(
            padding: EdgeInsets.only(left: size.width * 0.25, right: size.width * 0.25),
            height: 50.0,
            width: size.width * 0.47,
            child: ElevatedButton(
              child: Text(
                "Create",
                style: TextStyle(
                    fontFamily: "PoppinsMedium",
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                ),
              ),
              style: ElevatedButton.styleFrom(
                  elevation: 0.0,
                  primary: kPrimaryColorBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(90)))),
              onPressed: () {
                createLink();
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30.0, bottom: 10.0),
            child: Text(
              "All Payment Links",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                fontFamily: "PoppinsMedium",
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
          ),
          FutureBuilder<List<Datum>>(
            future: getLists(),
            builder: (BuildContext context, AsyncSnapshot<List<Datum>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),));
              else if (snapshot.hasError) {
                return Center(
                  child: Text("No Payment Links"),
                );
              } else {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_controller.hasClients) {
                      _controller.animateTo(
                          _controller.position.maxScrollExtent,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.fastLinearToSlowEaseIn);
                    } else {
                      setState(() => null);
                    }
                  });
                  return Scrollbar(
                    isAlwaysShown: true,
                    controller: _controller,
                    thickness: 3.0,
                    child: ListView.builder(
                        itemCount: snapshot.data.length,
                        shrinkWrap: true,
                        reverse: false,
                        controller: _controller,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 5.0),
                              child: PayLinksCard(size, snapshot.data[index],
                                  (){
                                    // send(snapshot.data[index].id);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => PayUWebView("Pay", "url")));
                                  },
                                  (){
                                    delete(snapshot.data[index].id);
                                  }
                                  )
                          );
                        }
                    ),
                  );
                } else {
                  return Center(child: Text("No Payment Links"));
                }
              }

            },
          ),
        ],
      )
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
          fontFamily: "PoppinsMedium",
          fontWeight: FontWeight.bold,
          fontSize: 12.0,
        ),
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      duration: Duration(seconds: 2),
    ));
  }

  bool validateEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  Future<void> createLink() async {
    if(mobController.text.isEmpty){
      showInSnackBar("Please Enter Mobile No.");
      return null;
    }
    if(mobController.text.length < 10){
      showInSnackBar("Please enter valid Mobile No.");
      return null;
    }
    if(nameController.text.isEmpty){
      showInSnackBar("Please enter Name");
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
    if(amountController.text.isEmpty){
      showInSnackBar("Please enter Amount");
      return null;
    }
    if(decController.text.isEmpty){
      showInSnackBar("Please enter Description");
      return null;
    }

    _showLoaderDialog(context);

    final param = {
      "mobile_no": mobController.text,
      "name": nameController.text,
      "email": emailController.text,
      "amount": amountController.text,
      "description": decController.text,
      "send_sms": rememberMe.toString(),
      "m_business_id": storeID,

    };

    final response = await http.post(
      "http://157.230.228.250/merchant-create-payment-link-api/",
      body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(response.statusCode);
    CommonData data;
    var responseJson = json.decode(response.body);
    print(response.body);
    data = new CommonData.fromJson(jsonDecode(response.body));
    print(responseJson);
    Navigator.of(context, rootNavigator: true).pop();

    if (response.statusCode == 200) {
      print("Submit Successful");
      print(data.status);
      if(data.status == "success"){
        mobController.clear();
        nameController.clear();
        emailController.clear();
        amountController.clear();
        decController.clear();
        showInSnackBar("Link Created Successfully");
      } else showInSnackBar(data.status);
    } else {
      print(data.status);
      showInSnackBar(data.status);
      return null;
    }

  }

  Future<void> send(int id) async {

    _showLoaderDialog(context);

    final param = {
      "payment_link_id": id.toString(),
    };

    final response = await http.post(
      "http://157.230.228.250/merchant-payment-link-send-api/",
      body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(response.statusCode);
    CommonData data;
    var responseJson = json.decode(response.body);
    print(response.body);
    data = new CommonData.fromJson(jsonDecode(response.body));
    print(responseJson);

    if (response.statusCode == 200) {
      print("Send Successful");
      print(data.status);
      if(data.status == "success"){
        Navigator.of(context, rootNavigator: true).pop();
        showInSnackBar("Link Send Successfully");
      } else showInSnackBar(data.status);
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      print(data.status);
      showInSnackBar(data.status);
      return null;
    }

  }

  Future<void> delete(int id) async {

    _showLoaderDialog(context);

    final param = {
      "payment_link_id": id.toString(),
    };

    final response = await http.post(
      "http://157.230.228.250/merchant-payment-link-delete-api/",
      body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(response.statusCode);
    CommonData data;
    var responseJson = json.decode(response.body);
    print(response.body);
    data = new CommonData.fromJson(jsonDecode(response.body));
    print(responseJson);

    if (response.statusCode == 200) {
      print("delete Successful");
      print(data.status);
      if(data.status == "success"){
        Navigator.of(context, rootNavigator: true).pop();
        setState(() {

        });
        showInSnackBar("Receipt Deleted Successfully");
      } else showInSnackBar(data.status);
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      print(data.status);
      showInSnackBar(data.status);
      return null;
    }

  }

}
