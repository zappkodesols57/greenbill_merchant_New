import 'dart:core';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/ui/BillInfo/ViewBill.dart';
import 'package:greenbill_merchant/src/ui/values/values.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_getStore.dart';
import 'package:greenbill_merchant/src/ui/HomeScreen/Home.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProceedToBuy extends StatefulWidget {
  final String numberOfUser,igst,costPerUser,cgst,rechargeAMT;
  ProceedToBuy(this.numberOfUser,this.igst,this.costPerUser,this.cgst,this.rechargeAMT);
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

  String token, businessLogo, storeCatID;
  int CPU,NOU;
  double IGST = 0.0,CGST = 0.0,SGST = 0.0,Total = 0.0;

  int id;
  int months;
  String selected1;
  List<String> value1 = ['1','2'];
  List<String> value2 = ['1','2','3','4','5'];
  List<String> value3 = ['1','2','3','4','5','6','7','8','9','10'];
  List<String> plan = ['6 Months','12 Months'];
  String selectedPlan;


  @override
  void initState() {

    super.initState();
    // calculation();
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
                        top: 20.0, bottom: 10.0, left: 0.0, right: 0.0) ,
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
                            // calculation();

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
                            // calculation();
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
                            // calculation();
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
                        top: 20.0, bottom: 10.0, left: 0.0, right: 0.0) ,
                    child: Text("*Note: Select the businesses",style: TextStyle(fontFamily: "PoppinsLight", fontSize: 12.0,color: Colors.red),),
                  ),
                  Container(
                    width: size.width * 0.90,
                    padding: EdgeInsets.only(
                        top: 00.0, bottom: 10.0, left: 0.0, right: 0.0),
                    child: Container(
                      child: new TextField(
                       focusNode: new AlwaysDisabledFocusNode(),
                        // inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),],
                        controller: nameController,
                        maxLength: 20,
                        style: TextStyle(
                          //fontFamily: "PoppinsBold",
                            fontSize: 17.0,
                            color: Colors.black87),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          counterStyle: TextStyle(
                            height: double.minPositive,
                          ),
                          counterText: "",
                          contentPadding: const EdgeInsets.symmetric(vertical: 0.0,horizontal: 15.0),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: kPrimaryColorBlue, width: 0.5),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(35.0)),
                          ),
                          focusedBorder: new OutlineInputBorder(
                            borderSide:
                            BorderSide(color: kPrimaryColorBlue, width: 0.5),
                            borderRadius:
                            const BorderRadius.all(Radius.circular(35.0)),
                          ),
                          suffixIcon: IconButton(
                           icon: Icon(Icons.arrow_drop_down),
                            color: kPrimaryColorBlue,
                            iconSize: 23.0,
                          ),
                          labelText: "Select business *",
                          labelStyle: TextStyle(
                              fontFamily: "PoppinsLight",
                              fontSize: 13.0,
                              color: kPrimaryColorBlue),
                        ),
                        onTap: (){
                          showStoreDialog(context);
                        },
                      ),
                    ),
                  ),

                  SizedBox(height: 20.0,),

                  Container(
                    width: size.width * 0.90,
                    padding: EdgeInsets.only(
                        top: 20.0, bottom: 10.0, left: 10.0, right: 0.0) ,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Total Amount",style: TextStyle(fontFamily: "PoppinsLight", fontSize: 16.0,color: AppColors.kPrimaryColorBlue),),
                      SizedBox(height: 5.0,),
                        Row(
                          children: [
                            Container(
                            width: size.width * 0.40,
                            child: Text("Subscription Cost",style:
                            TextStyle(fontFamily: "PoppinsLight",
                                fontSize: 14.0,
                                color: AppColors.kPrimaryColorBlue)),
                      ),
                            Container(
                              width: size.width * 0.40,
                              child: Text(CPU == null ? ": 0" :": $CPU",style:
                              TextStyle(fontFamily: "PoppinsLight",
                                  fontSize: 14.0,
                                  color: AppColors.kPrimaryColorBlue)),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(
                              width: size.width * 0.40,
                              child: Text("Min Recharge",style:
                              TextStyle(fontFamily: "PoppinsLight",
                                  fontSize: 14.0,
                                  color: AppColors.kPrimaryColorBlue)),
                            ),
                            Container(
                              width: size.width * 0.40,
                              child: Text(": ${widget.rechargeAMT} ",style:
                              TextStyle(fontFamily: "PoppinsLight",
                                  fontSize: 14.0,
                                  color: AppColors.kPrimaryColorBlue)),
                            ),
                          ],
                        ),

                        if(widget.igst == "18")
                        Row(
                          children: [
                            Container(
                              width: size.width * 0.40,
                              child: Text("IGST (${widget.igst}%)",style:
                              TextStyle(fontFamily: "PoppinsLight",
                                  fontSize: 14.0,
                                  color: AppColors.kPrimaryColorBlue)),
                            ),
                            Container(
                              width: size.width * 0.40,
                              child: Text(widget.igst == "18" ?": $IGST":": 0",style:
                              TextStyle(fontFamily: "PoppinsLight",
                                  fontSize: 14.0,
                                  color: AppColors.kPrimaryColorBlue)),
                            ),
                          ],
                        ),
                        if(widget.igst == "1")
                        Row(
                          children: [
                            Container(
                              width: size.width * 0.40,
                              child: Text("CGST(9%)SGST(9%)",style:
                              TextStyle(fontFamily: "PoppinsLight",
                                  fontSize: 14.0,
                                  color: AppColors.kPrimaryColorBlue)),
                            ),
                            Container(
                              width: size.width * 0.40,
                              child: Text(": $IGST",style:
                              TextStyle(fontFamily: "PoppinsLight",
                                  fontSize: 14.0,
                                  color: AppColors.kPrimaryColorBlue)),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Container(
                              width: size.width * 0.40,
                              child: Text("Total Cost",style:
                              TextStyle(fontFamily: "PoppinsLight",
                                  fontSize: 14.0,
                                  color: AppColors.kPrimaryColorBlue)),
                            ),
                            Container(
                              width: size.width * 0.40,
                              child: Text(": $Total",style:
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
                            "Send",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22.0,
                                fontFamily: "PoppinsBold"),
                          ),
                        ),
                        onPressed: () {
                         // submit();
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
                        // leading: Container(
                        //   width: 35.0,
                        //   height: 35.0,
                        //   decoration: new BoxDecoration(
                        //     color: kPrimaryColorBlue,
                        //     borderRadius: new BorderRadius.circular(25.0),
                        //   ),
                        //   alignment: Alignment.center,
                        //   child: new Icon(Icons.store, color: Colors.white, size: 22.0),
                        // ),

                        // leading:Checkbox(onChanged: (bool value) {
                        //
                        // }, value: null,
                        //
                        // ),
                        // trailing: Checkbox(
                        //
                        // ),
                        // onTap: () async {
                        //   final SharedPreferences prefs = await SharedPreferences.getInstance();
                        //   prefs.setString("businessName", snapshot.data[index].mBusinessName);
                        //   prefs.setString("businessID", snapshot.data[index].id.toString());
                        //  // prefs.setString("businessLogo", snapshot.data[index].mBusinessLogo);
                        //  // prefs.setString("businessCategoryID", snapshot.data[index].mBusinessCategory.toString());
                        //   setState(() {
                        //     store = snapshot.data[index].mBusinessName;
                        //     storeID = snapshot.data[index].id.toString();
                        //     //storeAddress = '${snapshot.data[index].mAddress}, ${snapshot.data[index].mArea}, ${snapshot.data[index].mCity}';
                        //    //// businessLogo = snapshot.data[index].mBusinessLogo;
                        //  //   storeCatID = snapshot.data[index].mBusinessCategory.toString();
                        //   });
                        //   Navigator.of(context).pop();
                        //   Navigator.pushAndRemoveUntil(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => HomeActivity()),
                        //         (Route<dynamic> route) => false,
                        //   );
                        // },
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
}
