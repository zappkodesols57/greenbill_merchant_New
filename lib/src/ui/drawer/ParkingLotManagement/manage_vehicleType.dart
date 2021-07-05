import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:greenbill_merchant/src/models/model_vehicleTypes.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ManageVehicleType extends StatefulWidget {
  @override
  ManageVehicleTypeState createState() => ManageVehicleTypeState();
}

class ManageVehicleTypeState extends State<ManageVehicleType> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, id, storeID;
  final ScrollController _controller = ScrollController();

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
    });
    print('$token\n$id');
  }

  showVehicleDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Add Vehicle Type',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w800,
                  fontSize: 15.0,
                  fontFamily: "PoppinsMedium"),
            ),
            content: setupAlertDialoagContainer(),
            actions: <Widget>[
              TextButton(
                child:
                Text('Cancel', style: TextStyle(color: kPrimaryColorBlue)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Widget setupAlertDialoagContainer() {
    return Container(
      height: 350.0,
      width: 300.0,
      child: Scrollbar(
        isAlwaysShown: true,
        controller: _controller,
        thickness: 3.0,
        child: ListView(
          controller: _controller,
          padding: EdgeInsets.all(0),
          children: [
            ListTile(
              title: Text("2 - Wheeler"),
              onTap: () {
                addVehicleType("2 - Wheeler");
                },
            ),
            ListTile(
              title: Text("3 - Wheeler"),
              onTap: () {
                addVehicleType("3 - Wheeler");
              },
            ),
            ListTile(
              title: Text("4 - Wheeler"),
              onTap: () {
                addVehicleType("4 - Wheeler");
                },
            ),
            ListTile(
              title: Text("Lorry"),
              onTap: () {
                addVehicleType("Lorry");
                },
            ),
            ListTile(
              title: Text("Truck"),
              onTap: () {
                addVehicleType("Truck");
                },
            ),
            ListTile(
              title: Text("Special Vehicle"),
              onTap: () {
                addVehicleType("Special Vehicle");
                },
            ),
            ListTile(
              title: Text("Cycle"),
              onTap: () {
                addVehicleType("Cycle");
                },
            ),
            ListTile(
              title: Text("Others"),
              onTap: () {
                addVehicleType("Others");
                },
            ),
          ],
        ),
      ),
    );
  }

  Future<List<VehicleTypes>> list() async {
    final param = {
      "m_business_id": storeID,
    };

    final res = await http.post(
      "http://157.230.228.250/parking-manage-vehicle-type-list-api/", body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(res.body);
    if(200 == res.statusCode){
      print(vehicleTypesFromJson(res.body).length);
      return vehicleTypesFromJson(res.body);
    } else{
      throw Exception('Failed to load Stores List');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Manage Vehicle Type"),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {Navigator.pop(context);},
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              showVehicleDialog(context);
            },
           icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<List<VehicleTypes>>(
        future: list(),
        builder: (BuildContext context, AsyncSnapshot<List<VehicleTypes>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),));
          else if (snapshot.hasError) {
            return Center(
              child: Text("No Data Found!"),
            );
          } else {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  shrinkWrap: true,
                  reverse: false,
                  itemBuilder: (BuildContext context, int index) {
                    return new Card(
                      elevation: 2.0,
                      child: ListTile(
                        dense: true,
                        title: Text(snapshot.data[index].vehicleType,
                          style: TextStyle(fontFamily: "PoppinsBold"),
                        ),
                        trailing: IconButton(
                            icon: Icon(Icons.delete_outline_rounded, color: kPrimaryColorRed,),
                            onPressed: () {
                              deleteEntry(snapshot.data[index].id);
                              },
                        ),
                        ),
                      );
                  }
              );

            } else {
              return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),));
            }
          }

        },
      ),
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

  addVehicleType(String type) async {
    final param = {
      "m_business_id": storeID,
      "vehicle_type": type,
    };

    final response = await http.post(
      "http://157.230.228.250/parking-manage-vehicle-type-api/", body: param,
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
      if(data.status == "success"){
        showInSnackBar(data.message);
        Navigator.of(context, rootNavigator: true).pop();
      } else showInSnackBar(data.message);
    } else {
      print(data.status);
      print(data.message);
      showInSnackBar(data.message);
      Navigator.of(context, rootNavigator: true).pop();
      return null;
    }

  }

  Future<void> deleteEntry(int id) async {
    final param = {
      "vehicle_id": id.toString(),
    };

    final response = await http.post(
      "http://157.230.228.250/parking-manage-vehicle-type-delete-api/",
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
        showInSnackBar("Vehicle Deleted Successfully");
        setState(() {

        });
      } else showInSnackBar(data.status);
    } else {
      print(data.status);
      showInSnackBar(data.status);
      return null;
    }
  }
}