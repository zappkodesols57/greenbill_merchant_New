import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:greenbill_merchant/src/models/postApi_model.dart';
import 'package:greenbill_merchant/src/ui/widgets/background.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../constants.dart';

class AddCashMemo extends StatefulWidget {
  AddCashMemo({Key key}) : super(key: key);
  @override
  AddCashMemoState createState() => AddCashMemoState();
}

class AddCashMemoState extends State<AddCashMemo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String signCode = "";
  List<PinCode> pin;
  String  token,userName,mobile;
  String _value="1";
  String userId,busId;

  @override
  void initState() {
    getCredentials();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    addressController.dispose();
    mobileController.dispose();
    templateController.dispose();
    dateController.dispose();
  }

  getCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("fName");
      userId=prefs.getInt("userID").toString();
      mobile = prefs.getString("mobile");
      token = prefs.getString("token");
      busId=prefs.getString("businessID");
    });
  }

  TextEditingController nameController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController templateController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();
  TextEditingController totalController = new TextEditingController();
  TextEditingController totalInWordController = new TextEditingController();
  TextEditingController discController = new TextEditingController();
  TextEditingController rateController = new TextEditingController();
  TextEditingController amountController = new TextEditingController();
  TextEditingController quantityController = new TextEditingController();



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

  bool _alertMob = true;

  bool rememberMe = false;



  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        body: SafeArea(
            child: Background(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                          width: size.width * 0.9,
                          padding: EdgeInsets.only(
                              top: 10.0, bottom: 10.0, left: 0.0, right: 0.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(
                                    CupertinoIcons.arrow_left,
                                    color: Colors.black,
                                    size: 25.0,
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              Text(
                                "Add Cash Memo",
                                style: TextStyle(
                                    color: kPrimaryColorBlue,
                                    fontSize: 25.0,
                                    fontFamily: "PoppinsBold"),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.transparent,
                                    size: 25.0,
                                  ),
                                  onPressed: null),
                            ],
                          )),
                      Container(
                        width: size.width * 0.9,
                        padding: EdgeInsets.only(
                            top: 5.0, bottom: 0.0, left: 15.0, right: 0.0),
                        child: Text(
                          'Mandatory Fields *',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),


                      Container(
                        width: size.width * 0.9,
                        padding: EdgeInsets.only(
                            top: 5.0, bottom: 10.0, left: 0.0, right: 0.0),
                        child: TextField(

                          controller: nameController,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            if (value.length <0) ;
                          },

                          style: TextStyle(
                              fontFamily: "PoppinsLight",
                              fontSize: 13.0,
                              color: kPrimaryColorBlue),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            counterStyle: TextStyle(
                              height: double.minPositive,
                            ),
                            counterText: "",
                            contentPadding: const EdgeInsets.symmetric(vertical: 13.0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                  kPrimaryColorBlue,
                                  width: 0.5),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(35.0)),
                            ),
                            focusedBorder: new OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                  kPrimaryColorBlue,
                                  width: 0.5),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(35.0)),
                            ),
                            prefixIcon: Icon(
                              CupertinoIcons.person,
                              color: kPrimaryColorBlue,
                              size: 20.0,
                            ),
                            suffixIcon: Icon(
                              _alertMob ? null : Icons.error,
                              color: kPrimaryColorRed,
                              size: 20.0,
                            ),
                            hintText: "Name",
                            labelText: "Name*",
                            // suffixText: '*',
                            // suffixStyle: TextStyle(
                            //   color: Colors.red,
                            // ),
                            labelStyle: TextStyle(
                                fontFamily: "PoppinsLight",
                                fontSize: 13.0,
                                color: kPrimaryColorBlue),
                          ),
                        ),
                      ),
                      Container(
                        width: size.width * 0.9,
                        padding: EdgeInsets.only(
                            top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                        child: TextField(

                          controller: addressController,
                          keyboardType: TextInputType.text,
                          // onSubmitted: (value){
                          //   if(value.isNotEmpty)
                          //     validateEmail(value) ? showInSnackBar('Valid Email', 2) : showInSnackBar(email, 2);
                          //   else showInSnackBar("Please enter the Email ID", 2);
                          // },
                          style: TextStyle(
                              fontFamily: "PoppinsLight",
                              fontSize: 13.0,
                              color: kPrimaryColorBlue),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(vertical: 13.0),
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
                              FontAwesomeIcons.map,
                              color: kPrimaryColorBlue,

                            ),
                            hintText: "Address",
                            labelText: "Address*",
                            // suffixText: '*',
                            // suffixStyle: TextStyle(
                            //   color: Colors.red,
                            // ),
                            labelStyle: TextStyle(
                                fontFamily: "PoppinsLight",
                                fontSize: 13.0,
                                color: kPrimaryColorBlue),
                          ),
                        ),
                      ),
                      Container(
                        width: size.width * 0.9,
                        padding: EdgeInsets.only(
                            top: 10.0, bottom: 10.0, left: 0.0, right: 0.0),
                        child: TextField(

                          controller: mobileController,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                          onChanged: (value) {
                            if (value.length == 10) ;
                          },
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          style: TextStyle(
                              fontFamily: "PoppinsLight",
                              fontSize: 13.0,
                              color: kPrimaryColorBlue),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            counterStyle: TextStyle(
                              height: double.minPositive,
                            ),
                            counterText: "",
                            contentPadding: const EdgeInsets.symmetric(vertical: 13.0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                  kPrimaryColorBlue,
                                  width: 0.5),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(35.0)),
                            ),
                            focusedBorder: new OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                  kPrimaryColorBlue,
                                  width: 0.5),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(35.0)),
                            ),
                            prefixIcon: Icon(
                              CupertinoIcons.device_phone_portrait,
                              color: kPrimaryColorBlue,
                              size: 20.0,
                            ),
                            suffixIcon: Icon(
                              _alertMob ? null : Icons.error,
                              color: kPrimaryColorRed,
                              size: 20.0,
                            ),
                            hintText: "Mobile",
                            labelText: "Mobile*",
                            // suffixText: '*',
                            // suffixStyle: TextStyle(
                            //   color: Colors.red,
                            // ),
                            labelStyle: TextStyle(
                                fontFamily: "PoppinsLight",
                                fontSize: 13.0,
                                color: kPrimaryColorBlue),
                          ),
                        ),
                      ),

                      Container(
                        width: size.width * 0.9,
                        padding: EdgeInsets.only(
                            top: 5.0, bottom: 10.0, left: 0.0, right: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                                width: size.width * 0.4,
                                decoration: BoxDecoration(
                                  border:
                                  Border.all(color: kPrimaryColorBlue, width: 0.5),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Center(
                                  child: DropdownButton(
                                    value: _value,

                                    iconEnabledColor: kPrimaryColorBlue,
                                    //elevation: 5,
                                    isExpanded: false,
                                    style: TextStyle(
                                        color: kPrimaryColorBlue,
                                        fontFamily: "PoppinsLight",
                                        fontSize: 13.0),
                                    underline: Container(
                                        height: 2,
                                        width: 50,
                                        color: Colors.transparent),
                                    items: [
                                      DropdownMenuItem(
                                        child: Text("Template One"),
                                        value: "1",
                                      ),
                                      DropdownMenuItem(
                                        child: Text("Template Two"),
                                        value: "2",
                                      ),
                                      DropdownMenuItem(
                                          child: Text("Template Three"),
                                          value: "3"
                                      ),
                                      DropdownMenuItem(
                                          child: Text("Template Four"),
                                          value: "4"
                                      ),
                                      DropdownMenuItem(
                                          child: Text("Template Five"),
                                          value: "5"
                                      )

                                    ],
                                    onChanged: ( value) {
                                      setState(() {

                                        _value = value;
                                      });
                                    },



                                    hint: Text(
                                      "Template*",
                                      style: TextStyle(
                                        color: kPrimaryColorBlue,
                                        fontSize: 13.0,
                                        fontFamily: "PoppinsLight",
                                      ),
                                    ),

                                  ),
                                )),
                            SizedBox(
                              width: size.width * 0.1,
                            ),
                            Container(
                              width: size.width * 0.4,
                              child: TextField(

                                controller: dateController,
                                onTap: () {
                                  _selectDate(context);
                                },
                                style: TextStyle(
                                    fontFamily: "PoppinsLight",
                                    fontSize: 13.0,
                                    color: kPrimaryColorBlue),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  counterStyle: TextStyle(
                                    height: double.minPositive,
                                  ),
                                  counterText: "",
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
                                    FontAwesomeIcons.calendar,
                                    color: kPrimaryColorBlue,
                                    size: 20.0,
                                  ),
                                  labelText: "Date",
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
                      SizedBox(
                        width: size.width * 0.1,
                      ),

                      Container(
                        width: size.width * 0.9,
                        padding: EdgeInsets.only(
                            top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: size.width * 0.4,
                              child: TextField(

                                controller: totalController,
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
                                    FontAwesomeIcons.cashRegister,
                                    color: kPrimaryColorBlue,
                                    size: 20.0,
                                  ),
                                  labelText: "Total",
                                  labelStyle: TextStyle(
                                      fontFamily: "PoppinsLight",
                                      fontSize: 13.0,
                                      color: kPrimaryColorBlue),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.1,
                            ),
                            Container(
                              width: size.width * 0.4,
                              child: TextField(

                                controller: totalInWordController,
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
                                    FontAwesomeIcons.moneyBill,
                                    color: kPrimaryColorBlue,
                                    size: 20.0,
                                  ),
                                  labelText: "Total In Word",
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
                      SizedBox(
                        width: size.width * 0.1,
                      ),


                      Container(
                        width: size.width * 0.9,
                        padding: EdgeInsets.only(
                            top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                        child: TextField(

                          controller: discController,
                          keyboardType: TextInputType.text,


                          style: TextStyle(
                              fontFamily: "PoppinsLight",
                              fontSize: 13.0,
                              color: kPrimaryColorBlue),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            counterStyle: TextStyle(
                              height: double.minPositive,
                            ),
                            counterText: "",
                            contentPadding: const EdgeInsets.symmetric(vertical: 13.0),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                  kPrimaryColorBlue,
                                  width: 0.5),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(35.0)),
                            ),
                            focusedBorder: new OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                  kPrimaryColorBlue,
                                  width: 0.5),
                              borderRadius:
                              const BorderRadius.all(Radius.circular(35.0)),
                            ),
                            prefixIcon: Icon(
                              CupertinoIcons.person,
                              color: kPrimaryColorBlue,
                              size: 20.0,
                            ),
                            suffixIcon: Icon(
                              _alertMob ? null : Icons.error,
                              color: kPrimaryColorRed,
                              size: 20.0,
                            ),
                            hintText: "Description",
                            labelText: "Description Of Item",
                            // suffixText: '*',
                            // suffixStyle: TextStyle(
                            //   color: Colors.red,
                            // ),
                            labelStyle: TextStyle(
                                fontFamily: "PoppinsLight",
                                fontSize: 13.0,
                                color: kPrimaryColorBlue),
                          ),
                        ),
                      ),




                      Container(
                        width: size.width * 0.9,
                        padding: EdgeInsets.only(
                            top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: size.width * 0.4,
                              child: TextField(


                                controller: rateController,
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
                                    FontAwesomeIcons.cashRegister,
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
                            SizedBox(
                              width: size.width * 0.1,
                            ),
                            Container(
                              width: size.width * 0.4,
                              child: TextField(

                                controller: amountController,
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
                                    FontAwesomeIcons.moneyBill,
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

                      SizedBox(
                        width: size.width * 0.1,
                      ),


                      Container(
                        width: size.width * 0.9,
                        padding: EdgeInsets.only(
                            top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: size.width * 0.4,
                              child: TextField(
                                controller: quantityController,

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
                                    FontAwesomeIcons.cashRegister,
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
                            SizedBox(
                              width: size.width * 0.1,
                            ),
                            Container(
                              width: size.width * 0.4,
                              decoration: new BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                                        vertical: 10.0, horizontal: 20.0),
                                    child: Text(
                                      "Add Item",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                          fontFamily: "PoppinsBold"),
                                    ),
                                  ),
                                  onPressed: () {
                                    print("Add Item");
                                  }),
                            ),







                          ],
                        ),
                      ),









                      Container(
                        width: size.width * 0.9,
                        padding: EdgeInsets.only(
                            top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: size.width * 0.4,
                              margin: EdgeInsets.only(top: 20.0),
                              decoration: new BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(25.0)),
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
                                        vertical: 10.0, horizontal: 20.0),
                                    child: Text(
                                      "Create",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                          fontFamily: "PoppinsBold"),
                                    ),
                                  ),
                                  onPressed: () {
                                    validates();
                                   print("Create");
                                  }),
                            ),
                            SizedBox(
                              width: size.width * 0.1,
                            ),
                            Container(
                              width: size.width * 0.4,
                              margin: EdgeInsets.only(top: 20.0),
                              decoration: new BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(25.0)),
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
                                        vertical: 10.0, horizontal: 20.0),
                                    child: Text(
                                      "Close",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15.0,
                                          fontFamily: "PoppinsBold"),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context

                                    );
                                  }),
                            ),
                          ],
                        ),
                      ),







                    ],
                  ),

                ))));
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

  // bool validatePassword(String value){
  //   String  pattern = r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$";
  //   RegExp regExp = new RegExp(pattern);
  //   return regExp.hasMatch(value);
  // }

  bool validateEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  Future<void> validates() async {
    if (nameController.text.isEmpty) {
      showInSnackBar("Please enter Name", 2);
      return null;
    }
    if (addressController.text.isEmpty) {
      showInSnackBar("Please enter the Address", 2);
      return null;
    }
    if (mobileController.text.length < 10) {
      showInSnackBar("Please enter Valid Number", 2);
      return null;
    }
    if (_value == null) {
      showInSnackBar("Please Select A Template", 2);
      return null;
    }
    if (dateController.text.isEmpty) {
      showInSnackBar("Please select a Date", 2);
      return null;
    }


    if (totalController.text.isEmpty) {
      showInSnackBar("Please enter Total Amount", 2);
      return null;
    }



     if(totalInWordController.text.isEmpty){
      showInSnackBar("Please enter Total Amount", 2);
      return null;
    }

    if(discController.text.isEmpty){
    showInSnackBar("Please Mention item Detail", 2);
           return null;
     }
    if(rateController.text.isEmpty){
      showInSnackBar("Please Enter item Rate", 2);
      return null;
    }
    if(amountController.text.isEmpty){
      showInSnackBar("Please Enter Amount", 2);
      return null;
    }
    if(quantityController.text.isEmpty){
      showInSnackBar("Please Enter Item Quantity", 2);
      return null;
    }
    final param = {
      "user_id":userId ,
      "m_business_id": busId,
      "name":nameController.text,
      "address": addressController.text,
      "mobile_number":mobileController.text,
      "total": totalController.text,
      "total_in_words": totalInWordController.text,
      "date": dateController.text,
      "template_choice": _value,
      "description":discController.text ,
      "quantity": quantityController.text,
      "rate": rateController.text,
      "amount": amountController.text,

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
        showInSnackBar("Cash Memo Created", 2);
        Navigator.of(context).pop();


      } else {
        print(data.status);

      }
    } else {
      print(data.status);

    }


      }
    }





