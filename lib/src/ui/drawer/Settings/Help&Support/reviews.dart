import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:greenbill_merchant/src/Services/historyServices.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_rating.dart';
import 'package:sticky_headers/sticky_headers.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Reviews extends StatefulWidget {
  @override
  ReviewsState createState() => ReviewsState();
}

class ReviewsState extends State<Reviews> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, id, storeID;
  String amount="0";
  int totalTran=1;
  int subTotal;
  String total;
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
  }


  Future<List<Datum>> getBillInfoList() async {
    final param = {
      "merchant_business_id": storeID,
    };
    final res = await http.post("http://157.230.228.250/merchant-get-bill-rating-api/",
        body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"});

    print(res.body);
    print(res.statusCode);
    if (200 == res.statusCode) {
      print(ratingFromJson(res.body).data.length);
     // total=paymentHistoryFromJson(res.body).totalAmountSpent;
     // totalTran=paymentHistoryFromJson(res.body).totalTransactionCount;
      return ratingFromJson(res.body).data;
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
                      child: Text("No Data Found!"),
                    );
                  } else {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      return Scrollbar(
                        isAlwaysShown: true,
                        controller: _controller,
                        thickness: 3.0,

                        child:ListView.builder(
                            controller: _controller,
                            reverse: false,
                            shrinkWrap: true,

                            itemCount: snapshot.data.length,
                           // padding:EdgeInsets.fromLTRB(0, 7.00, 0, 0) ,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(padding: EdgeInsets.fromLTRB(0, 0.00, 0, 0),

                                width: double.maxFinite,
                                child: Card(
                                  elevation: 10.0,
                                  color: kPrimaryColorBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          alignment:Alignment.topRight,
                                          width: size.width * 0.9,
                                          padding: EdgeInsets.only(
                                              top: 10.0, bottom: 0.0, left: 5.0, right: 5.0),
                                          child: Text(
                                            snapshot.data[index].rating,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12.0,
                                                fontFamily: "PoppinsBold"),
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
                                                    top: 10.0, bottom: 5.0, left: 5.0, right: 5.0),
                                                width: size.width * 0.4,
                                                child: Text(
                                                  "Mobile Number",
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
                                                  snapshot.data[index].mobileNo.toString(),
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
                                                width: size.width * 0.3,
                                                child: Text(
                                                  "Bill Amount",
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
                                                    "₹ "+snapshot.data[index].billAmount.toString(),
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
                                                  "Bill Date",
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
                                                  snapshot.data[index].billDate.toString().substring(0,10),
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
                                                  "Invoice No",
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
                                                  snapshot.data[index].invoiceNo.toString(),
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
