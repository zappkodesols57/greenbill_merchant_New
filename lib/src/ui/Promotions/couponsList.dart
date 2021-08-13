import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:greenbill_merchant/src/animations/hero_dialog_route.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:greenbill_merchant/src/ui/Promotions/coupons.dart';
import 'package:greenbill_merchant/src/ui/Promotions/couponsDetails.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/models/model_couponsList.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';

class CouponsList extends StatefulWidget {
  const CouponsList({Key key}) : super(key: key);

  @override
  _CouponsListState createState() => _CouponsListState();
}

class _CouponsListState extends State<CouponsList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isGoingDown = true;
  String token, storeID;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    getCredentials();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      storeID = prefs.getString("businessID");
    });
    print('$token\n$storeID');
  }

  Future<List<Datum>> getLists() async {

    final param = {
      "m_business_id": storeID,
    };

    final res = await http.post(
      "http://157.230.228.250/merchant-coupon-list-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(res.body);
    print(res.statusCode);
    if(200 == res.statusCode){
      print(allCouponsListFromJson(res.body).data.length);
      return allCouponsListFromJson(res.body).data;
    } else{
      throw Exception('Failed to load List');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFFF7F7F7),
      floatingActionButton: AnimatedContainer(
          duration: Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          child: RawMaterialButton(
              elevation: 5.0,
              shape: isGoingDown
                  ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)))
                  : CircleBorder(),
              onPressed: () async{
                SharedPreferences prefs = await SharedPreferences.getInstance();
                // File file = await downloadPicture(prefs.getString("businessLogo"));
                Navigator.push(context,
                    HeroDialogRoute(builder: (context) => Coupons("", "", "", "", "", "", "", "", "", "")))
                .then((value) => (value??false) ? couponCreated() : null);
              },
              fillColor: kPrimaryColorBlue,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: isGoingDown
                    ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          CupertinoIcons.ticket,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          "Add Coupon",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "PoppinsMedium",
                              fontWeight: FontWeight.bold
                          ),
                        )
                      ],
                    )
                    : const Icon(
                  CupertinoIcons.ticket,
                  color: Colors.white,
                ),
              ))),
      body: NotificationListener<ScrollNotification>(
        onNotification: (onScrollNotification) {
          if (onScrollNotification is ScrollUpdateNotification) {
            if (onScrollNotification.scrollDelta <= 0.0) {
              // if (!isGoingDown) setState(() => isGoingDown = true);
            } else {
              // if (isGoingDown) setState(() => isGoingDown = false);
            }
          }
          return false;
        },
        child: FutureBuilder<List<Datum>>(
          future: getLists(),
          builder: (BuildContext context, AsyncSnapshot<List<Datum>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),));
            else if (snapshot.hasError) {
              return Center(
                child: Text("No Coupons Created"),
              );
            } else {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_controller.hasClients) {
                    _controller.animateTo(
                        _controller.position.minScrollExtent,
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
                      padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 58),
                      itemCount: snapshot.data.length,
                      shrinkWrap: true,
                      reverse: false,
                      controller: _controller,
                      itemBuilder: (BuildContext context, int index) {
                        return Hero(
                          tag: snapshot.data[index].id,
                          child: Card(
                            elevation: 5.0,
                            child: Center(
                              child: ListTile(
                                dense: true,
                                title: Text(
                                    snapshot.data[index].couponName,
                                    style: TextStyle(fontSize: 15.0, fontFamily: "PoppinsMedium", fontWeight: FontWeight.bold)
                                ),
                                subtitle: Text('Coupon Code : ${snapshot.data[index].couponCode}\nValid Till : ${snapshot.data[index].validThrough}',
                                    style: TextStyle(fontSize: 10.0)) ,
                                trailing: Wrap(
                                  spacing: 30, // space between two icons
                                  crossAxisAlignment:
                                  WrapCrossAlignment.start,
                                  children: <Widget>[

                                    Text('\nRedeemed : ${snapshot.data[index].couponRedeem}\nClicks : ${snapshot.data[index].cout}',
                                    style: TextStyle(fontSize: 10.0,color: Colors.black54)),
                                    // IconButton(
                                    //   icon: Icon(
                                    //     CupertinoIcons.pencil_circle,
                                    //     color: Colors.black,
                                    //   ),
                                    //   onPressed: () async {
                                    //     _showLoaderDialog(context);
                                    //     Navigator.of(context, rootNavigator: true).pop();
                                    //     Navigator.push(context, MaterialPageRoute(builder: (context) => Coupons(snapshot.data[index].couponName,
                                    //         snapshot.data[index].couponCode, snapshot.data[index].greenPoint, snapshot.data[index].validFrom, snapshot.data[index].validThrough, snapshot.data[index].couponCaption,
                                    //         snapshot.data[index].couponValue, snapshot.data[index].couponValidForUser, snapshot.data[index].amountIn, snapshot.data[index].id.toString())));
                                    //   },
                                    // ),
                                    IconButton(
                                      icon: Icon(
                                        CupertinoIcons.delete,
                                        color: kPrimaryColorRed,
                                      ),
                                      onPressed: () {
                                        deleteCoupon(snapshot.data[index].id);
                                      },
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.of(context).push(
                                    PageRouteBuilder(
                                      opaque: false,
                                      pageBuilder: (_, animation, __) {
                                        return FadeTransition(
                                          opacity: animation,
                                          child: CouponsDetails(snapshot.data[index]),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      }
                  ),
                );
              } else {
                return Center(child: Text("No Coupons Created"));
              }
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
                  )
              )
          );
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
          color: Colors.white,
          fontFamily: "PoppinsMedium",
          fontWeight: FontWeight.bold,
          fontSize: 12.0,
        ),
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
      duration: Duration(seconds: 2),
    ));
  }

  Future<void> deleteCoupon(int id) async {
    _showLoaderDialog(context);

    final param = {
      "coupon_id": id.toString(),
    };

    final response = await http.post(
      "http://157.230.228.250/merchant-delete-coupon-api/",
      body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(response.statusCode);
    CommonData data;
    var responseJson = json.decode(response.body);
    print(response.body);
    data = new CommonData.fromJson(jsonDecode(response.body));
    print(responseJson);

    if (response.statusCode == 200) {
      print("Submit Successful");
      print(data.status);
      if(data.status == "success"){
        Navigator.of(context, rootNavigator: true).pop();
        showInSnackBar("Coupon Deleted Successfully");
      } else showInSnackBar(data.status);
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      print(data.status);
      showInSnackBar(data.status);
      return null;
    }
  }

  Future<File> downloadPicture(String url) async {
    // generate random number.
    var rng = new Random();
    // get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
    // get temporary path from temporary directory.
    String tempPath = tempDir.path;
    // create a new file in temporary path with random file name.
    File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
    // call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get("http://157.230.228.250");
    // write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
    // now return the file which is created with random name in
    // temporary directory and image bytes from response is written to // that file.
    return file;
  }

  couponCreated() {
    setState((){});
    showInSnackBar("Coupon Created Successfully");
  }

}
