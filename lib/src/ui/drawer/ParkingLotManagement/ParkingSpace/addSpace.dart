import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddSpace extends StatefulWidget {
  final String status, id, vehicleType, spaceCount;
  AddSpace(this.status, this.id, this.vehicleType, this.spaceCount);

  @override
  AddSpaceState createState() => AddSpaceState();
}

class AddSpaceState extends State<AddSpace> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, id, storeID;
  String _chosenName;
  final ScrollController _controller = ScrollController();

  TextEditingController countController = new TextEditingController();

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
      countController.text = widget.spaceCount;
      _chosenName = (widget.status == "true")?widget.vehicleType : null;
    });
    print('$token\n$id');
    this.getVehicles(storeID);
  }

  void saveSpace() async {

    if(_chosenName.isEmpty || _chosenName == null){
      showInSnackBar("Please select Vehicle Type");
      return null;
    }
    if(countController.text.isEmpty){
      showInSnackBar("Please enter Space Count");
      return null;
    }

    final param = {
      "id": (widget.id == null || widget.id.isEmpty) ? "" : widget.id,
      "m_business_id": storeID,
      "spaces_count": countController.text,
      "vehicle_type": _chosenName,
    };

    final response = await http.post(
      "http://157.230.228.250/parking-manage-space-api/",
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
          'Edit Space',
        ) :
        Text(
          'Add Space',
        ),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {Navigator.pop(context, false);},
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              saveSpace();
            },
            child: Text("Save", style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
      body: Column(
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
                "Select Role",
                style: TextStyle(
                    fontFamily: "PoppinsLight",
                    fontSize: 13.0,
                    color: kPrimaryColorBlue),
              ),
              onChanged: (String value) {
                setState(() {
                  _chosenName = value;
                });
              },
              value:_chosenName
            ),
          ),
          Container(
            padding: EdgeInsets.only(
                top: 10.0, bottom: 0.0, left: 10.0, right: 10.0),
            child: TextField(
              controller: countController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              maxLength: 5,
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
                  FontAwesomeIcons.parking,
                  color: kPrimaryColorBlue,
                  size: 23.0,
                ),
                labelText: "Space Count *",
                labelStyle: TextStyle(
                    fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
              ),
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