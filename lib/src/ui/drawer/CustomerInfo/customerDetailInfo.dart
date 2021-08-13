import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:greenbill_merchant/src/models/model_customerBills.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class CustomerDetailInfo extends StatefulWidget {
  final String token, id, storeID, mobileNo,email,name;
  CustomerDetailInfo(
      this.token, this.id, this.storeID, this.mobileNo, this.email, this.name);

  @override
  CustomerDetailInfoState createState() => CustomerDetailInfoState();
}

class CustomerDetailInfoState extends State<CustomerDetailInfo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  File media;
  Dio dio = new Dio();

  @override
  void initState() {
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
      throw Exception('Failed to load Stores List');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("All Bills"),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<CustomerBills>(
        future: getCustomerAllBills(),
        builder: (BuildContext context, AsyncSnapshot<CustomerBills> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),
            ));
          else if (snapshot.hasError) {
            return Center(
              child: Text("No Data Found!"),
            );
          } else {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 150.0,
                      child: Column(
                        children: [
                          Container(
                            color: kPrimaryColorBlue.withOpacity(0.3),
                            child: Text(
                              "Customer Personal Details",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                  fontFamily: "PoppinsMedium",
                                  fontWeight: FontWeight.bold),
                            ),
                            padding: EdgeInsets.only(left: 20.0, top: 3.0),
                            height: 40.0,
                            width: size.width,
                          ),
                          Container(
                            height: 100.0,
                            width: size.width,
                            padding: EdgeInsets.only(left: 20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Name         : ${widget.name}",
                                  style: TextStyle(
                                      fontFamily: "PoppinsMedium",
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Mobile No.  : ${widget.mobileNo}",
                                  style: TextStyle(
                                      fontFamily: "PoppinsMedium",
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Email ID      : ${widget.email}",
                                  style: TextStyle(
                                      fontFamily: "PoppinsMedium",
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   color: kPrimaryColorBlue.withOpacity(0.3),
                          //   child: Text(
                          //     "Payment Details",
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
                          // Row(
                          //   children: [
                          //     Container(
                          //       padding: EdgeInsets.only(top: 10.0, left: 20.0),
                          //       child: Text(
                          //         "Total Money Received: ₹ ${widget.amount}",
                          //         style: TextStyle(
                          //             fontFamily: "PoppinsMedium",
                          //             fontWeight: FontWeight.bold),
                          //       ),
                          //     )
                          //   ],
                          // )
                        ],
                      )),
                  ListTile(
                    tileColor: kPrimaryColorBlue,
                    title: Text(
                      "Bill Date",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.white, fontFamily: "PoppinsBold"),
                    ),
                    trailing: Wrap(
                      spacing: 12, // space between two icons
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 50.0,
                          child: Text(
                            "Send",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white, fontFamily: "PoppinsBold"),
                          ),
                        ),
                        Container(
                          width: 50.0,
                          child: Text(
                            "Bill",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white, fontFamily: "PoppinsBold"),
                          ),
                        ),
                        Container(
                          width: 80.0,
                          child: Text(
                            "Amount",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white, fontFamily: "PoppinsBold"),
                          ),
                        )
                      ],
                    ),
                    onTap: () {
                      // Navigator.push(context, MaterialPageRoute(builder:  (context)=>MerchantBillList(snapshot.data[index].mBusinessName)));
                    },
                  ),
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
                                spacing: 12, // space between two icons
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.sms_outlined,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      if (snapshot.data.allBills[index].billFile
                                          .isEmpty) {
                                        showInSnackBar("No Bill Found!");
                                        return null;
                                      }
                                      sendSms(
                                          snapshot.data.allBills[index].billId,
                                          snapshot.data.allBills[index].dbTable,
                                          snapshot
                                              .data.allBills[index].mobileNo);
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.file_present,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      if (snapshot.data.allBills[index].billFile
                                          .isEmpty) {
                                        showInSnackBar("No Bill Found!");
                                        return null;
                                      }
                                      openBill(
                                          snapshot
                                              .data.allBills[index].billFile,
                                          snapshot.data.allBills[index].billFile
                                              .split("/")
                                              .last);
                                    },
                                  ),
                                  Container(
                                    width: 80.0,
                                    child: Text(
                                        "    ₹ ${snapshot.data.allBills[index].amount}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                  ),
                                ],
                              ),
                              onTap: () {
                                // Navigator.push(context, MaterialPageRoute(builder:  (context)=>MerchantBillList(snapshot.data[index].mBusinessName)));
                              },
                            ),
                          );
                        }),
                  )
                ],
              );
            } else {
              return Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),
              ));
            }
          }
        },
      ),
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
