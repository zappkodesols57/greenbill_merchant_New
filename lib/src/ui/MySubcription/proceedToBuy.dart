import 'dart:convert';
import 'dart:core';
import 'dart:core';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/models/model_getStoreCat.dart';
import 'package:greenbill_merchant/src/ui/BillInfo/ViewBill.dart';
import 'package:greenbill_merchant/src/ui/values/values.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_getStore.dart';
import 'package:greenbill_merchant/src/ui/HomeScreen/Home.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
class ProceedToBuy extends StatefulWidget {
  final String numberOfUser,costPerUser,cgst,rechargeAMT;
  int igst;
  ProceedToBuy(this.numberOfUser,this.costPerUser,this.igst,this.cgst,this.rechargeAMT);
  // const ProceedToBuy({Key key}) : super(key: key);

  @override
  _ProceedToBuyState createState() => _ProceedToBuyState();
}

class _ProceedToBuyState extends State<ProceedToBuy> {

  TextEditingController nameController = TextEditingController();
  AnimationController animationController;
  final ScrollController _controller = ScrollController();
  String store = 'GB', storeID, storeAddress;
  PageController _pageController;
  List checkedValue = List();


  String token, businessLogo, storeCatID;
  int CPU = 0;
  double IGST = 0.0,CGST = 0.0,SGST = 0.0,Total = 0.0;

  int id;
  int months;
  String selected1;
  List<String> value1 = ['1','2'];
  List<String> value2 = ['1','2','3','4','5'];
  List<String> value3 = ['1','2','3','4','5','6','7','8','9','10'];
  List<String> plan = ['6 Months','12 Months'];
  String selectedPlan;

  String number,nameOfBuss,userId,emailAddress,busId;



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



  @override
  void initState() {

    super.initState();
    getCredentials();
    // calculation();
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

  calculation()  {
    setState(() {
    CPU = (int.parse(selected1)*(int.parse(widget.costPerUser))*months);
    IGST = (18*(CPU+int.parse(widget.rechargeAMT))/100);
    Total = CPU+int.parse(widget.rechargeAMT)+IGST;
     });

    print("userss  ${widget.numberOfUser}");
    print("igst  ${widget.igst}");
    print("cgst  ${widget.cgst}");
    print("cost  ${widget.costPerUser}");
    print("amt  ${widget.rechargeAMT}");
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
                        top: 10.0, bottom: 10.0, left: 0.0, right: 0.0) ,
                    child: Text("*Note: Kindly select No. of User and Plan Validity",style: TextStyle(fontFamily: "PoppinsLight", fontSize: 12.0,color: Colors.red),),
                  ),

                  if(widget.numberOfUser == "2")
                    Container(
                      width: size.width * 0.90,
                      decoration: BoxDecoration(
                        border: Border.all(color: kPrimaryColorBlue, width: 0.5),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: EdgeInsets.only(
                          top: 0.0, bottom: 0.0, left: 15.0, right: 15.0),
                      child: DropdownButton(
                        underline: Container(color: Colors.transparent,),
                        isExpanded: true,
                        hint: Text('Select Number Of User *',style: TextStyle(
                            fontFamily: "PoppinsLight",
                            fontSize: 13.0,
                            color: kPrimaryColorBlue)),
                        value: selected1,
                        onChanged: (newValue){
                          setState(() {
                            selected1 = newValue;
                            calculation();

                          });
                        },
                        items: value1.map((valuefnl){
                          return DropdownMenuItem(
                            child: new Text(valuefnl.toString()),
                            value: valuefnl,
                          );
                        },
                        ).toList(),
                      ),
                    ),

                  if(widget.numberOfUser == "5")
                    Container(
                      width: size.width * 0.90,
                      decoration: BoxDecoration(
                        border: Border.all(color: kPrimaryColorBlue, width: 0.5),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: EdgeInsets.only(
                          top: 0.0, bottom: 0.0, left: 15.0, right: 15.0),
                      child: DropdownButton(
                        underline: Container(color: Colors.transparent,),
                        isExpanded: true,
                        hint: Text('Select Number Of User *',style: TextStyle(
                            fontFamily: "PoppinsLight",
                            fontSize: 13.0,
                            color: kPrimaryColorBlue)),
                        value: selected1,
                        onChanged: (newValue){
                          setState(() {
                            selected1 = newValue;
                            calculation();
                          });
                        },
                        items: value2.map((valuefnl){
                          return DropdownMenuItem(
                            child: new Text(valuefnl.toString()),
                            value: valuefnl,
                          );
                        },
                        ).toList(),
                      ),
                    ),

                  if(widget.numberOfUser == "10")
                    Container(
                      width: size.width * 0.90,
                      decoration: BoxDecoration(
                        border: Border.all(color: kPrimaryColorBlue, width: 0.5),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: EdgeInsets.only(
                          top: 0.0, bottom: 0.0, left: 15.0, right: 15.0),
                      child: DropdownButton(
                        underline: Container(color: Colors.transparent,),
                        isExpanded: true,
                        hint: Text('Select Number Of User *',style: TextStyle(
                            fontFamily: "PoppinsLight",
                            fontSize: 13.0,
                            color: kPrimaryColorBlue)),
                        value: selected1,
                        onChanged: (newValue){
                          setState(() {
                            selected1 = newValue;
                            calculation();
                          });
                        },
                        items: value3.map((valuefnl){
                          return DropdownMenuItem(
                            child: new Text(valuefnl.toString()),
                            value: valuefnl,
                          );
                        },
                        ).toList(),
                      ),
                    ),

                  SizedBox(height: 10.0),

                  Container(
                    width: size.width * 0.90,
                    decoration: BoxDecoration(
                      border: Border.all(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: EdgeInsets.only(
                        top: 0.0, bottom: 0.0, left: 15.0, right: 15.0),
                    child: DropdownButton(
                      underline: Container(color: Colors.transparent,),
                      isExpanded: true,
                      hint: Text('Select Plan *',style: TextStyle(
                          fontFamily: "PoppinsLight",
                          fontSize: 13.0,
                          color: kPrimaryColorBlue),),
                      value: selectedPlan,
                      onChanged: (newValue){
                        setState(() {
                          selectedPlan = newValue;
                          months = (selectedPlan == "6 Months")? 6 : 12;
                          calculation();
                        });
                      },
                      items: plan.map((valuefnl){
                        return DropdownMenuItem(
                          child: new Text(valuefnl),
                          value: valuefnl,
                        );
                      },
                      ).toList(),
                    ),
                  ),
                  SizedBox(height: 10.0,),

                  Container(
                    width: size.width * 0.90,
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 0.0, left: 0.0, right: 0.0) ,
                    child: Text("*Note: Select the businesses",style: TextStyle(fontFamily: "PoppinsLight", fontSize: 12.0,color: Colors.red),),
                  ),

                  Column(
                    children: [
                      Container(
                        width: size.width * 0.95,
                        height: size.height * 0.27,
                        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
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
                                );                              }
                            }
                          },
                        ),

                      ),
                    ],
                  ),
                  // Container(
                  //   width: size.width * 0.90,
                  //   padding: EdgeInsets.only(
                  //       top: 00.0, bottom: 10.0, left: 0.0, right: 0.0),
                  //   child: Container(
                  //     child:
                  //     // MultiSelectDialogField(
                  //     //   height:size.width * 0.75,
                  //     //   items: _items,
                  //     //   title: Text("Select Businesses"),
                  //     //   selectedColor: kPrimaryColorBlue,
                  //     //
                  //     //
                  //     //   buttonText: Text(
                  //     //     "Select  Businesses",
                  //     //     style: TextStyle(
                  //     //       fontFamily: "PoppinsLight",
                  //     //       fontSize: 13.0,
                  //     //       color: kPrimaryColorBlue,
                  //     //     ),
                  //     //   ),
                  //     //   onConfirm: (results) {
                  //     //     //_selectedAnimals = results;
                  //     //     // print(_selectedAnimals.toString());
                  //     //
                  //     //   },
                  //     // )
                  //     new TextField(
                  //      focusNode: new AlwaysDisabledFocusNode(),
                  //       // inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),],
                  //       controller: nameController,
                  //       maxLength: 20,
                  //       style: TextStyle(
                  //         //fontFamily: "PoppinsBold",
                  //           fontSize: 17.0,
                  //           color: Colors.black87),
                  //       decoration: InputDecoration(
                  //         border: InputBorder.none,
                  //         counterStyle: TextStyle(
                  //           height: double.minPositive,
                  //         ),
                  //         counterText: "",
                  //         contentPadding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 15.0),
                  //         enabledBorder: OutlineInputBorder(
                  //           borderSide:
                  //           BorderSide(color: kPrimaryColorBlue, width: 0.5),
                  //           borderRadius:
                  //           const BorderRadius.all(Radius.circular(35.0)),
                  //         ),
                  //         focusedBorder: new OutlineInputBorder(
                  //           borderSide:
                  //           BorderSide(color: kPrimaryColorBlue, width: 0.5),
                  //           borderRadius:
                  //           const BorderRadius.all(Radius.circular(35.0)),
                  //         ),
                  //         suffixIcon: IconButton(
                  //          icon: Icon(Icons.arrow_drop_down),
                  //           color: kPrimaryColorBlue,
                  //           iconSize: 23.0,
                  //         ),
                  //         labelText: "Select business *",
                  //         labelStyle: TextStyle(
                  //             fontFamily: "PoppinsLight",
                  //             fontSize: 13.0,
                  //             color: kPrimaryColorBlue),
                  //       ),
                  //       onTap: (){
                  //         // showStoreDialog(context);
                  //       },
                  //     ),
                  //   ),
                  // ),

                  SizedBox(height: 20.0,),

                  Center(
                    child: Container(
                      width: size.width * 0.90,
                      padding: EdgeInsets.only(
                          top: 0.0, bottom: 10.0, left: 10.0, right: 0.0) ,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Total Amount     ",style: TextStyle(fontFamily: "PoppinsLight", fontSize: 16.0,color: AppColors.kPrimaryColorBlue,fontWeight: FontWeight.bold),),
                        SizedBox(height: 5.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                              width: size.width * 0.40,
                              child: Text("Subscription Cost",style:
                              TextStyle(fontFamily: "PoppinsLight",
                                  fontSize: 14.0,
                                  color: AppColors.kPrimaryColorBlue)),
                        ),
                              Container(
                                width: size.width * 0.25,
                                child: Text(CPU == null ? ": ₹ 0.00" :": ₹ $CPU.00",style:
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
                                child: Text("Min Recharge",style:
                                TextStyle(fontFamily: "PoppinsLight",
                                    fontSize: 14.0,
                                    color: AppColors.kPrimaryColorBlue)),
                              ),
                              Container(
                                width: size.width * 0.25,
                                child: Text(widget.rechargeAMT.contains('.')?": ₹ ${widget.rechargeAMT}" :": ₹ ${widget.rechargeAMT}.00",style:
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
                                child: Text(widget.igst == 18 ?": ₹ $IGST":": 0",style:
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
                                child: Text("CGST(9%)SGST(9%)",style:
                                TextStyle(fontFamily: "PoppinsLight",
                                    fontSize: 14.0,
                                    color: AppColors.kPrimaryColorBlue)),
                              ),
                              Container(
                                width: size.width * 0.25,
                                child: Text(": ₹ $IGST",style:
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
                                child: Text(": ₹ $Total",style:
                                TextStyle(fontFamily: "PoppinsLight",
                                    fontSize: 14.0,
                                    color: AppColors.kPrimaryColorBlue)),
                              ),
                            ],
                          )
                        ],
                      ),
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
                          _launchPayURL(Total.toString(),checkedValue.toString(),"Green Bill Subscription");

                        }),
                  ),
                ],
              ),
            )));
  }

  _launchPayURL(amount,id,planType)async {

    if(selected1 == null){
      showInSnackBar("Please Select Users");
      return null;
    }
    if(months == null){
      showInSnackBar("Please Select Months");
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

    print(">>>>>>>>>response ${responses.body}");
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

  // Widget setupAlertDialoagContainer() {
  //   return Container(
  //     height: 250,
  //     width: 350,
  //     child: FutureBuilder<List<Datus>>(
  //       future: getStoreCatList(),
  //       builder: (BuildContext context, AsyncSnapshot<List<Datus>> snapshot) {
  //         if (snapshot.connectionState == ConnectionState.done &&
  //             snapshot.hasData) {
  //           return Scrollbar(
  //               radius: Radius.circular(5.0),
  //               isAlwaysShown: true,
  //               controller: _controller,
  //               thickness: 3.0,
  //               child: ListView.builder(
  //                   controller: _controller,
  //                   itemCount: snapshot.data.length,
  //                   itemBuilder: (BuildContext context, int index) {
  //                     return CheckboxListTile(
  //                       title: Text(snapshot.data[index].business,
  //                           style: TextStyle(fontSize: 15.0)),
  //                       value: checkedValue,
  //                       onChanged: (newVal){
  //                         checkedValue = newVal;
  //                       },
  //                       controlAffinity: ListTileControlAffinity.leading,
  //                       // leading: Container(
  //                       //   width: 35.0,
  //                       //   height: 35.0,
  //                       //   decoration: new BoxDecoration(
  //                       //     color: kPrimaryColorBlue,
  //                       //     borderRadius: new BorderRadius.circular(25.0),
  //                       //   ),
  //                       //   alignment: Alignment.center,
  //                       //   child: new Icon(Icons.store, color: Colors.white, size: 22.0),
  //                       // ),
  //
  //                       // leading:Checkbox(onChanged: (bool value) {
  //                       //
  //                       // }, value: null,
  //                       //
  //                       // ),
  //                       // trailing: Checkbox(
  //                       //
  //                       // ),
  //                       // onTap: () async {
  //                       //   final SharedPreferences prefs = await SharedPreferences.getInstance();
  //                       //   prefs.setString("businessName", snapshot.data[index].mBusinessName);
  //                       //   prefs.setString("businessID", snapshot.data[index].id.toString());
  //                       //  // prefs.setString("businessLogo", snapshot.data[index].mBusinessLogo);
  //                       //  // prefs.setString("businessCategoryID", snapshot.data[index].mBusinessCategory.toString());
  //                       //   setState(() {
  //                       //     store = snapshot.data[index].mBusinessName;
  //                       //     storeID = snapshot.data[index].id.toString();
  //                       //     //storeAddress = '${snapshot.data[index].mAddress}, ${snapshot.data[index].mArea}, ${snapshot.data[index].mCity}';
  //                       //    //// businessLogo = snapshot.data[index].mBusinessLogo;
  //                       //  //   storeCatID = snapshot.data[index].mBusinessCategory.toString();
  //                       //   });
  //                       //   Navigator.of(context).pop();
  //                       //   Navigator.pushAndRemoveUntil(
  //                       //     context,
  //                       //     MaterialPageRoute(
  //                       //         builder: (context) => HomeActivity()),
  //                       //         (Route<dynamic> route) => false,
  //                       //   );
  //                       // },
  //                     );
  //                   }));
  //         } else {
  //           if(snapshot.hasError){
  //             print(">>>>>>>>>>${snapshot.error}");
  //           };
  //           return Center(
  //               child: CircularProgressIndicator(
  //                 // valueColor: animationController.drive(ColorTween(
  //                 //     begin: kPrimaryColorBlue, end: kPrimaryColorGreen)),
  //               ));
  //         }
  //       },
  //     ),
  //   );
  // }


  // showStoreDialog(BuildContext context) {
  //   showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           title: Text(
  //             'Select Business',
  //             style: TextStyle(
  //                 color: Colors.black87,
  //                 fontWeight: FontWeight.w800,
  //                 fontSize: 15.0,
  //                 fontFamily: "PoppinsMedium"),
  //           ),
  //           content: setupAlertDialoagContainer(),
  //           actions: <Widget>[
  //             TextButton(
  //               child:
  //               Text('Cancel', style: TextStyle(color: kPrimaryColorBlue)),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //           ],
  //         );
  //       });
  // }
}

