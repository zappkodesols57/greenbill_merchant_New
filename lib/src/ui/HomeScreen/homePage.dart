import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/models/model_analysis.dart';
import 'package:greenbill_merchant/src/models/model_doughnutChart.dart';
import 'package:greenbill_merchant/src/models/model_normalBusiness.dart';
import 'package:greenbill_merchant/src/models/model_parkingDashboard.dart';
import 'package:greenbill_merchant/src/models/model_petrolDashboard.dart';
import 'package:greenbill_merchant/src/ui/BillInfo/ViewBill.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../constants.dart';
import 'constants.dart';
import 'doughnut_chart_graph.dart';
import 'widgets/card_item.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import 'widgets/data_viz/circle/neuomorphic_circle.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, id,bussinessID, storeID, storeCatID,AvgTransaction,averageBilling,totalCollection,totalSale,avgSale;
  String newsCustomerText,returningCustomerText,c,d;
  static int newsCustomerValue=1;
  static int returningCustomerValue=1;
  static Map<String, double> dataMap;
  bool _headerEnabled,_headerBusiness;


  int todayTransaction;
  TextEditingController fromDateController = new TextEditingController();
  TextEditingController toDateController = new TextEditingController();
  String fDate = "";
  String eDate = "";


  PetrolDashboardData data;
  ParkingDashboardData parkingData;
  final ScrollController _controller = ScrollController();

  String vahicleLabels;

  @override
  void initState() {
    _headerEnabled = true;
    _headerBusiness=true;
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
      // bussinessID = prefs.getString("businessIDstore");
      storeCatID = prefs.getString("businessCategoryID");
    });
    print('$token\n$id');
    if(storeCatID == "11") loadData();
    else loadParkingData();
    if(storeCatID != "11" && storeCatID != "12") loadNormal();
    getAnalysisa();

  }

  loadParkingData() async {
    final param = {
      "m_business_id": storeID,
    };
    final response = await http.post("http://157.230.228.250/parking-merchant-dashboard-header-calulations-api/",
      body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );
    print(response.statusCode);
    var responseJson = json.decode(response.body);
    print(response.body);
    parkingData = new ParkingDashboardData.fromJson(jsonDecode(response.body));
    print(responseJson);
    if (response.statusCode == 200) {
      print("Submit Successful");
      print(parkingData.status);
      if(parkingData.status == "success"){
        setState(() {
          _headerEnabled = false;
        });
      } else print("Parking: ${parkingData.status}");
    } else {
      print(parkingData.status);
      return null;
    }
  }
  loadNormal() async {
    final param = {
      "merchant_business_id": storeID,
    };
    final res= await http.post("http://157.230.228.250/merchant-get-dashboard-details-api/",
      body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );
    print(res.body);
    print("Vinat The Legend");
    print(res.statusCode);
    if (200 == res.statusCode) {
      setState(() {
        _headerBusiness = false;
      });
      print(normalBusinessFromJson(res.body).data);
      todayTransaction=normalBusinessFromJson(res.body).data.todaysTransaction;
      AvgTransaction=normalBusinessFromJson(res.body).data.averageTransaction;
      totalSale=normalBusinessFromJson(res.body).data.totalSales;
      avgSale=normalBusinessFromJson(res.body).data.averageSales;
      return normalBusinessFromJson(res.body).data;

    } else {
      throw Exception('Failed to load Data');
    }
  }


  loadData() async {
    final param = {
      "m_business_id": storeID,
    };

    final response = await http.post("http://157.230.228.250/petrol-merchant-dashboard-header-calulations-api/",
      body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(response.statusCode);
    var responseJson = json.decode(response.body);
    print(response.body);
    data = new PetrolDashboardData.fromJson(jsonDecode(response.body));
    print(responseJson);

    if (response.statusCode == 200) {
      print("Submit Successful");
      print(data.status);
      if(data.status == "success"){
        setState(() {
          _headerEnabled = false;
        });
      } else print(data.status);
    } else {
      print(data.status);
      return null;
    }
  }


  Future<List<DoughnutChartData>> fetchProductOrVehicleWiseEarnData() async {
    final param = {
      "m_business_id": storeID,
    };
    String url;
    if(storeCatID == "11") url = "http://157.230.228.250/petrol-merchant-product-sales-graph-api/";
    else url = "http://157.230.228.250/parking-merchant-vehicle-type-wise-calulations-graph-api/";
    final response = await http.post(url, body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );
    print(response.body);
    print(response.statusCode);
    List<DoughnutChartData> data = [];
    if (response.statusCode == 400) {
      return null;
    }
    final body = json.decode(response.body);
    print(body);
    for (int i = 0; i < body["data"].length; i++) {
      data.add(DoughnutChartData(
          text: body["data"][i].toString(),
          x: body["labels"][i],
          y: body["data"][i]));
    }
    return data;
  }

  Future<List<DoughnutChartData>> fetchAddonsOrVehicleWiseBillData() async {
    final param = {
      "m_business_id": storeID,
    };
    String url;
    if(storeCatID == "11") url = "http://157.230.228.250/petrol-merchant-add-on-sales-graph-api/";
    else url = "http://157.230.228.250/parking-merchant-vehicle-type-wise-bills-graph-api/";
    final response = await http.post(url, body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );
    print(response.body);
    print(response.statusCode);
    List<DoughnutChartData> data = [];
    if (response.statusCode == 400) {
      return null;
    }
    final body = json.decode(response.body);
    print(body);
    for (int i = 0; i < body["data"].length; i++) {
      data.add(DoughnutChartData(
          text: body["data"][i].toString(),
          x: body["labels"][i],
          y: body["data"][i]));
    }
    return data;
  }

  Future<List<DoughnutChartData>> BilllingAnalysis() async {
    final param = {
      "merchant_business_id": storeID,
    };
    String url = "http://157.230.228.250/merchant-billing-analysis-graph-api/";

    final response = await http.post(url, body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );
    print(response.body);
    print(response.statusCode);
    List<DoughnutChartData> data = [];
    if (response.statusCode == 400) {
      return null;
    }
    final body = json.decode(response.body);
    print(body);
    for (int i = 0; i < body["data"].length; i++) {
      data.add(DoughnutChartData(
          text: body["data"][i].toString(),
          x: body["labels"][i],
          y: body["data"][i]));
    }
    return data;
  }



  Future<List<DoughnutChartData>> DigitalBilling() async {
    final param = {
      "merchant_business_id": storeID,
    };
    String url = "http://157.230.228.250/merchant-digital-billing-graph-api/";

    final response = await http.post(url, body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );
    print(response.body);
    print(response.statusCode);
    List<DoughnutChartData> data = [];
    if (response.statusCode == 400) {
      return null;
    }
    final body = json.decode(response.body);
    print(body);
    for (int i = 0; i < body["data"].length; i++) {
      data.add(DoughnutChartData(
          text: body["data"][i].toString(),
          x: body["labels"][i],
          y: body["data"][i]));
    }
    return data;
  }

  Future<List<DoughnutChartData>> coupenDetails() async {
    final param = {
      "merchant_business_id": storeID,
    };
    String url = "http://157.230.228.250/merchant-coupons-details-graph-api/";

    final response = await http.post(url, body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );
    print(response.body);
    print(response.statusCode);
    List<DoughnutChartData> data = [];
    if (response.statusCode == 400) {
      return null;
    }
    final body = json.decode(response.body);
    print(body);
    for (int i = 0; i < body["data"].length; i++) {
      data.add(DoughnutChartData(
          text: body["data"][i].toString(),
          x: body["labels"][i],
          y: body["data"][i]));
    }
    return data;
  }
  Future<List<DoughnutChartData>> offerDetails() async {
    final param = {
      "merchant_business_id": storeID,
    };
    String url = "http://157.230.228.250/merchant-offers-details-graph-api/";

    final response = await http.post(url, body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );
    print(response.body);
    print(response.statusCode);
    List<DoughnutChartData> data = [];
    if (response.statusCode == 400) {
      return null;
    }
    final body = json.decode(response.body);
    print(body);
    for (int i = 0; i < body["data"].length; i++) {
      data.add(DoughnutChartData(
          text: body["data"][i].toString(),
          x: body["labels"][i],
          y: body["data"][i]));
    }
    return data;
  }

  Future<List<ChartParkingData>> fetchAllParkingCollection() async {
    final param = {
      "m_business_id": storeID,
    };
    print (">>>>>>>>>>>>>$id>>>>$storeCatID>>>>>>>$storeID>>>>>>>>>$token");
    String url = "http://157.230.228.250/parking-merchant-session-graph-api/";

    final response = await http.post(url, body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    List<ChartParkingData> sessionData = [];
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 400) {
      return null;
    }

    final body = json.decode(response.body);
    print(body);
    print(">>>>>>>${body["month_labels"]}");
    for (int i = 0; i < body["month_labels"].length; i++) {
      sessionData.add(ChartParkingData(
        x: body["month_labels"][i],
        y: body["Amount"][i],
      ));
    }
    return sessionData;
  }

  Future<List<ChartPetrolData>> fetchAllPetrolCollection() async {
    final param = {
      "m_business_id": storeID,
    };
    print(">>>>>>>>>$storeID");
    String url = "http://157.230.228.250/petrol-merchant-session-graph-api/";

    final response = await http.post(url, body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );
    List<ChartPetrolData> sessionData1 = [];
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 400) {
      return null;
    }
    final body = json.decode(response.body);
    print(body);
    for (int i = 0; i < body["month_labels"].length; i++) {
      sessionData1.add(ChartPetrolData(
        x: body["month_labels"][i],
        y: body["Amount"][i],


      ));
    }
    return sessionData1;
  }

  Future<List<Metadata>> getUsersLists() async {

    final param = {
      "m_user_id": id,
      "m_business_id": storeID,
    };

    String url;
    if(storeCatID == "11") url = "http://157.230.228.250/petrol-merchant-user-analysis-api/";
    else url = "http://157.230.228.250/parking-merchant-user-analysis-api/";

    final response = await http.post(url, body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(response.statusCode);
    final decoded = json.decode(response.body);
    print(response.body);
    print(decoded.length);
    if (decoded['status'] != "success") {
      return null;
    }
    List<Metadata> arr = [];
    for (int i = 0; i < decoded['data'].length; i++) {
      arr.add(Metadata(
        name: decoded['data'][i]['name'].toString(),
        totalBills: decoded['data'][i]['total_bills'].toString(),
        totalCollection: decoded['data'][i]['total_collection'].toString(),
        loginAt: decoded['data'][i]['login_at'].toString(),
        logoutAt: decoded['data'][i]['logout_at'].toString(),
        totalFlagged: decoded['data'][i]['total_flagged'].toString(),
        loginDate: decoded['data'][i]['login_date'].toString(),
        loginTime: decoded['data'][i]['login_time'].toString(),
      ));
    }
    return arr;
  }


  Future<List<DataU>> getAnalysisa() async {
    final param = {
      "merchant_business_id":storeID,
    };
    final res = await http.post("http://157.230.228.250/merchant-overall-customer-analysis-graph-api/",
        body: param, headers: {HttpHeaders.authorizationHeader: "Token $token"});

    print(res.body);
    print(res.statusCode);
    if (200 == res.statusCode) {
      print(analysisFromJson(res.body));
      setState(() {
        newsCustomerText=analysisFromJson(res.body).data.newCustomersText;
        newsCustomerValue=analysisFromJson(res.body).data.newCustomersValue;
        returningCustomerText=analysisFromJson(res.body).data.returningCustomersText;
        returningCustomerValue=analysisFromJson(res.body).data.returningCustomersValue;
        dataMap = {
          "New Customer":10,
          "Returning Customer": 20,
        };
      });

      print("Vinay"+newsCustomerText+newsCustomerValue.toString()+returningCustomerText+returningCustomerValue.toString());

    } else {
      throw Exception('Failed to load List');
    }
  }

  _selectDateStart(BuildContext context) async {
    DateTime e = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    fDate =
    '${e.day.toString()}-${e.month.toString()}-${e.year.toString()}';
    fromDateController.text = fDate;
    return fDate;
  }

  _selectDateEnd(BuildContext context) async {
    DateTime e = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now());
    eDate = '${e.day.toString()}-${e.month.toString()}-${e.year.toString()}';
    toDateController.text = eDate;
    changeState();
    return eDate;
  }

  void changeState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        key: _scaffoldKey,
        body: SafeArea(
          child: (isMobile(context) ? mobilePage(size) : mobilePage(size)),
        ),
      ),
    );
  }

  Widget mobilePage(Size size) {
    double cardDimenWidth = size.width * 0.45;
    double cardDimenHeight = cardDimenWidth * 0.75;
    return SingleChildScrollView(
        child: Column(
          children: [storeCatID != "11" && storeCatID != "12" ?
          Container(
            child: Column(
              children:<Widget> [

                SizedBox(height: 5.0,),

                Container(
                  padding: EdgeInsets.fromLTRB(10, 10.00, 10, 0),
                  width: double.maxFinite,
                  child: Card(
                    elevation: 10.00,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: size.width * 0.9,
                          padding: EdgeInsets.only(
                              top: 10.0, bottom: 0.0, left: 5.0, right: 5.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                    top: 10.0, bottom: 0.0, left: 10.0, right: 0.0),
                                child: NeuomorphicCircle(
                                  innerShadow: false,
                                  outerShadow: true,
                                  backgroundColor: Colors.white,
                                  shadowColor: Constants.softShadowColor,
                                  highlightColor: Constants.highlightColor,
                                  child:  Icon(
                                    FontAwesomeIcons.list ,
                                    color:kPrimaryColorBlue.withOpacity(0.6),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 0.0, bottom: 0.0, left: 40.0, right: 0.0),
                                child: Text(
                                  "Total  Transaction",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                      fontFamily: "PoppinsLight"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              top: 0.0, bottom: 10.0, left: 0.0, right: 60),
                          child: Text(
                            todayTransaction.toString(),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color:kPrimaryColorBlue.withOpacity(0.6),
                                fontSize: 15.0,
                                fontFamily: "PoppinsLight"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10.00, 10, 0),
                  width: double.maxFinite,
                  child: Card(
                    elevation: 10.00,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: size.width * 0.9,
                          padding: EdgeInsets.only(
                              top: 10.0, bottom: 0.0, left: 5.0, right: 5.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                    top: 10.0, bottom: 0.0, left: 10.0, right: 0.0),
                                child: NeuomorphicCircle(
                                  innerShadow: false,
                                  outerShadow: true,
                                  backgroundColor: Colors.white,
                                  shadowColor: Constants.softShadowColor,
                                  highlightColor: Constants.highlightColor,
                                  child:  Icon(
                                    FontAwesomeIcons.divide ,
                                    color: Colors.deepOrange.withOpacity(0.6),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 0.0, bottom: 0.0, left: 40.0, right: 0.0),
                                child: Text(
                                  "Average  Transaction",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                      fontFamily: "PoppinsLight"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              top: 0.0, bottom: 10.0, left: 0.0, right: 60),
                          child: Text(
                            AvgTransaction.toString(),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.deepOrange.withOpacity(0.6),
                                fontSize: 15.0,
                                fontFamily: "PoppinsLight"),
                          ),
                        ),

                      ],),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10.00, 10, 0),
                  width: double.maxFinite,
                  child: Card(
                    elevation: 10.00,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: size.width * 0.9,
                          padding: EdgeInsets.only(
                              top: 10.0, bottom: 0.0, left: 5.0, right: 5.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                    top: 10.0, bottom: 0.0, left: 10.0, right: 0.0),
                                child: NeuomorphicCircle(
                                  innerShadow: false,
                                  outerShadow: true,
                                  backgroundColor: Colors.white,
                                  shadowColor: Constants.softShadowColor,
                                  highlightColor: Constants.highlightColor,
                                  child:  Icon(
                                    FontAwesomeIcons.angleUp,
                                    color: Colors.green.withOpacity(0.6),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 0.0, bottom: 0.0, left: 40.0, right: 0.0),
                                child: Text(
                                  "Total  Sales",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                      fontFamily: "PoppinsLight"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              top: 0.0, bottom: 10.0, left: 0.0, right: 60),
                          child: Text(
                            totalSale.toString(),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.green.withOpacity(0.6),
                                fontSize: 15.0,
                                fontFamily: "PoppinsLight"),
                          ),
                        ),

                      ],),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10.00, 10, 15),
                  width: double.maxFinite,
                  child: Card(
                    elevation: 10.00,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: size.width * 0.9,
                          padding: EdgeInsets.only(
                              top: 10.0, bottom: 0.0, left: 5.0, right: 5.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(
                                    top: 10.0, bottom: 0.0, left: 10.0, right: 0.0),
                                child: NeuomorphicCircle(
                                  innerShadow: false,
                                  outerShadow: true,
                                  backgroundColor: Colors.white,
                                  shadowColor: Constants.softShadowColor,
                                  highlightColor: Constants.highlightColor,
                                  child:  Icon(
                                    FontAwesomeIcons.divide ,
                                    color: Colors.pink.withOpacity(0.6),
                                  ),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 0.0, bottom: 0.0, left: 40.0, right: 0.0),
                                child: Text(
                                  "Average Sales",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                      fontFamily: "PoppinsLight"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(
                              top: 0.0, bottom: 10.0, left: 0.0, right: 60),
                          child: Text(
                            avgSale.toString(),
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Colors.pink.withOpacity(0.6),
                                fontSize: 15.0,
                                fontFamily: "PoppinsLight"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Container(
                  width: size.width * 0.95,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Container(
                      //   width: size.width,
                      //   height: 70.0,
                      //   child: Card(
                      //     elevation: 10.0,
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(10.0),
                      //     ),
                      //     child: Row(
                      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //       children: [
                      //         Container(
                      //           color: Colors.white,
                      //           width: size.width * 0.4,
                      //           height: 40.0,
                      //           child: TextField(
                      //             enableInteractiveSelection:
                      //             false,
                      //             focusNode: new AlwaysDisabledFocusNode(),
                      //             controller: fromDateController,
                      //             onTap: () {
                      //               _selectDateStart(context);
                      //             },
                      //             style: TextStyle(
                      //                 fontFamily: "PoppinsBold",
                      //                 fontSize: 13.0,
                      //                 color: kPrimaryColorBlue),
                      //             decoration: InputDecoration(
                      //               border: InputBorder.none,
                      //               contentPadding:
                      //               const EdgeInsets.symmetric(vertical: 10.0),
                      //               enabledBorder: OutlineInputBorder(
                      //                 borderSide: BorderSide(
                      //                     color: kPrimaryColorBlue, width: 0.5),
                      //                 borderRadius:
                      //                 const BorderRadius.all(Radius.circular(35.0)),
                      //               ),
                      //               focusedBorder: new OutlineInputBorder(
                      //                 borderSide: BorderSide(
                      //                     color: kPrimaryColorBlue, width: 0.5),
                      //                 borderRadius:
                      //                 const BorderRadius.all(Radius.circular(35.0)),
                      //               ),
                      //               prefixIcon: Icon(
                      //                 FontAwesomeIcons.calendar,
                      //                 color: kPrimaryColorBlue,
                      //                 size: 20.0,
                      //               ),
                      //               hintText: "From",
                      //               hintStyle: TextStyle(
                      //                   fontFamily: "PoppinsBold",
                      //                   fontSize: 13.0,
                      //                   color: kPrimaryColorBlue),
                      //             ),
                      //           ),
                      //         ),
                      //         Container(
                      //           width: size.width * 0.4,
                      //           height: 40.0,
                      //           child: TextField(
                      //             enableInteractiveSelection:
                      //             false,
                      //             focusNode: new AlwaysDisabledFocusNode(),
                      //             controller: toDateController,
                      //             onTap: () {
                      //               _selectDateEnd(context);
                      //             },
                      //             style: TextStyle(
                      //                 fontFamily: "PoppinsBold",
                      //                 fontSize: 13.0,
                      //                 color: kPrimaryColorBlue),
                      //             decoration: InputDecoration(
                      //               border: InputBorder.none,
                      //               contentPadding:
                      //               const EdgeInsets.symmetric(vertical: 10.0),
                      //               enabledBorder: OutlineInputBorder(
                      //                 borderSide: BorderSide(
                      //                     color: kPrimaryColorBlue, width: 0.5),
                      //                 borderRadius:
                      //                 const BorderRadius.all(Radius.circular(35.0)),
                      //               ),
                      //               focusedBorder: new OutlineInputBorder(
                      //                 borderSide: BorderSide(
                      //                     color: kPrimaryColorBlue, width: 0.5),
                      //                 borderRadius:
                      //                 const BorderRadius.all(Radius.circular(35.0)),
                      //               ),
                      //               prefixIcon: Icon(
                      //                 FontAwesomeIcons.calendar,
                      //                 color: kPrimaryColorBlue,
                      //                 size: 20.0,
                      //               ),
                      //               hintText: "To",
                      //
                      //               hintStyle: TextStyle(
                      //                   fontFamily: "PoppinsBold",
                      //                   fontSize: 13.0,
                      //                   color: kPrimaryColorBlue),
                      //             ),
                      //           ),
                      //         ),
                      //       ]
                      //     ),
                      //   ),
                      // ),
                      //
                      // SizedBox(height: 10.0,),

                      FutureBuilder<List<DoughnutChartData>>(
                        future:  BilllingAnalysis(),
                        builder: (ctx, snap) {
                          if (snap.hasData && snap.data == null) {
                            return Container(child: Text('Error'),);
                          } else if (snap.connectionState == ConnectionState.done && snap.hasData) {
                            return DoughnutChart(snap.data, size, "Billing Analysis");
                          } else {
                            return Center(
                                child:  Shimmer.fromColors(
                                    baseColor: Colors.grey[300],
                                    highlightColor: Colors.grey[100],
                                    enabled: _headerEnabled,
                                    child: Container(
                                      height: size.height * 0.3,
                                      width: size.width * 0.95,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(30)),
                                      ),
                                      child: null,
                                    )
                                )
                            );
                          }
                        },
                      ),
                      SizedBox(height: 10.0,),
                      FutureBuilder<List<DoughnutChartData>>(
                        future:  DigitalBilling(),
                        builder: (ctx, snap) {
                          if (snap.hasData && snap.data == null) {
                            return Container(child: Text('Error'),);
                          } else if (snap.connectionState == ConnectionState.done && snap.hasData) {
                            return DoughnutChart(snap.data, size, "Digital Billing");
                          } else {
                            return Center(
                                child:  Shimmer.fromColors(
                                    baseColor: Colors.grey[300],
                                    highlightColor: Colors.grey[100],
                                    enabled: _headerEnabled,
                                    child: Container(
                                      height: size.height * 0.3,
                                      width: size.width * 0.95,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(30)),
                                      ),
                                      child: null,
                                    )
                                )
                              //     child: CircularProgressIndicator(
                              //   valueColor: AlwaysStoppedAnimation<Color>(
                              //       kPrimaryColorBlue),
                              // ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 10.0,),
                      FutureBuilder<List<DoughnutChartData>>(
                        future:  coupenDetails(),
                        builder: (ctx, snap) {
                          if (snap.hasData && snap.data == null) {
                            return Container(child: Text('Error'),);
                          } else if (snap.connectionState == ConnectionState.done && snap.hasData) {
                            return DoughnutChart(snap.data, size, "Coupons");
                          } else {
                            return Center(
                                child:  Shimmer.fromColors(
                                    baseColor: Colors.grey[300],
                                    highlightColor: Colors.grey[100],
                                    enabled: _headerEnabled,
                                    child: Container(
                                      height: size.height * 0.3,
                                      width: size.width * 0.95,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(30)),
                                      ),
                                      child: null,
                                    )
                                )
                              //     child: CircularProgressIndicator(
                              //   valueColor: AlwaysStoppedAnimation<Color>(
                              //       kPrimaryColorBlue),
                              // ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 10.0,),
                      FutureBuilder<List<DoughnutChartData>>(
                        future:  offerDetails(),
                        builder: (ctx, snap) {
                          if (snap.hasData && snap.data == null) {
                            return Container(child: Text('Error'),);
                          } else if (snap.connectionState == ConnectionState.done && snap.hasData) {
                            return DoughnutChart(snap.data, size, "Offers");
                          } else {
                            return Center(
                                child:  Shimmer.fromColors(
                                    baseColor: Colors.grey[300],
                                    highlightColor: Colors.grey[100],
                                    enabled: _headerEnabled,
                                    child: Container(
                                      height: size.height * 0.3,
                                      width: size.width * 0.95,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(30)),
                                      ),
                                      child: null,
                                    )
                                )
                              //     child: CircularProgressIndicator(
                              //   valueColor: AlwaysStoppedAnimation<Color>(
                              //       kPrimaryColorBlue),
                              // ),
                            );
                          }
                        },
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 10.00, 0, 10),
                        width: double.maxFinite,
                        child: Card(
                          elevation: 12.00,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          child: Column(
                            children: <Widget>[
                              Container(
                                width: size.width * 0.9,
                                padding: EdgeInsets.only(
                                    top: 10.0, bottom: 0.0, left: 5.0, right: 5.0),
                                child:Container(
                                  padding: EdgeInsets.only(
                                      top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                                  child: Text(
                                    "Overall Customer Analysis",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: kPrimaryColorBlue,
                                        fontSize: 16.0,
                                        fontFamily: "PoppinsBold"),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10.0),
                              Container(
                                padding: EdgeInsets.only(
                                    top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: size.width * 0.5,
                                      padding: EdgeInsets.only(
                                          top: 10.0, bottom: 0.0, left: 5.0, right: 5.0),
                                      child:Container(
                                        padding: EdgeInsets.only(
                                            top: 0.0, bottom: 0.0, left: 15.0, right: 0.0),
                                        child: Text(
                                          "New Customer :",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: kPrimaryColorBlue,
                                              fontSize: 16.0,
                                              fontFamily: "PoppinsLight"),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: size.width * 0.4,
                                      padding: EdgeInsets.only(
                                          top: 10.0, bottom: 0.0, left: 5.0, right: 5.0),
                                      child:Container(
                                        padding: EdgeInsets.only(
                                            top: 0.0, bottom: 0.0, left: 10.0, right: 0.0),
                                        child: Text(
                                          newsCustomerText.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: kPrimaryColorBlue,
                                              fontSize: 16.0,
                                              fontFamily: "PoppinsLight"),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      width: size.width * 0.5,
                                      padding: EdgeInsets.only(
                                          top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                                      child:Container(
                                        padding: EdgeInsets.only(
                                            top: 0.0, bottom: 10.0, left: 15.0, right: 0.0),
                                        child: Text(
                                          "Returned Customer :",
                                          textAlign: TextAlign.start,
                                          style: TextStyle(
                                              color: kPrimaryColorBlue,
                                              fontSize: 16.0,
                                              fontFamily: "PoppinsLight"),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: size.width * 0.4,
                                      padding: EdgeInsets.only(
                                          top: 10.0, bottom: 10.0, left: 5.0, right: 5.0),
                                      child:Container(
                                        padding: EdgeInsets.only(
                                            top: 0.0, bottom: 0.0, left: 10.0, right: 0.0),
                                        child: Text(
                                          returningCustomerText.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: kPrimaryColorBlue,
                                              fontSize: 16.0,
                                              fontFamily: "PoppinsLight"),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                            ],),),),

                      // Container(
                      //     width: size.width * 0.95,
                      //     height: size.height * 0.35,
                      //     padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                      //     decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.all(Radius.circular(30)),
                      //         color: Colors.white,
                      //         boxShadow: [
                      //           BoxShadow(
                      //               color: Constants.softHighlightColor,
                      //               offset: Offset(-10, -10),
                      //               spreadRadius: 0,
                      //               blurRadius: 10),
                      //           BoxShadow(
                      //               color: Constants.softShadowColor,
                      //               offset: Offset(5, 5),
                      //               spreadRadius: 0,
                      //               blurRadius: 10)
                      //         ]
                      //     ),
                      //     child: FutureBuilder<List<ChartPetrolData>>(
                      //       future: fetchAllPetrolCollection(),
                      //       builder: (BuildContext context, AsyncSnapshot<List<ChartPetrolData>> snapshot) {
                      //         if (snapshot.connectionState == ConnectionState.waiting)
                      //           return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),));
                      //         else if (snapshot.hasError) {
                      //           return Center(
                      //             child: Text("Graph Not Available"),
                      //           );
                      //         } else {
                      //           if (snapshot.connectionState == ConnectionState.done &&
                      //               snapshot.hasData) {
                      //             return Column(
                      //               children: [
                      //                 Text("Bills Collection",
                      //                   style: TextStyle(
                      //                     color: kPrimaryColorBlue,
                      //                     fontSize: size.width * 0.04,
                      //                     fontFamily: "PoppinsBold",
                      //                   ),
                      //                 ),
                      //                 Expanded(
                      //                   child: _buildDefaultSplineChart(snapshot.data),
                      //
                      //                 )
                      //               ],
                      //             );
                      //           } else {
                      //             return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),));
                      //           }
                      //         }
                      //       },
                      //    )
                      // )

                    ],
                  ),
                ),
                SizedBox(height: 10.0,),
                //RingChart(dataMap,size)

              ],
            ),
          ):Container(
            child: Column(
              children:<Widget> [
                Container(
                  width: size.width * 0.9,
                  padding: EdgeInsets.only(
                      top: 10.0, bottom: 5.0, left: 5.0, right: 5.0),
                  child: Text(
                    "Today's Data",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontFamily: "PoppinsBold"),
                  ),
                ),
                SizedBox(height: 10.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    (_headerEnabled) ?
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      enabled: _headerEnabled,
                      child: Container(
                          height: cardDimenHeight,
                          width: cardDimenWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(kDefaultPaddingSmall),
                            child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: size.width * 0.1,
                                        width: size.width * 0.1,
                                        child: NeuomorphicCircle(
                                            innerShadow: false,
                                            outerShadow: true,
                                            backgroundColor: Colors.white,
                                            shadowColor: Constants.softShadowColor,
                                            highlightColor: Constants.highlightColor,
                                            child: null
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                                      ),
                                      Expanded(
                                        child: Container(
                                          width: double.infinity,
                                          height: 8.0,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: size.width * 0.03),
                                  ),
                                  Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: size.width * 0.25,
                                            height: 8.0,
                                            color: Colors.white,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 2.0),
                                          ),
                                          Container(
                                            width: size.width * 0.25,
                                            height: 8.0,
                                            color: Colors.white,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 2.0),
                                          ),
                                          Container(
                                            width: size.width * 0.25,
                                            height: 8.0,
                                            color: Colors.white,
                                          ),
                                        ],
                                      )
                                  )
                                ]
                            ),

                          )
                      ),
                    ) :
                    CardItem(
                      size,
                      title: "Payments",
                      category: (storeCatID == "11") ? "Cash - ₹ ${(data.todaysPayments.cash).toStringAsFixed(2)}" : "Cash - ₹ ${(parkingData.todaysPayments.cash).toStringAsFixed(2)}",
                      categoryTwo: (storeCatID == "11") ? "Online - ₹ ${data.todaysPayments.online}" : "Online - ₹ ${parkingData.todaysPayments.online}",
                      iconData: FontAwesomeIcons.wallet,
                    ),
                    (_headerEnabled) ?
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      // enabled: _enabled,
                      child: Container(
                          height: cardDimenHeight,
                          width: cardDimenWidth,
                          child: Padding(
                            padding: const EdgeInsets.all(kDefaultPaddingSmall),
                            child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: size.width * 0.1,
                                        width: size.width * 0.1,
                                        child: NeuomorphicCircle(
                                            innerShadow: false,
                                            outerShadow: true,
                                            backgroundColor: Colors.white,
                                            shadowColor: Constants.softShadowColor,
                                            highlightColor: Constants.highlightColor,
                                            child: null
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                                      ),
                                      Expanded(
                                        child: Container(
                                          width: double.infinity,
                                          height: 8.0,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: size.width * 0.03),
                                  ),
                                  Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: size.width * 0.25,
                                            height: 8.0,
                                            color: Colors.white,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 2.0),
                                          ),
                                          Container(
                                            width: size.width * 0.25,
                                            height: 8.0,
                                            color: Colors.white,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 2.0),
                                          ),
                                          Container(
                                            width: size.width * 0.25,
                                            height: 8.0,
                                            color: Colors.white,
                                          ),
                                        ],
                                      )
                                  )
                                ]
                            ),

                          )
                      ),
                    ) :
                    CardItem(
                      size,
                      title: "Bills",
                      category: (storeCatID == "11") ? "Total - ${data.todaysBill.total}" : "Total - ${parkingData.todaysBill.total}",
                      categoryTwo: (storeCatID == "11") ? "Flagged - ${data.todaysBill.flagged}" : "Flagged - ${parkingData.todaysBill.flagged}",
                      iconData: FontAwesomeIcons.receipt,
                    ),
                  ],
                ),
                SizedBox(height: 15.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    (_headerEnabled) ?
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      enabled: _headerEnabled,
                      child: Container(
                          height: cardDimenHeight,
                          width: cardDimenWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(kDefaultPaddingSmall),
                            child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: size.width * 0.1,
                                        width: size.width * 0.1,
                                        child: NeuomorphicCircle(
                                            innerShadow: false,
                                            outerShadow: true,
                                            backgroundColor: Colors.white,
                                            shadowColor: Constants.softShadowColor,
                                            highlightColor: Constants.highlightColor,
                                            child: null
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                                      ),
                                      Expanded(
                                        child: Container(
                                          width: double.infinity,
                                          height: 8.0,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: size.width * 0.03),
                                  ),
                                  Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: size.width * 0.25,
                                            height: 8.0,
                                            color: Colors.white,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 2.0),
                                          ),
                                          Container(
                                            width: size.width * 0.25,
                                            height: 8.0,
                                            color: Colors.white,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 2.0),
                                          ),
                                          Container(
                                            width: size.width * 0.25,
                                            height: 8.0,
                                            color: Colors.white,
                                          ),
                                        ],
                                      )
                                  )
                                ]
                            ),

                          )
                      ),
                    ) :
                    CardItem(
                      size,
                      data: data,
                      parkingData: parkingData,
                      catID: storeCatID,
                      title: (storeCatID == "11") ? "Sales" : "Space",
                      iconData: (storeCatID == "11") ? FontAwesomeIcons.gasPump : FontAwesomeIcons.car,
                    ),
                    (_headerEnabled) ?
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300],
                      highlightColor: Colors.grey[100],
                      enabled: _headerEnabled,
                      child: Container(
                          height: cardDimenHeight,
                          width: cardDimenWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(kDefaultPaddingSmall),
                            child:Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: size.width * 0.1,
                                        width: size.width * 0.1,
                                        child: NeuomorphicCircle(
                                            innerShadow: false,
                                            outerShadow: true,
                                            backgroundColor: Colors.white,
                                            shadowColor: Constants.softShadowColor,
                                            highlightColor: Constants.highlightColor,
                                            child: null
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                                      ),
                                      Expanded(
                                        child: Container(
                                          width: double.infinity,
                                          height: 8.0,
                                          color: Colors.white,
                                        ),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: size.width * 0.03),
                                  ),
                                  Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: size.width * 0.25,
                                            height: 8.0,
                                            color: Colors.white,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 2.0),
                                          ),
                                          Container(
                                            width: size.width * 0.25,
                                            height: 8.0,
                                            color: Colors.white,
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(vertical: 2.0),
                                          ),
                                          Container(
                                            width: size.width * 0.25,
                                            height: 8.0,
                                            color: Colors.white,
                                          ),
                                        ],
                                      )
                                  )
                                ]
                            ),

                          )
                      ),
                    ) :
                    CardItem(
                      size,
                      data: data,
                      parkingData: parkingData,
                      catID: storeCatID,
                      title: (storeCatID == "11") ? "Rate" : "Not Exited",
                      iconData: (storeCatID == "11") ? FontAwesomeIcons.rupeeSign : FontAwesomeIcons.checkDouble,
                    ),
                  ],
                ),
                SizedBox(height: 10.0,),

                Container(
                  width: size.width * 0.95,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FutureBuilder<List<DoughnutChartData>>(
                        future: fetchProductOrVehicleWiseEarnData(),
                        builder: (ctx, snap) {
                          if (snap.hasData && snap.data == null) {
                            return Container(child: Text('Error'),);
                          } else if (snap.connectionState == ConnectionState.done && snap.hasData) {
                            // return PieChartCategory(snap.data, size, (storeCatID == "11") ? "Product Sales" : "Collections");
                            return DoughnutChart(snap.data, size, (storeCatID == "11") ? "Product Sales" : "Collections");
                          } else {
                            return Center(
                                child:  Shimmer.fromColors(
                                    baseColor: Colors.grey[300],
                                    highlightColor: Colors.grey[100],
                                    enabled: _headerEnabled,
                                    child: Container(
                                      height: size.height * 0.3,
                                      width: size.width * 0.95,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(30)),
                                      ),
                                      child: null,
                                    )
                                )
                              //     child: CircularProgressIndicator(
                              //   valueColor: AlwaysStoppedAnimation<Color>(
                              //       kPrimaryColorBlue),
                              // ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 10.0,),
                      FutureBuilder<List<DoughnutChartData>>(
                        future: fetchAddonsOrVehicleWiseBillData(),
                        builder: (ctx, snap) {
                          if (snap.hasData && snap.data == null) {
                            return Container(child: Text('Error'),);
                          } else if (snap.connectionState == ConnectionState.done && snap.hasData) {
                            // return PieChartCategory(snap.data, size, (storeCatID == "11") ? "Addons Sales" : "Bills");
                            return DoughnutChart(snap.data, size, (storeCatID == "11") ? "Addons Sales" : "Bills");
                          } else {
                            return Center(
                                child:  Shimmer.fromColors(
                                    baseColor: Colors.grey[300],
                                    highlightColor: Colors.grey[100],
                                    enabled: _headerEnabled,
                                    child: Container(
                                      height: size.height * 0.3,
                                      width: size.width * 0.95,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(Radius.circular(30)),
                                      ),
                                      child: null,
                                    )
                                )
                              //     child: CircularProgressIndicator(
                              //   valueColor: AlwaysStoppedAnimation<Color>(
                              //       kPrimaryColorBlue),
                              // ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10.0,),

                (!_headerEnabled) ? Container(
                  width: size.width * 0.95,
                  height: size.height * 0.25,
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Constants.softHighlightColor,
                            offset: Offset(-10, -10),
                            spreadRadius: 0,
                            blurRadius: 10),
                        BoxShadow(
                            color: Constants.softShadowColor,
                            offset: Offset(5, 5),
                            spreadRadius: 0,
                            blurRadius: 10)
                      ]
                  ),
                  child: FutureBuilder<List<Metadata>>(
                    future: getUsersLists(),
                    builder: (BuildContext context, AsyncSnapshot<List<Metadata>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),));
                      else if (snapshot.hasError) {
                        return Center(
                          child: Text("No Data Found!"),
                        );
                      } else {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          return Column(
                            children: [
                              Text("Users Analysis",
                                style: TextStyle(
                                  color: kPrimaryColorBlue,
                                  fontSize: size.width * 0.04,
                                  fontFamily: "PoppinsBold",
                                ),
                              ),
                              Expanded(
                                child: Scrollbar(
                                  isAlwaysShown: true,
                                  controller: _controller,
                                  thickness: 3.0,
                                  child: ListView.builder(
                                      itemCount: snapshot.data.length,
                                      shrinkWrap: true,
                                      reverse: false,
                                      controller: _controller,
                                      itemBuilder: (BuildContext context, int index) {
                                        return new ListTile(
                                          isThreeLine: false,
                                          dense: true,
                                          title: Text(
                                              snapshot.data[index].name,
                                              style: TextStyle(fontSize: 15.0)
                                          ),
                                          subtitle: (snapshot.data[index].loginDate.isNotEmpty) ? Text('Login Detail: ${snapshot.data[index].loginDate} (${snapshot.data[index].loginTime}) . ${snapshot.data[index].logoutAt}'
                                              '\nTotal Bills: ${snapshot.data[index].totalBills} . Total Flagged: ${snapshot.data[index].totalFlagged}',
                                              style: TextStyle(fontSize: 10.0)) : Text("Not login yet.", style: TextStyle(fontSize: 10.0)),
                                          trailing: Text(
                                              "₹ ${snapshot.data[index].totalCollection}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 17.0)
                                          ),
                                        );
                                      }
                                  ),
                                ),
                              )
                            ],
                          );
                        } else {
                          return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),));
                        }
                      }
                    },
                  ),

                ) :
                Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  enabled: _headerEnabled,
                  child: Container(
                    width: size.width * 0.95,
                    height: size.height * 0.25,
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: Colors.white,
                    ),
                    child: null,
                  ),
                ),
                SizedBox(height: 10.0,),
                (!_headerEnabled) ? Container(
                    width: size.width * 0.95,
                    height: size.height * 0.35,
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Constants.softHighlightColor,
                              offset: Offset(-10, -10),
                              spreadRadius: 0,
                              blurRadius: 10),
                          BoxShadow(
                              color: Constants.softShadowColor,
                              offset: Offset(5, 5),
                              spreadRadius: 0,
                              blurRadius: 10)
                        ]
                    ),
                    child: (storeCatID == "11") ? FutureBuilder<List<ChartPetrolData>>(
                      future: fetchAllPetrolCollection(),
                      builder: (BuildContext context, AsyncSnapshot<List<ChartPetrolData>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),));
                        else if (snapshot.hasError) {
                          return Center(
                            child: Text("Graph Not Available"),
                          );
                        } else {
                          if (snapshot.connectionState == ConnectionState.done &&
                              snapshot.hasData) {
                            return Column(
                              children: [
                                Text("Bills Collection",
                                  style: TextStyle(
                                    color: kPrimaryColorBlue,
                                    fontSize: size.width * 0.04,
                                    fontFamily: "PoppinsBold",
                                  ),
                                ),
                                Expanded(
                                  child: _buildDefaultSplineChart(snapshot.data),

                                )
                              ],
                            );
                          } else {
                            return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),));
                          }
                        }
                      },
                    )
                        : FutureBuilder<List<ChartParkingData>>(
                      future: fetchAllParkingCollection(),
                      builder: (BuildContext context, AsyncSnapshot<List<ChartParkingData>> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),));
                        else if (snapshot.hasError) {
                          print(">>>>>>${snapshot.error}");
                          return Center(
                            child: Text("Graph Not Available"),
                          );
                        } else {
                          if (snapshot.connectionState == ConnectionState.done &&
                              snapshot.hasData) {
                            return Column(
                              children: [
                                Text("Bills Collection",
                                  style: TextStyle(
                                    color: kPrimaryColorBlue,
                                    fontSize: size.width * 0.04,
                                    fontFamily: "PoppinsBold",
                                  ),
                                ),
                                Expanded(
                                  child: _buildParkingSplineChart(snapshot.data),
                                )
                              ],
                            );
                          } else {
                            return Center(child: CircularProgressIndicator(valueColor:AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),));
                          }
                        }
                      },
                    )
                )
                    : Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.grey[100],
                  enabled: _headerEnabled,
                  child: Container(
                    width: size.width * 0.95,
                    height: size.height * 0.45,
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: Colors.white,
                    ),
                    child: null,
                  ),
                ),
                SizedBox(height: 10.0,),
              ],
            ),
          ),
          ],
        )
    );
  }

  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 800;
  }

  /// Returns the default spline chart.
  SfCartesianChart _buildDefaultSplineChart(List<ChartPetrolData> data) {
    return SfCartesianChart(
      // title: ChartTitle(
      //     text: "Bills Collection",
      //     textStyle: TextStyle(
      //       color: kPrimaryColorBlue,
      //       fontSize: size.width * 0.04,
      //       fontFamily: "PoppinsBold",
      //     )
      // ),,
      plotAreaBorderWidth: 0,


      primaryXAxis: CategoryAxis(
          majorGridLines: MajorGridLines(width: 0),
          labelPlacement: LabelPlacement.onTicks,
          labelRotation: -30,
          maximumLabels: 12,
      ),
      primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          labelFormat: '₹ {value}',
          majorTickLines: MajorTickLines(size: 0)
      ),
      series: <LineSeries<ChartPetrolData, String>>[
        LineSeries<ChartPetrolData, String>(
          dataSource: data,
          xValueMapper: (ChartPetrolData sales, _) => sales.x,
          yValueMapper: (ChartPetrolData sales, _) => double.parse(sales.y),
          markerSettings: MarkerSettings(isVisible: true),
        ),
      ],
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

  /// Returns the default spline chart.
  SfCartesianChart _buildParkingSplineChart(List<ChartParkingData> data) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: CategoryAxis(
          majorGridLines: MajorGridLines(width: 0),
          labelRotation: -30,
          maximumLabels: 12,
          labelPlacement: LabelPlacement.onTicks),
      primaryYAxis: NumericAxis(
          axisLine: AxisLine(width: 0),
          edgeLabelPlacement: EdgeLabelPlacement.shift,
          labelFormat: '₹ {value}',
          majorTickLines: MajorTickLines(size: 0)
      ),

      series: <LineSeries<ChartParkingData, String>>[
        LineSeries<ChartParkingData, String>(
          dataSource: data,
          xValueMapper: (ChartParkingData sales, _) => sales.x,
          yValueMapper: (ChartParkingData sales, _) => double.parse(sales.y),
          markerSettings: MarkerSettings(isVisible: true),
        ),

      ],
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }

}

class Metadata {
  Metadata({
    this.name,
    this.totalBills,
    this.totalCollection,
    this.loginAt,
    this.logoutAt,
    this.totalFlagged,
    this.loginDate,
    this.loginTime,
  });

  String name;
  String totalBills;
  String totalCollection;
  String loginAt;
  String logoutAt;
  String totalFlagged;
  String loginDate;
  String loginTime;
}
class AnalysisData {
  AnalysisData({
    this.newCustomerText,
    this.returningCustomersText,
    this.newCustomerValue,
    this.returningCustomersValue,

  });

  String newCustomerText;
  String returningCustomersText;
  int newCustomerValue;
  int returningCustomersValue;

}


class ChartPetrolData {
  ChartPetrolData({this.x,this.y});
  String x;
  String y;
}

class ChartParkingData {
  ChartParkingData({this.x, this.y});
  String x;
  String y;

}
class BillingAnalysis {
  BillingAnalysis({this.x, this.data});
  String x;
  int data;

}
