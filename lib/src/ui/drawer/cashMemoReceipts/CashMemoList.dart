
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:greenbill_merchant/src/models/model_cashMemo.dart';
import 'package:greenbill_merchant/src/ui/drawer/Settings/webView.dart';
import 'package:greenbill_merchant/src/ui/drawer/cashMemoReceipts/Creatememo.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'addcashmemo.dart';

class CashMemoList extends StatefulWidget {
  @override
  CashMemoListState createState() => CashMemoListState();
}

class CashMemoListState extends State<CashMemoList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, busId,mobile;
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
      busId =prefs.getString("businessID");
    });
    print('$token\n$busId');
  }
  Future<List<Datum>> getPassLists() async {
    final param = {
      "m_business_id": busId,
    };
    final res = await http.post("http://157.230.228.250/merchant-cash-memo-list-api/",
        body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"});

    print(res.body);
    print(res.statusCode);
    if (200 == res.statusCode) {
      print(cashMemoFromJson(res.body).data.length);
      return cashMemoFromJson(res.body).data.where((element) => element.mobileNumber.toLowerCase().contains(query.text) ||
          element.memoNo.toString().toLowerCase().contains(query.text)).toList();

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

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => CreateMemo()))
              .then((value) => (value??false) ? showInSnackBar("Created Successfully") : null);
        },
        child: const Icon(Icons.add),
        backgroundColor: kPrimaryColorBlue,
      ),


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
              onChanged: (value) {
                getPassLists();
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
                  onTap: () {},
                  child: Icon(
                    CupertinoIcons.search,
                    color: kPrimaryColorBlue,
                    size: 25.0,
                  ),
                ),
                hintText: "Search Cash Memo",
                hintStyle: TextStyle(
                    fontFamily: "PoppinsMedium",
                    fontSize: 15.0,
                    color: kPrimaryColorBlue),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Datum>>(
              future: getPassLists(),
              builder: (BuildContext context, AsyncSnapshot<List<Datum>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),
                        )),
                  );
                else if (snapshot.hasError) {
                  return Center(
                    child: Text("No Cash Memos Created"),
                  );
                } else {
                  if (snapshot.hasData && snapshot.data.isNotEmpty) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_controller.hasClients) {
                        _controller.animateTo(_controller.position.minScrollExtent,
                            duration: Duration(milliseconds: 500),
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
                          padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 50),
                          itemCount: snapshot.data.length,
                          shrinkWrap: true,
                          reverse: false,
                          controller: _controller,
                          itemBuilder: (BuildContext context, int index) {
                            return  Card(
                              elevation: 1.0,
                              child: ListTile(
                                dense: true,
                                title: Text(
                                    snapshot.data[index].mobileNumber,
                                    style: TextStyle(fontSize: 15.0)),
                                subtitle: Text('Date : ${snapshot.data[index].date}\nMemo No. : ${snapshot.data[index].memoNo}'),

                                // leading: Container(
                                //   width: 35.0,
                                //   height: 35.0,
                                //   decoration: new BoxDecoration(
                                //     color: Colors.primaries[Random()
                                //         .nextInt(
                                //         Colors.primaries.length)]
                                //         .withOpacity(0.6),
                                //     borderRadius:
                                //     new BorderRadius.circular(25.0),
                                //   ),
                                //   alignment: Alignment.center,
                                //   child: new Text(
                                //     snapshot.data[index].name
                                //         .substring(0, 1)
                                //         .toUpperCase(),
                                //     style: TextStyle(
                                //       fontSize: 23.0,
                                //       color: Colors.white,
                                //       fontWeight: FontWeight.normal,
                                //       fontFamily: "PoppinsLight",
                                //     ),
                                //   ),
                                // ),
                                trailing: Wrap(
                                  spacing: 10, // space between two icons
                                  crossAxisAlignment:
                                  WrapCrossAlignment.center,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(
                                        Icons.sms_outlined,
                                        color: Colors.black,
                                      ),
                                      onPressed: () {
                                        sendSms(
                                            snapshot.data[index].id,
                                            snapshot.data[index].mobileNumber);
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete_outline,
                                        color: kPrimaryColorRed,
                                      ),
                                      onPressed: () {
                                        delete(snapshot.data[index].id);
                                      },
                                    ),
                                    Container(
                                        width: 80.0,
                                        child: Text(
                                            "₹ ${snapshot.data[index].total}",
                                            style: TextStyle(
                                                fontWeight:
                                                FontWeight.bold))),
                                  ],
                                ),
                                // onTap: () {
                                //   Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => WebViewScreen("View Memo", snapshot.data[index].memoUrl)),
                                //   );
                                //
                                // },
                              ),
                            );
                          }),
                    );
                  } else //`snapShot.hasData` can be false if the `snapshot.data` is null
                    return Center(
                      child: Text("No Cash Memos Created"),
                    );
                }
              },
            ),
          )
        ],
      ),

    );
  }

  Future<void> sendSms(int memoNo, String mobileNumber) async {
    _showLoaderDialog(context);
    final param = {
      "cash_memo_id":memoNo.toString(),
      "mobile_no":mobileNumber,
    };

    final response = await http.post(
      "http://157.230.228.250/merchant-cash-memo-send-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );
    print(response.statusCode);
    CommonData data;

    print(response.body);
    data = new CommonData.fromJson(jsonDecode(response.body));

    Navigator.of(context, rootNavigator: true).pop();
    if (response.statusCode == 200) {
      if (data.status == "success") {
        showInSnackBar("Send Successful");
      } else {
        print(data.status);
      }
    } else {
      print(data.status);
    }
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
  Future<void> delete(int id) async {

    _showLoaderDialog(context);

    final param = {

      "m_business_id": busId,
      "cash_memo_id": id.toString(),
    };


    final response = await http.post(
      "http://157.230.228.250/merchant-cash-memo-delete-api/",
      body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(response.statusCode);
    CommonData data;
    var responseJson = json.decode(response.body);
    print(response.body);
    data = new CommonData.fromJson(jsonDecode(response.body));
    print(responseJson);

    if (response.statusCode == 200) {
      print("delete Successful");
      print(data.status);
      if(data.status == "success"){
        Navigator.of(context, rootNavigator: true).pop();
        setState(() {

        });
        showInSnackBar("Cash Memo Deleted Successfully");
      } else showInSnackBar(data.status);
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      return null;
    }

  }
}
