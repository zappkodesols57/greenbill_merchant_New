import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:greenbill_merchant/src/animations/hero_dialog_route.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:greenbill_merchant/src/models/model_myOffers.dart';
import 'package:greenbill_merchant/src/ui/Promotions/coupons.dart';
import 'package:greenbill_merchant/src/ui/Promotions/couponsDetails.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import 'Offers.dart';
import 'myofferDatails.dart';

class MyOfferList extends StatefulWidget {
  const MyOfferList({Key key}) : super(key: key);

  @override
  _MyOfferListState createState() => _MyOfferListState();
}

class _MyOfferListState extends State<MyOfferList> {
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
      "merchant_business_id":storeID,
    };

    final res = await http.post(
      "http://157.230.228.250/merchant-offers-list-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(res.body);
    print(res.statusCode);
    if(200 == res.statusCode){
      print(myOfferFromJson(res.body).data.length);
      return myOfferFromJson(res.body).data;
    } else{
      throw Exception('Failed to load List');
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,

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
                child: Text("No Offer Created"),
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
                      padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 48),
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
                                    "Audience : "+snapshot.data[index].offerType.toString(),
                                    style: TextStyle(fontSize: 13.0, fontFamily: "PoppinsMedium", fontWeight: FontWeight.bold)
                                ),
                                subtitle: Text((snapshot.data[index].status=="0")?'Status : Waiting For Approval \nValid Till : ${snapshot.data[index].validThrough}': (snapshot.data[index].status == "2") ?'Status : Disapproved \nValid Till : ${snapshot.data[index].validThrough}' :'Status : Approved \nValid Till : ${snapshot.data[index].validThrough}',
                                    style: TextStyle(fontSize: 10.0)),
                                trailing: Wrap(
                                  spacing: 30, // space between two icons
                                  crossAxisAlignment:
                                  WrapCrossAlignment.center,
                                  children: <Widget>[

                                    Text(
                                        'Clicks : ${snapshot.data[index].cout}',
                                        style: TextStyle(fontSize: 10.0,color: Colors.black54)),
                                    // IconButton(
                                    //   icon: Icon(
                                    //     CupertinoIcons.pencil_circle,
                                    //     color: Colors.black,
                                    //   ),
                                    //   onPressed: () async {
                                    //     _showLoaderDialog(context);
                                    //     Navigator.of(context, rootNavigator: true).pop();
                                    //     Navigator.push(context, MaterialPageRoute(builder: (context) => Offers(snapshot.data[index].offerName,snapshot.data[index].offerCaption,snapshot.data[index].offerImage,snapshot.data[index].validFrom,snapshot.data[index].validThrough,snapshot.data[index].offerType,snapshot.data[index].offerBusinessCategory,snapshot.data[index].id.toString())));
                                    //   },
                                    // ),
                                    IconButton(
                                      icon: Icon(
                                        CupertinoIcons.delete,
                                        color: kPrimaryColorRed,
                                      ),
                                      onPressed: () {
                                        deleteOffer(snapshot.data[index].id);
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
                                          child: MyOffersDetails(snapshot.data[index]),//CouponsDetails(snapshot.data[index]),
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

  Future<void> deleteOffer(int id) async {
    _showLoaderDialog(context);

    final param = {
      "offer_id": id.toString(),
    };

    final response = await http.post(
      "http://157.230.228.250/merchant-delete-offers-api/",
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
        showInSnackBar("Offer Deleted Successfully");
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
    showInSnackBar("Offer Created Successfully");
  }

}
