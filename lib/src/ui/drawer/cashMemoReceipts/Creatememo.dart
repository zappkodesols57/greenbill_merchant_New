import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_checkMeMo.dart';
import 'package:greenbill_merchant/src/models/model_stamp.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateMemo extends StatefulWidget {
  const CreateMemo({Key key}) : super(key: key);

  @override
  _CreateReceiptsState createState() => _CreateReceiptsState();
}

class _CreateReceiptsState extends State<CreateMemo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final ScrollController _controller = ScrollController();

  TextEditingController mobController = new TextEditingController();
  TextEditingController crfController = new TextEditingController();
  TextEditingController rsController = new TextEditingController();
  TextEditingController amtForController = new TextEditingController();
  TextEditingController totalController = new TextEditingController();
  TextEditingController gtController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();
  TextEditingController stampController = new TextEditingController();
  TextEditingController totalInWordController = new TextEditingController();
  TextEditingController quantityController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController newDisc = new TextEditingController();
  TextEditingController newRate = new TextEditingController();
  TextEditingController newAmount = new TextEditingController();
  TextEditingController newQuantity = new TextEditingController();
  TextEditingController newDisc2 = new TextEditingController();
  TextEditingController newRate2 = new TextEditingController();
  TextEditingController newQuantity2 = new TextEditingController();
  TextEditingController newDisc3 = new TextEditingController();
  TextEditingController newRate3 = new TextEditingController();
  TextEditingController newQuantity3 = new TextEditingController();
  TextEditingController term1 = new TextEditingController();
  TextEditingController term2 = new TextEditingController();
  TextEditingController term3 = new TextEditingController();

  String dropdownValue = "Select Cash Memo Template";
  String template = "",
      templateID;
  String token, id, mob, storeID;
  bool showButton = false;
  //bool showButton=false;

  bool removeButton1 = false;
  bool removeButton2 = false;
  bool removeButton3 = false;
  bool removeButton4 = false;
  bool showButton2 = false;
  bool showButton3 = false;
  bool showButton4 = false;
  bool addItem1 = false;
  bool addItem2 = false;
  bool addItem3 = false;
  bool addItem4 = false;

  List<String> discAll = [];
  List<String> rateAll = [];
  List<String> quanAll = [];

  String radioItem,stampId,stamptype,stamptype2,stampId2;

  bool custom=false;

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
    stampController.dispose();
    dateController.dispose();
    newDisc.dispose();
    newRate.dispose();
    newAmount.dispose();
    newQuantity.dispose();
    totalInWordController.dispose();
    quantityController.dispose();
    addressController.dispose();
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
    getStampLists();
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
        title: Text('Add Cash Memo'),
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
              if(templateID == "" ||templateID == "0") {
                saveTemplate();
              }else{}
              createTemplate();
            },
            child: Text("CREATE", style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _controller,
        child: Center(
          child: Column(
            children: [
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(
                    top: 20.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: TextField(
                  controller: crfController,
                  inputFormatters: [
                    new WhitelistingTextInputFormatter(RegExp("[a-z A-Z]")),
                  ],
                  maxLength: 25,
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
                child: TextField(
                  controller: addressController,
                  keyboardType: TextInputType.text,
                  maxLength: 20,

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
                      CupertinoIcons.map_pin,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Address ",
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

              Container(
                width: size.width,
                padding: EdgeInsets.only(
                    top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Container(
                      padding: EdgeInsets.only(
                          top: 0.0, bottom: 10.0, left: 10.0, right: 10.0),
                      width: size.width,
                      child: TextField(
                        maxLength: 15,
                        controller: amtForController,
                        inputFormatters: [
                          new WhitelistingTextInputFormatter(RegExp(
                              "[a-z A-Z]")),
                        ],
                        style: TextStyle(
                            fontFamily: "PoppinsLight",
                            fontSize: 17.0,
                            color: Colors.black87),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterStyle: TextStyle(height: double.minPositive,),
                          counterText: "",
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0.0),
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
                          labelText: "Description Of Item*",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight",
                              fontSize: 13.0,
                              color: kPrimaryColorBlue),
                        ),
                      ),
                    ),
                    Container(

                      width: size.width,
                      padding: EdgeInsets.only(
                          top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(
                                top: 0.0, bottom: 0.0, left: 10.0, right: 10.0),
                            width: size.width * 0.5,
                            child: TextField(
                              maxLength: 10,
                              controller: totalController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: <TextInputFormatter>[
                                LengthLimitingTextInputFormatter(8),
                                FilteringTextInputFormatter.allow( RegExp(r'^(\d+)?\.?\d{0,2}'))
                              ],
                              style: TextStyle(
                                  fontFamily: "PoppinsLight",
                                  fontSize: 17.0,
                                  color: Colors.black87),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                counterStyle: TextStyle(
                                  height: double.minPositive,),
                                counterText: "",
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0.0),
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
                                labelText: "Rate *",
                                labelStyle: TextStyle(
                                    fontFamily: "PoppinsLight",
                                    fontSize: 13.0,
                                    color: kPrimaryColorBlue),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(
                                top: 0.0, bottom: 0.0, left: 10.0, right: 10.0),
                            width: size.width * 0.5,
                            child: TextField(
                              controller: quantityController,
                              keyboardType: TextInputType.phone,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              maxLength: 7,
                              style: TextStyle(
                                  fontFamily: "PoppinsLight",
                                  fontSize: 17.0,
                                  color: Colors.black87),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                counterStyle: TextStyle(
                                  height: double.minPositive,),
                                counterText: "",
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0.0),
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
                                  Icons.show_chart_sharp,
                                  color: kPrimaryColorBlue,
                                  size: 23.0,
                                ),
                                labelText: "Quantity*",
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


                  ],
                ),

              ),

              if(!showButton)

                Container(
                  height: 50.0,
                  width: size.width,
                  margin: EdgeInsets.only(
                      top: 0.0, bottom: 0.0, left: 0.0, right: 10.0),
                  alignment: Alignment.bottomRight,


                  child: ElevatedButton(
                    child: Text(
                      "Add Item",
                      style: TextStyle(
                          fontFamily: "PoppinsMedium",
                          fontWeight: FontWeight.bold,
                          color: addItem1 ? Colors.black : Colors.white
                      ),


                    ),
                    style: ElevatedButton.styleFrom(
                        elevation: addItem1 ? 0.0 : 3.0,
                        primary: addItem1
                            ? Colors.grey[300]
                            : kPrimaryColorBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(90)))),

                    onPressed: () {
                      setState(() {
                        addItem1 = true;
                        removeButton1 = true;
                        showButton = true;
                      });
                    },

                  ),
                ),
              if(removeButton1)

                Container(
                  height: 50.0,
                  width: size.width,
                  margin: EdgeInsets.only(
                      top: 0.0, bottom: 0.0, left: 0.0, right: 10.0),
                  alignment: Alignment.bottomRight,

                  child: ElevatedButton(

                    child: Text(
                      "Remove Item",

                      style: TextStyle(
                          fontFamily: "PoppinsMedium",
                          fontWeight: FontWeight.bold,
                          color: addItem1 ? Colors.black : Colors.white
                      ),


                    ),
                    style: ElevatedButton.styleFrom(
                        elevation: addItem1 ? 0.0 : 3.0,
                        primary: addItem1
                            ? Colors.grey[300]
                            : kPrimaryColorBlue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(90)))),

                    onPressed: () {
                      setState(() {
                        removeButton1 = false;
                        showButton = false;
                        addItem1 = false;
                        newDisc.clear();
                        newRate.clear();
                        newQuantity.clear();
                      });
                    },

                  ),
                ),

              if(addItem1)
                Container(
                  width: size.width,
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Container(
                        padding: EdgeInsets.only(
                            top: 0.0, bottom: 10.0, left: 10.0, right: 10.0),
                        width: size.width,
                        child: TextField(
                          maxLength: 15,
                          controller: newDisc,
                          inputFormatters: [
                            new WhitelistingTextInputFormatter(
                              RegExp("[a-z A-Z]")),
                          ],
                          style: TextStyle(
                              fontFamily: "PoppinsLight",
                              fontSize: 17.0,
                              color: Colors.black87),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            counterStyle: TextStyle(
                              height: double.minPositive,),
                            counterText: "",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0.0),
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
                            labelText: "Description Of Item*",
                            labelStyle: TextStyle(
                                fontFamily: "PoppinsLight",
                                fontSize: 13.0,
                                color: kPrimaryColorBlue),
                          ),
                        ),
                      ),
                      Container(
                        width: size.width,
                        padding: EdgeInsets.only(
                            top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 0.0,
                                  bottom: 0.0,
                                  left: 10.0,
                                  right: 10.0),
                              width: size.width * 0.5,
                              child: TextField(
                                maxLength: 7,
                                controller: newRate,
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
                                  counterStyle: TextStyle(
                                    height: double.minPositive,),
                                  counterText: "",
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0.0),
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
                                  labelText: "Rate *",
                                  labelStyle: TextStyle(
                                      fontFamily: "PoppinsLight",
                                      fontSize: 13.0,
                                      color: kPrimaryColorBlue),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 0.0,
                                  bottom: 0.0,
                                  left: 10.0,
                                  right: 10.0),
                              width: size.width * 0.5,
                              child: TextField(
                                controller: newQuantity,
                                keyboardType: TextInputType.phone,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                maxLength: 7,
                                style: TextStyle(
                                    fontFamily: "PoppinsLight",
                                    fontSize: 17.0,
                                    color: Colors.black87),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  counterStyle: TextStyle(
                                    height: double.minPositive,),
                                  counterText: "",
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0.0),
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
                                    Icons.show_chart_sharp,
                                    color: kPrimaryColorBlue,
                                    size: 23.0,
                                  ),
                                  labelText: "Quantity*",
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

                      if(!showButton2)
                        Container(
                          height: 50.0,
                          width: size.width,
                          margin: EdgeInsets.only(
                              top: 0.0, bottom: 0.0, left: 0.0, right: 10.0),
                          alignment: Alignment.bottomRight,

                          child: ElevatedButton(
                            child: Text(
                              "Add Item",
                              style: TextStyle(
                                  fontFamily: "PoppinsMedium",
                                  fontWeight: FontWeight.bold,
                                  color: addItem2 ? Colors.black : Colors.white
                              ),


                            ),
                            style: ElevatedButton.styleFrom(
                                elevation: addItem2 ? 0.0 : 3.0,
                                primary: addItem2
                                    ? Colors.grey[300]
                                    : kPrimaryColorBlue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(90)))),

                            onPressed: () {
                              setState(() {
                                showButton2 = true;
                                addItem2 = true;
                                removeButton2 = true;
                              });
                            },

                          ),
                        ),

                      if(removeButton2)
                        Container(
                          height: 50.0,
                          width: size.width,
                          margin: EdgeInsets.only(
                              top: 0.0, bottom: 0.0, left: 0.0, right: 10.0),
                          alignment: Alignment.bottomRight,


                          child: ElevatedButton(

                            child: Text(
                              "Remove Item",
                              style: TextStyle(
                                  fontFamily: "PoppinsMedium",
                                  fontWeight: FontWeight.bold,
                                  color: addItem1 ? Colors.black : Colors.white
                              ),


                            ),
                            style: ElevatedButton.styleFrom(
                                elevation: addItem2 ? 0.0 : 3.0,
                                primary: addItem2
                                    ? Colors.grey[300]
                                    : kPrimaryColorBlue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(90)))),

                            onPressed: () {
                              setState(() {
                                removeButton2 = false;
                                showButton2 = false;
                                addItem2 = false;
                                newDisc2.clear();
                                newRate2.clear();
                                newQuantity2.clear();
                              });
                            },

                          ),
                        ),
                    ],
                  ),
                ),

              if(addItem2)

                Container(
                  width: size.width,
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Container(
                        padding: EdgeInsets.only(
                            top: 0.0, bottom: 10.0, left: 10.0, right: 10.0),
                        width: size.width,
                        child: TextField(
                          maxLength: 15,
                          controller: newDisc2,
                          inputFormatters: [new WhitelistingTextInputFormatter(
                              RegExp("[a-z A-Z]")),
                          ],
                          style: TextStyle(
                              fontFamily: "PoppinsLight",
                              fontSize: 17.0,
                              color: Colors.black87),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            counterStyle: TextStyle(
                              height: double.minPositive,),
                            counterText: "",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0.0),
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
                            labelText: "Description Of Item*",
                            labelStyle: TextStyle(
                                fontFamily: "PoppinsLight",
                                fontSize: 13.0,
                                color: kPrimaryColorBlue),
                          ),
                        ),
                      ),
                      Container(

                        width: size.width,
                        padding: EdgeInsets.only(
                            top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 0.0,
                                  bottom: 0.0,
                                  left: 10.0,
                                  right: 10.0),
                              width: size.width * 0.5,
                              child: TextField(
                                maxLength: 10,
                                controller: newRate2,
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
                                  counterStyle: TextStyle(
                                    height: double.minPositive,),
                                  counterText: "",
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0.0),
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
                                  labelText: "Rate *",
                                  labelStyle: TextStyle(
                                      fontFamily: "PoppinsLight",
                                      fontSize: 13.0,
                                      color: kPrimaryColorBlue),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 0.0,
                                  bottom: 0.0,
                                  left: 10.0,
                                  right: 10.0),
                              width: size.width * 0.5,
                              child: TextField(
                                controller: newQuantity2,
                                keyboardType: TextInputType.phone,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                maxLength: 7,
                                style: TextStyle(
                                    fontFamily: "PoppinsLight",
                                    fontSize: 17.0,
                                    color: Colors.black87),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  counterStyle: TextStyle(
                                    height: double.minPositive,),
                                  counterText: "",
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0.0),
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
                                    Icons.show_chart_sharp,
                                    color: kPrimaryColorBlue,
                                    size: 23.0,
                                  ),
                                  labelText: "Quantity*",
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

                      if(!showButton3)
                        Container(
                          height: 50.0,
                          width: size.width,
                          margin: EdgeInsets.only(
                              top: 0.0, bottom: 0.0, left: 0.0, right: 10.0),
                          alignment: Alignment.bottomRight,


                          child: ElevatedButton(
                            child: Text(
                              "Add Item",
                              style: TextStyle(
                                  fontFamily: "PoppinsMedium",
                                  fontWeight: FontWeight.bold,
                                  color: addItem3 ? Colors.black : Colors.white
                              ),


                            ),
                            style: ElevatedButton.styleFrom(
                                elevation: addItem3 ? 0.0 : 3.0,
                                primary: addItem3
                                    ? Colors.grey[300]
                                    : kPrimaryColorBlue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(90)))),

                            onPressed: () {
                              setState(() {
                                showButton3 = true;
                                addItem3 = true;
                                removeButton3 = true;
                              });
                            },

                          ),
                        ),

                      if(removeButton3)
                        Container(
                          height: 50.0,
                          width: size.width,
                          margin: EdgeInsets.only(
                              top: 0.0, bottom: 0.0, left: 0.0, right: 10.0),
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(

                            child: Text(
                              "Remove Item",
                              style: TextStyle(
                                  fontFamily: "PoppinsMedium",
                                  fontWeight: FontWeight.bold,
                                  color: addItem2 ? Colors.black : Colors.white
                              ),


                            ),
                            style: ElevatedButton.styleFrom(
                                elevation: addItem2 ? 0.0 : 3.0,
                                primary: addItem2
                                    ? Colors.grey[300]
                                    : kPrimaryColorBlue,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(90)))),

                            onPressed: () {
                              setState(() {
                                removeButton3 = false;
                                showButton3 = false;
                                addItem3 = false;
                                newDisc3.clear();
                                newRate3.clear();
                                newQuantity3.clear();
                              });
                            },

                          ),
                        ),
                    ],
                  ),


                ),

              if(addItem3)

                Container(
                  width: size.width,
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[

                      Container(
                        padding: EdgeInsets.only(
                            top: 0.0, bottom: 10.0, left: 10.0, right: 10.0),
                        width: size.width,
                        child: TextField(
                          maxLength: 15,
                          controller: newDisc3,
                          inputFormatters: [new WhitelistingTextInputFormatter(
                              RegExp("[a-z A-Z]")),
                          ],
                          style: TextStyle(
                              fontFamily: "PoppinsLight",
                              fontSize: 17.0,
                              color: Colors.black87),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            counterStyle: TextStyle(
                              height: double.minPositive,),
                            counterText: "",
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 0.0),
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
                            labelText: "Description Of Item*",
                            labelStyle: TextStyle(
                                fontFamily: "PoppinsLight",
                                fontSize: 13.0,
                                color: kPrimaryColorBlue),
                          ),
                        ),
                      ),
                      Container(

                        width: size.width,
                        padding: EdgeInsets.only(
                            top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(top: 0.0,
                                  bottom: 0.0,
                                  left: 10.0,
                                  right: 10.0),
                              width: size.width * 0.5,
                              child: TextField(
                                maxLength: 10,
                                controller: newRate3,
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
                                  counterStyle: TextStyle(
                                    height: double.minPositive,),
                                  counterText: "",
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0.0),
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
                                  labelText: "Rate *",
                                  labelStyle: TextStyle(
                                      fontFamily: "PoppinsLight",
                                      fontSize: 13.0,
                                      color: kPrimaryColorBlue),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 0.0,
                                  bottom: 0.0,
                                  left: 10.0,
                                  right: 10.0),
                              width: size.width * 0.5,
                              child: TextField(
                                controller: newQuantity3,
                                keyboardType: TextInputType.phone,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                maxLength: 7,
                                style: TextStyle(
                                    fontFamily: "PoppinsLight",
                                    fontSize: 17.0,
                                    color: Colors.black87),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  counterStyle: TextStyle(
                                    height: double.minPositive,),
                                  counterText: "",
                                  contentPadding: const EdgeInsets.symmetric(
                                      vertical: 0.0),
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
                                    Icons.show_chart_sharp,
                                    color: kPrimaryColorBlue,
                                    size: 23.0,
                                  ),
                                  labelText: "Quantity*",
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
                    ],
                  ),
                ),

              if(templateID == "" || templateID == "0")
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
                      labelText: "Cash Memo Template",
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
                            "http://157.230.228.250/media/cash-memo/cashmemo-template1.png";
                          else if (value == "2")
                            temp =
                            "http://157.230.228.250/media/cash-memo/cashmemo-template2.png";
                          else if (value == "3")
                            temp =
                            "http://157.230.228.250/media/cash-memo/cashmemo-template3.png";
                          else
                            temp = "";

                          setState(() {
                            dropdownValue = newValue;
                            template = temp;
                            templateID = value;
                          });
                        },
                        items: <String>[
                          'Select Cash Memo Template',
                          'Cash Memo Template 1',
                          'Cash Memo Template 2',
                          'Cash Memo Template 3',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                  fontSize: 16.0,
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

              Container(
                width: size.width,
                padding: EdgeInsets.only(left: 20.0),
                child: RichText(
                  text: TextSpan(
                      text: 'Stamp Type',
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
                    top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: size.width * 0.50,
                      alignment: Alignment.centerLeft,
                      child: RadioListTile(
                        dense: true,
                        groupValue: radioItem,
                        title: Text('Default Stamps',style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 13.0, color: kPrimaryColorBlue),),

                        value: 'Default Stamps',
                        onChanged: (val) {
                          setState(() {
                            radioItem = val;
                            custom=true;
                            _controller.jumpTo(_controller.position.maxScrollExtent);
                          });
                        },
                      ),
                    ),

                    Container(
                      width: size.width * 0.45,
                      alignment: Alignment.centerLeft,

                      child:RadioListTile(
                        dense: true,
                        groupValue: radioItem,
                        title: Text('Own Stamp',style: TextStyle(
                            fontWeight: FontWeight.normal, fontSize: 13.0, color: kPrimaryColorBlue),),
                        value: 'Own Stamps',
                        onChanged: (val) {
                          setState(() {
                            custom=false;
                            radioItem = val;
                            stampId = null;
                            stamptype = null;
                            print("$stamptype  $stampId  $stampId2 $stamptype2");
                            getStampLists();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              if(custom == true)
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(
                    top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: new TextField(
                  onTap: (){
                    stampDialog(context);
                  },
                  enableInteractiveSelection: false, // will disable paste operation
                  focusNode: new AlwaysDisabledFocusNode(),
                  controller: stampController,
                  style: TextStyle(
                      fontFamily: "PoppinsLight",
                      fontSize: 17.0,
                      color: kPrimaryColorBlue),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterStyle: TextStyle(height: double.minPositive,),
                    counterText: "",
                    contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      FontAwesomeIcons.stamp,
                      color: kPrimaryColorBlue,
                      size: 20.0,
                    ),
                    labelText: "Select Stamp *",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0,color: kPrimaryColorBlue),
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
            ],
          ),
        ),
      ),
    );
  }

  stampDialog(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Select Stamp',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w800,
                  fontSize: 15.0,
                  fontFamily: "PoppinsMedium"
              ),
            ),
            content: stampDialoagContainer(),
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


  Widget stampDialoagContainer() {
    return Container(
      height: 230.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: FutureBuilder<Stamp>(
        future: getStampLists(),
        builder: (BuildContext context, AsyncSnapshot<Stamp> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),
                  )),
            );
          else if (snapshot.hasError) {
            return Center(
              child: Text("No Stamps Found"),
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
                      itemCount: snapshot.data.data1.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            snapshot.data.data1[index].stampName,
                            style: TextStyle(fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: CircleAvatar(
                            foregroundColor: Colors.white,
                            backgroundColor: kPrimaryColorBlue,
                            child: Text(
                              snapshot.data.data1[index].stampName.substring(0,1).toUpperCase(),
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

                            stampController.text = snapshot.data.data1[index].stampName;
                            setState(() {
                              stampId = snapshot.data.data1[index].stampId.toString();
                              stamptype = snapshot.data.data1[index].type.toString();
                            });
                            Navigator.of(context).pop();
                          },
                        );
                      }
                  )
              );
            } else {
              return Center(child: Text("No Headers Found"),);
            }
          }

        },
      ),
    );
  }


  Future<Stamp> getStampLists() async {

    final param = {
      "business_id": storeID,
    };

    print(">>>>>>>>>$id\n$storeID");

    final res = await http.post(
      Uri.parse("http://157.230.228.250/get-stamp-data-api/"),
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(res.body);
    if(200 == res.statusCode){
      print(stampFromJson(res.body).data1.length);
      print(stampFromJson(res.body).data2.length);
      setState(() {
        stamptype2 = stampFromJson(res.body).data2[0].type2;
        stampId2 = stampFromJson(res.body).data2[0].stamp2Id.toString();
      });
      print("_____$stamptype2 _____ $stampId2 ________${stampFromJson(res.body).data2}");
      return stampFromJson(res.body);
    } else{
      throw Exception('Failed to load Stamps List');
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
      showInSnackBar("Please enter Name");
      return null;
    }
    // if (addressController.text.isEmpty) {
    //   showInSnackBar("Please enter Customer Address");
    //   return null;
    // }

    if (dateController.text.isEmpty) {
      showInSnackBar("Please Select Date");
      return null;
    }


    if (amtForController.text.isNotEmpty) {
      discAll.add(amtForController.text.toString());
    }

    if (newDisc.text.isNotEmpty) {
      discAll.add(newDisc.text.toString());
    }

    if (newDisc2.text.isNotEmpty) {
      discAll.add(newDisc2.text.toString());
    }
    if (newDisc3.text.isNotEmpty) {
      discAll.add(newDisc3.text.toString());
    }
    print(discAll);


    if (totalController.text.isNotEmpty) {
      rateAll.add(totalController.text.toString());
    }
    if (newRate.text.isNotEmpty) {
      rateAll.add(newRate.text.toString());
    }
    // if(double.parse(newRate.text) > 50000.00){
    //   showInSnackBar("Rate Must be less than 50000");
    //   return null;
    // }
    // if(double.parse(newRate.text) == 0.00){
    //   showInSnackBar("Rate should not be 0");
    //   return null;
    // }
    if (newRate2.text.isNotEmpty) {
      rateAll.add(newRate2.text.toString());
    }
    // if(double.parse(newRate2.text) > 50000.00){
    //   showInSnackBar("Rate Must be less than 50000");
    //   return null;
    // }
    // if(double.parse(newRate2.text) == 0.00){
    //   showInSnackBar("Rate should not be 0");
    //   return null;
    // }
    if (newRate3.text.isNotEmpty) {
      rateAll.add(newRate3.text.toString());
    }


    if (quantityController.text.isNotEmpty) {
      quanAll.add(quantityController.text.toString());
    }

    if (newQuantity.text.isNotEmpty) {
      quanAll.add(newQuantity.text.toString());
    }
    if (newQuantity2.text.isNotEmpty) {
      quanAll.add(newQuantity2.text.toString());
    }
    if (newQuantity3.text.isNotEmpty) {
      quanAll.add(newQuantity3.text.toString());
    }

    if(radioItem == null){
      showInSnackBar("Please Select Stamp Type");
      return null;
    }

    if(radioItem == "Default Stamps"){
      if(stampController.text.isEmpty){
        showInSnackBar("Please Select Stamp");
        return null;
      }
    }

    if (discAll.isEmpty) {
      showInSnackBar("Please Enter Item Description");
      return null;
    }
    if (rateAll.isEmpty) {
      showInSnackBar("Please Enter Item Rate");
      return null;
    }
    if (quanAll.isEmpty) {
      showInSnackBar("Please Enter Item Quantity");
      return null;
    }

    print(quanAll);

    _showLoaderDialog(context);

    print(id);
    print(storeID);
    print(crfController.text);
    print(addressController.text);
    print(mobController.text);
    print(rsController.text);
    print(totalInWordController.text);
    print(dateController.text);
    print(amtForController.text);
    print(quantityController.text);
    print(totalController.text);
    print(gtController.text);
    print(id);

    final param = {
      "user_id": id,
      "m_business_id": storeID,
      "name": crfController.text,
      "address": addressController.text,
      "mobile_number": mobController.text,
      "date": dateController.text,
      // "selected_template":  templateID,
      "description": (discAll.isEmpty) ? "" : discAll.reduce((value,
          element) => value + ',' + element),
      "quantity": (quanAll.isEmpty) ? "" : quanAll.reduce((value,
          element) => value + ',' + element),
      "rate": (rateAll.isEmpty) ? "" : rateAll.reduce((value,
          element) => value + ',' + element),
      "term_and_condition1": term1.text,
      "term_and_condition2": term2.text,
      "term_and_condition3": term3.text,
      "stamp_id": stampId == null ? stampId2 : stampId,
      "stamp_type": custom == true ? "1" : "2",
    };

    print(param);

    final response = await http.post(
      "http://157.230.228.250/merchant-create-cash-memo-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );
    print(response.statusCode);

    var responseJson = json.decode(response.body);
    print(response.body);

    print(responseJson);

    print(response.statusCode);

    var responseJs = json.decode(response.body);
    print(response.body);

    print(responseJs);
    CommonData data;
    data = new CommonData.fromJson(jsonDecode(response.body));

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

  Future<void> saveTemplate() async {
    final param = {
      "user_id": id,
      "selected_template": templateID
    };
    final res = await http.post(
        "http://157.230.228.250/merchant-cash-memo-save-template/",
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


  Future<List<Datumm2>> checkTemplate() async {
    final param = {
      "user_id": id,
    };

    final response = await http.post(
        "http://157.230.228.250/cash-memo-template-existornot/",
        body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"}
    );
    print(response.statusCode);

    if (200 == response.statusCode) {
      print(checkMemoFromJson(response.body).data.length);
      print(">>>>>>>>>>>>>${checkMemoFromJson(response.body).data[0].templateNo}");
      setState(() {
        templateID = checkMemoFromJson(response.body).data[0].templateNo;
        term1.text = checkMemoFromJson(response.body).data[0].term1;
        term2.text = checkMemoFromJson(response.body).data[0].term2;
        term3.text = checkMemoFromJson(response.body).data[0].term3;
      });
      return checkMemoFromJson(response.body).data;
    } else {
      throw Exception('Failed to load List');
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}