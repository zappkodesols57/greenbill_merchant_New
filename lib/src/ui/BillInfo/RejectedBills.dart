import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:greenbill_merchant/src/models/model_rejectedBills.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ViewBill.dart';

class BillRejected extends StatefulWidget {
  @override
  BillRejectedState createState() => BillRejectedState();
}

class BillRejectedState extends State<BillRejected> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, id, storeID;
  final ScrollController _controller = ScrollController();
  File media;
  TextEditingController fromDateController = new TextEditingController();
  TextEditingController toDateController = new TextEditingController();
  String fDate = "";
  String eDate = "";
  DateTime dateTime;
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
      "merchant_business_id":storeID,
      "from_date":fDate,
      "to_date":eDate,
    };

    print("parammm $param");

    final res = await http.post("http://157.230.228.250/merchant-get-rejected-bill-api/",
        body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"});

    print(res.body);
    print(res.statusCode);
    if (200 == res.statusCode) {
      print(rejectedFromJson(res.body).data.length);
      return rejectedFromJson(res.body).data
          .where((element) =>
      element.mobileNo.toString().toLowerCase().contains(query.text) ||
          element.invoiceNo.toString().toLowerCase().contains(query.text) ||
          element.billId.toString().toLowerCase().contains(query.text)|| element.amount.toString().contains(query.text))
          .toList();

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
    dateTime= e;
    fDate = '${e.year.toString()}-${e.month.toString()}-${e.day.toString()}';
    fromDateController.text = DateFormat("dd-MM-yyyy").format(e);
    // changeState();
    return fDate;
  }

  _selectDateEnd(BuildContext context) async {
    DateTime e = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate:dateTime,
        lastDate: DateTime.now());
    eDate = '${e.year.toString()}-${e.month.toString()}-${e.day.toString()}';
    if(fDate == "")
    {
      showInSnackBar("Please Select From Date");
    }else {
      toDateController.text = DateFormat("dd-MM-yyyy").format(e);
      setState(() {});
    }
    return eDate;
  }

  Future<void> deleteBill(id,table) async {
    final param = {
      "bill_id":id,
      "db_table":table,
    };

    final response = await http.post("http://157.230.228.250/merchant-delete-bill-api/",
      body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"},);

    print(response.statusCode);
    CommonData data;
    var responseJson = json.decode(response.body);
    data = new CommonData.fromJson(jsonDecode(response.body));
    print(response.body);
   // Navigator.of(context, rootNavigator: true).pop();

    if (response.statusCode == 200) {
      print(responseJson);
      print("Delete Successful");
      print(data.status);
      setState(() {});
      if(data.status == "success"){
        showInSnackBar("Bill Deleted Successfully");

      } else showInSnackBar(data.message);
    } else {
      print(data.status);
      showInSnackBar(data.status);
      return null;
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
            ListTile(
              tileColor: kPrimaryColorBlue,
              title: Container(
                margin: const EdgeInsets.only(left: 10.0, right: 0.0),
                child: Text(
                  "Mobile Number",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white, fontFamily: "PoppinsBold"),
                ),
              ),
              trailing:Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
              children: [
              Container(
                width: 80.0,
                child: Text(
                  "Amount",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontFamily: "PoppinsBold"),
                ),
              ),
              Container(
                width: 70.0,
                child: Text(
                  "Action",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white, fontFamily: "PoppinsBold"),
                ),
              ),
              ],
              ),
              onTap: () {
                // Navigator.push(context, MaterialPageRoute(builder:  (context)=>MerchantBillList(snapshot.data[index].mBusinessName)));
              },
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
                                        style: TextStyle(fontSize: 14.0,fontWeight: FontWeight.bold)),
                                    subtitle: Text(
                                        "Date : ${snapshot.data[index].billDate}\nInvoice Number : ${snapshot.data[index].invoiceNo}",
                                        style: TextStyle(
                                            fontSize: 11.0,
                                            color: Colors.grey)),
                                    isThreeLine: false,

                                    trailing: Wrap(
                                      spacing: 1, // space between two icons
                                      crossAxisAlignment:
                                      WrapCrossAlignment.center,
                                      children: <Widget>[

                                        Container(
                                          alignment: Alignment.center,
                                            width: 90.0,
                                            child: Text("₹ ${double.parse(snapshot.data[index].amount).toStringAsFixed(2)}",
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight.bold))
                                        ),
                                        Container(
                                          width: 60.0,
                                          child: IconButton(
                                            icon: Icon(Icons.delete_outlined, color: kPrimaryColorRed,),
                                            onPressed: () {

                                              deleteBill(snapshot.data[index].billId.toString(), snapshot.data[index].dbTable);


                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {

                                    },
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
