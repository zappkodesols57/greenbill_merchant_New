import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:greenbill_merchant/src/models/model_billInfoList.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BillInfo extends StatefulWidget {
  @override
  BillInfoState createState() => BillInfoState();
}

class BillInfoState extends State<BillInfo> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, id, storeID;
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

  Future<List<AllBill>> getBillInfoList() async {
    final param = {
      "merchant_business_id": storeID,
    };

    final res = await http.post(
      "http://157.230.228.250/get-bill-info-list-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(res.body);
    if (200 == res.statusCode) {
      print(billInfoModelFromJson(res.body).allBills.length);
      return billInfoModelFromJson(res.body)
          .allBills
          .where((element) =>
              element.mobileNo.toString().toLowerCase().contains(query.text) ||
              element.invoiceNo.toString().toLowerCase().contains(query.text) ||
              element.amount.toString().toLowerCase().contains(query.text))
          .toList();
    } else {
      throw Exception('Failed to load Stores List');
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
              width: size.width * 0.99,
              padding: EdgeInsets.only(
                  top: 10.0, bottom: 10.0, left: 0.0, right: 0.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
              ),
              child: TextField(
                controller: query,
                // keyboardType: TextInputType.phone,
                // maxLength: 10,
                textCapitalization: TextCapitalization.characters,
                onChanged: (value) {
                  getBillInfoList();
                  setState(() {});
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
                  counterStyle: TextStyle(
                    height: double.minPositive,
                  ),
                  counterText: "",
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 13.0, horizontal: 20.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: kPrimaryColorBlue, width: 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                  ),
                  focusedBorder: new OutlineInputBorder(
                    borderSide:
                        BorderSide(color: kPrimaryColorBlue, width: 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                  ),
                  // prefixIcon: Icon(
                  //   FontAwesomeIcons.search,
                  //   color: kPrimaryColorBlue,
                  //   size: 20.0,
                  // ),
                  suffixIcon: GestureDetector(
                    onTap: () {},
                    child: Icon(
                      CupertinoIcons.search,
                      color: kPrimaryColorBlue,
                      size: 25.0,
                    ),
                  ),
                  hintText: "Search Bills",
                  hintStyle: TextStyle(
                      fontFamily: "PoppinsMedium",
                      fontSize: 15.0,
                      color: kPrimaryColorBlue),
                ),
              ),
            ),
            ListTile(
              tileColor: kPrimaryColorBlue,
              title: Text(
                "Mobile No.",
                textAlign: TextAlign.start,
                style:
                TextStyle(color: Colors.white, fontFamily: "PoppinsBold"),
              ),
              trailing: Wrap(
                spacing: 12, // space between two icons
                crossAxisAlignment: WrapCrossAlignment.center,
                children: <Widget>[
                  Container(
                    width: 50.0,
                    child: Text(
                      "SMS ",
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
                    width: 72.0,
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
              child: FutureBuilder<List<AllBill>>(
                future: getBillInfoList(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<AllBill>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                        child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),
                    ));
                  else if (snapshot.hasError) {
                    return Center(
                      child: Text("No Bills Found"),
                    );
                  } else {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {

                      return Scrollbar(
                        isAlwaysShown: true,
                        controller: _controller,
                        thickness: 3.0,
                        child: ListView.builder(
                            controller: _controller,
                            reverse: false,
                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                child: Center(
                                  child: ListTile(
                                    dense: true,
                                    title: Text(snapshot.data[index].mobileNo,
                                        style: TextStyle(fontSize: 15.0)),
                                    subtitle: Text(
                                        "Date : ${snapshot.data[index].billDate}\nInvoice : ${snapshot.data[index].invoiceNo} ",
                                        style: TextStyle(
                                            fontSize: 11.0,
                                            color: Colors.grey)),
                                    isThreeLine: false,
                                    // leading: Container(
                                    //   width: 45.0,
                                    //   height: 45.0,
                                    //   decoration: new BoxDecoration(
                                    //     color: kPrimaryColorBlue,
                                    //     borderRadius: new BorderRadius.circular(25.0),
                                    //   ),
                                    //   alignment: Alignment.center,
                                    //   child: Icon(Icons.receipt_long, color: Colors.white,),
                                    // ),
                                    trailing: Wrap(
                                      spacing: 12, // space between two icons
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: <Widget>[
                                        IconButton(
                                          icon: Icon(
                                            Icons.sms_outlined,
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            if (snapshot
                                                .data[index].billFile.isEmpty) {
                                              showInSnackBar("No Bill Found!");
                                              return null;
                                            }
                                            sendSms(
                                                snapshot.data[index].billId,
                                                snapshot.data[index].dbTable,
                                                snapshot.data[index].mobileNo);
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            Icons.file_present,
                                            color: Colors.black,
                                          ),
                                          onPressed: () {
                                            if (snapshot
                                                .data[index].billFile.isEmpty) {
                                              showInSnackBar("No Bill Found!");
                                              return null;
                                            }
                                            openBill(
                                                snapshot.data[index].billFile,
                                                snapshot.data[index].billFile
                                                    .split("/")
                                                    .last);
                                          },
                                        ),
                                        Container(
                                            width: 70.0,
                                            child: Text(snapshot.data[index].amount.contains(".")?
                                                "₹ ${snapshot.data[index].amount.split(".").first+".00"}":"₹ ${snapshot.data[index].amount+".00"}",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
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

  Future<void> sendSms(int billId, String dbTable, String mobileNo) async {
    _showLoaderDialog(context);
    final param = {
      "bill_id": billId.toString(),
      "db_table": dbTable,
      "mobile_no": mobileNo,
    };

    final response = await http.post(
      "http://157.230.228.250/bill-info-send-sms-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
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
