import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCharges extends StatefulWidget {
  final String status, id, vehicleType, forHours, charges, forAdditionalHours, additionalHoursCharges;
  AddCharges(this.status, this.id, this.vehicleType, this.forHours, this.charges, this.forAdditionalHours, this.additionalHoursCharges);

  @override
  AddChargesState createState() => AddChargesState();
}

class AddChargesState extends State<AddCharges> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, storeID;
  int userID;
  String forHours, addHours, vehicleType;

  @override
  void initState() {
    super.initState();
    getCredentials();
  }

  @override
  void dispose() {
    super.dispose();
    chargesController.dispose();
    addChargesController.dispose();
  }

  TextEditingController chargesController = new TextEditingController();
  TextEditingController addChargesController = new TextEditingController();

  getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      storeID = prefs.getString("businessID");
      userID = prefs.getInt("userID");
      vehicleType = widget.vehicleType;
      forHours = widget.forHours;
      addHours = widget.forAdditionalHours;
      chargesController.text = widget.charges;
      addChargesController.text = widget.additionalHoursCharges;
    });
    this.getVehicles(storeID);
  }

  final String url = "http://157.230.228.250/parking-manage-vehicle-type-list-api/";
  List data = List();
  Future<String> getVehicles(String id) async {

    final param = {
      "m_business_id": id,
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: (widget.status == "true") ? Text(
          'Edit Space Charges',
        ) :
        Text(
          'Add Space Charges',
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {Navigator.pop(context, false);},
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              validate();
            },
            child: Text("Save", style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 20.0,),
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
                        child: new Text(item['vehicle_type']),
                        value: item['vehicle_type'].toString(),
                      );
                    }).toList(),
                    hint: Text(
                      "Select Vehicle Type",
                      style: TextStyle(
                          fontFamily: "PoppinsLight",
                          fontSize: 13.0,
                          color: kPrimaryColorBlue),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        vehicleType = value;
                      });
                    },
                    value:( vehicleType.isEmpty || vehicleType == null) ? "2 - Wheeler" : vehicleType,
                  ),
                ),
                Container(
                  width: size.width * 0.95,
                  padding: EdgeInsets.only(
                      top: 10.0, bottom: 0.0, left: 0.0, right: 0.0),
                  child: Text("Fixed Charges",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: "PoppinsBold"),
                  ),
                ),
                Container(
                    width: size.width * 0.95,
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 0.0, left: 0.0, right: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: size.width * 0.45,
                          decoration: BoxDecoration(
                            border: Border.all(color: kPrimaryColorBlue, width: 0.5),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          padding: EdgeInsets.only(
                              top: 0.0, bottom: 0.0, left: 10.0, right: 10.0),
                          child:new DropdownButton<String>(
                            iconEnabledColor: Colors.black,
                            dropdownColor: Colors.white,
                            value:( forHours.isEmpty || forHours == null) ? "1" : forHours,
                            isExpanded: true,
                            hint: Text("Select Hours",
                              style: TextStyle(
                                  fontFamily: "PoppinsMedium",
                                  fontSize: 13.0,
                                  color: kPrimaryColorBlue),
                            ),
                            style: TextStyle(
                                fontFamily: "PoppinsMedium",
                                fontSize: 13.0,
                                color: Colors.black),
                            underline: Container(
                              height: 1,
                              width: 0,
                              color: Colors.transparent,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                forHours = newValue;
                              });
                            },
                            items: <String>['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        Container(
                          width: size.width * 0.45,
                          padding: EdgeInsets.only(
                              top: 10.0, bottom: 10.0, left: 0.0, right: 0.0),
                          child: TextField(
                            controller: chargesController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(8),
                              FilteringTextInputFormatter.allow( RegExp(r'^(\d+)?\.?\d{0,2}'))
                            ],
                            style: TextStyle(
                                fontFamily: "PoppinsLight",
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
                                FontAwesomeIcons.rupeeSign,
                                color: kPrimaryColorBlue,
                                size: 23.0,
                              ),
                              labelText: "Charges *",
                              labelStyle: TextStyle(
                                  fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                            ),
                          ),
                        ),
                      ],
                    )
                ),
                Container(
                  width: size.width * 0.95,
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                  child: Text("Additional Hours Charges",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: "PoppinsBold"),
                  ),
                ),
                Container(
                    width: size.width * 0.95,
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 0.0, left: 0.0, right: 0.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: size.width * 0.45,
                          decoration: BoxDecoration(
                            border: Border.all(color: kPrimaryColorBlue, width: 0.5),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          padding: EdgeInsets.only(
                              top: 0.0, bottom: 0.0, left: 10.0, right: 10.0),
                          child:new DropdownButton<String>(
                            iconEnabledColor: Colors.black,
                            dropdownColor: Colors.white,
                            value:( addHours.isEmpty || addHours == null) ? "1" : addHours,
                            isExpanded: true,
                            hint: Text("Additional Hours",
                              style: TextStyle(
                                  fontFamily: "PoppinsMedium",
                                  fontSize: 13.0,
                                  color: kPrimaryColorBlue),
                            ),
                            style: TextStyle(
                                fontFamily: "PoppinsMedium",
                                fontSize: 13.0,
                                color: Colors.black),
                            underline: Container(
                              height: 1,
                              width: 0,
                              color: Colors.transparent,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                addHours = newValue;
                              });
                            },
                            items: <String>['1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23','24']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                        Container(
                          width: size.width * 0.45,
                          padding: EdgeInsets.only(
                              top: 10.0, bottom: 10.0, left: 0.0, right: 0.0),
                          child: TextField(
                            controller: addChargesController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              LengthLimitingTextInputFormatter(8),
                              FilteringTextInputFormatter.allow( RegExp(r'^(\d+)?\.?\d{0,2}'))
                            ],
                            style: TextStyle(
                                fontFamily: "PoppinsLight",
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
                                FontAwesomeIcons.rupeeSign,
                                color: kPrimaryColorBlue,
                                size: 23.0,
                              ),
                              labelText: "Additional Charges",
                              labelStyle: TextStyle(
                                  fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
                            ),
                          ),
                        ),
                      ],
                    )
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

  validate() async {
    if(vehicleType.isEmpty || vehicleType == null){
      showInSnackBar("Please select Vehicle Type");
      return null;
    }
    if(forHours.isEmpty || forHours == null){
      showInSnackBar("Please select Fixed Hours");
      return null;
    }
    if(chargesController.text.isEmpty){
      showInSnackBar("Please enter Fixed Charge");
      return null;
    }
    if(double.parse(chargesController.text) > 50000.00){
      showInSnackBar("Amount Must be less than 50000");
      return null;
    }
    if(double.parse(chargesController.text) == 0.00){
      showInSnackBar("Amount should not be 0");
      return null;
    }
    // if(addHours.isEmpty || addHours == null){
    //   showInSnackBar("Please select Additional Hours");
    //   return null;
    // }
    // if(addChargesController.text.isEmpty){
    //   showInSnackBar("Please enter Additional Charge");
    //   return null;
    // }
    // if(double.parse(addChargesController.text) > 50000.00){
    //   showInSnackBar("Amount Must be less than 50000");
    //   return null;
    // }
    // if(double.parse(addChargesController.text) == 0.00){
    //   showInSnackBar("Amount should not be 0");
    //   return null;
    // }

    _showLoaderDialog(context);

    final param = {
      "user_id": userID.toString(),
      "m_business_id": storeID,
      "vehicle_type": vehicleType,
      "for_hours": forHours,
      "charges": chargesController.text,
      "for_additional_hours": addHours.isEmpty || addHours == null ? "" : addHours,
      "additional_hours_charges": addChargesController.text.isEmpty ? "" : addChargesController.text,
      "id": (widget.id.isEmpty || widget.id == null) ? "" : widget.id,
    };

    final response = await http.post(
      "http://157.230.228.250/parking-manage-charges-api/",
      body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(response.statusCode);
    CommonData data;
    var responseJson = json.decode(json.encode(response.body));
    print(response.body);

    if (response.statusCode == 200) {
      data = new CommonData.fromJson(jsonDecode(response.body));
      print(responseJson);
      print("Submit Successful");
      print(data.status);
      if(data.status == "success"){
        Navigator.of(context, rootNavigator: true).pop();
        Navigator.pop(context, true);
      } else showInSnackBar(data.message);
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      return null;
    }
  }
}