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
  bool search = false;
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
    print(query.text.toString());
    if (200 == res.statusCode) {
      if (search == true) {
        print(ratingFromJson(res.body).data.length);
        return ratingFromJson(res.body).data.where((element) =>
        element.ratingId.contains(query.text.toString()))
            .toList();
      }
      else{
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
                  top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
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

            Flexible(
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
                          shrinkWrap: true,
                          reverse: false,
                          controller: _controller,
                          itemBuilder: (bui, index) {
                            return new Card(
                              elevation: 5,
                              child: ListTile(
                                dense: false,
                                title: Text('Invoice No : ${snapshot.data[index].invoiceNo}',
                                    style: TextStyle(fontSize: 12.0,fontFamily: "PoppinsBold")),
                                isThreeLine: false,
                                subtitle:
                                snapshot.data[index].mobileNo.isNotEmpty?
                                Text('Mobile No. : ${snapshot.data[index].mobileNo}\nDate : ${snapshot.data[index].billDate
                                    .toString()} \nStore Feedback : ${snapshot
                                    .data[index].storeFeedback.toString()}\nMerchant Reply : ${snapshot.data[index].merchantReplay}',
                                    style: TextStyle(fontSize: 12.0,fontFamily: "PoppinsLight",color: Colors.black))
                                    :Text('Date : ${snapshot.data[index].billDate
                                    .toString()}',
                                    style: TextStyle(fontSize: 12.0,fontFamily: "PoppinsLight",color: Colors.black))
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
