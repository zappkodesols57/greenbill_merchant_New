import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:greenbill_merchant/src/models/model_offersList.dart';
import 'package:greenbill_merchant/src/ui/Promotions/offersDetail.dart';
import 'package:http/http.dart' as http;
import 'package:greenbill_merchant/src/ui/Promotions/offers_card_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';

class OffersList extends StatefulWidget {
  const OffersList({Key key}) : super(key: key);

  @override
  _OffersListState createState() => _OffersListState();
}

class _OffersListState extends State<OffersList> {
  String token, storeID;
  int userID;
  final ScrollController _controller = ScrollController();
  TextEditingController query = new TextEditingController();

  @override
  void initState() {
    super.initState();
    getCredentials();
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
      storeID = prefs.getString("businessID");
      userID = prefs.getInt("userID");
    });
    print('>>>>>>>>>>>>>>>$token\n >>>>>>>>> user $userID');
  }

  Future<List<Datum>> getLists() async {
    final params = {
      "user_id": userID.toString(),
    };
    final res = await http.post(
      "http://157.230.228.250/merchant-get-offers-api/",
      body: params, headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(res.body);
    print(res.statusCode);
    if(200 == res.statusCode){
      print(offersListModelFromJson(res.body).data.length);
      return offersListModelFromJson(res.body).data.where((element) =>
      element.offerName.toString().toLowerCase().contains(query.text.toLowerCase()) ||
          element.mBusinessName.toString().toLowerCase().contains(query.text.toLowerCase())).toList();
    } else{
      throw Exception('Failed to load List');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Offers"),
      //   elevation: 0,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      // ),

      body: Column(
        children: [
          Container(
            width: size.width * 0.95,
            padding: EdgeInsets.only(
                top: 10.0, bottom: 10.0, left: 0.0, right: 0.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
            ),
            child: TextField(
              inputFormatters: [LengthLimitingTextInputFormatter(10)],
              controller: query,
              onChanged: (value) {
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
                hintText: "Search Offers",
                hintStyle: TextStyle(
                    fontFamily: "PoppinsMedium",
                    fontSize: 15.0,
                    color: kPrimaryColorBlue),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Datum>>(
              future: getLists(),
              builder: (BuildContext context, AsyncSnapshot<List<Datum>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColorDarkBlue),
                        )),
                  );
                else if (snapshot.hasError) {
                  print(snapshot.error);
                  return Center(
                    child: Text("No Current Offer Available"),
                  );
                } else {
                  if (snapshot.hasData && snapshot.data.isNotEmpty) {
                    return Scrollbar(
                      isAlwaysShown: true,
                      controller: _controller,
                      thickness: 3.0,
                      child: GridView.builder(
                          padding: EdgeInsets.all(10.0),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          // itemCount: snapshot.data.length,
                          itemCount: snapshot.data.length,
                          shrinkWrap: true,
                          reverse: false,
                          controller: _controller,
                          itemBuilder: (BuildContext context, int index) {
                            return Hero(
                              tag: snapshot.data[index].id,
                              child: OffersCard(size, snapshot.data[index],
                                      () {
                                        clickCoupon(snapshot.data[index].id);
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                        opaque: false,
                                        pageBuilder: (_, animation, __) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: OffersDetails(snapshot.data[index]),
                                          );
                                        },
                                      ),
                                    ).then((value){
                                      (value??false) ?
                                      setState(() {
                                      }) : null;
                                    });
                                  }
                              ),
                            );
                          }),
                    );
                  } else //`snapShot.hasData` can be false if the `snapshot.data` is null
                    return Center(
                      child: Text("No Current Offer Available"),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> clickCoupon(int id) async {

    final param = {
      "offer_id": id.toString(),
    };

    final response = await http.post(
      "http://157.230.228.250/get-merchant-clicks-of-offers-api/",
      body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(response.statusCode);
    CommonData data;
    var responseJson = json.decode(response.body);
    print(response.body);
    data = new CommonData.fromJson(jsonDecode(response.body));
    print(responseJson);

    if (response.statusCode == 200) {
      print("Click Submit Successful");
      print(data.status);
      //   if(data.status == "success"){
      //     Navigator.of(context, rootNavigator: true).pop();
      //     // showInSnackBar("Coupon Deleted Successfully");
      //   } else showInSnackBar(data.status);
      // } else {
      //   Navigator.of(context, rootNavigator: true).pop();
      //   print(data.status);
      //   showInSnackBar(data.status);
      //   return null;
      // }
    }
  }
}
