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

class AddProducts extends StatefulWidget {
  final String status, id, productAvailability, productCost, productName;
  AddProducts(this.status, this.id, this.productAvailability, this.productCost, this.productName);

  @override
  AddProductsState createState() => AddProductsState();
}

class AddProductsState extends State<AddProducts> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, id, storeID;
  String _chosenName, _chosenValue = "Select Product Availability";
  final ScrollController _controller = ScrollController();

  TextEditingController productController = new TextEditingController();
  TextEditingController costController = new TextEditingController();

  @override
  void initState() {
    getCredentials();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      id = prefs.getInt("userID").toString();
      storeID = prefs.getString("businessID");
      productController.text = widget.productName;
      costController.text = widget.productCost;
      _chosenValue = widget.productAvailability;
    });
    print('$token\n$id');
  }

  void saveProduct() async {

    if(productController.text.isEmpty){
      showInSnackBar("Please enter Product Name");
      return null;
    }
    if(costController.text.isEmpty){
      showInSnackBar("Please enter Product Cost");
      return null;
    }
    if(double.parse(costController.text) > 50000.00){
      showInSnackBar("Amount Must be less than 50000");
      return null;
    }
    if(double.parse(costController.text) == 0.00){
      showInSnackBar("Amount should not be 0");
      return null;
    }
    if(_chosenValue == "Select Product Availability"){
      showInSnackBar("Please select Product");
      return null;
    }

    final param = {
      "id": (widget.id == null || widget.id.isEmpty) ? "" : widget.id,
      "m_business_id": storeID,
      "product_name": productController.text,
      "product_cost": costController.text,
      "product_availability": _chosenValue,
    };

    final response = await http.post(
      "http://157.230.228.250/petrol-manage-product-api/",
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
      if(data.status == "success"){
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
        title: (widget.status == "true") ? Text(
          'Edit Products',
        ) :
        Text(
          'Add Products',
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {Navigator.pop(context, false);},
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              saveProduct();
            },
            child: Text("Save", style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
                top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
            child: TextField(
              inputFormatters: [LengthLimitingTextInputFormatter(20),
            FilteringTextInputFormatter.allow(RegExp("[a-z A-Z]"))],

              controller: productController,
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
                  FontAwesomeIcons.gasPump,
                  color: kPrimaryColorBlue,
                  size: 23.0,
                ),
                labelText: "Product Name *",
                labelStyle: TextStyle(
                    fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                top: 0.0, bottom: 10.0, left: 10.0, right: 10.0),
            child: TextField(
              controller: costController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                LengthLimitingTextInputFormatter(8),
                FilteringTextInputFormatter.allow( RegExp(r'^(\d+)?\.?\d{0,2}'))
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
                  FontAwesomeIcons.rupeeSign,
                  color: kPrimaryColorBlue,
                  size: 23.0,
                ),
                labelText: "Cost *",
                labelStyle: TextStyle(
                    fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
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
            child:new DropdownButton<String>(
              iconEnabledColor: Colors.black,
              dropdownColor: Colors.white,
              value: _chosenValue,
              isExpanded: true,
              style: TextStyle(
                  fontFamily: "PoppinsMedium",
                  fontSize: 13.0,
                  color: kPrimaryColorBlue),
              underline: Container(
                height: 1,
                width: 0,
                color: Colors.transparent,
              ),
              onChanged: (String newValue) {
                setState(() {
                  _chosenValue = newValue;
                });
              },
              items: <String>['Select Product Availability','Yes', 'No']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
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