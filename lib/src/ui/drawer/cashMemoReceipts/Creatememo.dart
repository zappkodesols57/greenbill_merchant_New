import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/constants.dart';
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

  TextEditingController mobController = new TextEditingController();
  TextEditingController crfController = new TextEditingController();
  TextEditingController rsController = new TextEditingController();
  TextEditingController amtForController = new TextEditingController();
  TextEditingController totalController = new TextEditingController();
  TextEditingController gtController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();
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
  String template = "", templateID;
  String token, id, mob, storeID;

  bool showButton=false;
  //bool showButton=false;

  bool removeButton1=false;
  bool removeButton2=false;
  bool removeButton3=false;
  bool removeButton4=false;
  bool showButton2=false;
  bool showButton3=false;
  bool showButton4=false;
  bool addItem1=false;
  bool addItem2=false;
  bool addItem3=false;
  bool addItem4=false;

  List<String> discAll = [];
  List<String> rateAll = [];
  List<String> quanAll = [];




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
  }

  Future<void> _selectDate(BuildContext context) async {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      dateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Add Cash Memo'),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {Navigator.pop(context, false);},
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
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
                padding: EdgeInsets.only(top: 20.0, bottom: 10.0, left: 0.0, right: 0.0),
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
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kPrimaryColorBlue,
                          width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      CupertinoIcons.phone,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Mobile No. *",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: TextField(
                  controller: crfController,
                  inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[a-z A-Z]")),],
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
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kPrimaryColorBlue,
                          width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      CupertinoIcons.person,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Cash Received From *",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
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
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kPrimaryColorBlue,
                          width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      CupertinoIcons.map_pin,
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
                child: TextField(
                  controller: dateController,
                  enableInteractiveSelection: false, // will disable paste operation
                  focusNode: new AlwaysDisabledFocusNode(),
                  onTap: (){
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
                    labelText: "Date *",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
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
                          padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 10.0, right: 10.0),
                          width: size.width,
                          child: TextField(
                            maxLength: 15,
                            controller: amtForController,
                            inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[a-z A-Z]")),],
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
                                borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                              ),
                              focusedBorder: new OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: kPrimaryColorBlue,
                                    width: 0.5),
                                borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                              ),
                              prefixIcon: Icon(
                                CupertinoIcons.bubble_left,
                                color: kPrimaryColorBlue,
                                size: 23.0,
                              ),
                              labelText: "Description Of Item*",
                              labelStyle: TextStyle(
                                  fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
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
                                padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 10.0, right: 10.0),
                                width: size.width * 0.5,
                                child: TextField(
                                  maxLength: 10,
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
                                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                                    ),
                                    focusedBorder: new OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: kPrimaryColorBlue,
                                          width: 0.5),
                                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                                    ),
                                    prefixIcon: Icon(
                                      CupertinoIcons.doc_append,
                                      color: kPrimaryColorBlue,
                                      size: 23.0,
                                    ),
                                    labelText: "Rate *",
                                    labelStyle: TextStyle(
                                        fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 10.0, right: 10.0),
                                width: size.width * 0.5,
                                child: TextField(
                                  controller: quantityController,
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
                                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                                    ),
                                    focusedBorder: new OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: kPrimaryColorBlue,
                                          width: 0.5),
                                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.show_chart_sharp,
                                      color: kPrimaryColorBlue,
                                      size: 23.0,
                                    ),
                                    labelText: "Quantity*",
                                    labelStyle: TextStyle(
                                        fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
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
                width: size.width ,
                margin: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 10.0),
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
                      primary: addItem1 ? Colors.grey[300] : kPrimaryColorBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(90)))),

                  onPressed: () {
                    setState(() {
                      addItem1 = true;
                      removeButton1=true;
                      showButton=true;
                    });
                  },

                ),
              ),
              if(removeButton1)

              Container(
                height: 50.0,
                width: size.width ,
                margin: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 10.0),
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
                      primary: addItem1 ? Colors.grey[300] : kPrimaryColorBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(90)))),

                  onPressed: () {
                    setState(() {
                      removeButton1=false;
                      showButton=false;
                      addItem1 = false;
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
                        padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 10.0, right: 10.0),
                        width: size.width,
                        child: TextField(
                          maxLength: 15,
                          controller: newDisc,
                          inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[a-z A-Z]")),],
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
                              borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                            ),
                            focusedBorder: new OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: kPrimaryColorBlue,
                                  width: 0.5),
                              borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                            ),
                            prefixIcon: Icon(
                              CupertinoIcons.bubble_left,
                              color: kPrimaryColorBlue,
                              size: 23.0,
                            ),
                            labelText: "Description Of Item*",
                            labelStyle: TextStyle(
                                fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
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
                              padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 10.0, right: 10.0),
                              width: size.width * 0.5,
                              child: TextField(
                                maxLength: 10,
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
                                    CupertinoIcons.doc_append,
                                    color: kPrimaryColorBlue,
                                    size: 23.0,
                                  ),
                                  labelText: "Rate *",
                                  labelStyle: TextStyle(
                                      fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 10.0, right: 10.0),
                              width: size.width * 0.5,
                              child: TextField(
                                controller: newQuantity,
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
                                    borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                                  ),
                                  focusedBorder: new OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kPrimaryColorBlue,
                                        width: 0.5),
                                    borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.show_chart_sharp,
                                    color: kPrimaryColorBlue,
                                    size: 23.0,
                                  ),
                                  labelText: "Quantity*",
                                  labelStyle: TextStyle(
                                      fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                                ),
                              ),
                            ),
                          ],
                        ),

                      ),

                      if(!showButton2)
                      Container(
                        height: 50.0,
                        width: size.width ,
                        margin: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 10.0),
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
                              primary: addItem2 ? Colors.grey[300] : kPrimaryColorBlue,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(90)))),

                          onPressed: () {
                            setState(() {
                              showButton2=true;
                              addItem2 = true;
                              removeButton2=true;
                            });
                          },

                        ),
                      ),

                      if(removeButton2)
                        Container(
                          height: 50.0,
                          width: size.width ,
                          margin: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 10.0),
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
                                primary: addItem2 ? Colors.grey[300] : kPrimaryColorBlue,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(90)))),

                            onPressed: () {
                              setState(() {
                                removeButton2=false;
                                showButton2=false;
                                addItem2 = false;
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
                        padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 10.0, right: 10.0),
                        width: size.width,
                        child: TextField(
                          maxLength: 15,
                          controller: newDisc2,
                          inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[a-z A-Z]")),],
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
                              borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                            ),
                            focusedBorder: new OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: kPrimaryColorBlue,
                                  width: 0.5),
                              borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                            ),
                            prefixIcon: Icon(
                              CupertinoIcons.bubble_left,
                              color: kPrimaryColorBlue,
                              size: 23.0,
                            ),
                            labelText: "Description Of Item*",
                            labelStyle: TextStyle(
                                fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
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
                              padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 10.0, right: 10.0),
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
                                    CupertinoIcons.doc_append,
                                    color: kPrimaryColorBlue,
                                    size: 23.0,
                                  ),
                                  labelText: "Rate *",
                                  labelStyle: TextStyle(
                                      fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 10.0, right: 10.0),
                              width: size.width * 0.5,
                              child: TextField(
                                controller: newQuantity2,
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
                                    borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                                  ),
                                  focusedBorder: new OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kPrimaryColorBlue,
                                        width: 0.5),
                                    borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.show_chart_sharp,
                                    color: kPrimaryColorBlue,
                                    size: 23.0,
                                  ),
                                  labelText: "Quantity*",
                                  labelStyle: TextStyle(
                                      fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                                ),
                              ),
                            ),
                          ],
                        ),

                      ),

                      if(!showButton3)
                        Container(
                          height: 50.0,
                          width: size.width ,
                          margin: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 10.0),
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
                                primary: addItem3 ? Colors.grey[300] : kPrimaryColorBlue,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(90)))),

                            onPressed: () {
                              setState(() {
                                showButton3=true;
                                addItem3 = true;
                                removeButton3=true;
                              });
                            },

                          ),
                        ),

                      if(removeButton3)
                        Container(
                          height: 50.0,
                          width: size.width ,
                          margin: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0, right: 10.0),
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
                                primary: addItem2 ? Colors.grey[300] : kPrimaryColorBlue,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(90)))),

                            onPressed: () {
                              setState(() {
                                removeButton3=false;
                                showButton3=false;
                                addItem3 = false;
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
                        padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 10.0, right: 10.0),
                        width: size.width,
                        child: TextField(
                          maxLength: 15,
                          controller: newDisc3,
                          inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[a-z A-Z]")),],
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
                              borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                            ),
                            focusedBorder: new OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: kPrimaryColorBlue,
                                  width: 0.5),
                              borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                            ),
                            prefixIcon: Icon(
                              CupertinoIcons.bubble_left,
                              color: kPrimaryColorBlue,
                              size: 23.0,
                            ),
                            labelText: "Description Of Item*",
                            labelStyle: TextStyle(
                                fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
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
                              padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 10.0, right: 10.0),
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
                                    CupertinoIcons.doc_append,
                                    color: kPrimaryColorBlue,
                                    size: 23.0,
                                  ),
                                  labelText: "Rate *",
                                  labelStyle: TextStyle(
                                      fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 10.0, right: 10.0),
                              width: size.width * 0.5,
                              child: TextField(
                                controller: newQuantity3,
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
                                    borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                                  ),
                                  focusedBorder: new OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kPrimaryColorBlue,
                                        width: 0.5),
                                    borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.show_chart_sharp,
                                    color: kPrimaryColorBlue,
                                    size: 23.0,
                                  ),
                                  labelText: "Quantity*",
                                  labelStyle: TextStyle(
                                      fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                                ),
                              ),
                            ),
                          ],
                        ),

                      ),




                    ],
                  ),


                ),


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
                    labelText: "Cash Memo Template *",
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
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kPrimaryColorBlue,
                          width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
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

                        var value = newValue.split(" ").last;
                        String temp;

                        if(value == "1")
                          temp = "http://157.230.228.250/media/cash-memo/cash-memo-1.png";
                        else if(value == "2")
                          temp = "http://157.230.228.250/media/cash-memo/cash-memo-2.png";
                        else if(value == "3")
                          temp = "http://157.230.228.250/media/cash-memo/cash-memo-3.png";
                        else if(value == "4")
                          temp = "http://157.230.228.250/media/cash-memo/cash-memo-4.png";
                        else if(value == "5")
                          temp = "http://157.230.228.250/media/cash-memo/cash-memo-5.png";
                        else temp = "";

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
                        'Cash Memo Template 4',
                        'Cash Memo Template 5',
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
                  padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                  child: Image.network(template),
                ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
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
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kPrimaryColorBlue,
                          width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      CupertinoIcons.doc_richtext,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Terms and Conditions 1",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
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
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kPrimaryColorBlue,
                          width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      CupertinoIcons.doc_richtext,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Terms and Conditions 1",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
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
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(
                          color: kPrimaryColorBlue,
                          width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      CupertinoIcons.doc_richtext,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Terms and Conditions 1",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
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

  createTemplate() async {



    if(mobController.text.length < 10){
      showInSnackBar("Please enter Valid Mobile No.");
      return null;
    }
    if(mobController.text.isEmpty){
      showInSnackBar("Please enter Mobile Number");
      return null;
    }
    if(crfController.text.isEmpty){
      showInSnackBar("Please enter Cash Received From");
      return null;
    }
    if(addressController.text.isEmpty){
      showInSnackBar("Please enter Customer Address");
      return null;
    }


    if(dateController.text.isEmpty){
      showInSnackBar("Please Select Date");
      return null;
    }
    if(dropdownValue == "Select Cash Memo Template"){
      showInSnackBar("Please Select Cash Memo Template");
      return null;
    }


    if(amtForController.text.isNotEmpty){
      discAll.add(amtForController.text.toString());
    }

    if(newDisc.text.isNotEmpty){
      discAll.add(newDisc.text.toString());
    }

    if(newDisc2.text.isNotEmpty){
      discAll.add(newDisc2.text.toString());
    }
    if(newDisc3.text.isNotEmpty){
      discAll.add(newDisc3.text.toString());
    }
    print(discAll);


    if(totalController.text.isNotEmpty){
      rateAll.add(totalController.text.toString());
    }
    if(newRate.text.isNotEmpty){
      rateAll.add(newRate.text.toString());
    }
    if(newRate2.text.isNotEmpty){
      rateAll.add(newRate2.text.toString());
    }
    if(newRate3.text.isNotEmpty){
      rateAll.add(newRate3.text.toString());
    }


    if(quantityController.text.isNotEmpty){
      quanAll.add(quantityController.text.toString());
    }

    if(newQuantity.text.isNotEmpty){
      quanAll.add(newQuantity.text.toString());
    }
    if(newQuantity2.text.isNotEmpty){
      quanAll.add(newQuantity2.text.toString());
    }
    if(newQuantity3.text.isNotEmpty){
      quanAll.add(newQuantity3.text.toString());
    }

    if(discAll.isEmpty){
      showInSnackBar("Please Enter Item Description");
      return null;
    }
    if(rateAll.isEmpty){
      showInSnackBar("Please Enter Item Rate");
      return null;
    }
    if(quanAll.isEmpty){
      showInSnackBar("Please Enter Item Quantity");
      return null;
    }

    print(quanAll);

    _showLoaderDialog(context);

   print(id);
    print(storeID);
    print(crfController.text);
    print(addressController.text);
    print( mobController.text);
    print(rsController.text);
    print(totalInWordController.text);
    print(dateController.text);
    print(amtForController.text);
    print(quantityController.text);
    print(totalController.text);
    print(gtController.text);
    print(id);

    final param = {
      "user_id":id ,
      "m_business_id": storeID,
      "name":crfController.text,
      "address": addressController.text,
      "mobile_number":mobController.text,
      "date":  dateController.text,
      "template_choice": templateID,
      "description":(discAll.isEmpty) ? "" : discAll.reduce((value, element) => value + ',' + element),
      "quantity":(quanAll.isEmpty) ? "" : quanAll.reduce((value, element) => value + ',' + element),
      "rate":(rateAll.isEmpty) ? "" : rateAll.reduce((value, element) => value + ',' + element),
      "term_and_condition1":term1.text,
      "term_and_condition2":term2.text,
      "term_and_condition3":term3.text,

    };
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
      if(data.status == "success"){
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pop(context, true);
      } else showInSnackBar(data.status);
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      print(data.status);
      showInSnackBar(data.status);
      return null;

    }
  }

}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

