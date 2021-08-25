import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/ui/drawer/ParkingLotManagement/ManageCharges/add_charges.dart';
import 'package:greenbill_merchant/src/models/model_manageCharges.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ManageCharges extends StatefulWidget {
  @override
  ManageChargesState createState() => ManageChargesState();
}

class ManageChargesState extends State<ManageCharges> {
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

  Future<ManageChargesList> list() async {

    final param = {
      "m_business_id": storeID,
    };

    final res = await http.post(
      "http://157.230.228.250/parking-manage-charges-list-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(res.body);
    print(res.statusCode);
    if(200 == res.statusCode){
      print(manageChargesFromJson(res.body).data.length);
      return manageChargesFromJson(res.body);
    } else{
      throw Exception('Failed to load QR List');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Manage Charges"),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {Navigator.pop(context);},
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddCharges("false", "", "", "", "", "", "")))
                  .then((value) => value ? showInSnackBar("Charges Save Successfully") : null);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<ManageChargesList>(
        future: list(),
        builder: (BuildContext context, AsyncSnapshot<ManageChargesList> snapshot) {
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
              return Scrollbar(
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
                        child: ListTile(
                          dense: true,
                          title: Text(snapshot.data.data[index].vehicleType,
                            style: TextStyle(fontFamily: "PoppinsBold"),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("For Hours: ${snapshot.data.data[index].forHours}",
                                style: TextStyle(fontFamily: "PoppinsBold"),
                              ),
                              Text("Charges: ${snapshot.data.data[index].charges}",
                                style: TextStyle(fontFamily: "PoppinsBold"),
                              ),
                              Text("For Additional Hours: ${snapshot.data.data[index].forAdditionalHours}",
                                style: TextStyle(fontFamily: "PoppinsBold"),
                              ),
                              Text("Additional Hours Charges: ${snapshot.data.data[index].additionalHoursCharges}",
                                style: TextStyle(fontFamily: "PoppinsBold"),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                              icon: Icon(Icons.edit, color: kPrimaryColorBlue,),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => AddCharges("true", snapshot.data.data[index].id.toString(),
                                        snapshot.data.data[index].vehicleType, snapshot.data.data[index].forHours
                                        , snapshot.data.data[index].charges, snapshot.data.data[index].forAdditionalHours
                                        , snapshot.data.data[index].additionalHoursCharges)))
                                    .then((value) => value ? showInSnackBar("Charges Save Successfully") : null);
                              }
                          ),
                        ),
                      );
                    }
                ),
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