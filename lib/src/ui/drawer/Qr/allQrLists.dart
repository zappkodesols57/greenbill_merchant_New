import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_allQr.dart';
import 'package:greenbill_merchant/src/ui/drawer/Qr/addQR.dart';
import 'package:greenbill_merchant/src/ui/drawer/Qr/editQR.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AllQrLists extends StatefulWidget {
  @override
  AllQrListsState createState() => AllQrListsState();
}

class AllQrListsState extends State<AllQrLists> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, id;
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
    });
    print('$token\n$id');
  }

  Future<AllQr> getQrLists() async {

    final param = {
      "user_id": id,
    };

    final res = await http.post(
      "http://157.230.228.250/list-customer-qr-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(res.body);
    print(res.statusCode);
    if(200 == res.statusCode){
      print(allQrFromJson(res.body).data.length);
      return allQrFromJson(res.body);
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
        title: Text('My QR'),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {Navigator.pop(context);},
        ),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddQR()),
              ).then((value) => value ? showInSnackBar("Qr Code Added Successfully") : null);
            },
            child: Text("Add QR"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: FutureBuilder<AllQr>(
        future: getQrLists(),
        builder: (BuildContext context, AsyncSnapshot<AllQr> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),));
          else if (snapshot.hasError) {
            return Center(
              child: Text("No QR Created!"),
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
                    reverse: true,
                    controller: _controller,
                    itemBuilder: (BuildContext context, int index) {
                      return new Card(
                        elevation: 2.0,
                        child: Center(
                          child: ListTile(
                            dense: true,
                            title: Text(
                                snapshot.data.data[index].description,
                                style: TextStyle(fontSize: 15.0)
                            ),
                            subtitle: Text('${snapshot.data.data[index].vehicleType} . ${snapshot.data.data[index].vehicleNo}',
                                style: TextStyle(fontSize: 10.0)) ,
                            leading: Container(
                              width: 35.0,
                              height: 35.0,
                              decoration: new BoxDecoration(
                                color: kPrimaryColorBlue,
                                borderRadius: new BorderRadius.circular(25.0),
                              ),
                              alignment: Alignment.center,
                              child: Icon(Icons.qr_code, color: Colors.white,),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios_sharp, color: Colors.grey),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                  EditQR(snapshot.data.data[index].id.toString(), snapshot.data.data[index].mobileNo, snapshot.data.data[index].description, snapshot.data.data[index].vehicleNo, snapshot.data.data[index].vehicleType)),
                              ).then((value) => value ? showInSnackBar("Qr Code Edited Successfully") : null);
                            },
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