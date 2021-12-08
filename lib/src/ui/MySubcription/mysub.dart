import 'dart:async';
import 'dart:convert';
import 'package:greenbill_merchant/src/models/model_addOn.dart';
import 'package:greenbill_merchant/src/models/model_transactional.dart';
import 'package:greenbill_merchant/src/ui/MySubcription/addOnsBuy.dart';
import 'package:greenbill_merchant/src/ui/MySubcription/otherBuy.dart';
import 'package:greenbill_merchant/src/ui/MySubcription/proceedToBuy.dart';
import 'package:greenbill_merchant/src/ui/values/values.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_bulkSmsSubscription.dart';
import 'package:greenbill_merchant/src/models/model_getsubplan.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Recharge extends StatefulWidget {
  @override
  RechargeState createState() => RechargeState();
}
class RechargeState extends State<Recharge> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, busId,mobile,number,emailAddress,nameOfBuss,userId,storeCatID;
  int subID;
  final ScrollController _controller = ScrollController();
  TextEditingController query = new TextEditingController();
  String _chosenValue="Green Bill Subscription Plan";
  bool _isCategory = true;
  String _platformVersion = '';

  bool _onTapBox1 = true;
  bool _onTapBox2 = false;
  bool _onTapBox3=false;
  bool _onTapBox4=false;
  bool _isSub = true;
  bool _isTrans=false;

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
    query.dispose();
  }

  getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      number = prefs.getString("mobile");
      token = prefs.getString("token");
      nameOfBuss=prefs.getString("fName");
      userId=prefs.getInt("userID").toString();
      emailAddress=prefs.getString("email");
      busId =prefs.getString("businessID");
      storeCatID = prefs.getString("businessCategoryID");
    });
    print('$token\n$busId');
  }

  Future<List<Datu>> getSms() async {
    final param = {
      "user_id":userId,
      "business_id":busId,
    };

    print(">>>>>>>>>$busId");

    final res = await http.post("http://157.230.228.250/merchant-get-promotional-sms-subscription-api/",
       body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"});

    print(res.body);
    print(res.statusCode);
    if (200 == res.statusCode) {
      print(subscriptionBulkSmsFromJson(res.body).data.length);
      return subscriptionBulkSmsFromJson(res.body).data;

    } else {
      throw Exception('Failed to load List');
    }
  }

  Future<List<DatuJI>> getTrans() async {
    final param = {
      "user_id":userId,
      "business_id":busId,
    };

    print("$userId >>>> $busId");
    final res = await http.post("http://157.230.228.250/merchant-get-transactional-sms-subscription-api/",
       body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"});

    print(res.body);
    print(res.statusCode);
    if (200 == res.statusCode) {
      print(transactionalSmsFromJson(res.body).data.length);
      return transactionalSmsFromJson(res.body).data;

    } else {
      throw Exception('Failed to load List');
    }
  }

  Future<List<Datumii>> getAddOn() async {
    final param = {
      "user_id":userId,
      "business_id":busId,
    };

    final res = await http.post("http://157.230.228.250/merchant-get-addon-recharge-api/",
       body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"});

    print(res.body);
    print(res.statusCode);
    if (200 == res.statusCode) {
      print(transactionalSmsFromJson(res.body).data.length);
      return addonFromJson(res.body).data;

    } else {
      throw Exception('Failed to load List');
    }
  }


  _launchPayURL(amount,id,planType)async {
    String key="IUZdcF";
    String salt="7ViVXMy1";

    var uuid = Uuid();
    var txId=(uuid.v4());
    var bytes = utf8.encode("$key|$txId|$amount|$planType|$nameOfBuss|$emailAddress|||||||||||$salt"); // data being hashed
    var digest = sha512.convert(bytes);
    print("$digest\n$txId");

    final paramss={
      'key':key,
      'txnid':txId,
      'amount':amount,
      'productinfo':planType,
      'firstname':nameOfBuss,
      'email':emailAddress,
      'phone':number,
      'lastname':id,
      'address1':busId,
      'address2':userId,
      'surl':'http://157.230.228.250/merchant-subscription-purchased-success/',
      'furl':'http://157.230.228.250/merchant-subscription-purchased-failed/',
      'hash':digest.toString(),
      'SALT':salt
    };

    print("Parameters....$paramss");

    final responses=await http.post("https://secure.payu.in/_payment",headers: {
      "accept":"application/json",
      "Content-Type":"application/x-www-form-urlencoded",
    },body: paramss);

    launch(responses.headers.values.elementAt(10));
  }

  Future<Map<String, dynamic>> postRequest(String key, String txId,String amount, String nameOfBuss,String emailAddress, String number,String name, String surl,String furl, String hash) async {
    // todo - fix baseUrl
    var url = '{{https://secure.payu.in}}/_payment';
    var body = json.encode({
      'key':key,
      'txnid':txId,
      'amount':amount,
      'productinfo':name,
      'firstname':nameOfBuss,
      'email':emailAddress,
      'phone':number,
      'surl':surl,
      'furl':furl,
      'hash':hash,
    });

    print('Body: $body');

    var response = await http.post(
      url,
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: body,
    );

    // todo - handle non-200 status code, etc
    return json.decode(response.body);
  }
  _launchURL() async {
    String encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri paymentLaunchUri = Uri(

      scheme:'https',
      path: '://secure.payu.in/_payment',
      query: encodeQueryParameters(<String, String>{
        'key':'IUZdcF',
        'txnid':'12349',
        'amount':'10',
        'productinfo':'Shopping',
        'firstname':'Test',
        'email':'test@test.com',
        'phone':'9876543210',
        'surl':'https://apiplayground-response.herokuapp.com/',
        'furl':'https://apiplayground-response.herokuapp.com/',
        'hash':'fe30b7e3a7067aa061f19f7a4f383a72601fd1d630ea452c841f10886665b4ada1b47f84f5f48eb374f7db5deb02ea75bf10ad9148becb3d7c49d88c8298499a',
        'udf2':'abc',
        'udf4':'15',
        'SALT':'7ViVXMy1',
      }),
    );

    launch(paymentLaunchUri.toString());
  }

  Future<List<Datum>> getLists() async {
    final param = {
      "user_id":userId,
      "m_business_id":busId,
      "business_category_id":(storeCatID == "11")? storeCatID : storeCatID =="12"? storeCatID : storeCatID,
    };

    print(">>>>>>>>>>>>>$storeCatID");

    final res = await http.post("http://157.230.228.250/merchant-get-subscription-plans-api/",
        body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"});

    print(res.body);
    print(res.statusCode);
    if (200 == res.statusCode) {
      print(subscriptionPlansFromJson(res.body).data.length);
      return subscriptionPlansFromJson(res.body).data;

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
        title: Text("Recharge"),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();

          },
        ),
      ),
      body:Column(
        children: [

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
                    width: size.width * 0.23,
                    child: Center(
                        child: Text(
                          'Green Bill',
                          style: TextStyle(color: _onTapBox1?Colors.white :_colorMerchantText,fontSize: 12.0),
                        )),
                  ),
                  onTap:(){
                    setState(() {
                      _isSub=true;
                      _onTapBox2=false;
                      _onTapBox3=false;
                      _onTapBox1=true;
                      _onTapBox4=false;
                      _isTrans=false;

                    });
                  } ,
                ),

                if(storeCatID != "11" || storeCatID != "12")
                InkWell(
                  child:Container(
                    decoration: BoxDecoration(
                        color: _onTapBox2?kPrimaryColorBlue:_colorMerchantContainer,
                        border: Border.all(color: kPrimaryColorBlue),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    width: size.width * 0.23,
                    child: Center(
                        child: Text(
                          'Promotional',
                          style: TextStyle(color: _onTapBox2?Colors.white :_colorMerchantText,fontSize: 12.0),
                        )),
                  ),
                  onTap:(){
                    setState(() {
                      _onTapBox3=false;
                      _onTapBox1=false;
                      _onTapBox2=true;
                      _isTrans=false;
                      _onTapBox4=false;
                      _isSub=false;
                    });
                  } ,
                ),

                if(storeCatID != "11" || storeCatID != "12")
                InkWell(

                  child:Container(
                    decoration: BoxDecoration(
                        color: _onTapBox3?kPrimaryColorBlue:_colorMerchantContainer,
                        border: Border.all(color: kPrimaryColorBlue),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    width: size.width * 0.23,
                    child: Center(
                        child: Text(
                          'Transactional',
                          style: TextStyle(color: _onTapBox3?Colors.white :_colorMerchantText,fontSize: 12.0),
                        )),
                  ),
                  onTap:(){
                    setState(() {
                      _isTrans=true;
                      _onTapBox1=false;
                      _onTapBox2=false;
                      _isSub=false;
                      _onTapBox3=true;
                      _onTapBox4=false;

                    });
                  } ,
                ),
                InkWell(

                  child:Container(
                    decoration: BoxDecoration(
                        color: _onTapBox4?kPrimaryColorBlue:_colorMerchantContainer,
                        border: Border.all(color: kPrimaryColorBlue),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    width: size.width * 0.23,
                    child: Center(
                        child: Text(
                          "Add On's",
                          style: TextStyle(color: _onTapBox4?Colors.white :_colorMerchantText,fontSize: 12.0),
                        )),
                  ),
                  onTap:(){
                    setState(() {
                      _isTrans=false;
                      _onTapBox1=false;
                      _onTapBox2=false;
                      _isSub=false;
                      _onTapBox3=false;
                      _onTapBox4=true;

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
              child: FutureBuilder<List<Datum>>(
                future: getLists(),
                builder: (BuildContext context, AsyncSnapshot<List<Datum>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),));
                  else if (snapshot.hasError) {
                    return Center(
                      child: Text("You don’t have any Recharge Plan"),
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
                                                width: size.width * 0.4,
                                                child: Text(
                                                  snapshot.data[index].subscriptionName,
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
                                                  "Users Up To",

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
                                                  snapshot.data[index].numberOfUsers,
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
                                                  "Monthly Charges",

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
                                                  "₹ "+double.parse(snapshot.data[index].costPerUser).toStringAsFixed(3),
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
                                              top: 10.0, bottom: 5.0, left: 5.0, right: 5.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              TextButton(
                                                onPressed: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext context) => _buildPopupDialog(context,snapshot.data[index]),
                                                  );
                                                },
                                                child: Text('View Details'),
                                              ),
                                              MaterialButton(

                                                  splashColor: kPrimaryColorBlue,
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                        vertical: 00.0, horizontal: 10.0),
                                                    child: Text(
                                                      "Buy",
                                                      style: TextStyle(
                                                          color:kPrimaryColorBlue,
                                                          fontSize: 15.0,
                                                          fontWeight: FontWeight.w500,
                                                          fontFamily: "PoppinsMedium"),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    print(">>>>>>>>>${_launchPayURL}");
                                                    print("User${snapshot.data[index].numberOfUsers}");
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProceedToBuy(snapshot.data[index].id,snapshot.data[index].numberOfUsers,snapshot.data[index].costPerUser,snapshot.data[index].igst,snapshot.data[index].cgst.toString(),snapshot.data[index].rechargeAmount)));
                                                  }),
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
          if(_onTapBox2)
            Expanded(
              child: FutureBuilder<List<Datu>>(
                future: getSms(),
                builder: (BuildContext context, AsyncSnapshot<List<Datu>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),));
                  else if (snapshot.hasError) {
                    return Center(
                      child: Text("You don’t have any Recharge Plan"),
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
                      return ListView.builder(
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
                                              width: size.width * 0.4,
                                              child: Text(
                                                snapshot.data[index].subscriptionName,
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
                                                snapshot.data[index].totalSms,
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
                                                "₹ "+double.parse(snapshot.data[index].perSmsCost).toStringAsFixed(3),
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
                                              width: size.width * 0.4,
                                              child: Text(
                                                "₹ "+snapshot.data[index].totalSmsCost.toStringAsFixed(3),
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
                                            top: 10.0, bottom: 5.0, left: 5.0, right: 5.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) => _buildPopupForSms(context,snapshot.data[index]),
                                                );
                                              },
                                              child: Text('View Details'),
                                            ),
                                            MaterialButton(

                                                splashColor: kPrimaryColorBlue,
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      vertical: 00.0, horizontal: 10.0),
                                                  child: Text(
                                                    "Buy",
                                                    style: TextStyle(
                                                        color:kPrimaryColorBlue,
                                                        fontSize: 15.0,
                                                        fontWeight: FontWeight.w500,
                                                        fontFamily: "PoppinsMedium"),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => OtherBuy(snapshot.data[index].id,snapshot.data[index].totalSmsCost,snapshot.data[index].igst)));

                                                  // _launchPayURL(snapshot.data[index].totalAmt, snapshot.data[index].id.toString(),"Promotional Sms Subscription");

                                                }),

                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }

                      );

                    } else {
                      return Center(child: Text("No Data Found"));
                    }
                  }

                },
              ),
            ),
          if(_onTapBox3)
            Expanded(
              child: FutureBuilder<List<DatuJI>>(
                future: getTrans(),
                builder: (BuildContext context, AsyncSnapshot<List<DatuJI>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),));
                  else if (snapshot.hasError) {
                    return Center(
                      child: Text("You don’t have any Recharge Plan"),
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
                      return ListView.builder(
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
                                              width: size.width * 0.4,
                                              child: Text(
                                                snapshot.data[index].subscriptionName,
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
                                                snapshot.data[index].totalSms,
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
                                                "₹ "+double.parse(snapshot.data[index].perSmsCost).toStringAsFixed(3),
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
                                              width: size.width * 0.4,
                                              child: Text(
                                                "₹ "+snapshot.data[index].totalSmsCost.toStringAsFixed(3),
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
                                            top: 10.0, bottom: 5.0, left: 5.0, right: 5.0),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) => _buildPopupForTrans(context,snapshot.data[index]),
                                                );
                                              },
                                              child: Text('View Details'),
                                            ),
                                            //if(snapshot.data[index].isActive)

                                            //snapshot.data[index].isActive?
                                            // Container(
                                            //  child: Row(
                                            //   children: <Widget>[
                                            //   Container(
                                            // padding: EdgeInsets.only(
                                            //     top: 0.0, bottom: 0.0, left: 5.0, right: 5.0),
                                            //   child:  Icon(
                                            //    Icons.check_circle,color: Colors.green,size: 20,
                                            //   ),
                                            //),

                                            //  Container(
                                            //     child: Text(  "Active",
                                            //      style: TextStyle(
                                            //        color:kPrimaryColorBlue,
                                            //       fontSize: 15.0,
                                            //       fontFamily: "Poppins"),
                                            //   textAlign: TextAlign.center,),
                                            //)
                                            // ],

                                            //),
                                            //  )


                                            MaterialButton(
                                                splashColor: kPrimaryColorBlue,
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(
                                                      vertical: 00.0, horizontal: 10.0),
                                                  child: Text(
                                                    "Buy",
                                                    style: TextStyle(
                                                        color:kPrimaryColorBlue,
                                                        fontSize: 15.0,
                                                        fontWeight: FontWeight.w500,
                                                        fontFamily: "PoppinsMedium"),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                                onPressed: () {
                                                  Navigator.push(context, MaterialPageRoute(builder: (context) => OtherBuy(snapshot.data[index].id,snapshot.data[index].totalSmsCost,snapshot.data[index].igst)));
                                                  // _launchPayURL(snapshot.data[index].totalAmt, snapshot.data[index].id.toString(),"Transactional Sms Subscription");

                                                }),

                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }

                      );

                    } else {
                      return Center(child: Text("No Data Found"));
                    }
                  }

                },
              ),
            ),
          if(_onTapBox4)
            Expanded(
              child: FutureBuilder<List<Datumii>>(
                future:  getAddOn(),
                builder: (BuildContext context, AsyncSnapshot<List<Datumii>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),));
                  else if (snapshot.hasError) {
                    return Center(
                      child: Text("You don’t have any Recharge Plan"),
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
                                                  "Add On's Name",
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
                                                  snapshot.data[index].addOnName,
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

                                        // Container(
                                        //   width: size.width * 0.9,
                                        //   padding: EdgeInsets.only(
                                        //       top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                        //   child: Row(
                                        //     crossAxisAlignment: CrossAxisAlignment.center,
                                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //     children: <Widget>[
                                        //
                                        //       Container(
                                        //         padding: EdgeInsets.only(
                                        //             top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                        //         width: size.width * 0.4,
                                        //         child: Text(
                                        //           "Recharge Amount",
                                        //
                                        //           style: TextStyle(
                                        //               color: Colors.black,
                                        //               fontSize: 12.0,
                                        //               fontFamily: "PoppinsBold"),
                                        //         ),
                                        //       ),
                                        //
                                        //       Container(
                                        //         padding: EdgeInsets.only(
                                        //             top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                        //         width: size.width * 0.4,
                                        //         child: Text(
                                        //           "₹ "+snapshot.data[index].totalAmt.toString(),
                                        //           textAlign: TextAlign.center,
                                        //           style: TextStyle(
                                        //               color: kPrimaryColorBlue,
                                        //               fontSize: 12.0,
                                        //               fontFamily: "PoppinsBold"),
                                        //         ),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),
                                        // Container(
                                        //   width: size.width * 0.9,
                                        //   padding: EdgeInsets.only(
                                        //       top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                        //   child: Row(
                                        //     crossAxisAlignment: CrossAxisAlignment.center,
                                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        //     children: <Widget>[
                                        //
                                        //       Container(
                                        //         padding: EdgeInsets.only(
                                        //             top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                        //         width: size.width * 0.4,
                                        //         child: Text(
                                        //           "Amount",
                                        //
                                        //           style: TextStyle(
                                        //               color: Colors.black,
                                        //               fontSize: 12.0,
                                        //               fontFamily: "PoppinsBold"),
                                        //         ),
                                        //       ),
                                        //
                                        //       Container(
                                        //         padding: EdgeInsets.only(
                                        //             top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                                        //         width: size.width * 0.4,
                                        //         child: Text(
                                        //           "₹ "+snapshot.data[index].rechargeAmount.toString(),
                                        //           textAlign: TextAlign.center,
                                        //           style: TextStyle(
                                        //               color: kPrimaryColorBlue,
                                        //               fontSize: 12.0,
                                        //               fontFamily: "PoppinsBold"),
                                        //         ),
                                        //       ),
                                        //     ],
                                        //   ),
                                        // ),

                                        Container(
                                          width: size.width * 0.9,
                                          padding: EdgeInsets.only(
                                              top: 10.0, bottom: 5.0, left: 5.0, right: 5.0),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              // TextButton(
                                              //   onPressed: () {
                                              //     showDialog(
                                              //       context: context,
                                              //       builder: (BuildContext context) => _buildPopupDialogAddOn(context,snapshot.data[index]),
                                              //     );
                                              //   },
                                              //   child: Text('View Details'),
                                              // ),
                                              MaterialButton(

                                                  splashColor: kPrimaryColorBlue,
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(
                                                        vertical: 00.0, horizontal: 10.0),
                                                    child: Text(
                                                      "Buy",
                                                      style: TextStyle(
                                                          color:kPrimaryColorBlue,
                                                          fontSize: 15.0,
                                                          fontWeight: FontWeight.w500,
                                                          fontFamily: "PoppinsMedium"),
                                                      textAlign: TextAlign.center,
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddOnBuy(snapshot.data[index].id,snapshot.data[index].totalAmt,snapshot.data[index].igst,snapshot.data[index].cgst.toString(),snapshot.data[index].rechargeAmount.toString())));

                                                    // _launchPayURL(snapshot.data[index].totalAmt, snapshot.data[index].id.toString(),"Add's On Subscription");

                                                  }),

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
                          Text("₹ "+double.parse(data.rechargeAmount).toStringAsFixed(3),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontFamily: "PoppinsBold"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              color: kPrimaryColorBlue,
            ),
          ),

          // Container(
            //width: MediaQuery.of(context).size.width,
            // padding: EdgeInsets.only(
            //     top: 10.0, bottom: 5.0, left: 5.0, right: 5.0),
            // child: Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[

                // Container(
                //   padding: EdgeInsets.only(
                //       top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                //   //width:MediaQuery.of(context).size.width* 0.5,
                //   child: Text(
                //     "Subscription Name",
                //     style: TextStyle(
                //         color: Colors.black,
                //         fontSize: 12.0,
                //         fontFamily: "PoppinsBold"),
                //   ),
                // ),

                Center(
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 10.0, left: 5.0, right: 5.0),
                    // width:MediaQuery.of(context).size.width* 0.5,
                    child: Text(
                      data.subscriptionName,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: AppColors.kPrimaryColorBlue,
                          fontSize: 16.0,
                          fontFamily: "PoppinsBold"),
                    ),
                  ),
                ),



          // Container(
          //width: MediaQuery.of(context).size.width,
          //  padding: EdgeInsets.only(
          //top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
          //  child: Row(
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: <Widget>[

          //        Container(
          //      padding: EdgeInsets.only(
          //           top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
          //width:MediaQuery.of(context).size.width* 0.5,
          //       child: Text(
          //        "Recharge  Amount",

          //          style: TextStyle(
          //              color: Colors.black,
          //              fontSize: 12.0,
          //               fontFamily: "PoppinsBold"),
          //          ),
          //        ),

          //    Container(
          //         padding: EdgeInsets.only(
          //            top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
          // width:MediaQuery.of(context).size.width* 0.5,
          //          child: Text(
          //            "₹ "+data.rechargeAmount+".00",
          //           textAlign: TextAlign.end,
          //           style: TextStyle(
          //              color: kPrimaryColorBlue,
          //             fontSize: 12.0,
          //              fontFamily: "PoppinsBold"),
          //        ),
          //    ),
          //  ],
          // ),
          // ),

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
                  // width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(
                    "₹ "+double.parse(data.rechargeAmount).toStringAsFixed(3),
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
                  // width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(
                    "₹ "+double.parse(data.perBillCost).toStringAsFixed(3),
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
                    "₹ "+double.parse(data.perDigitalBillCost).toStringAsFixed(3),
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

          SizedBox(
            height: MediaQuery.of(context).size.width * 0.05,
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
                    "Number Of Users",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.0),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  // width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(data.numberOfUsers.toString(),
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.0),
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
                    "Cost Per User",

                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.0),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  // width:MediaQuery.of(context).size.width* 0.5,
                  child: Text("₹ "+data.costPerUser.toString(),
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.0),
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
                    "CGST",

                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.0),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  // width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(data.igst == 1 ? "9%" : "0",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.0),
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
                    "SGST",

                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.0),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  // width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(data.igst == 1 ? "9%" : "0",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.0),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.only(
                  top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
              // width:MediaQuery.of(context).size.width* 0.5,
              child: Text(data.igst == 1? "Include IGST : 0" :
              "Include IGST : "+data.igst.toString()+"%",
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 13.0),
              ),
            ),
          )
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


  Widget _buildPopupDialogAddOn(BuildContext context, Datumii data) {

    return new AlertDialog(

      title: Text("Add On's Plans",style: TextStyle(
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
                            "₹ "+data.totalAmt.toString(),
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
                    "Add'On Name",

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
                    data.addOnName,
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
                    "₹ "+data.totalAmt.toString(),
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
                  child:
                  Text(data.perBillCost.characters.first=="0"?
                  "₹ "+data.perBillCost :  "₹ "+data.perBillCost+".00",
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
                  child: Text(data.perDigitalBillCost.characters.first=="0"?
                  "₹ "+data.perDigitalBillCost:"₹ "+data.perDigitalBillCost+".00",
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

          SizedBox(
            height: 10.0,
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
                    "CGST",

                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.0),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  // width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(data.igst == 1 ? "9%" : "0",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.0),
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
                    "SGST",

                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.0),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  // width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(data.igst == 1 ? "9%" : "0",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.0),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.only(
                  top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
              // width:MediaQuery.of(context).size.width* 0.5,
              child: Text(data.igst == 1? "Include IGST : 0" :
              "Include IGST : "+data.igst.toString()+"%",
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 13.0),
              ),
            ),
          )


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
      title: Text("Pramotional SMS Plans",style: TextStyle(
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
                            "₹ "+double.parse(data.totalAmt).toStringAsFixed(3),
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

          Center(
            child: Container(
              padding: EdgeInsets.only(
                  top: 10.0, bottom: 10.0, left: 5.0, right: 5.0),
              // width:MediaQuery.of(context).size.width* 0.5,
              child: Text(
                data.subscriptionName,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: kPrimaryColorBlue,
                    fontSize: 16.0,
                    fontFamily: "PoppinsBold"),
              ),
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
                    "₹ "+double.parse(data.totalAmt).toStringAsFixed(3),
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
                    data.totalSms+" SMS",
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
                    "₹ "+double.parse(data.perSmsCost).toStringAsFixed(3),
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

          SizedBox(
            height: 10.0,
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
                    "CGST",

                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.0),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  // width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(data.igst == 1 ? "9%" : "0",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.0),
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
                          "SGST",

                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12.0),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.only(
                            top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                        // width:MediaQuery.of(context).size.width* 0.5,
                        child: Text(data.igst == 1 ? "9%" : "0",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 12.0),
                        ),
                      ),
              ],
            ),
                ),
                Center(
                  child: Container(
                    padding: EdgeInsets.only(
                        top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                    // width:MediaQuery.of(context).size.width* 0.5,
                    child: Text(data.igst == 1? "Include IGST : 0" :
                    "Include IGST : "+data.igst.toString()+"%",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 13.0),
                    ),
                  ),
                )
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


  Widget _buildPopupForTrans(BuildContext context, DatuJI data) {

    return new AlertDialog(
      title: Text("Transactional SMS Plans",style: TextStyle(
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
                            "₹ "+double.parse(data.totalAmt).toStringAsFixed(3),
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

          Center(
            child: Container(
              padding: EdgeInsets.only(
                  top: 10.0, bottom: 10.0, left: 5.0, right: 5.0),
              // width:MediaQuery.of(context).size.width* 0.5,
              child: Text(
                data.subscriptionName,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: kPrimaryColorBlue,
                    fontSize: 16.0,
                    fontFamily: "PoppinsBold"),
              ),
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
                    "₹ "+double.parse(data.totalAmt).toStringAsFixed(3),
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
                    data.totalSms+" SMS",
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
                    "₹"+double.parse(data.perSmsCost).toStringAsFixed(3),
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

          SizedBox(
            height: 10.0,
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
                    "CGST",

                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.0),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  // width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(data.igst == 1 ? "9%" : "0",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.0),
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
                    "SGST",

                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.0),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
                  // width:MediaQuery.of(context).size.width* 0.5,
                  child: Text(data.igst == 1 ? "9%" : "0",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 12.0),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.only(
                  top: 0.0, bottom: 5.0, left: 5.0, right: 5.0),
              // width:MediaQuery.of(context).size.width* 0.5,
              child: Text(data.igst == 1? "Include IGST : 0" :
              "Include IGST : "+data.igst.toString()+"%",
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 13.0),
              ),
            ),
          )



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