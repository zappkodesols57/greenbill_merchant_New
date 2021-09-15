import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greenbill_merchant/src/models/model_myOffers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:greenbill_merchant/src/ui/HomeScreen/widgets/data_viz/circle/neuomorphic_circle.dart';
import 'package:greenbill_merchant/src/ui/Promotions/Offers.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../constants.dart';
import 'card_item.dart';
import 'carditem_MyOffers.dart';
import 'coupons.dart';
import 'package:http/http.dart' as http;

class MyOffersDetails extends StatefulWidget {
  final Datum data;
  MyOffersDetails(this.data);

  @override
  _MyOffersDetailsState createState() => _MyOffersDetailsState(data);
}

class _MyOffersDetailsState extends State<MyOffersDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final double _initFabHeight = 230.0;
  double _fabHeight = 0;
  double _panelHeightOpen;
  double _panelHeightClosed;
  bool value = false;
  String storeName,profileImage;

  final Datum data;
  _MyOffersDetailsState(this.data);

  @override
  void initState() {
    super.initState();
    _fabHeight = _initFabHeight;
    getCredentials();
  }

  getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      storeName = prefs.getString("businessName");
      profileImage = prefs.getString("profile");

    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _panelHeightClosed = size.height * 0.3;
    _panelHeightOpen = size.height * 0.45;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black87,
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          SlidingUpPanel(
            maxHeight: _panelHeightOpen,
            minHeight: _panelHeightClosed,
            parallaxEnabled: false,
            parallaxOffset: .5,
            color: Colors.white,
            body: _body(size),
            panelBuilder: (sc) => _panel(sc, size),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
            onPanelSlide: (double pos) => setState((){
              _fabHeight = (1.0 - pos) * (_panelHeightOpen - _panelHeightClosed) + _initFabHeight - 130;
            }),
          ),
          Positioned(
            top: _fabHeight,
            child: Container(
                height: size.width * 0.6,
                width: size.width * 0.6,
                child: CardItemMyOffer( data, null)
            ),
          ),
          Positioned(
            bottom: 5.0,
            left: 25.0,
            right: 25.0,
            child: Container(
              height: 35.0,
              width: size.width,
              child: ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.clear, color: Colors.white,),
                    SizedBox(width: 5.0,),
                    Center(
                      child: Text(
                        "Close",
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                          fontFamily: "PoppinsMedium",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(5.0),
                    primary: Colors.blueAccent,
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(90)))
                ),
                onPressed: () {
                  Navigator.pop(context, value);
                },
              ),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(24.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.white, blurRadius: 50.0, spreadRadius: 20.0)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _panel(ScrollController sc, Size size){
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          children: [
            SizedBox(height: 12.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(12.0))
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                controller: sc,
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        height: size.width * 0.1,
                        width: size.height * 0.1,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black
                        ),
                        child: NeuomorphicCircle(
                          innerShadow: false,
                          outerShadow: false,
                          backgroundColor: Colors.white,
                          shadowColor: softShadowColor,
                          highlightColor: highlightColor,
                          child: Image.network(profileImage, height: size.width * 0.08, width: size.width * 0.08,),
                        ),
                      ),
                      Text(
                        storeName.toUpperCase(),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: "PoppinsMedium",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 25.0, right: 25.0),
                      child:
                      Text(
                        "${data.offerName} on $storeName",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: "PoppinsMedium",
                        ),
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 0.0, bottom: 10.0, left: 25.0, right: 25.0),
                      child:
                      Text(
                        "${data.offerCaption}",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: "PoppinsMedium",
                        ),
                      )
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 25.0, right: 25.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          "Offer valid for ${data.offerType}",
                          style: TextStyle(
                            fontSize: 13.0,
                            fontFamily: "PoppinsMedium",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5.0,),

                      ],
                    ),
                  ),

                  Padding(
                      padding: const EdgeInsets.only(top: 0.0, bottom: 0.0, left: 25.0, right: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Expiry Date",
                            style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: "PoppinsMedium",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            getDate(data.validThrough),
                            style: TextStyle(
                              fontSize: 12.0,
                              fontFamily: "PoppinsMedium",
                            ),
                          )
                        ],
                      )
                  ),
                  SizedBox(height: 70.0,)
                ],
              ),
            ),
          ],
        )
    );
  }

  Widget _body(Size size){
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 45.0, left: 20.0, right: 20.0),
          child: Row(
            children: [
              IconButton(
                  icon: Icon(CupertinoIcons.clear, color: Colors.white70,),
                  onPressed: (){
                    Navigator.pop(context, value);
                  }
              )
            ],
          ),
        )
      ],
    );
  }

  String getDate(String validThrough) {
    var exp = validThrough.split("-");
    final date = DateTime(int.parse(exp[2]), int.parse(exp[1]), int.parse(exp[0]));
    return DateFormat('EEEE, d MMM, yyyy').format(date);
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

  Future<void> editCoupon(Datum data) async {
    _showLoaderDialog(context);
    // generate random number.
    var rng = new Random();
    // get temporary directory of device.
    Directory tempDir = await getTemporaryDirectory();
    // get temporary path from temporary directory.
    String tempPath = tempDir.path;
    // create a new file in temporary path with random file name.
    File file = new File('$tempPath'+ (rng.nextInt(100)).toString() +'.png');
    // call http.get method and pass imageUrl into it to get response.
    http.Response response = await http.get("http://157.230.228.250${data.offerImage}");
    // write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
    // now return the file which is created with random name in
    // temporary directory and image bytes from response is written to // that file.

    Navigator.of(context, rootNavigator: true).pop();

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Offers(data.offerName,
        data.offerCaption, data.offerImage, data.validFrom, data.validThrough, data.offerType,
        data.offerBusinessCategory,  data.id.toString())));

  }

}