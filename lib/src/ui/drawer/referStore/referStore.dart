import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReferralPage extends StatefulWidget {
  @override
  _ReferralPageState createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  String codeResponse = "";
  String token, id;

  fetchData() async {
    final param = {
      "user_id": id,
    };
    var response = await http.post(
        'http://157.230.228.250/get-merchant-referral-code-api/',
        body: param,
        headers: {
          HttpHeaders.authorizationHeader:
          "Token $token"
        });
    print(response.body);
    CommonData data;
    data = CommonData.fromJson(jsonDecode(response.body));
    if (response.statusCode == 200) {
      setState(() {
        codeResponse = data.message;
      });
    } else {
      print(data.message);
    }
  }

  @override
  void initState() {
    getCredentials();
    super.initState();
  }

  getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      id = prefs.getInt("userID").toString();
    });
    print('$token\n$id');
    fetchData();
  }

  void share(BuildContext context) {
    String text = "Hi,\nHere's my Green Bill Business Referral Code $codeResponse\nClick on the link below and go Paper Less\n"
        "http://157.230.228.250/merchant-index/";
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height -
        MediaQuery.of(context).padding.top -
        kToolbarHeight;
    final _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Refer a Store"),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    height: MediaQuery.of(context).size.height / 3.0,
                    decoration: BoxDecoration(
                        color: kPrimaryColorBlue,
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.elliptical(100, 50),
                            bottomRight: Radius.elliptical(100, 50))),
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            height: _height / 3.0,
                            width: _width,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: ExactAssetImage("assets/images/Canvas.png"),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: _height / 1.0,
                    width: _width,
                    child: Column(
                      children: [
                        SizedBox(
                          height: _height / 40,
                        ),
                        Container(
                          height: _height / 3.4,
                          width: _width,
                          child: Stack(
                            children: [
                              Container(
                                height: _height / 10,
                                width: _width,
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: _width / 2.015,
                                      child: Container(
                                        height: _height / 10,
                                        width: _width / 2.5,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: kPrimaryColorBlue, width: 3)),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: _height / 17,
                                                width: _width / 7,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: ExactAssetImage(
                                                        "assets/images/voucher.png"),
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                const EdgeInsets.only(left: 8),
                                                child: Text(
                                                  "Share your Code",
                                                  style: TextStyle(
                                                      fontFamily: "PoppinsMedium",
                                                      fontSize: _height / 80,
                                                      color: kPrimaryColorBlue,
                                                      decoration:
                                                      TextDecoration.none),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: _width / 2.25,
                                      top: _height / 95,
                                      child: Container(
                                        width: _width / 9,
                                        height: _height / 12,
                                        decoration: BoxDecoration(
                                            color: kPrimaryColorBlue,
                                            border:
                                            Border.all(color: Color(0xFF00569D)),
                                            shape: BoxShape.circle),
                                        child: Center(
                                          child: Text(
                                            "1",
                                            style: TextStyle(
                                                fontSize: _width / 15,
                                                color: Colors.white,
                                                decoration: TextDecoration.none),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: _height / 10.4,
                                child: Container(
                                  width: _width,
                                  height: _height / 10,
// decoration: BoxDecoration(
// border: Border.all(color: Colors.black)),
                                  child: Stack(children: [
                                    Positioned(
                                      right: _width / 2.015,
                                      child: Container(
                                        height: _height / 10,
                                        width: _width / 2.5,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: kPrimaryColorBlue, width: 3)),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: _height / 17,
                                                width: _width / 7,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: ExactAssetImage(
                                                        "assets/images/refer-a-store.png"),
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                "People Join",
                                                style: TextStyle(
                                                    fontFamily: "PoppinsMedium",
                                                    fontSize: _height / 80,
                                                    color: kPrimaryColorBlue,
                                                    decoration: TextDecoration.none),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: _width / 2.25,
                                      top: _height / 95,
                                      child: Container(
                                        width: _width / 9,
                                        height: _height / 12,
                                        decoration: BoxDecoration(
                                            color: kPrimaryColorBlue,
                                            border:
                                            Border.all(color: Color(0xFF00569D)),
                                            shape: BoxShape.circle),
                                        child: Center(
                                          child: Text(
                                            "2",
                                            style: TextStyle(
                                                fontSize: _width / 15,
                                                color: Colors.white,
                                                decoration: TextDecoration.none),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                              Positioned(
                                top: _height / 5.2,
                                child: Container(
                                  width: _width,
                                  height: _height / 10,
// decoration: BoxDecoration(
// border: Border.all(color: Colors.black)),
                                  child: Stack(children: [
                                    Positioned(
                                      left: _width / 2.015,
                                      child: Container(
                                        height: _height / 10,
                                        width: _width / 2.5,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: kPrimaryColorBlue, width: 3)),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: _height / 19,
                                                width: _width / 7,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: ExactAssetImage(
                                                        "assets/images/promotion.png"),
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(0.0),
                                                child: Text(
                                                  "Free Credits",
                                                  style: TextStyle(
                                                      fontSize: _height / 80,
                                                      fontFamily: "PoppinsMedium",
                                                      color: kPrimaryColorBlue,
                                                      decoration:
                                                      TextDecoration.none),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      left: _width / 2.25,
                                      top: _height / 95,
                                      child: Container(
                                        width: _width / 9,
                                        height: _height / 12,
                                        decoration: BoxDecoration(
                                          color: kPrimaryColorBlue,
                                          border:
                                          Border.all(color: Color(0xFF00569D)),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Text(
                                            "3",
                                            style: TextStyle(
                                                fontSize: _width / 15,
                                                color: Colors.white,
                                                decoration: TextDecoration.none),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: _height / 40,
                        ),
                        Center(
                          child: Container(
                            height: _height / 30,
                            width: _width / 2,
                            child: Center(
                              child: Text(
                                "YOUR REFERRAL CODE",
                                style: TextStyle(
                                    fontFamily: "PoppinsMedium",
                                    fontSize: _width / 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade800,
                                    decoration: TextDecoration.none),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Container(
                              height: _height / 20,
                              width: _width / 2,
// color: Color.fromRGBO(197, 235, 237, 0.5),
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(197, 235, 237, 0.5),
                                  border: Border.all(color: Colors.blue)),
                              child: Center(
                                child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    codeResponse.toString(),
                                    style: TextStyle(
                                        color: Colors.black,
                                        decoration: TextDecoration.none),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Container(
                              height: _height / 13,
                              width: _width / 2,
                              child: ElevatedButton(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.share,
                                      size: _height / 30,
                                    ),
                                    SizedBox(
                                      width: _width / 20,
                                    ),
                                    Text(
                                      "Refer Now",
                                      style: TextStyle(
                                        fontFamily: "PoppinsBold",
                                        fontSize: _height / 40,
                                      ),
                                    )
                                  ],
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: kPrimaryColorBlue,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(90)))),
                                onPressed: () {
                                  share(context);
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
      ),
    );
  }
}