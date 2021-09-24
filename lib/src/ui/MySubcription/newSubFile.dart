import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/animations/hero_dialog_route.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:greenbill_merchant/src/models/model_subscription.dart';
import 'package:greenbill_merchant/src/models/model_subscriptionHistory.dart';
import 'package:greenbill_merchant/src/ui/MySubcription/subHistory.dart';
import 'package:greenbill_merchant/src/ui/drawer/Settings/webView.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'mysub.dart';
class subUpdated extends StatefulWidget {
  @override
  subUpdatedState createState() => subUpdatedState();
}

class subUpdatedState extends State<subUpdated> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, busId,mobile,balanceAmount,balanceAmount2;
  double totalAmountAvail=10;
  int totalSmsAvail=10;
  final ScrollController _controller = ScrollController();
  final ScrollController _controller2 = ScrollController();
  TextEditingController query = new TextEditingController();
  bool _onTapBox1 = true;
  bool _onTapBox2 = false;
  Color _colorMerchantContainer = Colors.white;
  Color _colorMerchantText = kPrimaryColorBlue;
  bool _onTapBox3=false;

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
      busId =prefs.getString("businessID");

    });
    print('$token\n$busId');
    getAmount();
  }

  Future<List<SubscriptionDatum>>getAmount() async {
    final param = {
      "m_business_id":busId,
    };
    final res = await http.post("http://157.230.228.250/merchant-get-subscription-details-api/",
        body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"});
    print(res.body);
    // print(res.statusCode);
    if (200 == res.statusCode) {
      print(subscriptionFromJson(res.body));
      setState(() {
        totalAmountAvail=subscriptionFromJson(res.body).totalAmountAvilable;
        totalSmsAvail=subscriptionFromJson(res.body).totalTransactionalSmsAvilable;
      });




    } else {
      throw Exception('Failed to load List');
    }
  }

  Future<List<SubscriptionDatum>>getLists() async {
    final param = {
      "m_business_id":busId,
    };
    final res = await http.post("http://157.230.228.250/merchant-get-subscription-details-api/",
        body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"});
    print(res.body);
    // print(res.statusCode);
    if (200 == res.statusCode) {
      print(subscriptionFromJson(res.body));


      print(totalAmountAvail);
      return subscriptionFromJson(res.body).subscriptionData;

    } else {
      throw Exception('Failed to load List');
    }
  }

  Future<List<PromotionalSmsDatum>>getBulk() async {
    final param = {
      "m_business_id":busId,
    };
    final res = await http.post("http://157.230.228.250/merchant-get-subscription-details-api/",
        body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"});

    print(res.body);
    print(res.statusCode);
    if (200 == res.statusCode) {
      print(subscriptionFromJson(res.body));
      return subscriptionFromJson(res.body).promotionalSmsData;

    } else {
      throw Exception('Failed to load List');
    }
  }
  Future<List<TransactionalSmsDatum>>getTrans() async {
    final param = {
      "m_business_id":busId,
    };
    final res = await http.post("http://157.230.228.250/merchant-get-subscription-details-api/",
        body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"});

    print(res.body);
    print(res.statusCode);
    if (200 == res.statusCode) {
      print(subscriptionFromJson(res.body));
      return subscriptionFromJson(res.body).transactionalSmsData;

    } else {
      throw Exception('Failed to load List');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: AnimatedContainer(
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          child: RawMaterialButton(
              elevation: 5.0,
              shape:  RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0))),

              onPressed: () async{
                SharedPreferences prefs = await SharedPreferences.getInstance();
                // File file = await downloadPicture(prefs.getString("businessLogo"));
                Navigator.push(context,
                    HeroDialogRoute(builder: (context) => Recharge()));

              },
              fillColor: kPrimaryColorBlue,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                       FontAwesomeIcons.plusCircle,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      "Recharge",
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "PoppinsMedium",
                          fontWeight: FontWeight.bold
                      ),
                    )
                  ],
                )


              ))),
      appBar: AppBar(
        title: Text("Active Subscription"),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body:Column(
        children: <Widget>[
          SizedBox(
            height: 5,
          ),
          Container(
            width: size.width ,
            height: 30,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  child:Container(
                    decoration: BoxDecoration(
                        color: _onTapBox1?kPrimaryColorBlue:_colorMerchantContainer,
                        border: Border.all(color: kPrimaryColorBlue),
                        borderRadius: BorderRadius.all(Radius.circular(40))),
                    width: size.width * 0.30,
                    child: Center(
                        child: Text(
                          'Green Bill',
                          style: TextStyle(color: _onTapBox1?Colors.white :_colorMerchantText),
                        )),
                  ),
                  onTap:(){
                    setState(() {
                      _onTapBox2=false;
                      _onTapBox3=false;
                      _onTapBox1=true;

                    });
                  } ,

                ),
                InkWell(

                  child:Container(
                    decoration: BoxDecoration(
                        color: _onTapBox2?kPrimaryColorBlue:_colorMerchantContainer,
                        border: Border.all(color: kPrimaryColorBlue),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    width: size.width * 0.30,
                    child: Center(
                        child: Text(
                          'Promotional',
                          style: TextStyle(color: _onTapBox2?Colors.white :_colorMerchantText),
                        )),
                  ),
                  onTap:(){
                    setState(() {
                      _onTapBox3=false;
                      _onTapBox1=false;
                      _onTapBox2=true;
                    });
                  } ,
                ),
                InkWell(

                  child:Container(
                    decoration: BoxDecoration(
                        color: _onTapBox3?kPrimaryColorBlue:_colorMerchantContainer,
                        border: Border.all(color: kPrimaryColorBlue),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    width: size.width * 0.30,
                    child: Center(
                        child: Text(
                          'Transactional ',
                          style: TextStyle(color: _onTapBox3?Colors.white :_colorMerchantText),
                        )),
                  ),
                  onTap:(){
                    setState(() {
                      _onTapBox1=false;
                      _onTapBox2=false;
                      _onTapBox3=true;

                    });
                  } ,
                ),

              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          if(_onTapBox1)
          Expanded(
            child: FutureBuilder<List<SubscriptionDatum>>(
              future: getLists(),
              builder: (BuildContext context, AsyncSnapshot<List<SubscriptionDatum>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),));
                else if (snapshot.hasError) {
                  return Center(
                    child: Text("You don’t have any Active Subscription"),
                  );
                }
                else if (snapshot.data.isEmpty) {
                  return Center(
                    child: Text("You don’t have any Active Green Bill Subscription"),
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
                          padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 48),
                          itemCount: snapshot.data.length,
                          shrinkWrap: true,
                          reverse: false,
                          controller: _controller,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              width: double.maxFinite,
                              child: Card(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(topLeft: Radius.elliptical(30, 20),bottomRight:  Radius.elliptical(30, 20)),
                                ),
                                child: Center(
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(height: 10.0,),
                                      Text(snapshot.data[index].subscriptionName,
                                      style: TextStyle(
                                          color: kPrimaryColorBlue,
                                          fontSize: 15.0,
                                          fontFamily: "PoppinsBold"),
                                      ),
                                      Divider(color: kPrimaryColorBlue,),
                                      Container(
                                        width: size.width * 0.9,
                                        padding: EdgeInsets.only(
                                            top: 5.0, bottom: 5.0, left: 5.0, right: 5.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[

                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                              width: size.width * 0.4,
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
                                              width: size.width * 0.4,
                                              child: Text(
                                                snapshot.data[index].purchaseDate,
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
                                              width: size.width * 0.4,
                                              child: Text(
                                                "Expiry Date",
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12.0,
                                                    fontFamily: "PoppinsBold"),
                                              ),
                                            ),

                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                              width: size.width * 0.4,
                                              child: Text(
                                                snapshot.data[index].expiryDate,
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
                                              width: size.width * 0.4,
                                              child: Text(
                                                "Per Bill Cost",

                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12.0,
                                                    fontFamily: "PoppinsBold"),
                                              ),
                                            ),

                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                              width: size.width * 0.4,
                                              child: Text(
                                                "₹ "+snapshot.data[index].perBillCost,
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
                                              width: size.width * 0.4,
                                              child: Text(
                                                "Per digital Bill Cost",

                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12.0,
                                                    fontFamily: "PoppinsBold"),
                                              ),
                                            ),

                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                              width: size.width * 0.4,
                                              child: Text(
                                                "₹ "+snapshot.data[index].perDigitalBillCost,
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
                                              width: size.width * 0.4,
                                              child: Text(
                                                "Recharge Amount",

                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12.0,
                                                    fontFamily: "PoppinsBold"),
                                              ),
                                            ),

                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                              width: size.width * 0.4,
                                              child: Text("₹ "+snapshot.data[index].purchaseCost.toStringAsFixed(2),
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
                                              width: size.width * 0.4,
                                              child: Text(
                                                "Amount Balance",

                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12.0,
                                                    fontFamily: "PoppinsBold"),
                                              ),
                                            ),

                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                              width: size.width * 0.4,
                                              child: Text("₹ "+snapshot.data[index].totalAmountAvilable.toStringAsFixed(2),
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
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }
                      ),
                    );

                  } else {
                    return Center(child: Text("No Subscription Found"));
                  }
                }

              },
            ),
          ),

          if(_onTapBox2)
            Expanded(
              child: FutureBuilder<List<PromotionalSmsDatum>>(
                future: getBulk(),
                builder: (BuildContext context, AsyncSnapshot<List<PromotionalSmsDatum>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),));
                  else if (snapshot.hasError) {
                    return Center(
                      child: Text("You don’t have any Active Promotional SMS Subscription"),
                    );
                  }
                  else if (snapshot.data.isEmpty) {
                    return Center(
                      child: Text("You don’t have any Active Promotional SMS Subscription"),
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
                            padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 48),
                            itemCount: snapshot.data.length,
                            shrinkWrap: true,
                            reverse: false,
                            controller: _controller,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                width: double.maxFinite,
                                child: Card(
                                  elevation: 5.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(topLeft: Radius.elliptical(30, 20),bottomRight:  Radius.elliptical(30, 20)),
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
                                                width: size.width * 0.4,
                                                child: Text(
                                                  "Cost",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12.0,
                                                      fontFamily: "PoppinsBold"),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 10.0, bottom: 5.0, left: 5.0, right: 5.0),
                                                width: size.width * 0.4,
                                                child: Text(
                                                  "₹ "+snapshot.data[index].promotionalSmsPurchaseCost.toStringAsFixed(2),
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
                                                width: size.width * 0.4,
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
                                                width: size.width * 0.4,
                                                child: Text(
                                                  snapshot.data[index].promotionalSmsPurchaseDate,
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
                                                width: size.width * 0.4,
                                                child: Text(
                                                  "Total SMS",

                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12.0,
                                                      fontFamily: "PoppinsBold"),
                                                ),
                                              ),

                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                                width: size.width * 0.4,
                                                child: Text(
                                                  snapshot.data[index].promotionalSmsTotalSms.toString(),
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
                                                width: size.width * 0.4,
                                                child: Text(
                                                  "Per SMS Cost",

                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12.0,
                                                      fontFamily: "PoppinsBold"),
                                                ),
                                              ),

                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                                width: size.width * 0.4,
                                                child: Text(
                                                  "₹ "+snapshot.data[index].promotionalSmsPerSmsCost,
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
                                                width: size.width * 0.4,
                                                child: Text(
                                                  "SMS Balance",

                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12.0,
                                                      fontFamily: "PoppinsBold"),
                                                ),
                                              ),

                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                                width: size.width * 0.4,
                                                child: Text(
                                                  snapshot.data[index].promotionalSmsTotalSmsAvilable.toString(),
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

                                      ],
                                    ),
                                  ),
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
            ),
          if(_onTapBox3)
            Expanded(
              child: FutureBuilder<List<TransactionalSmsDatum>>(
                future: getTrans(),
                builder: (BuildContext context, AsyncSnapshot<List<TransactionalSmsDatum>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),));
                  else if (snapshot.hasError) {
                    return Center(
                      child: Text("You don’t have any Active Subscription"),
                    );
                  }
                  else if (snapshot.data.isEmpty) {
                    return Center(
                      child: Text("You don’t have any Active Transactional SMS Subscription"),
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
                            padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 48),
                            itemCount: snapshot.data.length,
                            shrinkWrap: true,
                            reverse: false,
                            controller: _controller,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                width: double.maxFinite,
                                child: Card(
                                  elevation: 5.0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(topLeft: Radius.elliptical(30, 20),bottomRight:  Radius.elliptical(30, 20)),
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
                                                width: size.width * 0.4,
                                                child: Text(
                                                  "Cost",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12.0,
                                                      fontFamily: "PoppinsBold"),
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                                width: size.width * 0.4,
                                                child: Text(
                                                  "₹ "+snapshot.data[index].transactionalSmsPurchaseCost.toString(),
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
                                                width: size.width * 0.4,
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
                                                width: size.width * 0.4,
                                                child: Text(
                                                  snapshot.data[index].transactionalSmsPurchaseDate,
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
                                                width: size.width * 0.4,
                                                child: Text(
                                                  "Total SMS",

                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12.0,
                                                      fontFamily: "PoppinsBold"),
                                                ),
                                              ),

                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                                width: size.width * 0.4,
                                                child: Text(
                                                  snapshot.data[index].transactionalSmsTotalSms.toString(),
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
                                                width: size.width * 0.4,
                                                child: Text(
                                                  "Per SMS Cost",

                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12.0,
                                                      fontFamily: "PoppinsBold"),
                                                ),
                                              ),

                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                                width: size.width * 0.4,
                                                child: Text(
                                                  "₹ "+snapshot.data[index].transactionalSmsPerSmsCost,
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
                                                width: size.width * 0.4,
                                                child: Text(
                                                  "SMS Balance",

                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12.0,
                                                      fontFamily: "PoppinsBold"),
                                                ),
                                              ),

                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                                width: size.width * 0.4,
                                                child: Text(
                                                  snapshot.data[index].transactionalSmsTotalSmsAvilable.toStringAsFixed(2),
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

                                      ],
                                    ),
                                  ),
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
            ),

               ],
             ),
         );
  }


  Widget _buildPopupDialog(BuildContext context, SubscriptionDatum data) {

    return new AlertDialog(

      title: Text("Green Bill Subscription Details",style: TextStyle(
          color: kPrimaryColorBlue,
          fontSize: 15.0,
          fontFamily: "PoppinsBold"),),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 60,
            width: double.maxFinite,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),),
              child: Center(
                child: Column(
                  children: <Widget>[

                    Container(
                      //width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                          top: 10.0, bottom: 0.0, left: 5.0, right: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "₹ "+data.purchaseCost.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontFamily: "PoppinsBold"),
                          ),

                        ],


                      ),

                    ),

                  ],),

              ),
              color: kPrimaryColorBlue,
            ),
          ),


          Container(
            //width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                top: 10.0, bottom: 5.0, left: 5.0, right: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  //width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(
                    "Subscription Name",

                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: "PoppinsBold"),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  // width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(
                    data.subscriptionName,
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
            //width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  //width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(
                    "Recharge  Amount",

                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: "PoppinsBold"),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  // width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(
                    "₹ "+data.purchaseCost.toString()+".00",
                    textAlign: TextAlign.end,
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
            //width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  //width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(
                    "Per Bill  Cost",

                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: "PoppinsBold"),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  // width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(
                    "₹ "+data.perBillCost+".00",
                    textAlign: TextAlign.end,
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
            //width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  //width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(
                    "Per Digital Bill Cost",

                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: "PoppinsBold"),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  // width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(
                    "₹ "+data.perDigitalBillCost+".00",
                    textAlign: TextAlign.end,
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
            //width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  //width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(
                    "Per Receipt Cost",

                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: "PoppinsBold"),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  // width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(
                    "₹ "+data.perReceiptCost+".00",
                    textAlign: TextAlign.end,
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
            //width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  //width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(
                    "Per Digital Receipt Cost",

                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: "PoppinsBold"),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  // width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(
                    "₹ "+data.perDigitalReceiptCost+".00",
                    textAlign: TextAlign.end,
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
            //width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  //width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(
                    "Per Cash Memo Cost",

                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: "PoppinsBold"),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  // width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(
                    "₹ "+data.perCashMemoCost+".00",
                    textAlign: TextAlign.end,
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
            //width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  //width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(
                    "Per Digital CashMemo Cost",

                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: "PoppinsBold"),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  // width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(
                    "₹ "+data.perDigitalCashMemoCost+".00",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: kPrimaryColorBlue,
                        fontSize: 12.0,
                        fontFamily: "PoppinsBold"),
                  ),
                ),
              ],
            ),
          ),



        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }



  Widget _buildPopupForSms(BuildContext context, PromotionalSmsDatum data) {

    return new AlertDialog(
      title: Text("Bulk SMS Plans",style: TextStyle(
          color: kPrimaryColorBlue,
          fontSize: 15.0,
          fontFamily: "PoppinsBold"
      ),),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          Container(
            height: 60,
            width: double.maxFinite,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),),
              child: Center(
                child: Column(
                  children: <Widget>[

                    Container(
                      //width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                          top: 10.0, bottom: 0.0, left: 5.0, right: 5.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            "₹ "+data.promotionalSmsPurchaseCost.toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontFamily: "PoppinsBold"),
                          ),

                        ],


                      ),

                    ),

                  ],),

              ),
              color: kPrimaryColorBlue,
            ),
          ),

          Container(
            //width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                top: 10.0, bottom: 5.0, left: 5.0, right: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  //width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(
                    "Subscription Name",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: "PoppinsBold"),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  // width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(
                    data.promotionalSmsSubscriptionName,
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
            //width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  //width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(
                    "Total Amount",

                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: "PoppinsBold"),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  // width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(
                    "₹"+data.promotionalSmsPurchaseCost.toString()+".00",
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
            //width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  //width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(
                    "Total SMS",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: "PoppinsBold"),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  // width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(
                    data.promotionalSmsTotalSms.toString()+" SMS",
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
            //width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(
                top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  //width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(
                    "Per SMS Cost",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: "PoppinsBold"),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  // width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(
                    "₹"+data.promotionalSmsPerSmsCost+".00",
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



        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }
}
