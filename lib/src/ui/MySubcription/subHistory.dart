import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_subscriptionHistory.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'newSubFile.dart';
class subHistory extends StatefulWidget {
  @override
  subHistoryState createState() => subHistoryState();
}

class subHistoryState extends State<subHistory> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, busId,userId,mobile;
  final ScrollController _controller = ScrollController();
  TextEditingController query = new TextEditingController();

  @override
  void initState() {
    getCredentials();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    query.dispose();
  }

  getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      userId = prefs.getInt("userID").toString();
      busId =prefs.getString("businessID");
    });
    print('$token\n$busId');
  }

  Future<List<Datum>> getLists() async {
    final param = {
      "user_id": userId,
      "m_business_id": busId,
    };
    final res = await http.post("http://157.230.228.250/get-subscription-recharge-history-details-api/",
        body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"});

    print(res.body);
    print(res.statusCode);
    if (200 == res.statusCode) {
      print(subscriptionHistoryFromJson(res.body).result.length);
      return subscriptionHistoryFromJson(res.body).result;

    } else {
      throw Exception('Failed to load List');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Recharge History"),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => subUpdated()));
          },
        ),
      ),
      body:Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Datum>>(
              future: getLists(),
              builder: (BuildContext context, AsyncSnapshot<List<Datum>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),));
                else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(
                    child: Text("You don’t have any Active Subscription"),
                  );
                } else {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_controller.hasClients) {
                        _controller.animateTo(
                            _controller.position.minScrollExtent,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.fastOutSlowIn);
                      } else {
                        setState(() => null);
                      }
                    });
                    return Scrollbar(
                      isAlwaysShown: true,
                      controller: _controller,
                      thickness: 3.0,
                      child: ListView.builder(
                          itemCount: snapshot.data.length,
                          shrinkWrap: true,
                          reverse: false,
                          controller: _controller,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              width: double.maxFinite,
                              child: InkWell(
                                child: Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          width: size.width * 0.9,
                                          padding: EdgeInsets.only(
                                              top: 10.0, bottom: 5.0, left: 5.0, right: 5.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[

                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 10.0, bottom: 5.0, left: 5.0, right: 5.0),
                                                width: size.width * 0.3,
                                                child: Text(
                                                  "Plan",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12.0,
                                                      fontFamily: "PoppinsBold"),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 10.0, bottom: 5.0, left: 5.0, right: 5.0),
                                                width: size.width * 0.5,
                                                child: Text(
                                                  snapshot.data[index].subType,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: kPrimaryColorBlue,
                                                      fontSize: 12.0,
                                                      fontFamily: "PoppinsBold"),
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: size.width * 0.9,
                                          padding: EdgeInsets.only(
                                              top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[

                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                                width: size.width * 0.3,
                                                child: Text(
                                                  "Payment Mode",

                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12.0,
                                                      fontFamily: "PoppinsBold"),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                                width: size.width * 0.5,
                                                child: Text(
                                                  snapshot.data[index].mode,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: kPrimaryColorBlue,
                                                      fontSize: 12.0,
                                                      fontFamily: "PoppinsBold"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if(snapshot.data[index].modeId == "")
                                        Container(
                                          width: size.width * 0.9,
                                          padding: EdgeInsets.only(
                                              top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[

                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                                width: size.width * 0.3,
                                                child: Text(
                                                  "Transaction Id",

                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12.0,
                                                      fontFamily: "PoppinsBold"),
                                                ),
                                              ),

                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                                width: size.width * 0.5,

                                                child: Text(
                                                  snapshot.data[index].transactionId == "" ? "-------" : snapshot.data[index].transactionId,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: kPrimaryColorBlue,
                                                      fontSize: 12.0,
                                                      fontFamily: "PoppinsBold"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if(snapshot.data[index].modeId != "")
                                        Container(
                                          width: size.width * 0.9,
                                          padding: EdgeInsets.only(
                                              top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[

                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                                width: size.width * 0.3,
                                                child: Text(
                                                  "Payment Id",

                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12.0,
                                                      fontFamily: "PoppinsBold"),
                                                ),
                                              ),

                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                                width: size.width * 0.5,

                                                child: Text(
                                                  snapshot.data[index].modeId,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: kPrimaryColorBlue,
                                                      fontSize: 12.0,
                                                      fontFamily: "PoppinsBold"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: size.width * 0.9,
                                          padding: EdgeInsets.only(
                                              top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[

                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                                width: size.width * 0.3,
                                                child: Text(
                                                  "Amount",

                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12.0,
                                                      fontFamily: "PoppinsBold"),
                                                ),
                                              ),

                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                                width: size.width * 0.5,
                                                child: Text(
                                                    "₹ "+double.parse(snapshot.data[index].amount).toStringAsFixed(3),
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: kPrimaryColorBlue,
                                                      fontSize: 12.0,
                                                      fontFamily: "PoppinsBold"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),


                                        Container(
                                          width: size.width * 0.9,
                                          padding: EdgeInsets.only(
                                              top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[

                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                                width: size.width * 0.3,
                                                child: Text(
                                                  "Purchase Date",

                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12.0,
                                                      fontFamily: "PoppinsBold"),
                                                ),
                                              ),

                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                                width: size.width * 0.5,
                                                child: Text(
                                                  snapshot.data[index].date,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: kPrimaryColorBlue,
                                                      fontSize: 12.0,
                                                      fontFamily: "PoppinsBold"),
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 5.0,),
                                        RaisedButton(
                                            shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                            ),
                                            child: Text("View Invoice",style: TextStyle(color: Colors.white,fontSize: 12.0, fontFamily: "PoppinsBold"),),
                                            color: kPrimaryColorBlue,
                                            onPressed: (){
                                              launch(snapshot.data[index].url);
                                            }),
                                        SizedBox(height: 5.0,),
                                      ],
                                    ),
                                  ),
                                ),
                                // onTap: (){
                                //   launch(snapshot.data[index].url);
                                // },
                              ),
                            );
                          }
                      ),
                    );

                  } else {
                    return Center(child: Text("No Subscriptions Found"));
                  }
                }

              },
            ),
          )

        ],
      ),

    );
  }







}
