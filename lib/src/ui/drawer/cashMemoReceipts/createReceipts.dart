import 'dart:convert';
import 'dart:io';
import 'package:greenbill_merchant/src/models/model_checkReceipt.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';

class CreateReceipts extends StatefulWidget {
  const CreateReceipts({Key key}) : super(key: key);

  @override
  _CreateReceiptsState createState() => _CreateReceiptsState();
}

class _CreateReceiptsState extends State<CreateReceipts> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController mobController = new TextEditingController();
  TextEditingController crfController = new TextEditingController();
  TextEditingController rsController = new TextEditingController();
  TextEditingController amtForController = new TextEditingController();
  TextEditingController totalController = new TextEditingController();
  TextEditingController gtController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();

  TextEditingController term1 = new TextEditingController();
  TextEditingController term2 = new TextEditingController();
  TextEditingController term3 = new TextEditingController();

  String dropdownValue = "Select Receipt Template";
  String template = "",
      templateID;
  String radioItem1;
  String val1 = "";
  String val2 = "";
  String val3 = "";

  String token, id, mob, storeID;

  @override
  void initState() {
    super.initState();
    getCredentials();
  }

  @override
  void dispose() {
    super.dispose();
    mobController.dispose();
    crfController.dispose();
    rsController.dispose();
    amtForController.dispose();
    totalController.dispose();
    gtController.dispose();
    dateController.dispose();
    term1.dispose();
    term2.dispose();
    term3.dispose();
  }

  getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      id = prefs.getInt("userID").toString();
      mob = prefs.getString("mobile");
      storeID = prefs.getString("businessID");
    });
    checkTemplate();
    dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
  }

  Future<void> _selectDate(BuildContext context) async {
    showDatePicker(
      context: context,

      initialDate: DateTime.now(),
      firstDate: DateTime(1950, 1),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Add Receipt'),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if(templateID =="") {
                saveReceiptTemplate();
              }else{}
              createTemplate();
            },
            child: Text("CREATE", style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(
                    top: 20.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: TextField(
                  controller: mobController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  maxLength: 10,
                  style: TextStyle(
                      fontFamily: "PoppinsLight",
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
                      borderRadius: const BorderRadius.all(
                          Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kPrimaryColorBlue,
                          width: 0.5),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      CupertinoIcons.phone,
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
                child: TextField(
                  controller: crfController,
                  maxLength: 25,
                  inputFormatters: [
                    new WhitelistingTextInputFormatter(RegExp("[a-z A-Z]")),
                  ],
                  style: TextStyle(
                      fontFamily: "PoppinsLight",
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
                      borderRadius: const BorderRadius.all(
                          Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kPrimaryColorBlue,
                          width: 0.5),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      CupertinoIcons.person,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Cash Received From *",
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
                child: TextField(
                  maxLength: 20,
                  controller: amtForController,
                  inputFormatters: [
                    new WhitelistingTextInputFormatter(RegExp("[a-z A-Z]")),
                  ],
                  style: TextStyle(
                      fontFamily: "PoppinsLight",
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
                      borderRadius: const BorderRadius.all(
                          Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kPrimaryColorBlue,
                          width: 0.5),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      CupertinoIcons.bubble_left,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Amount For *",
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
                child: TextField(
                  maxLength: 7,
                  controller: totalController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  style: TextStyle(
                      fontFamily: "PoppinsLight",
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
                      borderRadius: const BorderRadius.all(
                          Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kPrimaryColorBlue,
                          width: 0.5),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      CupertinoIcons.doc_append,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Total *",
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
                child: TextField(
                  controller: dateController,
                  enableInteractiveSelection: false,
                  // will disable paste operation
                  focusNode: new AlwaysDisabledFocusNode(),
                  onTap: () {
                    _selectDate(context);
                  },
                  style: TextStyle(
                      fontFamily: "PoppinsLight",
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
                      borderRadius: const BorderRadius.all(
                          Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kPrimaryColorBlue,
                          width: 0.5),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      CupertinoIcons.calendar,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Date *",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight",
                        fontSize: 13.0,
                        color: kPrimaryColorBlue),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                width: size.width,
                padding: EdgeInsets.only(left: 20.0),
                child: RichText(
                  text: TextSpan(
                      text: 'Payment Received in',
                      style: TextStyle(
                        fontFamily: "PoppinsLight",
                        fontSize: 13.0,
                        color: kPrimaryColorBlue,
                        fontWeight: FontWeight.bold,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: '*',
                          style: TextStyle(
                            color: kPrimaryColorBlue,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ]),
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(
                    top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: size.width * 0.45,
                      child: RadioListTile(
                        groupValue: radioItem1,
                        title: Text('Cash', style: TextStyle(
                            fontFamily: "PoppinsLight",
                            fontSize: 15.0,
                            color: kPrimaryColorBlue),),

                        value: 'cash',
                        onChanged: (val) {
                          setState(() {
                            radioItem1 = val;
                          });
                        },
                      ),
                    ),
                    Container(
                      width: size.width * 0.45,
                      child: RadioListTile(
                        groupValue: radioItem1,
                        title: Text('Cheque', style: TextStyle(
                            fontFamily: "PoppinsLight",
                            fontSize: 15.0,
                            color: kPrimaryColorBlue),),
                        value: 'Cheque',
                        onChanged: (val) {
                          setState(() {
                            radioItem1 = val;
                          });
                        },
                      ),
                    ),

                  ],
                ),

              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(
                    top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),

                child: RadioListTile(
                  groupValue: radioItem1,
                  title: Text('Other', style: TextStyle(
                      fontFamily: "PoppinsLight",
                      fontSize: 15.0,
                      color: kPrimaryColorBlue),),
                  value: 'other',
                  onChanged: (val) {
                    setState(() {
                      radioItem1 = val;
                    });
                  },
                ),
              ),

              if(templateID == "")
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(
                    top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: InputDecorator(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      CupertinoIcons.rectangle_dock,
                      color: kPrimaryColorBlue,
                    ),
                    labelText: "Receipt Template *",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight",
                        fontSize: 13.0,
                        color: kPrimaryColorBlue),
                    border: InputBorder.none,
                    counterStyle: TextStyle(
                      height: double.minPositive,
                    ),
                    counterText: "",
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: .0, horizontal: 5),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kPrimaryColorBlue,
                          width: 0.5),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kPrimaryColorBlue,
                          width: 0.5),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(35.0)),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: new DropdownButton<String>(
                      iconEnabledColor: Colors.black,
                      dropdownColor: Colors.white,
                      value: dropdownValue,
                      isExpanded: true,
                      style: TextStyle(
                          fontFamily: "PoppinsLight",
                          fontSize: 13.0,
                          color: kPrimaryColorBlue
                      ),
                      underline: Container(
                        height: 1,
                        width: 50,
                        color: Colors.black38,
                      ),
                      onChanged: (String newValue) {
                        var value = newValue
                            .split(" ")
                            .last;
                        String temp;

                        if (value == "1")
                          temp =
                          "http://157.230.228.250/media/receipt/receipt-template1.png";
                        else if (value == "2")
                          temp =
                          "http://157.230.228.250/media/receipt/receipt-template2.png";
                        else if (value == "3")
                          temp =
                          "http://157.230.228.250/media/receipt/receipt-template3.png";
                        else
                          temp = "";

                        setState(() {
                          dropdownValue = newValue;
                          template = temp;
                          templateID = value;
                        });
                      },
                      items: <String>[
                        'Select Receipt Template',
                        'Receipt Template 1',
                        'Receipt Template 2',
                        'Receipt Template 3',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                                fontSize: 17.0,
                                color: Colors.black
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              if(template.isNotEmpty)
                Container(
                  height: 200.0,
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                  child: Image.network(template),
                ),


              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(
                    top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: TextField(
                  maxLength: 28,
                  controller: term1,
                  inputFormatters: <TextInputFormatter>[
                  ],
                  style: TextStyle(
                      fontFamily: "PoppinsLight",
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
                      borderRadius: const BorderRadius.all(
                          Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kPrimaryColorBlue,
                          width: 0.5),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      CupertinoIcons.doc_richtext,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Terms and Conditions 1",
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
                child: TextField(
                  maxLength: 28,
                  controller: term2,
                  inputFormatters: <TextInputFormatter>[
                  ],
                  style: TextStyle(
                      fontFamily: "PoppinsLight",
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
                      borderRadius: const BorderRadius.all(
                          Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kPrimaryColorBlue,
                          width: 0.5),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      CupertinoIcons.doc_richtext,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Terms and Conditions 2",
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
                child: TextField(
                  maxLength: 28,
                  controller: term3,
                  inputFormatters: <TextInputFormatter>[
                  ],
                  style: TextStyle(
                      fontFamily: "PoppinsLight",
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
                      borderRadius: const BorderRadius.all(
                          Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kPrimaryColorBlue,
                          width: 0.5),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      CupertinoIcons.doc_richtext,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Terms and Conditions 3",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight",
                        fontSize: 13.0,
                        color: kPrimaryColorBlue),
                  ),
                ),
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
            fontSize: 16.0,
            fontFamily: "PoppinsMedium"),
      ),
      backgroundColor: kPrimaryColorBlue,
      duration: Duration(seconds: 2),
    ));
  }

  Future<void> saveReceiptTemplate() async {
    final param = {
      "user_id": id,
      "template_choice": templateID
    };
    final res = await http.post(
        "http://157.230.228.250/merchant-receipt-save-template/",
        body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"}
    );
    print(res.statusCode);
    CommonData data;
    var responseJson = json.decode(res.body);
    print(res.body);
    data = new CommonData.fromJson(jsonDecode(res.body));
    print(responseJson);
    // Navigator.of(context, rootNavigator: true).pop();
    if (res.statusCode == 200) {
      if (data.status == "success") {
        print("Send Successfullyyy");
        showInSnackBar(data.message);
        print(data.message);
      } else {
        print(data.status);
        showInSnackBar(data.message);
      }
    } else {
      print(data.status);
      showInSnackBar(data.message);
    }
  }

  createTemplate() async {
    if (mobController.text.length < 10) {
      showInSnackBar("Please enter Valid Mobile No.");
      return null;
    }
    if (mobController.text.isEmpty) {
      showInSnackBar("Please enter Mobile Number");
      return null;
    }
    if (crfController.text.isEmpty) {
      showInSnackBar("Please enter Cash Received From");
      return null;
    }

    if (amtForController.text.isEmpty) {
      showInSnackBar("Please enter Amount For");
      return null;
    }
    if (totalController.text.isEmpty) {
      showInSnackBar("Please enter Total");
      return null;
    }
    if(double.parse(totalController.text) > 50000.00){
      showInSnackBar("Amount Must be less than 50000");
      return null;
    }
    if(double.parse(totalController.text) == 0.00){
      showInSnackBar("Amount should not be 0");
      return null;
    }

    if (dateController.text.isEmpty) {
      showInSnackBar("Please Select Date");
      return null;
    }
    // if(dropdownValue == "Select Receipt Template"){
    //   showInSnackBar("Please Select Receipt Template");
    //   return null;
    // }

    if (radioItem1.contains("cash")) {
      setState(() {
        val1 = 'cash';
      });
    } else if (radioItem1.contains('Cheque')) {
      setState(() {
        val2 = 'Cheque';
      });
    } else if (radioItem1.contains("other")) {
      setState(() {
        val3 = 'Cheque';
      });
    }


    print(val1);
    print(val2);
    print(val3);


    _showLoaderDialog(context);

    final param = {
      "user_id": id,
      "m_business_id": storeID,
      "mobile_no": mobController.text,
      "cash_received_from": crfController.text,
      "amount_for": amtForController.text,
      "date": dateController.text,
      "cash": val1,
      "cheque": val2,
      "other": val3,
      "term_and_condition1": term1.text,
      "term_and_condition2": term2.text,
      "term_and_condition3": term3.text,
      "total": totalController.text,
    };

    final response = await http.post(
      "http://157.230.228.250/merchant-create-receipt-api/",
      body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"},
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
        Navigator.pop(context, true);
      } else
        showInSnackBar(data.status);
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      print(data.status);
      showInSnackBar(data.status);
      return null;
    }
  }

  Future<List<Datum3>> checkTemplate() async {
    final param = {
      "user_id": id,
    };

    final response = await http.post(
        "http://157.230.228.250/receipt-template-existornot/",
        body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"}
    );
    print(response.statusCode);

    if (200 == response.statusCode) {
      print(checkReceiptFromJson(response.body).data.length);
      print(">>>>>>>>>>>>>${checkReceiptFromJson(response.body).data[0]
          .templateNo}");
      setState(() {
        templateID = checkReceiptFromJson(response.body).data[0].templateNo;
        term1.text = checkReceiptFromJson(response.body).data[0].term1;
        term2.text = checkReceiptFromJson(response.body).data[0].term2;
        term3.text = checkReceiptFromJson(response.body).data[0].term3;
      });
      return checkReceiptFromJson(response.body).data;
    } else {
      throw Exception('Failed to load List');
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
