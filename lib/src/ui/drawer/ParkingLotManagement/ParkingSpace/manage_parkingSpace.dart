import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/ui/drawer/ParkingLotManagement/ParkingSpace/addSpace.dart';
import 'package:greenbill_merchant/src/models/model_space.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ManageParkingSpace extends StatefulWidget {
  @override
  ManageParkingSpaceState createState() => ManageParkingSpaceState();
}

class ManageParkingSpaceState extends State<ManageParkingSpace> {
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

  Future<RemainingSpace> getSpaces() async {

    final param = {
      "m_business_id": storeID,
    };

    final res = await http.post("http://157.230.228.250/parking-manage-space-list-api/", body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(res.body);
    print(res.statusCode);
    if(200 == res.statusCode){
      print(remainingSpaceFromJson(res.body).data.length);
      return remainingSpaceFromJson(res.body);
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
        title: Text("Manage Parking Space"),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {Navigator.pop(context);},
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddSpace("false", "", "", "")))
                  .then((value) => value ? showInSnackBar("Parking Space Save Successfully") : null);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<RemainingSpace>(
        future: getSpaces(),
        builder: (BuildContext context, AsyncSnapshot<RemainingSpace> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),));
          else if (snapshot.hasError) {
            return Center(
              child: Text("No Data Found!"),
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
              return Column(
                children: [
                  ListTile(
                    dense: true,
                    isThreeLine: false,
                    tileColor: kPrimaryColorBlue,
                    title: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Vehicle Type",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white, fontFamily: "PoppinsBold", fontSize: 12.0),
                          ),
                        ),
                        Container(
                          child: Text(
                            "Space",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white, fontFamily: "PoppinsBold", fontSize: 12.0),
                          ),
                        ),
                        Container(
                          child: Text(
                            "Available",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white, fontFamily: "PoppinsBold", fontSize: 12.0),
                          ),
                        ),
                        Container(
                          child: Text(
                            "Edit",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white, fontFamily: "PoppinsBold", fontSize: 12.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Scrollbar(
                    isAlwaysShown: true,
                    controller: _controller,
                    thickness: 3.0,
                    child: ListView.builder(
                        itemCount: snapshot.data.data.length,
                        shrinkWrap: true,
                        reverse: false,
                        controller: _controller,
                        itemBuilder: (BuildContext context, int index) {
                          return new Card(
                            elevation: 2.0,
                            child: Center(
                              child: ListTile(
                                dense: true,
                                isThreeLine: false,
                                title: Wrap(
                                  spacing: 0, // space between two icons
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  alignment: WrapAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Text(snapshot.data.data[index].vehicleType,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontFamily: "PoppinsBold"),
                                      ),
                                      width: 80.0,
                                    ),
                                    Text(snapshot.data.data[index].spacesCount,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontFamily: "PoppinsBold"),
                                    ),
                                    Text(snapshot.data.data[index].availableParkingSpace.toString(),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontFamily: "PoppinsBold"),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) => AddSpace("true", snapshot.data.data[index].id.toString(),
                                                snapshot.data.data[index].vehicleType, snapshot.data.data[index].spacesCount)))
                                            .then((value) => value ? showInSnackBar("Parking Space Save Successfully") : null);
                                      },
                                      icon: Icon(Icons.edit, color: kPrimaryColorBlue),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                    ),
                  ),
                ],
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

}