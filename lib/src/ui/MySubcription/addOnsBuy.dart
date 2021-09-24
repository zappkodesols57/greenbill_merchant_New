import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:greenbill_merchant/src/models/model_getStoreCat.dart';
import 'package:greenbill_merchant/src/ui/values/values.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_getStore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
class AddOnBuy extends StatefulWidget {
  final String totalAMT,cgst,rechargeAMT;
  final int igst,subID;
  AddOnBuy(this.subID,this.totalAMT,this.igst,this.cgst,this.rechargeAMT);

  @override
  _AddOnBuyState createState() => _AddOnBuyState();
}

class _AddOnBuyState extends State<AddOnBuy> {

  TextEditingController nameController = TextEditingController();
  AnimationController animationController;
  final ScrollController _controller = ScrollController();
  String store = 'GB', storeID, storeAddress,_chosenValue;
  PageController _pageController;

  String token, businessLogo, storeCatID,number,nameOfBuss,userId,emailAddress,busId;
  int CPU,NOU,id;
  double IGST = 0.0,Total = 0.0;
  List checkedValue = List();

  @override
  void initState() {

    super.initState();
    getCredentials();
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
    this.getAmounts();
    // calculation();
  }

  calculation(){
    setState(() {
      IGST = (18*(int.parse(_chosenValue))/100);
      Total = IGST+int.parse(_chosenValue);
    });
    print("IGST $IGST ______ Total $Total");
  }

  void _onCategorySelected(bool selected, category_id) {
    if (selected == true) {
      setState(() {
        checkedValue.add(category_id);
      });
    } else {
      setState(() {
        checkedValue.remove(category_id);
      });
    }
  }


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Buy Plan"),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Container(
                    width: size.width * 0.90,
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 0.0, left: 0.0, right: 0.0) ,
                    child: Text("*Note: Kindly select Amounts",style: TextStyle(fontFamily: "PoppinsLight", fontSize: 12.0,color: Colors.red),),
                  ),

                  SizedBox(height: 10.0,),

                  Container(
                    child: Text("Select Amount",
                      style: TextStyle(fontFamily: "PoppinsLight", fontSize: 16.0,color: AppColors.kPrimaryColorBlue,fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10.0,),

                  Container(
                      width: size.width * 0.95,
                      padding: EdgeInsets.only(
                          top: 0.0, bottom: 0.0, left: 15.0, right: 15.0) ,
                      decoration: BoxDecoration(
                        border: Border.all(color: kPrimaryColorBlue, width: 0.5),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Center(
                        child: new DropdownButton(
                          iconEnabledColor: kPrimaryColorBlue,
                          //elevation: 5,
                          isExpanded: true,
                          style: TextStyle(color: kPrimaryColorBlue, fontFamily: "PoppinsBold",fontSize: 17.0),
                          underline: Container(
                              height: 2,
                              width: 95,
                              color: Colors.transparent),
                          items: data.map((item){
                            return DropdownMenuItem(
                              child: new Text(item['all_recharge_amount']),
                              value: item['all_recharge_amount'].toString(),
                            );
                          }).toList(),
                          hint: Text(
                            "Select Amount",
                            style: TextStyle(
                              color: kPrimaryColorBlue,
                              fontSize: 13.0,
                              fontFamily: "PoppinsLight",),
                          ),
                          onChanged: (String value) {
                            setState(() {
                              _chosenValue = value;
                              IGST = (18*(int.parse(_chosenValue))/100);
                              Total = IGST+int.parse(_chosenValue);
                            });
                          },
                          value: _chosenValue,
                        ),
                      )
                  ),
                  SizedBox(height: 10.0,),

                  Container(
                    width: size.width * 0.90,
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 0.0, left: 0.0, right: 0.0) ,
                    child: Text("*Note: Kindly select Businesses",style: TextStyle(fontFamily: "PoppinsLight", fontSize: 12.0,color: Colors.red),),
                  ),
                  Container(
                    width: size.width * 0.95,
                    height: size.height * 0.23,
                    padding: EdgeInsets.only(top: 0.0, bottom: 10.0),
                    child: FutureBuilder<List<Datus>>(
                      future: getStoreCatList(),
                      builder: (BuildContext context, AsyncSnapshot<List<Datus>> snapshot) {
                        print(">>>>>>>>>>>>$snapshot");
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Center(
                            child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),
                                )),
                          );
                        else if (snapshot.hasError) {
                          print(">>>>${snapshot.error}");
                          return Center(
                            child: Text("No Business Found"),
                          );
                        } else {
                          if (snapshot.hasData && snapshot.data.isNotEmpty) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (_controller.hasClients) {
                                _controller.animateTo(_controller.position.minScrollExtent,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.fastLinearToSlowEaseIn);
                              } else {
                                setState(() => null);
                              }
                            });
                            return Column(
                              children: [
                                Text("Select Businesses",
                                  style: TextStyle(fontFamily: "PoppinsLight", fontSize: 16.0,color: AppColors.kPrimaryColorBlue,fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  child: Scrollbar(
                                    isAlwaysShown: true,
                                    controller: _controller,
                                    thickness: 3.0,
                                    child: ListView.builder(
                                        itemCount: snapshot.data.length,
                                        shrinkWrap: true,
                                        reverse: false,
                                        controller: _controller,
                                        itemBuilder: (BuildContext context, int index) {
                                          return new CheckboxListTile(
                                            value: checkedValue.contains(snapshot.data[index].id),
                                            onChanged: (bool selected){
                                              _onCategorySelected(selected, snapshot.data[index].id);
                                              print(">>Value $checkedValue");
                                            },
                                            title: Text(
                                                snapshot.data[index].business,
                                                style: TextStyle(fontSize: 15.0)
                                            ),
                                            // trailing: Checkbox(
                                            //   value: checkedValue,
                                            //   onChanged: (newVal){
                                            //     // setState(() {
                                            //     //   checkedValue = newVal;
                                            //     // });
                                            //   },
                                            // ),
                                            // onTap: (){
                                            //   setState(() {
                                            //     checkedValue = !checkedValue;
                                            //   });
                                            // },
                                          );
                                        }
                                    ),
                                  ),
                                )
                              ],
                            );
                          } else {
                            return Center(
                              child: Text("No Businesses Available"),
                            );
                          }
                        }
                      },
                    ),
                  ),

                  SizedBox(height: 20.0,),

                  Container(
                    width: size.width * 0.90,
                    padding: EdgeInsets.only(
                        top: 20.0, bottom: 10.0, left: 10.0, right: 0.0) ,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("Total Amount      ",style: TextStyle(fontFamily: "PoppinsLight", fontSize: 16.0,color: AppColors.kPrimaryColorBlue,fontWeight: FontWeight.bold),),
                        SizedBox(height: 5.0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: size.width * 0.40,
                              child: Text("Selected Amount",style:
                              TextStyle(fontFamily: "PoppinsLight",
                                  fontSize: 14.0,
                                  color: AppColors.kPrimaryColorBlue)),
                            ),
                            Container(
                              width: size.width * 0.25,
                              child: Text(_chosenValue == null ? ": ₹ 0" :": ₹ $_chosenValue",style:
                              TextStyle(fontFamily: "PoppinsLight",
                                  fontSize: 14.0,
                                  color: AppColors.kPrimaryColorBlue)),
                            ),
                          ],
                        ),

                        if(widget.igst == 18)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: size.width * 0.40,
                                child: Text("IGST (${widget.igst}%)",style:
                                TextStyle(fontFamily: "PoppinsLight",
                                    fontSize: 14.0,
                                    color: AppColors.kPrimaryColorBlue)),
                              ),
                              Container(
                                width: size.width * 0.25,
                                child: Text("₹ ${IGST.toStringAsFixed(2)}",style:
                                TextStyle(fontFamily: "PoppinsLight",
                                    fontSize: 14.0,
                                    color: AppColors.kPrimaryColorBlue)),
                              ),
                            ],
                          ),
                        if(widget.igst == 1)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: size.width * 0.40,
                                child: Text("CGST(9%)",style:
                                TextStyle(fontFamily: "PoppinsLight",
                                    fontSize: 14.0,
                                    color: AppColors.kPrimaryColorBlue)),
                              ),

                              Container(
                                width: size.width * 0.25,
                                child: Text(": ₹ ${(IGST/2).toStringAsFixed(2)}",style:
                                TextStyle(fontFamily: "PoppinsLight",
                                    fontSize: 14.0,
                                    color: AppColors.kPrimaryColorBlue)),
                              ),
                            ],
                          ),
                        if(widget.igst == 1)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: size.width * 0.40,
                                child: Text("SGST(9%)",style:
                                TextStyle(fontFamily: "PoppinsLight",
                                    fontSize: 14.0,
                                    color: AppColors.kPrimaryColorBlue)),
                              ),
                              Container(
                                width: size.width * 0.25,
                                child: Text(": ₹ ${(IGST/2).toStringAsFixed(2)}",style:
                                TextStyle(fontFamily: "PoppinsLight",
                                    fontSize: 14.0,
                                    color: AppColors.kPrimaryColorBlue)),
                              ),
                            ],
                          ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: size.width * 0.40,
                              child: Text("Total Cost",style:
                              TextStyle(fontFamily: "PoppinsLight",
                                  fontSize: 14.0,
                                  color: AppColors.kPrimaryColorBlue)),
                            ),
                            Container(
                              width: size.width * 0.25,
                              child: Text(Total == null ?": ₹ 0.0" :": ₹ ${Total.toStringAsFixed(2)}",style:
                              TextStyle(fontFamily: "PoppinsLight",
                                  fontSize: 14.0,
                                  color: AppColors.kPrimaryColorBlue)),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(top: 10.0),
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(35.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(1.0, 6.0),
                          blurRadius: 20.0,
                        ),
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(1.0, 6.0),
                          blurRadius: 20.0,
                        ),
                      ],
                      gradient: new LinearGradient(
                          colors: [
                            kPrimaryColorBlue,
                            kPrimaryColorBlue,
                          ],
                          begin: const FractionalOffset(0.2, 0.2),
                          end: const FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    child: MaterialButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 42.0),
                          child: Text(
                            "Buy",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                                fontFamily: "PoppinsBold"),
                          ),
                        ),
                        onPressed: () {
                          _launchPayURL(Total.toStringAsFixed(2),checkedValue.toString(),"Green Bill Subscription");
                        }),
                  ),
                ],
              ),
            )));
  }

  Future<List<StoreList>> getStoreList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getInt("userID");
      token = prefs.getString("token");
      store = prefs.getString("businessName");
      storeID = prefs.getString("businessID");
      businessLogo = prefs.getString("businessLogo");
      storeCatID = prefs.getString("businessCategoryID");
      print('$id  $token $store $storeID $businessLogo');
    });

    final param = {
      "user_id": id.toString(),
    };

    final res = await http.post(
      "http://157.230.228.250/get-merchant-businesses-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(res.body);
    if (200 == res.statusCode) {
      print(storeListFromJson(res.body).length);
      return storeListFromJson(res.body);
    } else {
      throw Exception('Failed to load Stores List');
    }
  }
  Widget setupAlertDialoagContainer() {
    return Container(
      height: 250,
      width: 350,
      child: FutureBuilder<List<StoreList>>(
        future: getStoreList(),
        builder: (BuildContext context, AsyncSnapshot<List<StoreList>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Scrollbar(
                radius: Radius.circular(5.0),
                isAlwaysShown: true,
                controller: _controller,
                thickness: 3.0,
                child: ListView.builder(
                    controller: _controller,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(snapshot.data[index].mBusinessName,
                            style: TextStyle(fontSize: 15.0)),
                        subtitle: (snapshot.data[index].mArea.isNotEmpty)
                            ? Text(
                            '${snapshot.data[index].mAddress}, ${snapshot.data[index].mArea}, ${snapshot.data[index].mCity}',
                            style: TextStyle(fontSize: 10.0))
                            : Text('Address not available',
                            style: TextStyle(fontSize: 10.0)),
                      );
                    }));
          } else {
            if(snapshot.hasError){
              print(">>>>>>>>>>${snapshot.error}");
            };
            return Center(
                child: CircularProgressIndicator(
                  // valueColor: animationController.drive(ColorTween(
                  //     begin: kPrimaryColorBlue, end: kPrimaryColorGreen)),
                ));
          }
        },
      ),
    );
  }

  _launchPayURL(amount,id,planType)async {

    if(_chosenValue == null){
      showInSnackBar("Please select Amount");
      return null;
    }

    if(checkedValue.isEmpty){
      showInSnackBar("Please select At leat 1 Business");
      return null;
    }



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
      'lastname':widget.subID.toString(),
      'address1':id,
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

    Navigator.pop(context);

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


  Future<List<Datus>> getStoreCatList() async {


    final param = {
      "user_id": userId.toString(),
      "merchant_business_category" : storeCatID.toString(),
    };

    print(">>>>>$id>>>>$storeCatID>>>>$token");

    final res = await http.post(
      "http://157.230.228.250/merchant-get-businessname-by-category-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print("RESPONSE ${res.body}");
    if (200 == res.statusCode) {
      print(getStoreCatFromJson(res.body).data.length);
      return getStoreCatFromJson(res.body).data;
    } else {
      throw Exception('Failed to load Stores List');
    }
  }

  showStoreDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Select Business',
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


  List data = List();
  Future<String> getAmounts() async {
    final param = {
      "plan_id": widget.subID.toString(),
    };

    print(param);
    final res = await http.post("http://157.230.228.250/merchant-get-all-addon-amounts-api/",
        body: param, headers: { HttpHeaders.authorizationHeader: "Token $token"});
    final resBody = json.decode(res.body);
    setState(() {
      data = resBody;
    });

    print(resBody);
    return "Success";
  }


}
