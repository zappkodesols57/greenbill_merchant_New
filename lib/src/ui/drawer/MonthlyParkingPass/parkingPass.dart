import 'dart:io';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/models/model_monthlyPass.dart';
import 'package:greenbill_merchant/src/ui/drawer/MonthlyParkingPass/full_pass.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../constants.dart';

class ParkingPass extends StatefulWidget {
  @override
  ParkingPassState createState() => ParkingPassState();
}

class ParkingPassState extends State<ParkingPass> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, mobile,business;
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
      mobile = prefs.getString("mobile");
      business = prefs.getString("businessID");
    });
    print('$token\n$mobile');
  }

  Future<List<Datum>> getPassLists() async {
    final param = {
      "m_business_id": business,
    };
    final res = await http.post("http://157.230.228.250/merchant-parking-lot-pass-list-api/",
        body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"});

    print(res.body);
    print(res.statusCode);
    if (200 == res.statusCode) {
      print(monthlyParkingFromJson(res.body).data.length);
      return monthlyParkingFromJson(res.body).data.where((element) => element.businessName.toLowerCase().contains(query.text) ||
          element.amount.toLowerCase().contains(query.text)).toList();
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
        appBar: AppBar(
          title: Text('Parking Pass'),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
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
                  hintText: "Search Bills",
                  hintStyle: TextStyle(
                      fontFamily: "PoppinsMedium",
                      fontSize: 15.0,
                      color: kPrimaryColorBlue),
                ),
              ),
            ),
            Flexible(
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
                      child: Text("No Pass Found"),
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
                            itemCount: snapshot.data.length,
                            shrinkWrap: true,
                            reverse: false,
                            controller: _controller,
                            itemBuilder: (BuildContext context, int index) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                  child: Hero(
                                    tag: snapshot.data[index].id.toString(),
                                    child: new Card(
                                      elevation: 1.0,
                                      child: ListTile(
                                        dense: true,
                                        title: Text(
                                            snapshot.data[index].businessName,
                                            style: TextStyle(fontSize: 15.0)),
                                        subtitle: (checkStatus(snapshot.data[index].validTo) == "Active") ?
                                        Text('From ${snapshot.data[index].validFrom} to ${snapshot.data[index].validTo}\n'
                                            'Active',
                                            style: TextStyle(fontSize: 10.0)) :
                                        Text('From ${snapshot.data[index].validFrom} to ${snapshot.data[index].validTo}\n'
                                            'Expire',
                                            style: TextStyle(fontSize: 10.0)),
                                        leading: (snapshot.data[index]
                                            .businessLogo.isEmpty)
                                            ? Container(
                                          width: 40.0,
                                          height: 40.0,
                                          decoration: new BoxDecoration(
                                            color: Colors.primaries[
                                            Random().nextInt(Colors
                                                .primaries.length)],
                                            borderRadius:
                                            new BorderRadius.circular(
                                                25.0),
                                          ),
                                          alignment: Alignment.center,
                                          child: new Text(
                                            snapshot
                                                .data[index].businessName
                                                .characters.getRange(0,1).toString()
                                                .toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 23.0,
                                              color: Colors.white,
                                              fontWeight:
                                              FontWeight.normal,
                                              fontFamily: "PoppinsLight",
                                            ),
                                          ),
                                        )
                                            : CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              snapshot.data[index]
                                                  .businessLogo),
                                          radius: 20.0,
                                          backgroundColor:
                                          kPrimaryColorBlue,
                                        ),
                                        trailing: Text(
                                            "₹ ${snapshot.data[index].amount}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17.0)
                                        ),
                                        onTap: () {
                                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => FullPass(snapshot.data[index])),);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      );
                    } else //`snapShot.hasData` can be false if the `snapshot.data` is null
                      return Center(
                        child: Text("No Pass Found"),
                      );
                  }
                },
              ),
            )
          ],
        )

    );
  }

  String checkStatus(String expiryDate) {
    String status;
    var exp = expiryDate.split("-");
    final now = DateTime.now();
    final expirationDate = DateTime(int.parse(exp[2]), int.parse(exp[1]), int.parse(exp[0]));
    final bool isExpired = expirationDate.isBefore(now);
    print("Result: $isExpired");

    if(isExpired) status = "Expired";
    else status = "Active";

    return status;
  }

}
