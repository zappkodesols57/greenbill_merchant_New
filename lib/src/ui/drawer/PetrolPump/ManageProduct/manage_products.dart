import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/models/model_petrolProducts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constants.dart';
import 'addProduct.dart';

class ManageProducts extends StatefulWidget {
  @override
  ManageProductsState createState() => ManageProductsState();
}

class ManageProductsState extends State<ManageProducts> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, id, storeID;
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
      id = prefs.getInt("userID").toString();
      storeID = prefs.getString("businessID");
    });
    print('$token\n$id');
  }

  Future<PetrolProducts> list() async {

    final param = {
      "m_business_id": storeID,
    };

    final res = await http.post(
      "http://157.230.228.250/petrol-manage-product-list-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(res.body);
    print(res.statusCode);
    if(200 == res.statusCode){
      print(petrolProductsFromJson(res.body).data.length);
      return petrolProductsFromJson(res.body);
    } else{
      throw Exception('Failed to load Products List');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Manage Products"),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {Navigator.pop(context);},
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddProducts("false", "", "Select Product Availability", "", "")))
                  .then((value) => value ? showInSnackBar("Product Save Successfully") : null);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<PetrolProducts>(
        future: list(),
        builder: (BuildContext context, AsyncSnapshot<PetrolProducts> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),));
          else if (snapshot.hasError) {
            return Center(
              child: Text("No Product Found!"),
            );
          } else {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_controller.hasClients) {
                  _controller.animateTo(
                      _controller.position.maxScrollExtent,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.fastLinearToSlowEaseIn);
                } else {
                  setState(() => null);
                }
              });
              return Column(
                children: [
                  ListTile(
                    dense: true,
                    tileColor: kPrimaryColorBlue,
                    title: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      alignment: WrapAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Text(
                            "Product",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white, fontFamily: "PoppinsBold", fontSize: 12.0),
                          ),
                          width: 80.0,
                        ),
                        Container(
                          child: Text(
                            "Cost/Litre",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white, fontFamily: "PoppinsBold", fontSize: 12.0),
                          ),
                        ),
                        Container(
                          child: Text(
                            "Available",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white, fontFamily: "PoppinsBold", fontSize: 12.0),
                          ),
                        ),
                        Container(
                          child: Text(
                            "Edit",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white, fontFamily: "PoppinsBold", fontSize: 12.0),
                          ),
                        ),
                        // Container(
                        //   child: Text(
                        //     "Delete",
                        //     textAlign: TextAlign.center,
                        //     style: TextStyle(
                        //         color: Colors.white, fontFamily: "PoppinsBold", fontSize: 12.0),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  Scrollbar(
                    isAlwaysShown: true,
                    controller: _controller,
                    thickness: 3.0,
                    child: ListView.builder(
                        itemCount: snapshot.data.data.length,
                        shrinkWrap: true,
                        reverse: false,
                        controller: _controller,
                        itemBuilder: (BuildContext context, int index) {
                          return new Card(
                            elevation: 2.0,
                            child: Center(
                              child: ListTile(
                                dense: true,
                                title: Wrap(
                                  spacing: 0, // space between two icons
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  alignment: WrapAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 80.0,
                                      child: Text(snapshot.data.data[index].productName,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontFamily: "PoppinsBold"),
                                      ),
                                    ),
                                    Text(double.parse(snapshot.data.data[index].productCost).toStringAsFixed(3),
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontFamily: "PoppinsBold"),
                                    ),
                                    Text(snapshot.data.data[index].productAvailability,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontFamily: "PoppinsBold"),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) => AddProducts("true", snapshot.data.data[index].id.toString(),
                                                snapshot.data.data[index].productAvailability, snapshot.data.data[index].productCost,
                                                snapshot.data.data[index].productName)))
                                            .then((value) => value ? showInSnackBar("Product Save Successfully") : null);
                                      },
                                      icon: Icon(Icons.edit, color: kPrimaryColorBlue),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                    ),
                  ),
                ],
              );

            } else {
              return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),));
            }
          }

        },
      ),
    );
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
            fontSize: 16.0,
            fontFamily: "PoppinsMedium"),
      ),
      backgroundColor: kPrimaryColorBlue,
      duration: Duration(seconds: 2),
    ));
  }

}