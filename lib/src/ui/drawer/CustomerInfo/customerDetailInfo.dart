import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:greenbill_merchant/src/models/model_customerBills.dart';
import 'package:greenbill_merchant/src/models/model_infoCashmemo.dart';
import 'package:greenbill_merchant/src/models/model_infoReceipts.dart';
import 'package:http/http.dart' as http;
import 'package:image_downloader/image_downloader.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class CustomerDetailInfo extends StatefulWidget {
  final String token, id, storeID, mobileNo, email, name, state, city;

  CustomerDetailInfo(this.token, this.id, this.storeID, this.mobileNo,
      this.email, this.name, this.state, this.city);

  @override
  CustomerDetailInfoState createState() => CustomerDetailInfoState();
}

class CustomerDetailInfoState extends State<CustomerDetailInfo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  File media;
  Dio dio = new Dio();
  bool _onTapBox1 = true;
  bool _onTapBox2 = false;
  bool _onTapBox3 = false;
  Color _colorMerchantContainer = Colors.white;
  Color _colorMerchantText = kPrimaryColorBlue;

  String name,mobile;

  @override
  void initState() {
    name = widget.name;
    mobile = widget.mobileNo;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    media.delete();
  }

  Future<CustomerBills> getCustomerAllBills() async {
    final param = {
      "user_id": widget.id,
      "mobile_no": widget.mobileNo,
    };

    final res = await http.post(
      "http://157.230.228.250/get-bills-by-mobile-no-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token ${widget.token}"},
    );

    print(res.body);
    if (200 == res.statusCode) {
      print(customerBillsFromJson(res.body).allBills.length);
      return customerBillsFromJson(res.body);
    } else {
      throw Exception('Failed to load List');
    }
  }

  Future<CustomerCashmemo> getCustomerCashMemo() async {
    final param = {
      "user_id": widget.id,
      "merchant_business_id": widget.storeID,
      "mobile_no": widget.mobileNo,
    };

    final res = await http.post(
      "http://157.230.228.250/get-cash-memo-by-mobile-no-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token ${widget.token}"},
    );

    print(res.body);
    if (200 == res.statusCode) {
      print(customerMemoFromJson(res.body).datad.length);
      return customerMemoFromJson(res.body);
    } else {
      throw Exception('Failed to load List');
    }
  }

  Future<CustomerReceipt> getCustomerReceipt() async {
    final param = {
      "user_id": widget.id,
      "merchant_business_id": widget.storeID,
      "mobile_no": widget.mobileNo,
    };

    final res = await http.post(
      "http://157.230.228.250/get-receipt-by-mobile-no-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token ${widget.token}"},
    );

    print(res.body);
    if (200 == res.statusCode) {
      print(customerReceiptFromJson(res.body).datar.length);
      return customerReceiptFromJson(res.body);
    } else {
      throw Exception('Failed to load List');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Customer Details"),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(children: [
        Container(
            child: Column(
          children: [
            // Container(
            //   color: kPrimaryColorBlue.withOpacity(0.3),
            //   child: Text(
            //     "Customer Personal Details",
            //     textAlign: TextAlign.left,
            //     style: TextStyle(
            //         fontSize: 20.0,
            //         color: Colors.white,
            //         fontFamily: "PoppinsMedium",
            //         fontWeight: FontWeight.bold),
            //   ),
            //   padding: EdgeInsets.only(left: 20.0, top: 3.0),
            //   height: 40.0,
            //   width: size.width,
            // ),
            Container(
              width: size.width,
              padding: EdgeInsets.only(left: 20.0, top: 10.0, bottom: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (name != "")
                    Row(
                      children: [
                        Container(
                          width: size.width * 0.30,
                          child: Text(
                            "Name",
                            style: TextStyle(
                                fontFamily: "PoppinsMedium",
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: Text(
                            ": $name",
                            style: TextStyle(
                                fontFamily: "PoppinsMedium",
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  if (mobile != "")
                    Row(
                      children: [
                        Container(
                          width: size.width * 0.30,
                          child: Text(
                            "Mobile No.",
                            style: TextStyle(
                                fontFamily: "PoppinsMedium",
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: Text(
                            ": $mobile",
                            style: TextStyle(
                                fontFamily: "PoppinsMedium",
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  if (widget.email != "")
                    Row(
                      children: [
                        Container(
                          width: size.width * 0.30,
                          child: Text(
                            "Email",
                            style: TextStyle(
                                fontFamily: "PoppinsMedium",
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: Text(
                            ": ${widget.email}",
                            style: TextStyle(
                                fontFamily: "PoppinsMedium",
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  if (widget.state != "")
                    Row(
                      children: [
                        Container(
                          width: size.width * 0.30,
                          child: Text(
                            "State",
                            style: TextStyle(
                                fontFamily: "PoppinsMedium",
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: Text(
                            ": ${widget.state}",
                            style: TextStyle(
                                fontFamily: "PoppinsMedium",
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  if (widget.city != "")
                    Row(
                      children: [
                        Container(
                          width: size.width * 0.30,
                          child: Text(
                            "City",
                            style: TextStyle(
                                fontFamily: "PoppinsMedium",
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: Text(
                            ": ${widget.city}",
                            style: TextStyle(
                                fontFamily: "PoppinsMedium",
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        )),
        SizedBox(
          height: 10.0,
        ),
        Container(
          width: size.width,
          height: 30,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(40))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                      color: _onTapBox1
                          ? kPrimaryColorBlue
                          : _colorMerchantContainer,
                      border: Border.all(color: kPrimaryColorBlue),
                      borderRadius: BorderRadius.all(Radius.circular(40))),
                  width: size.width * 0.30,
                  child: Center(
                      child: Text(
                    'Customer Bills',
                    style: TextStyle(
                        color: _onTapBox1 ? Colors.white : _colorMerchantText),
                  )),
                ),
                onTap: () {
                  setState(() {
                    _onTapBox2 = false;
                    _onTapBox3 = false;
                    _onTapBox1 = true;
                  });
                },
              ),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                      color: _onTapBox2
                          ? kPrimaryColorBlue
                          : _colorMerchantContainer,
                      border: Border.all(color: kPrimaryColorBlue),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  width: size.width * 0.30,
                  child: Center(
                      child: Text(
                    'Cash Memos',
                    style: TextStyle(
                        color: _onTapBox2 ? Colors.white : _colorMerchantText),
                  )),
                ),
                onTap: () {
                  setState(() {
                    _onTapBox3 = false;
                    _onTapBox1 = false;
                    _onTapBox2 = true;
                  });
                },
              ),
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                      color: _onTapBox3
                          ? kPrimaryColorBlue
                          : _colorMerchantContainer,
                      border: Border.all(color: kPrimaryColorBlue),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  width: size.width * 0.30,
                  child: Center(
                      child: Text(
                    'Receipts',
                    style: TextStyle(
                        color: _onTapBox3 ? Colors.white : _colorMerchantText),
                  )),
                ),
                onTap: () {
                  setState(() {
                    _onTapBox1 = false;
                    _onTapBox2 = false;
                    _onTapBox3 = true;
                  });
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        if (_onTapBox1)
          Expanded(
            child: FutureBuilder<CustomerBills>(
              future: getCustomerAllBills(),
              builder: (BuildContext context,
                  AsyncSnapshot<CustomerBills> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                      child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),
                  ));
                else if (snapshot.hasError) {
                  return Center(
                    child: Text("No Bills Found!"),
                  );
                } else {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10.0,
                        ),
                        if (_onTapBox1)
                          ListTile(
                            tileColor: kPrimaryColorBlue,
                            title: Text(
                              " Bill Date",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "PoppinsBold"),
                            ),
                            trailing: Wrap(
                              spacing: 20, // space between two icons
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: <Widget>[
                                Container(
                                  width: 65.0,
                                  child: Text(
                                    "Amount",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "PoppinsBold"),
                                  ),
                                ),
                                Container(
                                  width: 100.0,
                                  child: Text(
                                    "Action ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "PoppinsBold"),
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(builder:  (context)=>MerchantBillList(snapshot.data[index].mBusinessName)));
                            },
                          ),
                        if (_onTapBox1)
                          Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data.allBills.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    child: ListTile(
                                      title: Text(
                                          snapshot.data.allBills[index].billDate,
                                          style: TextStyle(fontSize: 15.0)),
                                      trailing: Wrap(
                                        spacing: 1,
                                        // space between two icons
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: <Widget>[

                                          Container(
                                            alignment: Alignment.center,
                                            width: 100.0,
                                            child: Text(
                                                "₹ ${double.parse(snapshot.data.allBills[index].amount).toStringAsFixed(2)}",
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold)),
                                          ),

                                          IconButton(
                                            icon: Icon(
                                              FontAwesomeIcons.paperPlane,
                                              size: 15.0,
                                              color: kPrimaryColorBlue,
                                            ),
                                            onPressed: () {
                                              if (snapshot.data.allBills[index]
                                                  .billFile.isEmpty) {
                                                showInSnackBar(
                                                    "No Bill Found!");
                                                return null;
                                              }
                                              sendSms(
                                                  snapshot.data.allBills[index]
                                                      .billId,
                                                  snapshot.data.allBills[index]
                                                      .dbTable,
                                                  snapshot.data.allBills[index]
                                                      .mobileNo);
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              FontAwesomeIcons.download,
                                              size: 15.0,
                                              color: kPrimaryColorBlue,
                                            ),
                                            onPressed: () async {
                                              try {
                                                await ImageDownloader.downloadImage(snapshot.data.allBills[index].billFile).then((context) => showInSnackBar("Download Complete"));
                                              }
                                              on PlatformException catch (error) {
                                                print(error);
                                              }
                                            },
                                            // onPressed: ()
                                            // {
                                            //   if (snapshot.data.allBills[index]
                                            //       .billFile.isEmpty) {
                                            //     showInSnackBar(
                                            //         "No Bill Found!");
                                            //     return null;
                                            //   }
                                            //   openBill(
                                            //       snapshot.data.allBills[index]
                                            //           .billFile,
                                            //       snapshot.data.allBills[index]
                                            //           .billFile
                                            //           .split("/")
                                            //           .last);
                                            // },
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        // Navigator.push(context, MaterialPageRoute(builder:  (context)=>MerchantBillList(snapshot.data[index].mBusinessName)));
                                      },
                                    ),
                                  );
                                }),
                          ),
                      ],
                    );
                  } else {
                    return Center(
                        child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),
                    ));
                  }
                }
              },
            ),
          ),
        if (_onTapBox2)
          Expanded(
            child: FutureBuilder<CustomerCashmemo>(
              future: getCustomerCashMemo(),
              builder: (BuildContext context,
                  AsyncSnapshot<CustomerCashmemo> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                      child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),
                  ));
                else if (snapshot.hasError) {
                  return Center(
                    child: Text("No Cash Memo Available"),
                  );
                } else if (snapshot.data.datad.isEmpty) {
                  return Center(
                    child: Text("No Cash Memo Available"),
                  );
                } else {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return Column(
                      children: [
                        if (_onTapBox2)
                          Container(
                            child: ListTile(
                              tileColor: kPrimaryColorBlue,
                              title: Text(
                                "Date",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "PoppinsBold"),
                              ),
                              trailing: Wrap(
                                spacing: 10, // space between two icons
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 80.0,
                                    child: Text(
                                      "Memo No.",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "PoppinsBold"),
                                    ),
                                  ),
                                  Container(
                                    width: 90.0,
                                    child: Text(
                                      "Amount",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "PoppinsBold"),
                                    ),
                                  ),
                                  Container(
                                    width: 60.0,
                                    child: Text(
                                      "Action",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "PoppinsBold"),
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        if (_onTapBox2)
                          Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data.datad.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    child: ListTile(
                                      title: Text(
                                          "${snapshot.data.datad[index].date}",
                                          style: TextStyle(fontSize: 15.0)),
                                      trailing: Wrap(
                                        spacing: 10,
                                        // space between two icons
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.center,
                                            width: 80.0,
                                            child: Text(
                                                "${snapshot.data.datad[index].memoNo}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            width: 80.0,
                                            child: Text(
                                                "₹ ${double.parse(snapshot.data.datad[index].amount).toStringAsFixed(2)}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Container(
                                            width: 60.0,
                                            alignment: Alignment.center,
                                            child: IconButton(
                                              icon: Icon(
                                                FontAwesomeIcons.paperPlane,
                                                size: 15.0,
                                                color: kPrimaryColorBlue,
                                              ),
                                              onPressed: () {
                                                sendMemoSms(snapshot.data.datad[index].Id, widget.mobileNo);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        // Navigator.push(context, MaterialPageRoute(builder:  (context)=>MerchantBillList(snapshot.data[index].mBusinessName)));
                                      },
                                    ),
                                  );
                                }),
                          ),
                      ],
                    );
                  } else {
                    return Center(child: Text("No Cash Memo Available"));
                  }
                }
              },
            ),
          ),

        if (_onTapBox3)
          Expanded(
            child: FutureBuilder<CustomerReceipt>(
              future: getCustomerReceipt(),
              builder: (BuildContext context,
                  AsyncSnapshot<CustomerReceipt> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                      child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),
                  ));
                else if (snapshot.hasError) {
                  return Center(
                    child: Text("No Receipts Available"),
                  );
                } else if (snapshot.data.datar.isEmpty) {
                  return Center(
                    child: Text("No Receipts Available"),
                  );
                } else {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return Column(
                      children: [

                        if (_onTapBox3)
                          Container(
                            child: ListTile(
                              tileColor: kPrimaryColorBlue,
                              title: Text(
                                "Date",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "PoppinsBold"),
                              ),
                              trailing: Wrap(
                                spacing: 15, // space between two icons
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: <Widget>[
                                  Container(
                                    width: 62.0,
                                    child: Text(
                                      "Receipt",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "PoppinsBold"),
                                    ),
                                  ),
                                  Container(
                                    width: 80.0,
                                    child: Text(
                                      "Amount",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "PoppinsBold"),
                                    ),
                                  ),
                                  Container(
                                    width: 60.0,
                                    child: Text(
                                      "Action",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: "PoppinsBold"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        if (_onTapBox3)
                          Expanded(
                            child: ListView.builder(
                                itemCount: snapshot.data.datar.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    child: ListTile(
                                      title: Text(
                                          "${snapshot.data.datar[index].date}",
                                          style: TextStyle(fontSize: 15.0),),
                                      trailing: Wrap(
                                        spacing: 10,
                                        // space between two icons
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            width: 80.0,
                                            alignment: Alignment.center,
                                            child: Text(
                                                "${snapshot.data.datar[index].receptNo}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Container(
                                            width: 80.0,
                                            alignment: Alignment.center,
                                            child: Text(
                                                "₹ ${double.parse(snapshot.data.datar[index].amount).toStringAsFixed(2)}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                          Container(
                                            width: 60.0,
                                            alignment: Alignment.center,
                                            child: IconButton(
                                              icon: Icon(
                                                FontAwesomeIcons.paperPlane,
                                                size: 15.0,
                                                color: kPrimaryColorBlue,
                                              ),
                                              onPressed: () {
                                                sendReceiptSms(snapshot.data.datar[index].Id, widget.mobileNo);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        // Navigator.push(context, MaterialPageRoute(builder:  (context)=>MerchantBillList(snapshot.data[index].mBusinessName)));
                                      },
                                    ),
                                  );
                                }),
                          ),
                      ],
                    );
                  } else {
                    return Center(child: Text("No Receipts Available"));
                  }
                }
              },
            ),
          ),
      ]),
    );
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

  Future<void> sendMemoSms(int memoNo, String mobileNumber) async {
    _showLoaderDialog(context);
    final param = {
      "cash_memo_id":memoNo.toString(),
      "mobile_no":mobileNumber,
    };

    final response = await http.post(
      "http://157.230.228.250/merchant-cash-memo-send-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token ${widget.token}"},
    );
    print(response.statusCode);
    CommonData data;

    print(response.body);
    data = new CommonData.fromJson(jsonDecode(response.body));

    Navigator.of(context, rootNavigator: true).pop();
    if (response.statusCode == 200) {
      if (data.status == "success") {
        showInSnackBar("Cash Memo Sent Successfully");
      } else {
        print(data.status);
      }
    } else {
      showInSnackBar(data.message);
      print(response.statusCode);
      return null;
    }
  }

  Future<void> sendReceiptSms(int id, String mobileNumber) async {

    _showLoaderDialog(context);

    final param = {
      "receipt_id": id.toString(),
      "mobile_no": mobileNumber,
    };

    final response = await http.post(
      "http://157.230.228.250/merchant-receipt-send-api/",
      body: param, headers: {HttpHeaders.authorizationHeader: "Token ${widget.token}"},
    );

    print(response.statusCode);
    CommonData data;
    var responseJson = json.decode(response.body);
    print(response.body);
    data = new CommonData.fromJson(jsonDecode(response.body));
    print(responseJson);

    if (response.statusCode == 200) {
      print("Sent Successful");
      print(data.status);
      if(data.status == "success"){
        Navigator.of(context, rootNavigator: true).pop();
        showInSnackBar("Receipt Sent Successfully");
      } else showInSnackBar(data.message);
    } else {
      showInSnackBar(data.message);
      Navigator.of(context, rootNavigator: true).pop();
      print(data.status);
      return null;
    }
  }


  Future<void> sendSms(int billId, String dbTable, String mobileNo) async {
    _showLoaderDialog(context);
    final param = {
      "bill_id": billId.toString(),
      "db_table": dbTable,
      "mobile_no": mobileNo,
    };

    final response = await http.post(
      "http://157.230.228.250/customer-info-send-sms-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token ${widget.token}"},
    );
    print(response.statusCode);
    CommonData data;
    var responseJson = json.decode(response.body);
    print(response.body);
    data = new CommonData.fromJson(jsonDecode(response.body));
    print(responseJson);
    Navigator.of(context, rootNavigator: true).pop();
    if (response.statusCode == 200) {
      if (data.status == "success") {
        print("Send Successful");
        showInSnackBar(data.message);
        print(data.message);
      } else {
        print(data.status);
        showInSnackBar(data.message);
      }
    } else {
      print(data.status);
      showInSnackBar(data.message);
    }
  }

  Future<void> openBill(String billFile, String fileName) async {
    _showLoaderDialog(context);
    var tempDir = await getTemporaryDirectory();
    String fullPath = tempDir.path + "/$fileName";
    File file = new File(fullPath);
    print('full path ${fullPath}');
    download2(dio, billFile, fullPath);
    setState(() {
      media = file;
    });
  }

  Future download2(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status < 500;
            }),
      );
      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.data);
      await raf.close();
      print(file.path);
      Navigator.of(context, rootNavigator: true).pop();
      final result = await OpenFile.open(file.path);
      print(
          "==========================================================> ${result.message} ${result.type.index}");
    } catch (e) {
      print(e);
    }
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }
}
