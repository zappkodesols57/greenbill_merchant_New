import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("My Subscription"),
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
          Container(
           child: Scrollbar(isAlwaysShown: true,
           controller: _controller,
           thickness: 3.0,
           child: Container(
            padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
            width: double.maxFinite,
             child:Column(
               children: <Widget>[
                 Container(
                   width: size.width,
                   child: Row(
                     children: [
                       Container(
                         child:Card(
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(10.0),
                           ),
                           elevation:10,
                           child:Container(
                             width: size.width * 0.45,
                             padding: EdgeInsets.only(
                                 top: 10.0, bottom: 5.0, left: 0.0, right: 0.0),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.center,
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: <Widget>[
                                 Container(
                                   alignment: Alignment.center,
                                   width: size.width * 0.4,
                                   child: Text(
                                     "Subscription Balance",
                                     style: TextStyle(
                                         color: kPrimaryColorBlue,
                                         fontSize: 14.0,
                                         fontFamily: "PoppinsBold"),
                                   ),
                                 ),
                                 Divider(thickness: 1,
                                     color: Colors.black,height: 10, indent: 0,
                                     endIndent: 0),
                                 Container(
                                   padding: EdgeInsets.only(
                                       top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                                   alignment: Alignment.topLeft,
                                   width: size.width * 0.4,
                                   child: Text("Green Bill Subscription"
                                     ,
                                     style: TextStyle(
                                         color: kPrimaryColorBlue,
                                         fontSize: 12.0,
                                         fontFamily: "PoppinsLight"),
                                   ),
                                 ),
                                 Container(
                                   alignment: Alignment.centerLeft,
                                   padding: EdgeInsets.only(
                                       top: 0.0, bottom: 0.0, left: 10.0, right: 0.0),
                                   child: Text("Amount Balance : "+"₹ "+totalAmountAvail.toString()+"0"
                                     ,
                                     style: TextStyle(
                                         color: Colors.black,
                                         fontSize: 12.0,
                                         fontFamily: "PoppinsLight"),
                                   ),
                                 ),
                                 Container(
                                   child: Row(
                                     children:<Widget> [
                                       Container(
                                         alignment: Alignment.centerLeft,
                                         padding: EdgeInsets.only(
                                             top: 0.0, bottom: 0.0, left: 10.0, right: 0.0),
                                         child: Text("Check Usages"
                                           ,
                                           style: TextStyle(
                                               color: Colors.black,
                                               fontSize: 12.0,
                                               fontFamily: "PoppinsLight"),
                                         ),
                                       ),
                                       Container(
                                           alignment: Alignment.topRight,
                                           padding: EdgeInsets.only(
                                               top: 0.0, bottom: 0.0, left: 10.0, right: 0.0),
                                           child: IconButton(

                                             icon: const Icon(Icons.arrow_forward_ios),
                                             color: kPrimaryColorBlue,
                                             onPressed: () {},
                                           )
                                       ),
                                     ],
                                   ),
                                 )
                               ],),
                           ),

                         ),
                       ),
                       Container(
                         child:Card(
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(10.0),
                           ),
                           elevation:10,
                           child:Container(
                             width: size.width * 0.45,
                             padding: EdgeInsets.only(
                                 top: 10.0, bottom: 5.0, left: 0.0, right: 0.0),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.center,
                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                               children: <Widget>[
                                 Container(
                                   alignment: Alignment.center,
                                   width: size.width * 0.4,
                                   child: Text(
                                     "SMS Plan Balance",
                                     style: TextStyle(
                                         color: kPrimaryColorBlue,
                                         fontSize: 14.0,
                                         fontFamily: "PoppinsBold"),
                                   ),
                                 ),
                                 Divider(thickness: 1,
                                     color: Colors.black,height: 10, indent: 0,
                                     endIndent: 0),
                                 Container(
                                   padding: EdgeInsets.only(
                                       top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                                   alignment: Alignment.topLeft,
                                   width: size.width * 0.4,
                                   child: Text("Bulk SMS Subscription",
                                     style: TextStyle(
                                         color: kPrimaryColorBlue,
                                         fontSize: 12.0,
                                         fontFamily: "PoppinsLight"),
                                   ),
                                 ),
                                 Container(
                                   alignment: Alignment.centerLeft,
                                   padding: EdgeInsets.only(
                                       top: 0.0, bottom: 0.0, left: 10.0, right: 0.0),
                                   child: Text("SMS Balance : "+totalSmsAvail.toString()
                                     ,
                                     style: TextStyle(
                                         color: Colors.black,
                                         fontSize: 12.0,
                                         fontFamily: "PoppinsLight"),
                                   ),
                                 ),
                                 Container(
                                   child: Row(
                                     children:<Widget> [
                                       Container(
                                         alignment: Alignment.centerLeft,
                                         padding: EdgeInsets.only(
                                             top: 0.0, bottom: 0.0, left: 10.0, right: 0.0),
                                         child: Text("Check Usages"
                                           ,
                                           style: TextStyle(
                                               color: Colors.black,
                                               fontSize: 12.0,
                                               fontFamily: "PoppinsLight"),
                                         ),
                                       ),
                                       Container(
                                           alignment: Alignment.topRight,
                                           padding: EdgeInsets.only(
                                               top: 0.0, bottom: 0.0, left: 10.0, right: 0.0),
                                           child: IconButton(

                                             icon: const Icon(Icons.arrow_forward_ios),
                                             color: kPrimaryColorBlue,
                                             onPressed: () {},
                                           )
                                       ),
                                     ],
                                   ),
                                 )
                               ],),
                           ),

                         ),
                       ),
                     ],
                   ),
                 ),
                 Container(
                   width: size.width,
                   child: Column(
                       children: [
                         Container(
                           width: size.width ,
                           child: Card(
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(10.0),
                             ),
                             elevation:10,
                             child:Container(
                               child: Column(
                                 children: <Widget>[
                                   Container(
                                     padding: EdgeInsets.only(
                                         top: 10.0, bottom: 10.0, left: 10.0, right: 10.0),
                                     alignment: Alignment.centerLeft,
                                     child:Text(
                                       "My Plans :",
                                       style: TextStyle(
                                           color:kPrimaryColorBlue,
                                           fontSize: 20.0,
                                           fontFamily: "PoppinsBold"),
                                     ),
                                   ),
                                   Container(
                                     child: Row(
                                       children: <Widget>[
                                         Container(
                                           width: size.width * 0.45,
                                           child:FutureBuilder<List<SubscriptionDatum>>(
                                             future: getLists(),
                                             builder: (BuildContext context, AsyncSnapshot<List<SubscriptionDatum>> snapshot) {
                                               if (snapshot.connectionState == ConnectionState.waiting)
                                                 return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),));
                                               else if (snapshot.hasError ||snapshot.data.isEmpty) {
                                                 print(snapshot.hasError);
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
                                                     child:ListView.builder(
                                                         itemCount: snapshot.data.length,
                                                         shrinkWrap: true,
                                                         reverse: false,
                                                         controller: _controller,
                                                         itemBuilder: (BuildContext context, int index) {
                                                           return Container(padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                                             width: double.maxFinite,
                                                             child:Container(
                                                               width: size.width * 0.45,
                                                               padding: EdgeInsets.only(
                                                                   top: 0.0, bottom: 5.0, left: 0.0, right: 0.0),
                                                               child: Column(
                                                                 crossAxisAlignment: CrossAxisAlignment.center,
                                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                 children: <Widget>[
                                                                   Container(
                                                                     alignment: Alignment.centerLeft,
                                                                     width: size.width * 0.4,
                                                                     child: Text(
                                                                       "Green Bill Plans",
                                                                       style: TextStyle(
                                                                           color: kPrimaryColorBlue,
                                                                           fontSize: 14.0,
                                                                           fontFamily: "PoppinsBold"),
                                                                     ),
                                                                   ),
                                                                   Divider(thickness: 1,
                                                                       color: Colors.black,height: 10, indent: 0,
                                                                       endIndent: 0),

                                                                   Container(
                                                                     alignment: Alignment.centerLeft,
                                                                     padding: EdgeInsets.only(
                                                                         top: 0.0, bottom: 0.0, left: 10.0, right: 0.0),
                                                                     child: Text("Plan Name : "+ snapshot.data[index].subscriptionName
                                                                       ,
                                                                       style: TextStyle(
                                                                           color: Colors.black,
                                                                           fontSize: 12.0,
                                                                           fontFamily: "PoppinsLight"),
                                                                     ),
                                                                   ),
                                                                   Container(
                                                                     alignment: Alignment.centerLeft,
                                                                     padding: EdgeInsets.only(
                                                                         top: 0.0, bottom: 0.0, left: 10.0, right: 0.0),
                                                                     child: Text("Amount : " +"₹ "+snapshot.data[index].purchaseCost.toString()+"0"
                                                                       ,
                                                                       style: TextStyle(
                                                                           color: Colors.black,
                                                                           fontSize: 12.0,
                                                                           fontFamily: "PoppinsLight"),
                                                                     ),
                                                                   ),
                                                                   Container(
                                                                     alignment: Alignment.centerLeft,
                                                                     padding: EdgeInsets.only(
                                                                         top: 0.0, bottom: 0.0, left: 10.0, right: 0.0),
                                                                     child: Text("Expires On : "+snapshot.data[index].expiryDate.toString()
                                                                       ,
                                                                       style: TextStyle(
                                                                           color: Colors.black,
                                                                           fontSize: 12.0,
                                                                           fontFamily: "PoppinsLight"),
                                                                     ),
                                                                   ),
                                                                   Container(
                                                                     child: Row(
                                                                       children:<Widget> [
                                                                         Container(
                                                                           alignment: Alignment.centerLeft,
                                                                           padding: EdgeInsets.only(
                                                                               top: 0.0, bottom: 0.0, left: 10.0, right: 0.0),
                                                                           child: Text("View Details"
                                                                             ,
                                                                             style: TextStyle(
                                                                                 color: Colors.black,
                                                                                 fontSize: 12.0,
                                                                                 fontFamily: "PoppinsLight"),
                                                                           ),
                                                                         ),
                                                                         Container(
                                                                             alignment: Alignment.topRight,
                                                                             padding: EdgeInsets.only(
                                                                                 top: 0.0, bottom: 0.0, left: 10.0, right: 0.0),
                                                                             child: IconButton(

                                                                               icon: const Icon(Icons.arrow_forward_ios),
                                                                               color: kPrimaryColorBlue,
                                                                               onPressed: () {
                                                                                 showDialog(
                                                                                   context: context,
                                                                                   builder: (BuildContext context) => _buildPopupDialog(context,snapshot.data[index]),
                                                                                 );
                                                                               },
                                                                             )
                                                                         ),
                                                                       ],
                                                                     ),
                                                                   )
                                                                 ],),
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
                                         Container(
                                           width: size.width * 0.45,
                                           child:FutureBuilder<List<PromotionalSmsDatum>>(
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
                                                     child:ListView.builder(
                                                         itemCount: snapshot.data.length,
                                                         shrinkWrap: true,
                                                         reverse: false,
                                                         controller: _controller,
                                                         itemBuilder: (BuildContext context, int index) {
                                                           return Container(padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                                             width: double.maxFinite,
                                                             child:Container(
                                                               width: size.width * 0.45,
                                                               padding: EdgeInsets.only(
                                                                   top: 0.0, bottom: 5.0, left: 0.0, right: 0.0),
                                                               child: Column(
                                                                 crossAxisAlignment: CrossAxisAlignment.center,
                                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                 children: <Widget>[
                                                                   Container(
                                                                     alignment: Alignment.centerLeft,
                                                                     width: size.width * 0.4,
                                                                     child: Text(
                                                                       "Bulk SMS Plans",
                                                                       style: TextStyle(
                                                                           color: kPrimaryColorBlue,
                                                                           fontSize: 14.0,
                                                                           fontFamily: "PoppinsBold"),
                                                                     ),
                                                                   ),
                                                                   Divider(thickness: 1,
                                                                       color: Colors.black,height: 10, indent: 0,
                                                                       endIndent: 0),

                                                                   Container(
                                                                     alignment: Alignment.centerLeft,
                                                                     padding: EdgeInsets.only(
                                                                         top: 0.0, bottom: 0.0, left: 10.0, right: 0.0),
                                                                     child: Text("Plan Name : "+ snapshot.data[index].promotionalSmsSubscriptionName
                                                                       ,
                                                                       style: TextStyle(
                                                                           color: Colors.black,
                                                                           fontSize: 12.0,
                                                                           fontFamily: "PoppinsLight"),
                                                                     ),
                                                                   ),
                                                                   Container(
                                                                     alignment: Alignment.centerLeft,
                                                                     padding: EdgeInsets.only(
                                                                         top: 0.0, bottom: 0.0, left: 10.0, right: 0.0),
                                                                     child: Text("Amount : " +"₹ "+snapshot.data[index].promotionalSmsPurchaseCost.toString()+"0"
                                                                       ,
                                                                       style: TextStyle(
                                                                           color: Colors.black,
                                                                           fontSize: 12.0,
                                                                           fontFamily: "PoppinsLight"),
                                                                     ),
                                                                   ),
                                                                   Container(
                                                                     alignment: Alignment.centerLeft,
                                                                     padding: EdgeInsets.only(
                                                                         top: 0.0, bottom: 0.0, left: 10.0, right: 0.0),
                                                                     child: Text("Purchase On :"+snapshot.data[index].promotionalSmsPurchaseDate.toString()
                                                                       ,
                                                                       style: TextStyle(
                                                                           color: Colors.black,
                                                                           fontSize: 12.0,
                                                                           fontFamily: "PoppinsLight"),
                                                                     ),
                                                                   ),
                                                                   Container(
                                                                     child: Row(
                                                                       children:<Widget> [
                                                                         Container(
                                                                           alignment: Alignment.centerLeft,
                                                                           padding: EdgeInsets.only(
                                                                               top: 0.0, bottom: 0.0, left: 10.0, right: 0.0),
                                                                           child: Text("View Details"
                                                                             ,
                                                                             style: TextStyle(
                                                                                 color: Colors.black,
                                                                                 fontSize: 12.0,
                                                                                 fontFamily: "PoppinsLight"),
                                                                           ),
                                                                         ),
                                                                         Container(
                                                                             alignment: Alignment.topRight,
                                                                             padding: EdgeInsets.only(
                                                                                 top: 0.0, bottom: 0.0, left: 10.0, right: 0.0),
                                                                             child: IconButton(

                                                                               icon: const Icon(Icons.arrow_forward_ios),
                                                                               color: kPrimaryColorBlue,
                                                                               onPressed: () {
                                                                                 showDialog(
                                                                                   context: context,
                                                                                   builder: (BuildContext context) => _buildPopupForSms(context,snapshot.data[index]),
                                                                                 );
                                                                               },
                                                                             )
                                                                         ),
                                                                       ],
                                                                     ),
                                                                   )
                                                                 ],),
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
                                   ),
                                 ],
                               ),

                             ),

                         ),
                         ),
                       ],),
                 ),
                 Container(
                   child:Card(
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(10.0),
                     ),
                     elevation:10,
                     child:Container(
                       width: size.width ,
                       padding: EdgeInsets.only(
                           top: 10.0, bottom: 5.0, left: 0.0, right: 0.0),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.center,
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: <Widget>[
                           Container(
                             alignment: Alignment.center,
                             width: size.width * 0.4,
                             child: Text(
                               "Recharge",
                               style: TextStyle(
                                   color: kPrimaryColorBlue,
                                   fontSize: 20.0,
                                   fontFamily: "PoppinsBold"),
                             ),
                           ),

                           Container(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: size.width*0.45,
                                        alignment: Alignment.topLeft,
                                        padding: EdgeInsets.only(
                                            top: 0.0, bottom: 0.0, left: 20.0, right: 0.0),
                                        child: Text("Recharge"
                                          ,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.0,
                                              fontFamily: "PoppinsBold"),
                                        ),
                                      ),
                                      Container(
                                          width: size.width*0.45,
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.only(
                                              top: 0.0, bottom: 0.0, left: 10.0, right: 0.0),
                                          child: IconButton(

                                            icon: const Icon(Icons.arrow_forward_ios),
                                            color: kPrimaryColorBlue,
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.push(context,
                                                  MaterialPageRoute(builder: (context) => Recharge()));
                                            },
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: size.width*0.45,
                                        alignment: Alignment.topLeft,
                                        padding: EdgeInsets.only(
                                            top: 0.0, bottom: 0.0, left: 20.0, right: 0.0),
                                        child: Text("Recharge History"
                                          ,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.0,
                                              fontFamily: "PoppinsBold"),
                                        ),
                                      ),
                                      Container(
                                          width: size.width*0.45,
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.only(
                                              top: 0.0, bottom: 0.0, left: 10.0, right: 0.0),
                                          child: IconButton(

                                            icon: const Icon(Icons.arrow_forward_ios),
                                            color: kPrimaryColorBlue,
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.push(context,
                                                  MaterialPageRoute(builder: (context) => subHistory()));
                                            },
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: <Widget>[
                                      Container(
                                        width: size.width*0.45,
                                        alignment: Alignment.topLeft,
                                        padding: EdgeInsets.only(
                                            top: 0.0, bottom: 0.0, left: 20.0, right: 0.0),
                                        child: Text("Download Invoice"
                                          ,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.0,
                                              fontFamily: "PoppinsBold"),
                                        ),
                                      ),
                                      Container(
                                          width: size.width*0.45,
                                          alignment: Alignment.center,
                                          padding: EdgeInsets.only(
                                              top: 0.0, bottom: 0.0, left: 10.0, right: 0.0),
                                          child: IconButton(

                                            icon: const Icon(Icons.arrow_forward_ios),
                                            color: kPrimaryColorBlue,
                                            onPressed: () {},
                                          )
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                           ),



                         ],),
                     ),

                   ),
                 ),
               ],
             ),



         ),
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
