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

  String dropdownValue = "Select Cash Memo Template";
  String template = "", templateID;
  String token, id, mob, storeID;
  bool addItem=true;
  bool showButton=true;
  //bool showButton=false;
  bool removeButton=true;


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
      firstDate: DateTime(1950, 1),
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
                  controller: rsController,
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
                      Icons.attach_money,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Total Amount *",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: TextField(
                  controller: totalInWordController,
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
                      CupertinoIcons.textformat,
                      color: kPrimaryColorBlue,
                      size: 23.0,
                    ),
                    labelText: "Total in Words*",
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
                          padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 10.0, right: 10.0),
                          width: size.width * 0.5,
                          child: TextField(
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

                      ],
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
                            controller: gtController,
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
                                CupertinoIcons.doc_richtext,
                                color: kPrimaryColorBlue,
                                size: 23.0,
                              ),
                              labelText: "Amount*",
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
                        color: addItem ? Colors.black : Colors.white
                    ),


                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: addItem ? 0.0 : 3.0,
                      primary: addItem ? Colors.grey[300] : kPrimaryColorBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(90)))),

                  onPressed: () {
                    setState(() {
                      addItem = false;
                      removeButton=false;
                      showButton=true;
                    });
                  },

                ),
              ),
              if(!removeButton)

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
                        color: addItem ? Colors.black : Colors.white
                    ),


                  ),
                  style: ElevatedButton.styleFrom(
                      elevation: addItem ? 0.0 : 3.0,
                      primary: addItem ? Colors.grey[300] : kPrimaryColorBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(90)))),

                  onPressed: () {
                    setState(() {
                      removeButton=true;
                      showButton=false;
                      addItem = true;
                    });
                  },

                ),
              ),

              if(!addItem)
                Container(
                  width: size.width,
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: size.width * 0.5,
                          padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 10.0, right: 0.0),
                          child: TextField(

                            controller: newDisc,
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                                fontFamily: "PoppinsLight",
                                fontSize: 13.0,
                                color: kPrimaryColorBlue),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                              const EdgeInsets.symmetric(vertical: 13.0),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: kPrimaryColorBlue, width: 0.5),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(35.0)),
                              ),
                              focusedBorder: new OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: kPrimaryColorBlue, width: 0.5),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(35.0)),
                              ),
                              prefixIcon: Icon(
                                CupertinoIcons.bubble_left,
                                color: kPrimaryColorBlue,
                                size: 20.0,
                              ),
                              labelText: "Description Of item",
                              labelStyle: TextStyle(
                                  fontFamily: "PoppinsLight",
                                  fontSize: 13.0,
                                  color: kPrimaryColorBlue),
                            ),
                          ),
                        ),




                        Container(
                          width: size.width * 0.5,
                          padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 10.0, right: 10.0),
                          child: TextField(

                            controller: newAmount,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                fontFamily: "PoppinsLight",
                                fontSize: 13.0,
                                color: kPrimaryColorBlue),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              contentPadding:
                              const EdgeInsets.symmetric(vertical: 13.0),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: kPrimaryColorBlue, width: 0.5),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(35.0)),
                              ),
                              focusedBorder: new OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: kPrimaryColorBlue, width: 0.5),
                                borderRadius:
                                const BorderRadius.all(Radius.circular(35.0)),
                              ),
                              prefixIcon: Icon(
                                CupertinoIcons.doc_richtext,
                                color: kPrimaryColorBlue,
                                size: 20.0,
                              ),
                              labelText: "Amount",
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


              if(!addItem)
                Container(
                  width: size.width,
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: size.width * 0.5,
                        padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 10.0, right: 0.0),
                        child: TextField(

                          controller: newRate,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              fontFamily: "PoppinsLight",
                              fontSize: 13.0,
                              color: kPrimaryColorBlue),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 13.0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: kPrimaryColorBlue, width: 0.5),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(35.0)),
                            ),
                            focusedBorder: new OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: kPrimaryColorBlue, width: 0.5),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(35.0)),
                            ),
                            prefixIcon: Icon(
                              CupertinoIcons.doc_append,
                              color: kPrimaryColorBlue,
                              size: 20.0,
                            ),
                            labelText: "Rate",
                            labelStyle: TextStyle(
                                fontFamily: "PoppinsLight",
                                fontSize: 13.0,
                                color: kPrimaryColorBlue),
                          ),
                        ),
                      ),

                      Container(
                        width: size.width * 0.5,
                        padding: EdgeInsets.only(top: 0.0, bottom: 0.0, left: 10.0, right: 10.0),
                        child: TextField(

                          controller: newQuantity,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                              fontFamily: "PoppinsLight",
                              fontSize: 13.0,
                              color: kPrimaryColorBlue),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 13.0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: kPrimaryColorBlue, width: 0.5),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(35.0)),
                            ),
                            focusedBorder: new OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: kPrimaryColorBlue, width: 0.5),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(35.0)),
                            ),
                            prefixIcon: Icon(
                              Icons.show_chart_sharp,
                              color: kPrimaryColorBlue,
                              size: 20.0,
                            ),
                            labelText: "Quantity",
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
    if(rsController.text.isEmpty){
      showInSnackBar("Please enter Total Amount");
      return null;
    }
    if(totalInWordController.text.isEmpty){
      showInSnackBar("Please enter Total in Word");
      return null;
    }
    if(amtForController.text.isEmpty){
      showInSnackBar("Please enter Amount For");
      return null;
    }
    if(totalController.text.isEmpty){
      showInSnackBar("Please enter Rate Of Item");
      return null;
    }
    if(gtController.text.isEmpty){
      showInSnackBar("Please enter Payable Amount");
      return null;
    }
    if(quantityController.text.isEmpty){
      showInSnackBar("Please enter item quantity");
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
      "total": rsController.text,
      "total_in_words": totalInWordController.text,
      "date":  dateController.text,
      "template_choice": templateID,
      "description":amtForController.text,
      "quantity":quantityController.text,
      "rate": totalController.text,
      "amount": gtController.text,

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

      if (data.status == "success") {
        showInSnackBar("Created Successfully");
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pop(context, true);

      } else {
        print(data.status);

      }
    } else {
      print(data.status);

    }
  }

}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}

