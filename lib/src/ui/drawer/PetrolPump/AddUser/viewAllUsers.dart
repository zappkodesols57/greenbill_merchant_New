import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/models/model_allUsers.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constants.dart';
import 'addUser.dart';

class ViewAllUsers extends StatefulWidget {
  @override
  ViewAllUsersState createState() => ViewAllUsersState();
}

class ViewAllUsersState extends State<ViewAllUsers> {
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

  Future<AllUsers> list() async {

    final param = {
      "m_business_id": storeID,
      "m_user_id": id,
    };

    final res = await http.post(
      "http://157.230.228.250/merchant-users-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(res.body);
    print(res.statusCode);
    if(200 == res.statusCode){
      print(allUsersFromJson(res.body).data.length);
      return allUsersFromJson(res.body);
    } else{
      throw Exception('Failed to load Users List');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("All Users"),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {Navigator.pop(context);},
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddUser()))
                  .then((value) => value ? showInSnackBar("User Added Successfully") : null);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<AllUsers>(
        future: list(),
        builder: (BuildContext context, AsyncSnapshot<AllUsers> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),));
          else if (snapshot.hasError) {
            return Center(
              child: Text("No Users Found!"),
            );
          } else {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_controller.hasClients) {
                  _controller.animateTo(
                      _controller.position.minScrollExtent,
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
                    controller: _controller,
                    itemBuilder: (BuildContext context, int index) {
                      return new Card(
                        elevation: 2.0,
                        child: Center(
                          child: ListTile(
                            dense: true,
                            title: Text(snapshot.data.data[index].name,
                              style: TextStyle(fontFamily: "PoppinsBold"),
                            ),
                            subtitle: Text("Mob: ${snapshot.data.data[index].mobileNo} . Role: ${snapshot.data.data[index].roleName}"
                                "\nEmail: ${snapshot.data.data[index].email}",),
                            leading: Container(
                              width: 40.0,
                              height: 40.0,
                              decoration: new BoxDecoration(
                                color: Colors.primaries[
                                Random().nextInt(Colors
                                    .primaries.length)],
                                borderRadius:
                                new BorderRadius.circular(
                                    25.0),
                              ),
                              alignment: Alignment.center,
                              child: new Text(snapshot.data.data[index].name.characters.getRange(0,1).toString()
                                    .toUpperCase(),
                                style: TextStyle(
                                  fontSize: 23.0,
                                  color: Colors.white,
                                  fontWeight:
                                  FontWeight.normal,
                                  fontFamily: "PoppinsLight",
                                ),
                              ),
                            ),
                          ),
                        )
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