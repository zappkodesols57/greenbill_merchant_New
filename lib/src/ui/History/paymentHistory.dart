import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:greenbill_merchant/src/Services/historyServices.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/ui/BillInfo/ViewBill.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:greenbill_merchant/src/models/model_History.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class History extends StatefulWidget {
  @override
  HistoryState createState() => HistoryState();
}

class HistoryState extends State<History> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, id, storeID;
  String amount="0";
  int totalTran=0;
  int subTotal;
  String total="0";
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
    };
    final res = await http.post("http://157.230.228.250/merchant-get-payment-history-api/",
        body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"});

    print(res.body);
    print(res.statusCode);
    if (200 == res.statusCode) {
      setState(() {
        total=paymentHistoryFromJson(res.body).totalAmountSpent;
        totalTran=paymentHistoryFromJson(res.body).totalTransactionCount;
      });
      print(paymentHistoryFromJson(res.body).data.length);

      print("Vinay"+total.toString());
      print(totalTran);

    } else {
      throw Exception('Failed to load List');
    }
  }


  Future<List<Datum>> getBillInfoList() async {
    final param = {
      "merchant_business_id": storeID,
    };

    final res = await http.post("http://157.230.228.250/merchant-get-payment-history-api/",
        body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"});


    if (200 == res.statusCode) {
      print(paymentHistoryFromJson(res.body).data.length);
      total=paymentHistoryFromJson(res.body).totalAmountSpent;
      totalTran=paymentHistoryFromJson(res.body).totalTransactionCount;
      return paymentHistoryFromJson(res.body).data;
    } else {
      throw Exception('Failed to load List');
    }
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
              padding: EdgeInsets.fromLTRB(10.00, 10.00, 10.00, 0),
              width: double.maxFinite,
              child: Container(
                width: size.width * 0.9,
                child: Row(
                  children: [
                    Container(
                      child:Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation:10,
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
                                  "Total Amount",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.0,
                                      fontFamily: "PoppinsBold"),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: size.width * 0.4,
                                child: Text("₹"+total.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.0,
                                      fontFamily: "PoppinsBold"),
                                ),
                              ),
                            ],
                          ),
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
                                  "Total Transaction",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.0,
                                      fontFamily: "PoppinsBold"),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                width: size.width * 0.4,
                                child: Text(totalTran.toString(),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.0,
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
                      child: Text("No History Available"),
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
                                  elevation: 2.0,
                                  child: Center(
                                    child: ListTile(
                                      dense: true,
                                      title: Text(
                                          snapshot.data[index].business,
                                          style: TextStyle(fontSize: 15.0, fontFamily: "PoppinsMedium", fontWeight: FontWeight.bold)
                                      ),
                                      subtitle: Text('Purchase Date : ${snapshot.data[index].purchaseDate }\nTransaction Id : ${snapshot.data[index].transactionId == null ? "----" : snapshot.data[index].transactionId}\nPayment Mode : ${snapshot.data[index].mode}',
                                          style: TextStyle(fontSize: 10.0)) ,
                                      isThreeLine: false,
                                      trailing: Wrap(
                                        spacing: 10, // space between two icons
                                        crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                        children: <Widget>[

                                          Text(
                                              "₹ ${(snapshot.data[index].cost).toStringAsFixed(2)}",
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
