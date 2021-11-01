import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/Services/historyServices.dart';
import 'package:greenbill_merchant/src/animations/hero_dialog_route.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_rating.dart';
import 'package:greenbill_merchant/src/ui/drawer/Settings/Help&Support/bar_chart.dart';
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
  String count = "";
  bool search = false;
  String total;
  final ScrollController _controller = ScrollController();
  File media;
  Dio dio = new Dio();
  TextEditingController query = new TextEditingController();

  List<Color> palette = [
    Color.fromRGBO(0, 173, 239, 1.0),
    Color.fromRGBO(204, 18, 46, 1.0),
    Color.fromRGBO(246, 142, 31, 1.0),
    Color.fromRGBO(7, 187, 193, 1.0),
    Color.fromRGBO(0, 110, 182, 1.0),
    Color.fromRGBO(223, 202, 0, 1.0),
    Color.fromRGBO(174, 68, 68, 1.0),
    Color.fromRGBO(136, 197, 61, 1.0),
    Color.fromRGBO(64, 224, 208, 1.0),
    Color.fromRGBO(7, 111, 187, 1.0),
    Color.fromRGBO(197, 47, 88, 1.0),
    Color.fromRGBO(26, 192, 124, 1.0),
    Color.fromRGBO(229, 135, 49, 1.0),
    Color.fromRGBO(87, 136, 76, 1.0),
    Color.fromRGBO(72, 75, 136, 1.0),
    Color.fromRGBO(99, 99, 96, 1.0),
    Color.fromRGBO(141, 95, 142, 1.0),
    Color.fromRGBO(97, 146, 150, 1.0),
    Color.fromRGBO(96, 87, 131, 1.0),
    Color.fromRGBO(99, 255, 162, 1.0),
    Color.fromRGBO(255, 187, 88, 1.0),
    Color.fromRGBO(142, 106, 61, 1.0)
  ];


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
    getBillInfo();
  }

  Future<List<Datum>> getBillInfo() async {
    final param = {
      "merchant_business_id": storeID,
      "merchant_rating": "",
    };
    final res = await http.post("http://157.230.228.250/merchant-get-bill-rating-api/",
        body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"});

    print(res.body);
    print(res.statusCode);
    print(query.text.toString());
    if (200 == res.statusCode) {
      count = ratingFromJson(res.body).count.toString();

      // setState(() {
      //   count = ratingFromJson(res.body).count.toString();
      // });

      print(ratingFromJson(res.body).data.length);
      return ratingFromJson(res.body).data;
    }
    else {
      throw Exception('Failed to load List');
    }
  }

  Future<List<Datum>> getBillInfoList() async {
    final param = {
      "merchant_business_id": storeID,
      "merchant_rating": query.text.isEmpty ? "" : query.text,
    };
    final res = await http.post("http://157.230.228.250/merchant-get-bill-rating-api/",
        body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"});

    print(res.body);
    print(res.statusCode);
    print(query.text.toString());
    if (200 == res.statusCode) {
      if (search == true) {
        count = ratingFromJson(res.body).count.toString();
        print(ratingFromJson(res.body).data.length);
        return ratingFromJson(res.body).data.where((element) =>
            element.ratingId.contains(query.text.toString()))
            .toList();
      }
      else{
        count = ratingFromJson(res.body).count.toString();
        print(ratingFromJson(res.body).data.length);
        return ratingFromJson(res.body).data.where((element) =>
        element.mobileNo.contains(query.text.toString())||
            element.invoiceNo.contains(query.text.toString())||
            element.merchantReplay.contains(query.text.toString())
        ).toList();
      }
    }
    else {
      throw Exception('Failed to load List');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        floatingActionButton: new Padding(
          padding: const EdgeInsets.only(left: 30.0),
          child: AnimatedContainer(
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              child: RawMaterialButton(
                  elevation: 5.0,
                  shape:  RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0))),

                  onPressed: () async{
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => showAlertDialog(),
                    );
                  },

                  fillColor: kPrimaryColorBlue,
                  child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                            "Analysis",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "PoppinsMedium",
                                fontWeight: FontWeight.bold
                            ),
                          )
                      )
                  ))),
        appBar: AppBar(
          title: Text('Ratings'),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Row(
              children: [
                Container(
                  child: Checkbox(
                    value: search,
                    onChanged: (value) {
                      setState(() {
                        search = value;
                        query.clear();
                      });
                    },
                  ),
                ),
                Text("Search By Ratings ( 1 to 5 )",style: TextStyle(
                    fontFamily: "PoppinsMedium",
                    fontSize: 15.0,
                    color: kPrimaryColorBlue),
                ),
              ],
            ),
            Container(
              width: size.width * 0.95,
              padding: EdgeInsets.only(
                  top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
              ),
              child: TextField(
                controller: query,
                keyboardType:(search == true)?TextInputType.number:TextInputType.text,
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
                    },
                    child: Icon(
                      CupertinoIcons.search,
                      color: kPrimaryColorBlue,
                      size: 25.0,
                    ),
                  ),
                  hintText: "Search",
                  hintStyle: TextStyle(
                      fontFamily: "PoppinsMedium",
                      fontSize: 15.0,
                      color: kPrimaryColorBlue),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                child: Flexible(
                  child: FutureBuilder<List<Datum>>(
                      future: getBillInfoList(),
                      builder: (ctx, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Center(
                            child: Center(
                                child:  Row(
                                  children: [
                                    Container(
                                      width: size.width * 0.9,
                                      alignment: Alignment.center,
                                      child:Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        elevation:8,
                                        child:Container(
                                          alignment: Alignment.center,
                                          width: size.width * 0.7,
                                          padding: EdgeInsets.only(
                                              top: 10.0, bottom: 10.0, left: 10.0, right: 5.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.center,
                                                width: size.width * 0.4,
                                                child: Text(
                                                  "Total Count",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 11.0,
                                                      fontFamily: "PoppinsBold"),
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                width: size.width * 0.4,
                                                child: Text("$count",
                                                  style: TextStyle(
                                                      color: kPrimaryColorBlue,
                                                      fontSize: 14.0,
                                                      fontFamily: "PoppinsBold"),
                                                ),
                                              ),
                                            ],),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                          );
                        else {

                          return Scrollbar(
                            //  controller: _controller,
                            thickness: 3.0,
                            child: ListView.builder(
                              shrinkWrap: true,
                              reverse: false,
                              //controller: _controller,
                              itemBuilder: (bui, index) {
                                return new Row(
                                  children: [
                                    Container(
                                      width: size.width * 0.9,
                                      alignment : Alignment.center,
                                      child:Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        elevation:8,
                                        child:Container(
                                          alignment: Alignment.center,
                                          width: size.width * 0.7,
                                          padding: EdgeInsets.only(
                                              top: 10.0, bottom: 10.0, left: 10.0, right: 5.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.center,
                                                width: size.width * 0.4,
                                                child: Text(
                                                  "Total Count",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 11.0,
                                                      fontFamily: "PoppinsBold"),
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                width: size.width * 0.4,
                                                child: Text("$count",
                                                  style: TextStyle(
                                                      color: kPrimaryColorBlue,
                                                      fontSize: 14.0,
                                                      fontFamily: "PoppinsBold"),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                              itemCount: 1,
                            ),
                          );
                        }
                      }

                  ),
                ),
              ),
            ),


            Expanded(
              child: FutureBuilder<List<Datum>>(
                future: getBillInfoList(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: Center(
                          child: CircularProgressIndicator(
                            valueColor:
                            AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),
                          )),
                    );
                  else {
                    if (snapshot.data != null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_controller.hasClients) {
                          _controller.animateTo(
                              _controller.position.minScrollExtent,
                              duration: Duration(milliseconds: 1),
                              curve: Curves.fastLinearToSlowEaseIn);
                        } else {
                          setState(() => null);
                        }
                      });
                      return Scrollbar(
                        isAlwaysShown: true,
                        controller: _controller,
                        thickness: 3.0,
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 52),
                          shrinkWrap: true,
                          reverse: false,
                          controller: _controller,
                          itemBuilder: (bui, index) {
                            return new Card(
                              elevation: 5,
                              child: ListTile(
                                dense: false,
                                title: Text('Invoice No : ${snapshot.data[index].invoiceNo}',
                                    style: TextStyle(fontSize: 14.0,fontFamily: "PoppinsBold")),
                                isThreeLine: false,
                                subtitle:
                                snapshot.data[index].mobileNo.isNotEmpty?
                                Text('Mobile No. : ${snapshot.data[index].mobileNo}\nDate : ${snapshot.data[index].billDate
                                    .toString()} \nStore Feedback : ${snapshot
                                    .data[index].storeFeedback.toString()}\nMerchant Reply : ${snapshot.data[index].merchantReplay}',
                                    style: TextStyle(fontSize: 11.0,fontFamily: "PoppinsLight",color: Colors.black))
                                    :Text('Date : ${snapshot.data[index].billDate
                                    .toString()}',
                                    style: TextStyle(fontSize: 11.0,fontFamily: "PoppinsLight",color: Colors.black))
                                ,

                                trailing: Wrap(
                                  spacing: 5, // space between two icons
                                  crossAxisAlignment: WrapCrossAlignment.end,
                                  children: <Widget>[
                                    if(snapshot.data[index].mobileNo
                                        .isNotEmpty)
                                      Text(
                                          '${snapshot.data[index].rating
                                              .toString()}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17.0)
                                      ),
                                   ],
                                ),
                                onTap: () {

                                },
                              ),
                            );
                          },
                          itemCount: snapshot.data.length,
                        ),
                      );
                    } else {
                      return Container(
                        child: Center(
                          child: Text("No Rating Found!"),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
    );
  }

  Widget showAlertDialog(){
    return new AlertDialog(
      insetPadding: EdgeInsets.all(10),
      title: Text("Rating Analysis Graph"),
      content: new Container(
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: FutureBuilder<List<BarData>>(
          future: fetchDataVisuals(),
          builder: (BuildContext context,
              AsyncSnapshot<List<BarData>> snapshot) {
            if (snapshot.hasData && snapshot.data == null) {
              return Container();
            } else if (snapshot.connectionState ==
                ConnectionState.done &&
                snapshot.hasData) {
              return Container(
                child: BarChartCategory(snapshot.data),
                padding: EdgeInsets.only(
                  left: 0,
                  right: 0,
                ),
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 1,
              );
            } else {
              return Center(
                child: Text(''),
                //     child: CircularProgressIndicator(
                //   valueColor: AlwaysStoppedAnimation<Color>(
                //       kPrimaryColorBlue),
                // ),
              );
            }
          },
        ),
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

  Future<List<BarData>> fetchDataVisuals() async {
    final param = {
      "m_business_id": storeID,
    };

    final response = await http.post(
      Uri.parse("http://157.230.228.250/view-merchant-analysis-rating-graph-api/"),
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 400) {
      return null;
    }
    List<BarData> data = [];
    final body = json.decode(response.body);
    for (int i = 0; i < body["data"].length; i++) {
      data.add(
          BarData(body["labels"][i], body["data"][i], palette[i]));
    }
    return data;
  }


}

class BarData {
  final String x;
  final int y;
  final Color color;
  BarData(this.x, this.y, this.color);
}