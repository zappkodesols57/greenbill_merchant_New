import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:greenbill_merchant/src/models/model_flagBills.dart';
import 'package:greenbill_merchant/src/ui/BillInfo/ViewBill.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:multi_select_item/multi_select_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FlagBills extends StatefulWidget {
  @override
  FlagBillsState createState() => FlagBillsState();
}

class FlagBillsState extends State<FlagBills> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, storeID, id, storeCatID;
  final ScrollController _controller = ScrollController();
  List<String> ids = [];
  List<Datum> filterSearch = [];
  TextEditingController fromDateController = new TextEditingController();
  TextEditingController toDateController = new TextEditingController();
  String fDate = "";
  String eDate = "";
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
    setState(() {
      token = prefs.getString("token");
      id = prefs.getInt("userID").toString();
      storeID = prefs.getString("businessID");
      storeCatID = prefs.getString("businessCategoryID");
    });
    print('$token\n$id\n$storeID');
    getFlagBillLists();
  }

  List<Datum> snapshot;

  void getFlagBillLists() async {
    String url;
    if(storeCatID == "11") url = "http://157.230.228.250/petrol-flag-bill-list-api/";
    else url = "http://157.230.228.250/parking-flag-bill-list-api/";

    final param = {
      "m_business_id": storeID,
      "from_date": fDate,
      "to_date": eDate,
    };

    final res = await http.post(url, body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(res.body);
    print(res.statusCode);
    if(200 == res.statusCode){
      print(flagBillsListFromJson(res.body).data.length);
      for(int i=0 ; i<flagBillsListFromJson(res.body).data.length ; i++){
        inputs.add(!_isCheckAll);
      }
      setState(() {
        length = flagBillsListFromJson(res.body).data.length;
        controller.disableEditingWhenNoneSelected = true;
        controller.set(flagBillsListFromJson(res.body).data.length);
        _isLoading = false;
      });
      snapshot =  flagBillsListFromJson(res.body).data.toList();
      filterSearch = snapshot;
    } else{
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
    String url;
    if(storeCatID == "11") url = "http://157.230.228.250/petrol-delete-selected-flag-bill-api/";
    else url = "http://157.230.228.250/parking-delete-selected-flag-bill-api/";
    final param = {
      "bill_ids": (ids.isEmpty) ? "" : ids.reduce((value, element) => value + ',' + element),
    };
    print("ok");

    final response = await http.post(url, body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"},);

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
        showInSnackBar("Bill Deleted Successfully");
        getFlagBillLists();
        setState(() {
          snapshot.toList();
        });
      } else showInSnackBar(data.status);
    } else {
      print(data.status);
      showInSnackBar(data.status);
      return null;
    }
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
    getFlagBillLists();
    setState(() {});
    return eDate;
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
        floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (controller.isSelecting)
              FloatingActionButton(
                backgroundColor: Colors.white,
                child: Badge(
                  animationType: BadgeAnimationType.scale,
                  badgeContent: Text("${controller.selectedIndexes.length}", style: TextStyle(color: Colors.white),),
                  child: Icon(
                    Icons.delete_outlined,
                    color: kPrimaryColorRed,
                  ),
                ),
                onPressed: delete,
                heroTag: null,
              ),
              SizedBox(
                height: 10,
              ),
              if (controller.isSelecting)
              FloatingActionButton(
                backgroundColor: Colors.white,
                child: Icon(
                    Icons.select_all,
                  color: kPrimaryColorBlue,
                ),
                onPressed: selectAll,
                heroTag: null,
              )
            ]
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
                  textCapitalization: TextCapitalization.characters,
                  onChanged: (value){
                    filter(value);
                  },
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
                title:SizedBox(width: 1.0,),
                trailing: Wrap(
                  spacing: 30, // space between two icons
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 90.0,
                      alignment: Alignment.center,
                      child: Text(
                        "Mobile No.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "PoppinsBold"),
                      ),
                    ),
                    Container(
                      width: 90.0,
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Amount",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "PoppinsBold"),
                      ),
                    ),
                    Container(
                      width: 53.0,
                      child: Text(
                        "Action",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "PoppinsBold"),
                      ),
                    ),
                  ],
                ),
                onTap: () {},
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
                                alignment: Alignment.center,
                                child: CheckboxListTile(
                                  contentPadding: EdgeInsets.only(left: 5),
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
                                  title: Text((snapshot[index].mobileNo.isEmpty ? "" : snapshot[index].mobileNo),
                                      style: TextStyle(fontSize: 15.0)
                                  ),
                                  subtitle: Text('Time : ${snapshot[index].flaggedTime}\nInvoice : ${snapshot[index].invoiceNo}\nDate : ${snapshot[index].flaggedDate}\n${snapshot[index].flaggedBy}'
                                      '\n${snapshot[index].flaggedReason}',
                                      style: TextStyle(fontSize: 10.0)) ,
                                  secondary: Wrap(
                                    spacing: 15, // space between two icons
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: <Widget>[
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Container(
                                            width: 90.0,
                                            alignment: Alignment.center,
                                            child: Text("₹ ${double.parse(snapshot[index].amount).toStringAsFixed(2)}",
                                                style: TextStyle(fontWeight: FontWeight.bold)),
                                          ),
                                        ],
                                      ),
                                      if (!controller.isSelecting)
                                        Container(
                                          width: 65.0,
                                          alignment: Alignment.centerLeft,
                                          child: IconButton(
                                            icon: Icon(Icons.delete_outlined, color: kPrimaryColorRed,),
                                            onPressed: () {
                                              setState(() {
                                                controller.toggle(index);
                                              });
                                              delete();
                                            },
                                          ),
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
              ) : Container(
                height: MediaQuery.of(context).size.height/3,
                child: Center(
                  child: (_hasData) ? Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),)) :
                  Text("No Bills Found"),
                ),
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
        element.invoiceNo.toLowerCase().contains(value.toLowerCase()) || element.amount.toLowerCase().contains(value.toLowerCase())
        || element.flaggedBy.toUpperCase().toLowerCase().contains(value.toLowerCase()) || element.flaggedReason.toUpperCase().toLowerCase().contains(value.toLowerCase())).toList();

    setState(() {
      snapshot.toList();
    });
  }

}