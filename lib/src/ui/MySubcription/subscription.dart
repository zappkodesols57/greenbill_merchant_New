import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:greenbill_merchant/src/models/model_bulkSmsSubscription.dart';
import 'package:greenbill_merchant/src/models/model_getsubplan.dart';
import 'package:greenbill_merchant/src/models/model_subscription.dart';
import 'package:greenbill_merchant/src/ui/drawer/Settings/webView.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class MySub extends StatefulWidget {
  @override
  MySubState createState() => MySubState();
}
class MySubState extends State<MySub> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, busId,mobile;
  final ScrollController _controller = ScrollController();
  final ScrollController _controller2 = ScrollController();

  TextEditingController query = new TextEditingController();
  String _chosenValue="Green Bill Subscription Plan";
  bool _isCategory = true;
  bool _onTapBox1 = true;
  bool _onTapBox2 = false;

  PageController _pageController = PageController(
    initialPage: 0,
  );
  int _currentIndex;
  int _colorChange;
  bool _isSub = true;

  Color _colorCategoryContainer = kPrimaryColorBlue;
  Color _colorMerchantContainer = Colors.white;
  Color _colorTagContainer = Colors.white;
  Color _colorCategoryText = Colors.white;
  Color _colorMerchantText = kPrimaryColorBlue;
  Color _colorTagText = kPrimaryColorBlue;
  @override
  void initState() {
    getCredentials();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _controller2.dispose();
    query.dispose();
  }

  getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      busId =prefs.getString("businessID");
    });
    print('$token\n$busId');
  }

  Future<List<SubscriptionDatum>>getLists() async {
    final param = {
      "m_business_id":busId,
    };
    final res = await http.post("http://157.230.228.250/merchant-get-subscription-details-api/",
        body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"});

    //print(res.body);
   // print(res.statusCode);
    if (200 == res.statusCode) {
      print(subscriptionFromJson(res.body));
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
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      body:Column(
        children: [
          SizedBox(
            height: 5,
          ),
          Container(
            width: size.width * 0.99,
            height: 50,
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
                  width: size.width * 0.45,
                  child: Center(
                      child: Text(
                        'Green Bill Plans',
                        style: TextStyle(color: _onTapBox1?Colors.white :_colorMerchantText),
                      )),
                ),
               onTap:(){
                 setState(() {
                   _isSub=true;
                   _onTapBox2=false;
                   _onTapBox1=true;

                 });
               } ,

             ),
              InkWell(

               child:Container(
                    decoration: BoxDecoration(
                        color: _onTapBox2?kPrimaryColorBlue:_colorMerchantContainer,
                        border: Border.all(color: kPrimaryColorBlue),
                        borderRadius: BorderRadius.all(Radius.circular(40))),
                    width: size.width * 0.45,
                    child: Center(
                        child: Text(
                          'Promotional SMS Plans',
                          style: TextStyle(color: _onTapBox2?Colors.white :_colorMerchantText),
                        )),
                  ),
                onTap:(){
                 setState(() {
                   _onTapBox1=false;
                   _onTapBox2=true;
                   _isSub=false;
                 });
                } ,
              ),

              ],
            ),
          ),
          SizedBox(
            height: 5,
          ),
          _isSub?Expanded(
            child: FutureBuilder<List<SubscriptionDatum>>(
              future: getLists(),
              builder: (BuildContext context, AsyncSnapshot<List<SubscriptionDatum>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),));
                else if (snapshot.hasError) {
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
                              child: Card(
                                color: kPrimaryColorBlue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0),
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
                                              "Subscription Name",

                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.0,
                                                  fontFamily: "PoppinsBold"),
                                            ),
                                          ),

                                         Container(
                                           padding: EdgeInsets.only(
                                               top: 10.0, bottom: 5.0, left: 5.0, right: 5.0),
                                          width: size.width * 0.4,
                                          child: Text(
                                              snapshot.data[index].subscriptionName,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Colors.white,
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
                                                    color: Colors.white,
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
                                                    color: Colors.white,
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
                                                "Purchase Cost",

                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                    fontFamily: "PoppinsBold"),
                                              ),
                                            ),

                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                              width: size.width * 0.4,
                                              child: Text(
                                                "₹ "+snapshot.data[index].purchaseCost.toString()+".00",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
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
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                    fontFamily: "PoppinsBold"),
                                              ),
                                            ),

                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                              width: size.width * 0.4,
                                              child: Text(
                                                "₹ "+snapshot.data[index].perBillCost.toString()+".00",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
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
                                                "Per Digital Bill Cost",

                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                    fontFamily: "PoppinsBold"),
                                              ),
                                            ),

                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                              width: size.width * 0.4,
                                              child: Text(
                                                "₹ "+snapshot.data[index].perDigitalBillCost.toString()+".00",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
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
                                                "Per Receipt Cost",

                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                    fontFamily: "PoppinsBold"),
                                              ),
                                            ),

                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                              width: size.width * 0.4,
                                              child: Text(
                                                "₹ "+snapshot.data[index].perReceiptCost.toString()+".00",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
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
                                                "Per Digital Receipt Cost",

                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                    fontFamily: "PoppinsBold"),
                                              ),
                                            ),

                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                              width: size.width * 0.4,
                                              child: Text(
                                                "₹ "+snapshot.data[index].perDigitalReceiptCost.toString()+".00",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
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
                                                "Per Cash Memo Cost",

                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                    fontFamily: "PoppinsBold"),
                                              ),
                                            ),

                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                              width: size.width * 0.4,
                                              child: Text(
                                                "₹ "+snapshot.data[index].perCashMemoCost.toString()+".00",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
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
                                                "Per Digital Cash Memo Cost",

                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                    fontFamily: "PoppinsBold"),
                                              ),
                                            ),

                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                              width: size.width * 0.4,
                                              child: Text(
                                                "₹ "+snapshot.data[index].perDigitalCashMemoCost.toString()+".00",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                    fontFamily: "PoppinsBold"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(thickness: 1,
                                          color: Colors.white,height: 10, indent: 10,
                                          endIndent: 10),

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
                                                "Total Amount Available",

                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                    fontFamily: "PoppinsBold"),
                                              ),
                                            ),

                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                              width: size.width * 0.4,
                                              child: Text(
                                                "₹ "+snapshot.data[index].totalAmountAvilable.toString()+"0",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
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
                                                    color: Colors.white,
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
                                                    color: Colors.white,
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
                    return Center(child: Text("No Data Found"));
                  }
                }

              },
            ),
          ):
          Expanded(

            child: FutureBuilder<List<PromotionalSmsDatum>>(
              future: getBulk(),
              builder: (BuildContext context, AsyncSnapshot<List<PromotionalSmsDatum>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),));
                else if (snapshot.hasError) {
                  return Center(
                    child: Text("You don’t have any Active Subscription"),
                  );
                } else {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_controller2.hasClients) {
                        _controller2.animateTo(
                            _controller2.position.minScrollExtent,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.fastOutSlowIn);
                      } else {
                        setState(() => null);
                      }
                    });
                    return Scrollbar(
                      isAlwaysShown: true,
                      controller: _controller2,
                      thickness: 3.0,
                      child: ListView.builder(
                          itemCount: snapshot.data.length,
                          shrinkWrap: true,
                          reverse: false,
                          controller: _controller2,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              width: double.maxFinite,
                              child: Card(
                                color: kPrimaryColorBlue,
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
                                              width: size.width * 0.4,
                                              child: Text(
                                                "Subscription Name",

                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                    fontFamily: "PoppinsBold"),
                                              ),
                                            ),

                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 10.0, bottom: 5.0, left: 5.0, right: 5.0),
                                              width: size.width * 0.4,
                                              child: Text(
                                                snapshot.data[index].promotionalSmsSubscriptionName,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
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
                                                    color: Colors.white,
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
                                                    color: Colors.white,
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
                                                "Purchase Cost",

                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                    fontFamily: "PoppinsBold"),
                                              ),
                                            ),

                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                              width: size.width * 0.4,
                                              child: Text(
                                                "₹ "+snapshot.data[index].promotionalSmsPurchaseCost.toString()+"0",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
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
                                                "Per Bulk SMS Cost",

                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                    fontFamily: "PoppinsBold"),
                                              ),
                                            ),

                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                              width: size.width * 0.4,
                                              child: Text(
                                                "₹ "+snapshot.data[index].promotionalSmsPerSmsCost.toString()+".00",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                    fontFamily: "PoppinsBold"),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Divider(thickness: 1,
                                          color: Colors.white,height: 10, indent: 10,
                                          endIndent: 10),

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
                                                    color: Colors.white,
                                                    fontSize: 12.0,
                                                    fontFamily: "PoppinsBold"),
                                              ),
                                            ),

                                            Container(
                                              padding: EdgeInsets.only(
                                                  top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                              width: size.width * 0.4,
                                              child: Text(
                                                snapshot.data[index].promotionalSmsTotalSms,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.white,
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
                                                "Available Bulk SMS",

                                                style: TextStyle(
                                                    color: Colors.white,
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
                                                    color: Colors.white,
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
                    return Center(child: Text("No Data Found"));
                  }
                }

              },
            ),

          ),
              ],
            ),





    );

  }

  Widget _buildPopupDialog(BuildContext context, Datum data) {

    return new AlertDialog(
      title: Text(data.subscriptionName),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(

            child: Row(

            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: EdgeInsets.only(
                top: 10.0, bottom: 5.0, left: 5.0, right: 5.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                Container(
                  padding: EdgeInsets.only(
                      top: 10.0, bottom: 5.0, left: 5.0, right: 5.0),
                  width: MediaQuery.of(context).size.width * 0.4,
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
                      top: 10.0, bottom: 5.0, left: 5.0, right: 5.0),
                  width: MediaQuery.of(context).size.width * 0.4,
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
            padding: EdgeInsets.only(
                top: 10.0, bottom: 5.0, left: 5.0, right: 5.0),


            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[

                  Text(
                    "Subscription Name",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    "Total Amount",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                ]
            ),

          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.01,
          ),
          Container(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[

                  Text(
                    data.subscriptionName,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: "PoppinsBold"),
                  ),
                  Text(
                    "₹"+data.rechargeAmount,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: "PoppinsBold"),
                  ),
                ]
            ),

          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ),
          Container(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[

                  Text(
                    "Per Bill Cost",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    "Per Digital Bill Cost",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                ]
            ),

          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.01,
          ),
          Container(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[

                  Text(
                    "₹"+data.perBillCost,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: "PoppinsBold"),
                  ),
                  Text(
                    "₹"+data.perDigitalBillCost,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: "PoppinsBold"),
                  ),
                ]
            ),

          ),

          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ),
          Container(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[

                  Text(
                    "Per Receipt Cost",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    "Per Digital Receipt Cost",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                ]
            ),

          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.01,
          ),
          Container(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[

                  Text(
                    "₹"+data.perReceiptCost,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: "PoppinsBold"),
                  ),
                  Text(
                    "₹"+data.perDigitalReceiptCost,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: "PoppinsBold"),
                  ),
                ]
            ),

          ),

          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ),
          Container(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[

                  Text("Per CashMemo Cost",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    "Per Digital CashMemo Cost",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                ]
            ),

          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.01,
          ),
          Container(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[

                  Text(
                    "₹"+data.perCashMemoCost,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: "PoppinsBold"),
                  ),
                  Text(
                    "₹"+data.perDigitalCashMemoCost,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: "PoppinsBold"),
                  ),
                ]
            ),

          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ),
          Container(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[

                  Text("(Software Maintainance Cost :"+"₹"+
                      data.softwareMaintainaceCost+")",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.0,
                        fontFamily: "PoppinsBold"),
                  ),

                ]
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



  Widget _buildPopupForSms(BuildContext context, Datu data) {

    return new AlertDialog(
      title: Text(data.subscriptionName),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[

                  Text(
                    "Subscription Name",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    "Total Amount",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                ]
            ),

          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.01,
          ),
          Container(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[

                  Text(
                    data.subscriptionName,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: "PoppinsBold"),
                  ),
                  Text(
                    "₹"+data.totalSmsCost,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: "PoppinsBold"),
                  ),
                ]
            ),

          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.03,
          ),
          Container(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[

                  Text(
                    "Total SMS",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                  Text(
                    "Per SMS Cost",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 12.0,
                    ),
                  ),
                ]
            ),

          ),
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.01,
          ),
          Container(
            child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[

                  Text(
                    data.totalSms,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: "PoppinsBold"),
                  ),
                  Text(
                    "₹"+data.perSmsCost,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 12.0,
                        fontFamily: "PoppinsBold"),
                  ),
                ]
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




  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white, fontSize: 16.0, fontFamily: "PoppinsMedium"),
      ),
      backgroundColor: kPrimaryColorBlue,
      duration: Duration(seconds: 2),
    ));
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
                  )));
        });
  }


}
