import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:greenbill_merchant/src/models/model_allPayments.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:multi_select_item/multi_select_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExitBillList extends StatefulWidget {
  @override
  ExitBillListState createState() => ExitBillListState();
}

class ExitBillListState extends State<ExitBillList> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, storeID, mID, userID, formattedDate, passID = "";
  final ScrollController _controller = ScrollController();
  List<String> ids = [];
  List<Datum> filterSearch = [];
  bool _isLoading, _hasData, _isCheckAll;
  MultiSelectController controller = new MultiSelectController();
  List<bool> inputs = new List<bool>();
  int length = 0;

  @override
  void initState() {
    _isLoading = true;
    _hasData = true;
    _isCheckAll = true;
    getCredentials();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    query.dispose();
  }

  TextEditingController query = new TextEditingController();

  getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final DateTime now = DateTime.now();
    final DateFormat formatterDate = DateFormat('dd-MM-yyyy');
    setState(() {
      token = prefs.getString("token");
      mID = prefs.getString("merchantID");
      storeID = prefs.getString("businessID");
      userID = prefs.getInt("userID").toString();
      formattedDate = formatterDate.format(now);
    });
    print('$token\n$storeID\n$formattedDate');
    getExitBillLists();
  }

  List<Datum> snapshot;

  void getExitBillLists() async {

    final param = {
      "m_business_id": storeID,
    };

    final res = await http.post(
      "http://157.230.228.250/parking-lot-exit-bill-list-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(res.body);
    print(res.statusCode);
    if(200 == res.statusCode){
      print(paymentsFromJson(res.body).data.length);
      for(int i=0 ; i<paymentsFromJson(res.body).data.length ; i++){
        inputs.add(!_isCheckAll);
      }
      setState(() {
        length = paymentsFromJson(res.body).data.length;
        controller.disableEditingWhenNoneSelected = true;
        controller.set(paymentsFromJson(res.body).data.length);
        _isLoading = false;
      });
      snapshot =  paymentsFromJson(res.body).data.reversed.toList();
      filterSearch = snapshot;
    } else{
      // if (!mounted) return;
      setState(() {
        _hasData = false;
        _isLoading = true;
      });
      throw Exception('Failed to load Stores List');
    }
  }

  void delete() {
    _showLoaderDialog(context);
    var list = controller.selectedIndexes;

    list.sort((b, a) =>
        a.compareTo(b)); //reoder from biggest number, so it wont error
    list.forEach((element) {
      ids.add(snapshot[element].id.toString());
      snapshot.removeAt(element);
      inputs.removeAt(element);
      length--;
    });
    setState(() {
      controller.set(snapshot.length);
    });
    removeExitBill();
  }

  void selectAll() {
    if(controller.selectedIndexes.length == length){
      for(int i=0 ; i < length ; i++){
        setState(() {
          inputs[i] = !_isCheckAll;
        });
      }
    } else{
      for(int i=0 ; i < length ; i++){
        setState(() {
          inputs[i] = _isCheckAll;
        });
      }
    }

    setState(() {
      controller.toggleAll();
    });
  }

  Future<void> removeExitBill() async {
    final param = {
      "bill_ids": (ids.isEmpty) ? "" : ids.reduce((value, element) => value + ',' + element),
      "pass_id": passID,
    };
    print("ok");

    final response = await http.post(
      "http://157.230.228.250/set-parking-vehicle-as-exit-api/",
      body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(response.statusCode);
    CommonData data;
    var responseJson = json.decode(response.body);
    data = new CommonData.fromJson(jsonDecode(response.body));
    print(response.body);
    Navigator.of(context, rootNavigator: true).pop();

    if (response.statusCode == 200) {
      print(responseJson);
      print("Delete Successful");
      print(data.status);
      if(data.status == "success"){
        showInSnackBar("Vehicles Exited Successfully");
        getExitBillLists();
        setState(() {
          snapshot.toList();
        });
      } else showInSnackBar(data.message);
    } else {
      print(data.status);
      showInSnackBar(data.message);
      return null;
    }
  }

  void itemChange(bool val,int index){
    setState(() {
      inputs[index] = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: (controller.isSelecting) ?
          Text('Exit Vehicles (${controller.selectedIndexes.length})') :
          Text('Exit Vehicles'),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {Navigator.pop(context);},
          ),
          actions: <Widget>[
            if (controller.isSelecting)
              IconButton(
                icon: Icon(Icons.select_all),
                onPressed: selectAll,
              ),
            if (controller.isSelecting)
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: delete,
              ),
          ],
        ),
        body: Column(
            children: [
              Container(
                width: size.width * 0.99,
                padding: EdgeInsets.only(
                    top: 10.0, bottom: 10.0, left: 0.0, right: 0.0),
                decoration: BoxDecoration(
                  borderRadius:  BorderRadius.circular(32),
                ),
                child: TextField(
                  controller: query,
                  // keyboardType: TextInputType.phone,
                  // maxLength: 10,
                  textCapitalization: TextCapitalization.characters,
                  onChanged: (value){
                    filter(value);
                  },
                  // inputFormatters: <TextInputFormatter>[
                  //   FilteringTextInputFormatter.digitsOnly
                  // ],
                  style: TextStyle(
                      fontFamily: "PoppinsMedium",
                      fontSize: 15.0,
                      color: kPrimaryColorBlue),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterStyle: TextStyle(height: double.minPositive,),
                    counterText: "",
                    contentPadding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 20.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColorBlue, width: 1.0),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColorBlue, width: 1.0),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    // prefixIcon: Icon(
                    //   FontAwesomeIcons.search,
                    //   color: kPrimaryColorBlue,
                    //   size: 20.0,
                    // ),
                    suffixIcon: GestureDetector(
                      onTap:(){
                        filter(query.text);
                      },
                      child: Icon(
                        CupertinoIcons.search,
                        color: kPrimaryColorBlue,
                        size: 25.0,
                      ),
                    ),
                    hintText: "Search Bills",
                    hintStyle: TextStyle(
                        fontFamily: "PoppinsMedium", fontSize: 15.0, color: kPrimaryColorBlue),
                  ),
                ),
              ),
              (!_isLoading) ?
              Expanded(
                child: ListView.builder(
                    itemCount: snapshot.length,
                    shrinkWrap: true,
                    reverse: false,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: InkWell(
                          onTap: () {
                            print("Tap");
                          },
                          child: MultiSelectItem(
                            isSelecting: controller.isSelecting,
                            onSelected: () {
                              setState(() {
                                controller.toggle(index);
                              });
                            },
                            child: Container(
                              child: CheckboxListTile(
                                dense: true,
                                value: inputs[index],
                                controlAffinity: ListTileControlAffinity.leading,
                                activeColor: kPrimaryColorBlue,
                                onChanged:(bool val){
                                  itemChange(val, index);
                                  setState(() {
                                    controller.toggle(index);
                                  });
                                },
                                title: (snapshot[index].isCheckoutpin) ?
                                Text(snapshot[index].cUniqueId,
                                    style: TextStyle(fontSize: 15.0)
                                ):
                                Text((snapshot[index].mobileNo.isEmpty ? "--//--" : snapshot[index].mobileNo),
                                    style: TextStyle(fontSize: 15.0)
                                ),
                                // title: Text((snapshot[index].mobileNo.isEmpty ? "--//--" : snapshot[index].mobileNo),
                                //     style: TextStyle(fontSize: 15.0)
                                // ),
                                subtitle: Text('${snapshot[index].date} . ${snapshot[index].time}\n${snapshot[index].vehicleType} . ${snapshot[index].vehicleNumber}',
                                    style: TextStyle(fontSize: 10.0)) ,
                                secondary: Wrap(
                                  spacing: 0, // space between two icons
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: <Widget>[
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Container(
                                          width: 55.0,
                                          child: Text("₹ ${snapshot[index].amount}", style: TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                    if (!controller.isSelecting)
                                      IconButton(
                                        icon: Icon(Icons.exit_to_app, color: kPrimaryColorRed,),
                                        onPressed: () {
                                          setState(() {
                                            controller.toggle(index);
                                          });
                                          delete();
                                        },
                                      ),
                                  ],
                                ),
                              ),
                              decoration: controller.isSelected(index)
                                  ? new BoxDecoration(color: Colors.grey[300])
                                  : new BoxDecoration(),
                            ),
                          ),
                        ),
                      );
                    }
                ),
              ) : Center(
                child: (_hasData) ? Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),)) :
                Text("No Data Found!"),
              ),
            ]

        ),

      ),
      onWillPop: () async {
        //block app from quitting when selecting
        var before = !controller.isSelecting;
        setState(() {
          controller.deselectAll();
        });
        for(int i=0 ; i < length ; i++){
          setState(() {
            inputs[i] = !_isCheckAll;
          });
        }
        return before;
      },
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

  void filter(String value) {

    snapshot = filterSearch.where((element) => element.mobileNo.toLowerCase().contains(value.toLowerCase()) ||
        element.cUniqueId.toLowerCase().contains(value.toLowerCase()) || element.vehicleNumber.toLowerCase().contains(value.toLowerCase())
        || element.amount.toLowerCase().contains(value.toLowerCase()) || element.invoiceNo.toLowerCase().contains(value.toLowerCase())).toList();

    setState(() {
      snapshot.toList();
    });
  }

}