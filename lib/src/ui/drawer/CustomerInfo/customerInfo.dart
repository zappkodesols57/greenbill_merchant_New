import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/ui/drawer/CustomerInfo/customerDetailInfo.dart';
import 'package:greenbill_merchant/src/models/model_CustomerInfo.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CustomerInfo extends StatefulWidget {
  @override
  CustomerInfoState createState() => CustomerInfoState();
}

class CustomerInfoState extends State<CustomerInfo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, id, storeID;
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
      id = prefs.getInt("userID").toString();
      storeID = prefs.getString("businessID");
    });
    print('$token\n$id\n$storeID');
  }

  Future<List<Datum>> getCustomerInfoList() async {
    final param = {
      "user_id": id,
      "merchant_business_id": storeID,
    };

    final res = await http.post(
      "http://157.230.228.250/get-customer-info-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(res.body);
    if(200 == res.statusCode){
      print(cInfoFromJson(res.body).data.length);
      return cInfoFromJson(res.body).data.where((element) =>
          element.mobileNo.toString().toLowerCase().contains(query.text)||
          element.name.toUpperCase().toLowerCase().contains(query.text.toUpperCase().toLowerCase())||
          element.city.toUpperCase().toLowerCase().contains(query.text.toUpperCase().toLowerCase())||
          element.state.toUpperCase().toLowerCase().contains(query.text.toUpperCase().toLowerCase())).toList();

    } else{
      throw Exception('Failed to load Stores List');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Customer Info"),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context, true);
            },
          ),
        ),
        body: Column(
          children: [
            Container(
              width: size.width * 0.99,
              padding: EdgeInsets.only(
                  top: 10.0, bottom: 10.0, left: 0.0, right: 0.0),
              decoration: BoxDecoration(
                borderRadius:  BorderRadius.circular(32),
              ),
              child: TextField(
                controller: query,
                // keyboardType: TextInputType.phone,
                // maxLength: 10,
                textCapitalization: TextCapitalization.characters,
                onChanged: (value){
                  getCustomerInfoList();
                  setState(() {
                  });
                },
                // inputFormatters: <TextInputFormatter>[
                //   FilteringTextInputFormatter.digitsOnly
                // ],
                style: TextStyle(
                    fontFamily: "PoppinsMedium",
                    fontSize: 15.0,
                    color: kPrimaryColorBlue),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  counterStyle: TextStyle(height: double.minPositive,),
                  counterText: "",
                  contentPadding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 20.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColorBlue, width: 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                  ),
                  focusedBorder: new OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColorBlue, width: 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                  ),
                  // prefixIcon: Icon(
                  //   FontAwesomeIcons.search,
                  //   color: kPrimaryColorBlue,
                  //   size: 20.0,
                  // ),
                  suffixIcon: GestureDetector(
                    onTap:(){

                    },
                    child: Icon(
                      CupertinoIcons.search,
                      color: kPrimaryColorBlue,
                      size: 25.0,
                    ),
                  ),
                  hintText: "Search Customers",
                  hintStyle: TextStyle(
                      fontFamily: "PoppinsMedium", fontSize: 15.0, color: kPrimaryColorBlue),
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: FutureBuilder<List<Datum>>(
                  future: getCustomerInfoList(),
                  builder: (BuildContext context, AsyncSnapshot<List<Datum>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),));
                    else if (snapshot.hasError) {
                      return Center(
                        child: Text("No Data Found!"),
                      );
                    } else{
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        // WidgetsBinding.instance.addPostFrameCallback((_) {
                        //   if (_controller.hasClients) {
                        //     _controller.animateTo(
                        //         _controller.position.maxScrollExtent,
                        //         duration: Duration(milliseconds: 500),
                        //         curve: Curves.fastLinearToSlowEaseIn);
                        //   } else {
                        //     setState(() => null);
                        //   }
                        // });
                        return Scrollbar(
                          isAlwaysShown: true,
                          controller: _controller,
                          thickness: 3.0,
                          child: ListView.builder(
                              controller: _controller,
                              reverse: false,
                              shrinkWrap: true,
                              itemCount: snapshot.data.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  child: ListTile(
                                    title: Text(
                                        "Mobile No. : ${snapshot.data[index].mobileNo}",
                                        style: TextStyle(fontSize: 15.0)
                                    ),
                                    subtitle: Text(
                                      "Name : ${snapshot.data[index].name}\nEmail : ${snapshot.data[index].email}\nState : ${snapshot.data[index].state}\nCity : ${snapshot.data[index].city}",
                                        style: TextStyle(fontSize: 12.0)
                                    ),
                                    // trailing: Text("₹ ${snapshot.data[index].amount}", style: TextStyle(fontWeight: FontWeight.bold)),
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder:  (context)=>CustomerDetailInfo(token, id, storeID,
                                          snapshot.data[index].mobileNo,snapshot.data[index].email,snapshot.data[index].name)));
                                    },
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
              ),
            )
          ],
        )
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