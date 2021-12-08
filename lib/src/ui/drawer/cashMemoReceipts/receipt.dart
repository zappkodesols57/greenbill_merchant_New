import 'dart:convert';
import 'dart:io';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:greenbill_merchant/src/models/model_receiptList.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../constants.dart';
import 'createReceipts.dart';

class Receipt extends StatefulWidget {
  const Receipt({Key key}) : super(key: key);

  @override
  _ReceiptState createState() => _ReceiptState();
}
class _ReceiptState extends State<Receipt>{

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, id, mob, storeID;
  TextEditingController fromDateController = new TextEditingController();
  TextEditingController toDateController = new TextEditingController();
  String fDate = "";
  String eDate = "";
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
    query.dispose();
  }

  getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      id = prefs.getInt("userID").toString();
      mob = prefs.getString("mobile");
      storeID = prefs.getString("businessID");
    });
  }

  _selectDateStart(BuildContext context) async {
    DateTime e = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    fDate = '${e.year.toString()}-${e.month.toString()}-${e.day.toString()}';
    fromDateController.text = DateFormat("dd-MM-yyyy").format(e);
    // changeState();
    return fDate;
  }

  _selectDateEnd(BuildContext context) async {
    DateTime e = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now());
    eDate = '${e.year.toString()}-${e.month.toString()}-${e.day.toString()}';
    toDateController.text = DateFormat("dd-MM-yyyy").format(e);
    setState(() {});
    return eDate;
  }

  Future<List<Datum>> getLists() async {

    final param = {
      "m_business_id": storeID,
      "from_date": fDate,
      "to_date": eDate,
    };
      print(">>>>>>>>>>$param");

    final res = await http.post("http://157.230.228.250/merchant-receipt-list-api/", body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(res.body);
    print(res.statusCode);
    if(200 == res.statusCode){
      print(receiptListFromJson(res.body).data.length);
      return receiptListFromJson(res.body).data.where((element) =>
          element.mobileNumber.toLowerCase().toString().contains(query.text.toLowerCase().toString()) ||
              element.receiptNo.toLowerCase().toString().contains(query.text.toLowerCase().toString()) ).toList();
    } else{
      throw Exception('Failed to load List');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
          backgroundColor: kPrimaryColorBlue,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateReceipts()))
                .then((value) => (value??false) ? showInSnackBar("Created Successfully") : null);
          },
          tooltip: 'Create Receipt',
          child: Icon(
            CupertinoIcons.add,
            color: Colors.white,
          )
      ),
      body: Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.99,
            padding: EdgeInsets.only(
                top: 10.0, bottom: 10.0, left: 0.0, right: 0.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
            ),
            child: TextField(
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
                hintText: "Search Receipts",
                hintStyle: TextStyle(
                    fontFamily: "PoppinsMedium",
                    fontSize: 15.0,
                    color: kPrimaryColorBlue),
              ),
            ),

          ),
          Container(
            width: size.width * 0.95,
            height: 60.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: size.width * 0.4,
                  height: 50.0,
                  padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                  child: TextField(
                    enableInteractiveSelection:
                    false, // will disable paste operation
                    focusNode: new AlwaysDisabledFocusNode(),
                    controller: fromDateController,
                    onTap: () {
                      _selectDateStart(context);
                    },
                    style: TextStyle(
                        fontFamily: "PoppinsBold",
                        fontSize: 12.0,
                        color: kPrimaryColorBlue),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 10.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: kPrimaryColorBlue, width: 1),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(35.0)),
                      ),
                      focusedBorder: new OutlineInputBorder(
                        borderSide: BorderSide(
                            color: kPrimaryColorBlue, width: 1),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(35.0)),
                      ),
                      prefixIcon: Icon(
                        FontAwesomeIcons.calendar,
                        color: kPrimaryColorBlue,
                        size: 20.0,
                      ),
                      hintText: "From",

                      hintStyle: TextStyle(
                          fontFamily: "PoppinsBold",
                          fontSize: 12.0,
                          color: kPrimaryColorBlue),
                    ),
                  ),
                ),
                Container(
                  width: size.width * 0.4,
                  height: 50.0,
                  padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
                  child: TextField(
                    enableInteractiveSelection:
                    false, // will disable paste operation
                    focusNode: new AlwaysDisabledFocusNode(),
                    controller: toDateController,
                    onTap: () {
                      _selectDateEnd(context);
                    },
                    style: TextStyle(
                        fontFamily: "PoppinsBold",
                        fontSize: 12.0,
                        color: kPrimaryColorBlue),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 10.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: kPrimaryColorBlue, width: 1),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(35.0)),
                      ),
                      focusedBorder: new OutlineInputBorder(
                        borderSide: BorderSide(
                            color: kPrimaryColorBlue, width: 1),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(35.0)),
                      ),
                      prefixIcon: Icon(
                        FontAwesomeIcons.calendar,
                        color: kPrimaryColorBlue,
                        size: 20.0,
                      ),
                      hintText: "To",

                      hintStyle: TextStyle(
                          fontFamily: "PoppinsBold",
                          fontSize: 12.0,
                          color: kPrimaryColorBlue),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5.0,),
          ListTile(

            tileColor: kPrimaryColorBlue,
            title: Text(
              "Mobile No.",
              textAlign: TextAlign.start,
              style:
              TextStyle(color: Colors.white, fontFamily: "PoppinsBold"),
            ),
            trailing: Wrap(
              spacing: 18, // space between two icons
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Container(
                  width: 75.0,
                  child: Text(
                    "Amount",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontFamily: "PoppinsBold"),
                  ),
                ),
                Container(
                  width: 73.0,
                  child: Text(
                    "Action",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontFamily: "PoppinsBold"),
                  ),
                )
              ],
            ),
            onTap: () {
              // Navigator.push(context, MaterialPageRoute(builder:  (context)=>MerchantBillList(snapshot.data[index].mBusinessName)));
            },
          ),
          Expanded(
            child: FutureBuilder<List<Datum>>(
              future: getLists(),
              builder: (BuildContext context, AsyncSnapshot<List<Datum>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),));
                else if (snapshot.hasError) {
                  print(">>>>${snapshot.error}");
                  return Center(
                    child: Text("No Receipts Created"),
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
                          padding: const EdgeInsets.only(bottom: kFloatingActionButtonMargin + 50),
                          itemCount: snapshot.data.length,
                          shrinkWrap: true,
                          reverse: false,
                          controller: _controller,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              child: Center(
                                child: ListTile(
                                  dense: true,
                                  title: Text(snapshot.data[index].mobileNumber,
                                      style: TextStyle(fontSize: 15.0)),
                                  subtitle: Text(
                                      "Date : ${snapshot.data[index].date}\nReceipt No. : ${snapshot.data[index].receiptNo}",
                                      style: TextStyle(
                                          fontSize: 11.0,
                                          color: Colors.grey)),
                                  isThreeLine: false,
                                  trailing: Wrap(
                                    spacing: 1, // space between two icons
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: <Widget>[
                                      Container(
                                          width: 110.0,
                                          alignment: Alignment.center,
                                          child: Text("₹ ${snapshot.data[index].total.toStringAsFixed(2)}",
                                              style: TextStyle(fontWeight: FontWeight.bold))
                                      ),
                                      Container(
                                        width:70.0,
                                        child: IconButton(
                                          icon: Icon(
                                            FontAwesomeIcons.paperPlane,
                                            size: 15.0,
                                            color: kPrimaryColorBlue,
                                          ),
                                          onPressed: () {
                                            send(snapshot.data[index].id, snapshot.data[index].mobileNumber);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  onTap: (){
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) => WebViewScreen("View Receipts", snapshot.data[index].receiptUrl)),
                                    // );
                                    launch(snapshot.data[index].receiptUrl);
                                  },
                                ),
                              ),
                            );
                          }
                      ),
                    );
                  } else {
                    return Center(child: Text("No Receipts Created"));
                  }
                }

              },
            ),
          ),
        ],
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
            fontSize: 16.0,
            fontFamily: "PoppinsMedium"),
      ),
      backgroundColor: kPrimaryColorBlue,
      duration: Duration(seconds: 2),
    ));
  }

  Future<void> send(int id, String mobileNumber) async {

    _showLoaderDialog(context);

    final param = {
      "receipt_id": id.toString(),
      "mobile_no": mobileNumber,
    };

    final response = await http.post(
      "http://157.230.228.250/merchant-receipt-send-api/",
      body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(response.statusCode);
    CommonData data;
    var responseJson = json.decode(response.body);
    print(response.body);
    data = new CommonData.fromJson(jsonDecode(response.body));
    print(responseJson);

    if (response.statusCode == 200) {
      print("Sent Successful");
      print(data.status);
      if(data.status == "success"){
        Navigator.of(context, rootNavigator: true).pop();
        showInSnackBar("Receipt Sent Successfully");
      } else showInSnackBar(data.message);
    } else {
      showInSnackBar(data.message);
      Navigator.of(context, rootNavigator: true).pop();
      print(data.status);
      return null;
    }

  }

  Future<void> delete(int id) async {

    _showLoaderDialog(context);

    final param = {
      "receipt_id": id.toString(),
      "m_business_id": storeID,
    };

    final response = await http.post(
      "http://157.230.228.250/merchant-receipt-delete-api/",
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
        showInSnackBar("Receipt Deleted Successfully");
      } else showInSnackBar(data.status);
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      return null;
    }

  }

}
