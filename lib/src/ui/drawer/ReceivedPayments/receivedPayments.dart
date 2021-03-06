import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/Services/historyServices.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_Received.dart';
import 'package:greenbill_merchant/src/ui/BillInfo/ViewBill.dart';
import 'package:intl/intl.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ReceivedPayments extends StatefulWidget {
  @override
  ReceivedPaymentsState createState() => ReceivedPaymentsState();
}

class ReceivedPaymentsState extends State<ReceivedPayments> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, id, storeID;
  int amount = 0;
  int totalTran = 0;
  int subTotal;
  TextEditingController fromDateController = new TextEditingController();
  TextEditingController toDateController = new TextEditingController();
  String fDate = "";
  String eDate = "";
  double total = 0;
  DateTime dateTime;
  final ScrollController _controller = ScrollController();
  File media;
  Dio dio = new Dio();
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
    getInfo();
  }

   getInfo() async {
    final param = {
      "merchant_business_id": storeID,
      "from_date": fDate,
      "to_date": eDate,
    };
    final res = await http.post("http://157.230.228.250/merchant-get-payment-received-api/",
        body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"});

    print(res.body);
    print(res.statusCode);
    if (200 == res.statusCode) {
      setState(() {
        total=receivedPaymentsFromJson(res.body).totalPaymentReceived;
        totalTran=receivedPaymentsFromJson(res.body).totalPaymentReceivedCount;
      });
      print(receivedPaymentsFromJson(res.body).data.length);

      print("Vinay"+total.toString());
      print(totalTran);

      return receivedPaymentsFromJson(res.body).data.where((element) => element.mobile.contains(query.text.toString()) ||
          element.amount.contains(query.text.toString()) || element.transactionId.contains(query.text)).toList();

    } else {
      setState(() {
        totalTran = 0;
        total = 0;
      });
      throw Exception('Failed to load List');
    }
  }

  Future<List<Datum>> getBillInfoList() async {
    final param = {
      "merchant_business_id": storeID,
      "from_date": fDate,
      "to_date": eDate,

    };
    final res = await http.post("http://157.230.228.250/merchant-get-payment-received-api/",
        body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"});

    print(">>>>>>>>>>>>>>>>>${res.body}");
   print(res.statusCode);
    if (200 == res.statusCode) {
      print(receivedPaymentsFromJson(res.body).data.length);
      print(receivedPaymentsFromJson(res.body).totalPaymentReceived);
      print(receivedPaymentsFromJson(res.body).totalPaymentReceivedCount);

      total=receivedPaymentsFromJson(res.body).totalPaymentReceived;
      totalTran=receivedPaymentsFromJson(res.body).totalPaymentReceivedCount;


      return receivedPaymentsFromJson(res.body).data.where((element) => element.mobile.contains(query.text.toString()) ||
          element.amount.contains(query.text.toString()) || element.transactionId.contains(query.text)).toList();
    } else {
      throw Exception('Failed to load List');
    }
  }

  _selectDateStart(BuildContext context) async {
    DateTime e = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    dateTime = e;
    fDate = '${e.year.toString()}-${e.month.toString()}-${e.day.toString()}';
    fromDateController.text = DateFormat("dd-MM-yyyy").format(e);
    // changeState();
    return fDate;
  }

  _selectDateEnd(BuildContext context) async {
    DateTime e = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: dateTime,
        lastDate: DateTime.now());
    eDate = '${e.year.toString()}-${e.month.toString()}-${e.day.toString()}';
    if(fDate == "")
    {
      showInSnackBar("Please Select From Date");
    }else {
      toDateController.text = DateFormat("dd-MM-yyyy").format(e);
      getInfo();
      setState(() {});
    }
    return eDate;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Column(
          children: [
        Container(
        width: size.width * 0.95,
          padding: EdgeInsets.only(
              top: 10.0, bottom: 10.0, left: 0.0, right: 0.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
          ),
          child: TextField(
            controller: query,
            onChanged: (value) {
              getBillInfoList();
              setState(() {});
            },
            style: TextStyle(
                fontFamily: "PoppinsMedium",
                fontSize: 15.0,
                color: kPrimaryColorBlue),
               decoration: InputDecoration(
              border: InputBorder.none,
              counterStyle: TextStyle(
                height: double.minPositive,
              ),
              counterText: "",
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 13.0, horizontal: 20.0),
              enabledBorder: OutlineInputBorder(
                borderSide:
                BorderSide(color: kPrimaryColorBlue, width: 1.0),
                borderRadius:
                const BorderRadius.all(Radius.circular(35.0)),
              ),
              focusedBorder: new OutlineInputBorder(
                borderSide:
                BorderSide(color: kPrimaryColorBlue, width: 1.0),
                borderRadius:
                const BorderRadius.all(Radius.circular(35.0)),
              ),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {});
                },
                child: Icon(
                  CupertinoIcons.search,
                  color: kPrimaryColorBlue,
                  size: 25.0,
                ),
              ),
              hintText: "Search Payments",
              hintStyle: TextStyle(
                  fontFamily: "PoppinsMedium",
                  fontSize: 15.0,
                  color: kPrimaryColorBlue),
            ),
          ),
        ),
            Container(
              width: size.width * 0.95,
              height: 60.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: size.width * 0.4,
                    height: 50.0,
                    padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                    child: TextField(
                      enableInteractiveSelection:
                      false, // will disable paste operation
                      focusNode: new AlwaysDisabledFocusNode(),
                      controller: fromDateController,
                      onTap: () {
                        _selectDateStart(context);
                      },
                      style: TextStyle(
                          fontFamily: "PoppinsBold",
                          fontSize: 12.0,
                          color: kPrimaryColorBlue),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 10.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: kPrimaryColorBlue, width: 1),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                        ),
                        focusedBorder: new OutlineInputBorder(
                          borderSide: BorderSide(
                              color: kPrimaryColorBlue, width: 1),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                        ),
                        prefixIcon: Icon(
                          FontAwesomeIcons.calendar,
                          color: kPrimaryColorBlue,
                          size: 20.0,
                        ),
                        hintText: "From *",

                        hintStyle: TextStyle(
                            fontFamily: "PoppinsBold",
                            fontSize: 12.0,
                            color: kPrimaryColorBlue),
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * 0.4,
                    height: 50.0,
                    padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                    child: TextField(
                      enableInteractiveSelection:
                      false, // will disable paste operation
                      focusNode: new AlwaysDisabledFocusNode(),
                      controller: toDateController,
                      onTap: () {
                        _selectDateEnd(context);
                        setState(() {});
                      },
                      style: TextStyle(
                          fontFamily: "PoppinsBold",
                          fontSize: 12.0,
                          color: kPrimaryColorBlue),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 10.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: kPrimaryColorBlue, width: 1),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                        ),
                        focusedBorder: new OutlineInputBorder(
                          borderSide: BorderSide(
                              color: kPrimaryColorBlue, width: 1),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                        ),
                        prefixIcon: Icon(
                          FontAwesomeIcons.calendar,
                          color: kPrimaryColorBlue,
                          size: 20.0,
                        ),
                        hintText: "To *",

                        hintStyle: TextStyle(
                            fontFamily: "PoppinsBold",
                            fontSize: 12.0,
                            color: kPrimaryColorBlue),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 5.0,),
            Container(
              padding: EdgeInsets.fromLTRB(10.00, 0.00, 10.00, 0),
              width: double.maxFinite,
              child: Container(
                width: size.width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child:Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation:2,
                        child:Container(
                          height: 60,
                          width: size.width * 0.45,
                          padding: EdgeInsets.only(
                              top: 10.0, bottom: 5.0, left: 5.0, right: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                width: size.width * 0.4,
                                child: Text(
                                  "Total Received",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 11.0,
                                      fontFamily: "PoppinsBold"),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: size.width * 0.4,
                                child: Text("??? ${total.toStringAsFixed(2)}",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontFamily: "PoppinsBold"),
                                ),
                              ),
                            ],),
                        ),
                      ),
                    ),
                    Container(

                      child:Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation:2,
                        child:Container(
                          height: 60,
                          width: size.width * 0.45,
                          padding: EdgeInsets.only(
                              top: 10.0, bottom: 5.0, left: 5.0, right: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                width: size.width * 0.4,
                                child: Text(
                                  "Total Received Count",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 11.0,
                                      fontFamily: "PoppinsBold"),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: size.width * 0.4,
                                child: Text(totalTran.toString()
                                  ,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontFamily: "PoppinsBold"),
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
            Expanded(

              child: FutureBuilder<List<Datum>>(
                future: getBillInfoList(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Datum>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                        child: CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),
                        ));
                  else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Center(
                      child: Text("No Payments Available"),
                    );
                  } else {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      return Scrollbar(
                        isAlwaysShown: true,
                        controller: _controller,
                        thickness: 3.0,
                        child:ListView.builder(
                            padding: EdgeInsets.only(
                                top: 10.0, bottom: 0.0, left: 5.0, right: 5.0),
                            controller: _controller,
                            reverse: false,
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return
                                 Card(
                                  elevation: 1.0,
                                  child: Center(
                                    child: ListTile(
                                      dense: true,
                                      title: Text("${snapshot.data[index].mobile == "" ? "Green Bill" :snapshot.data[index].mobile}",
                                          style: TextStyle(fontSize: 15.0, fontFamily: "PoppinsMedium", fontWeight: FontWeight.bold)
                                      ),
                                      subtitle: (snapshot.data[index].description == "") ? Text('Transaction Id : ${snapshot.data[index].transactionId }\nPayment Date : ${snapshot.data[index].paymentDate}',
                                          style: TextStyle(fontSize: 10.0))
                                      :Text('Description : ${snapshot.data[index].description}\nTransaction Id : ${snapshot.data[index].transactionId}\nPayment Date : ${snapshot.data[index].paymentDate}',
                                          style: TextStyle(fontSize: 10.0)),
                                      isThreeLine: false,
                                      trailing: Wrap(
                                        spacing: 10, // space between two icons
                                        crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                        children: <Widget>[
                                          Text(
                                              "??? ${double.parse(snapshot.data[index].amount).toStringAsFixed(2)}",
                                              style: TextStyle(fontSize: 15.0, fontFamily: "PoppinsMedium", fontWeight: FontWeight.bold)
                                          ),
                                        ],
                                      ),
                                      // onTap: () {
                                      //   Navigator.of(context).push(
                                      //     PageRouteBuilder(
                                      //       opaque: false,
                                      //       pageBuilder: (_, animation, __) {
                                      //         return FadeTransition(
                                      //           opacity: animation,
                                      //           child: ViewBill("","",snapshot.data[index].billUrl,"","",""),
                                      //         );
                                      //       },
                                      //     ),
                                      //   );
                                      // },
                                    ),
                                  ),
                              );
                            }
                        ),
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
            )
          ],
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
