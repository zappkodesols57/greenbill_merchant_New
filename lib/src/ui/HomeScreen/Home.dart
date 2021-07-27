import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:greenbill_merchant/src/models/model_getProfileImage.dart';
import 'package:greenbill_merchant/src/models/model_getStore.dart';
import 'package:greenbill_merchant/src/ui/BillInfo/tabBar.dart';
import 'package:greenbill_merchant/src/ui/History/historyTab.dart';
import 'package:greenbill_merchant/src/ui/History/paymentHistory.dart';
import 'package:greenbill_merchant/src/ui/MySubcription/newSubFile.dart';
import 'package:greenbill_merchant/src/ui/MySubcription/tabbarsubscription.dart';
import 'package:greenbill_merchant/src/ui/PayLinks/paylinks.dart';
import 'package:greenbill_merchant/src/ui/Profile/personalInfo.dart';
import 'package:greenbill_merchant/src/ui/Promotions/bulkSMS.dart';
import 'package:greenbill_merchant/src/ui/Promotions/offersList.dart';
import 'package:greenbill_merchant/src/ui/Promotions/tabBarPromotions.dart';
import 'package:greenbill_merchant/src/ui/drawer/CustomerInfo/customerInfo.dart';
import 'package:greenbill_merchant/src/ui/drawer/DM/dmEnquiry.dart';
import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/ui/HomeScreen/homePage.dart';
import 'package:greenbill_merchant/src/ui/drawer/MonthlyParkingPass/parkingPass.dart';
import 'package:greenbill_merchant/src/ui/drawer/ParkingLotManagement/ManageCharges/manage_charges.dart';
import 'package:greenbill_merchant/src/ui/drawer/ParkingLotManagement/ParkingSpace/manage_parkingSpace.dart';
import 'package:greenbill_merchant/src/ui/drawer/ParkingLotManagement/exitBill.dart';
import 'package:greenbill_merchant/src/ui/drawer/ParkingLotManagement/manage_vehicleType.dart';
import 'package:greenbill_merchant/src/ui/drawer/PetrolPump/AddOn/addOn_products.dart';
import 'package:greenbill_merchant/src/ui/drawer/PetrolPump/AddUser/viewAllUsers.dart';
import 'package:greenbill_merchant/src/ui/drawer/PetrolPump/ManageProduct/manage_products.dart';
import 'package:greenbill_merchant/src/ui/drawer/Qr/allQrLists.dart';
import 'package:greenbill_merchant/src/ui/drawer/ReceivedPayments/receivedPayments.dart';
import 'package:greenbill_merchant/src/ui/drawer/Settings/settings_main.dart';
import 'package:greenbill_merchant/src/ui/drawer/Settings/share_a_word.dart';
import 'package:greenbill_merchant/src/ui/drawer/cashMemoReceipts/tabBarMemo.dart';
import 'package:greenbill_merchant/src/ui/drawer/referStore/referStore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';

class HomeActivity extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GB Business',
      theme: ThemeData(
        primaryColor: kPrimaryColorBlue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Green Bill User'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  AnimationController animationController;
  final ScrollController _controller = ScrollController();
  String store = 'GB', storeID, storeAddress;
  PageController _pageController;

  String token, businessLogo, storeCatID;

  int id;
  int length=3;

  //State class
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();

  @override
  void initState() {
    setData();
    super.initState();
    _pageController = PageController();
    animationController =
        AnimationController(duration: new Duration(seconds: 2), vsync: this);
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    _pageController.dispose();
    super.dispose();
    profileFName.dispose();
    profileLName.dispose();
    profileMob.dispose();
    profile.dispose();
    profileUid.dispose();
    _controller.dispose();
  }

  TextEditingController profileFName = new TextEditingController();
  TextEditingController profileLName = new TextEditingController();
  TextEditingController profileMob = new TextEditingController();
  TextEditingController profileUid = new TextEditingController();
  TextEditingController profile = new TextEditingController();
  TextEditingController nozzleController = new TextEditingController();

  Future<void> setData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      id = prefs.getInt("userID");
      token = prefs.getString("token");
      store = prefs.getString("businessName");
      storeID = prefs.getString("businessID");
      businessLogo = prefs.getString("businessLogo");
      storeCatID = prefs.getString("businessCategoryID");
      print('$id  $token $store $storeID $businessLogo');
    });

    final param = {
      "user_id": id.toString(),
    };

    final response = await http.post(
      "http://157.230.228.250/get-merchant-profile-image-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    GetProfileImage profileImage;
    var responseJson = json.decode(response.body);
    print(response.body);
    profileImage = new GetProfileImage.fromJson(jsonDecode(response.body));
    print(responseJson);

    if (response.statusCode == 200) {
      if (profileImage.status == "success") {
        print("Profile fetch Successful");
        print(profileImage.data.firstName);
        profileFName.text = profileImage.data.firstName;
        profileLName.text = profileImage.data.lastName;
        profileMob.text = profileImage.data.mobileNo;
        profile.text = profileImage.data.profileImage;
        profileUid.text = profileImage.data.cUniqueId;
        prefs.setString("profile", profileImage.data.profileImage);
        setState(() {});
      } else
        print(profileImage.status);
    } else
      print(profileImage.status);

    if(storeCatID =="11" || storeCatID =="12" ){
      setState(() {
        length=4;
      });
    }else{
      setState(() {
        length=3;
      });
    }
  }

  // j2pStatus() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   String b = preferences.getString("j2p");
  //   if(b == "yes") {
  //     setState(() {
  //       _currentIndex = 2;
  //     });
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       if(_pageController.hasClients){
  //         _pageController.jumpToPage(2);
  //       }
  //     });
  //     preferences.getKeys();
  //     for(String key in preferences.getKeys()) {
  //       if(key == "j2p") {
  //         preferences.remove(key);
  //       }
  //     }
  //     _showMyDialog();
  //   }
  // }
  static Future<List<StoreList>> getStoreList(String id, String token) async {
    final param = {
      "user_id": id,
    };

    final res = await http.post(
      "http://157.230.228.250/get-merchant-businesses-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(res.body);
    if (200 == res.statusCode) {
      print(storeListFromJson(res.body).length);
      return storeListFromJson(res.body);
    } else {
      throw Exception('Failed to load Stores List');
    }
  }
  Widget setupAlertDialoagContainer() {
    return Container(
      height: 150,
      width: 350,
      child: FutureBuilder<List<StoreList>>(
        future: getStoreList(id.toString(), token),
        builder: (BuildContext context,
            AsyncSnapshot<List<StoreList>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Scrollbar(
                radius: Radius.circular(5.0),
                isAlwaysShown: true,
                controller: _controller,
                thickness: 3.0,
                child: ListView.builder(
                    controller: _controller,
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(snapshot.data[index].mBusinessName,
                            style: TextStyle(fontSize: 15.0)),
                        subtitle: (snapshot.data[index].mArea.isNotEmpty)
                            ? Text(
                            '${snapshot.data[index].mAddress}, ${snapshot.data[index].mArea}, ${snapshot.data[index].mCity}',
                            style: TextStyle(fontSize: 10.0))
                            : Text('Address not available',
                            style: TextStyle(fontSize: 10.0)),
                        // leading: Container(
                        //   width: 35.0,
                        //   height: 35.0,
                        //   decoration: new BoxDecoration(
                        //     color: kPrimaryColorBlue,
                        //     borderRadius: new BorderRadius.circular(25.0),
                        //   ),
                        //   alignment: Alignment.center,
                        //   child: new Icon(Icons.store, color: Colors.white, size: 22.0),
                        // ),

                        leading:
                        (snapshot.data[index].mBusinessLogo != null)
                            ? CircleAvatar(
                          backgroundColor: kPrimaryColorBlue,
                          backgroundImage: NetworkImage(snapshot.data[index].mBusinessLogo),
                        )
                            : CircleAvatar(
                          backgroundColor: kPrimaryColorBlue,
                          child: Text(
                            store.substring(0, 1).toUpperCase(),
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        onTap: () async {
                          final SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString("businessName", snapshot.data[index].mBusinessName);
                          prefs.setString("businessID", snapshot.data[index].id.toString());
                          prefs.setString("businessLogo", snapshot.data[index].mBusinessLogo);
                          prefs.setString("businessCategoryID", snapshot.data[index].mBusinessCategory.toString());
                          setState(() {
                            store = snapshot.data[index].mBusinessName;
                            storeID = snapshot.data[index].id.toString();
                            storeAddress = '${snapshot.data[index].mAddress}, ${snapshot.data[index].mArea}, ${snapshot.data[index].mCity}';
                            businessLogo = snapshot.data[index].mBusinessLogo;
                            storeCatID = snapshot.data[index].mBusinessCategory.toString();
                          });
                          Navigator.of(context).pop();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeActivity()),
                                (Route<dynamic> route) => false,
                          );
                        },
                      );
                    }));
          } else {
            return Center(
                child: CircularProgressIndicator(
                  valueColor: animationController.drive(ColorTween(
                      begin: kPrimaryColorBlue, end: kPrimaryColorGreen)),
                ));
          }
        },
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: new Text(store),
      elevation: 0,
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 10.0),

        ),
        GestureDetector(
            child: (businessLogo != null)
                ? CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage:
              NetworkImage("${profile.text}"),
            )
                : CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                store.substring(0, 1).toUpperCase(),
                style: TextStyle(
                  fontSize: 20.0,
                  color: kPrimaryColorBlue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            onTap: () {
              showStoreDialog(context);
            }),
        SizedBox(
          width: 20.0,
        ),
      ],
    );
  }

  showStoreDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Switch Business',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w800,
                  fontSize: 15.0,
                  fontFamily: "PoppinsMedium"),
            ),
            content: setupAlertDialoagContainer(),
            actions: <Widget>[
              TextButton(
                child:
                Text('Cancel', style: TextStyle(color: kPrimaryColorBlue)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  showNozzleDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Nozzle Count',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w800,
                  fontSize: 15.0,
                  fontFamily: "PoppinsMedium"),
            ),
            content: setupNozzleAlertDialoagContainer(),
            actions: <Widget>[
              TextButton(
                child:
                Text('Save', style: TextStyle(color: kPrimaryColorBlue)),
                onPressed: () {
                  saveNozzle();
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child:
                Text('Cancel', style: TextStyle(color: kPrimaryColorBlue)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future saveNozzle() async {
    if(nozzleController.text.isEmpty) {
      Fluttertoast.showToast(
          msg: "Nozzle Count is not entered!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return null;
    }
    if(int.parse(nozzleController.text) > 100) {
      Fluttertoast.showToast(
          msg: "Nozzle Count should not be grater than 100!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return null;
    }

    final param = {
      "m_business_id": storeID,
      "nozzle_count": nozzleController.text,
    };

    final response = await http.post(
      "http://157.230.228.250/petrol-manage-nozzle-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(response.statusCode);
    CommonData data;
    var responseJson = json.decode(response.body);
    print(response.body);
    data = new CommonData.fromJson(jsonDecode(response.body));
    print(responseJson);

    if (response.statusCode == 200) {
      print(data.status);
      if(data.status == "success"){
        print("Submit Successful");
        Fluttertoast.showToast(
            msg: "Nozzle Count added successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: kPrimaryColorBlue,
            textColor: Colors.white,
            fontSize: 16.0
        );
      } else print(data.message);
    } else {
      print(data.status);
      print(data.message);
      return null;
    }
  }

  Future fetchNozzleCount() async {
    final param = {
      "m_business_id": storeID,
    };

    final response = await http.post(
      "http://157.230.228.250/petrol-nozzle-count-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(response.statusCode);
    CommonData data;
    var responseJson = json.decode(response.body);
    print(response.body);
    data = new CommonData.fromJson(jsonDecode(response.body));
    print(responseJson);

    if (response.statusCode == 200) {
      print("Fetch Successful");
      print(data.status);
      if(data.status == "success"){
        setState(() {
          nozzleController.text = data.message;
        });
      } else print(data.message);
    } else {
      print(data.status);
      print(data.message);
      return null;
    }
  }

  Widget setupNozzleAlertDialoagContainer() {
    return Container(
      height: 100,
      width: 350,
      child: TextField(
        controller: nozzleController,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
        maxLength: 3,
        autofocus: true,
        style: TextStyle(
            fontFamily: "PoppinsMedium",
            fontSize: 13.0,
            color: Colors.black87),
        decoration: InputDecoration(
          counterStyle: TextStyle(height: double.minPositive,),
          counterText: "",
          hintText: "Nozzle Count *",
          hintStyle: TextStyle(
              fontFamily: "PoppinsLight", fontSize: 13.0, color: kPrimaryColorBlue),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      drawer: SafeArea(
        child: new Drawer(
            child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text('${profileFName.text} ${profileLName.text}'),
                  accountEmail: null,
                  // accountEmail: RichText(
                  //   text: TextSpan(
                  //       text: 'Checkout Pin: ',
                  //       style: TextStyle(
                  //         color: Colors.white,
                  //       ),
                  //       children: <TextSpan>[
                  //         TextSpan(
                  //           text: profileUid.text,
                  //           style: TextStyle(
                  //             color: Colors.white,
                  //             fontWeight: FontWeight.bold,
                  //           ),
                  //           // recognizer: TapGestureRecognizer()
                  //           //   ..onTap = () {
                  //           //     // open desired screen
                  //           //   }
                  //         ),
                  //       ]),
                  // ),
                  arrowColor: Colors.transparent,
                  // accountEmail: Text(profileMob.text),
                  currentAccountPicture: GestureDetector(
                      child: CircleAvatar(
                        backgroundImage: NetworkImage("${profile.text}"),
                      ),
                      onTap: () {
                        profileView();
                      }),
                  onDetailsPressed: () {
                    profileView();
                  },
                  //.. This line of code provides the usage of multiple accounts
                  otherAccountsPictures: <Widget>[
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 35.0,
                        height: 35.0,
                        decoration: new BoxDecoration(
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                        alignment: Alignment.center,
                        child: new Icon(Icons.clear, color: Colors.white, size: 20.0),
                      ),
                    ),
                  ],

                  decoration: BoxDecoration(
                    color: kPrimaryColorBlue,
                  ),
                ),
                ListTile(
                    dense: false,
                    title: Text("Manage QR Code"),
                    leading: Container(
                      width: 35.0,
                      height: 35.0,
                      margin: const EdgeInsets.only(right: 10.0),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.circular(25.0),
                      ),
                      alignment: Alignment.center,
                      child: new Icon(CupertinoIcons.qrcode,
                          color: kPrimaryColorBlue, size: 25.0),
                    ),
                    onTap: () {
                      print("Manage QRs");
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => AllQrLists()));
                    }),
                if(storeCatID != "11" && storeCatID != "1")
                  ListTile(
                      dense: false,
                      title: Text("Parking Pass"),
                      leading: Container(
                        width: 35.0,
                        height: 35.0,
                        margin: const EdgeInsets.only(right: 10.0),
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                        alignment: Alignment.center,
                        child: new Icon(CupertinoIcons.person_crop_rectangle,
                            color: kPrimaryColorBlue, size: 25.0),
                      ),
                      onTap: () {
                        print("Parking Pass");
                        Navigator.of(context).pop();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ParkingPass()));
                      }
                  ),
                if(storeCatID != "11" && storeCatID != "12")
                ListTile(
                    dense: false,
                    title: Text("Cash Memo & Receipt"),
                    leading: Container(
                      width: 35.0,
                      height: 35.0,
                      margin: const EdgeInsets.only(right: 10.0),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.circular(25.0),
                      ),
                      alignment: Alignment.center,
                      child: new Icon(CupertinoIcons.doc_text_search,
                          color: kPrimaryColorBlue, size: 25.0),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => TabBarMemo()));
                    }
                ),
                if(storeCatID != "11" && storeCatID != "12")
                  ListTile(
                      dense: false,
                      title: Text("Customer Info"),
                      leading: Container(
                        width: 35.0,
                        height: 35.0,
                        margin: const EdgeInsets.only(right: 10.0),
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                        alignment: Alignment.center,
                        child: new Icon(CupertinoIcons.person_3,
                            color: kPrimaryColorBlue, size: 25.0),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => CustomerInfo()));
                      }
                  ),
                ListTile(
                    dense: false,
                    title: Text("My Subscription"),
                    leading: Container(
                      width: 35.0,
                      height: 35.0,
                      margin: const EdgeInsets.only(right: 10.0),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.circular(25.0),
                      ),
                      alignment: Alignment.center,
                      child: new Icon(CupertinoIcons.purchased,
                          color: kPrimaryColorBlue, size: 25.0),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => subUpdated()));
                    }
                ),
                if(storeCatID != "11" && storeCatID != "12")
                ListTile(
                    dense: false,
                    title: Text("Bulk SMS"),
                    leading: Container(
                      width: 35.0,
                      height: 35.0,
                      margin: const EdgeInsets.only(right: 10.0),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.circular(25.0),
                      ),
                      alignment: Alignment.center,
                      child: new Icon(CupertinoIcons.bubble_left_bubble_right,
                          color: kPrimaryColorBlue, size: 25.0),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => BulkSMS()));
                    }),

                /* ListTile(
                  dense: false,
                  title: Text("Received Payments"),
                  leading: Container(
                    width: 35.0,
                    height: 35.0,
                    margin: const EdgeInsets.only(right: 10.0),
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.circular(25.0),
                    ),
                    alignment: Alignment.center,
                    child: new Icon(CupertinoIcons.tray_arrow_down,
                        color: kPrimaryColorBlue, size: 25.0),
                  ),
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ReceivedPayments()));
                  }),*/

                ListTile(
                    dense: false,
                    title: Text("Offers"),
                    leading: Container(
                      width: 35.0,
                      height: 35.0,
                      margin: const EdgeInsets.only(right: 10.0),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.circular(25.0),
                      ),
                      alignment: Alignment.center,
                      child: new Icon(CupertinoIcons.gift,
                          color: kPrimaryColorBlue, size: 25.0),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => OffersList()));
                    }
                ),
                if(storeCatID == "12")
                  ListTile(
                      dense: false,
                      title: Text("Exit Parked Vehicles"),
                      leading: Container(
                        width: 35.0,
                        height: 35.0,
                        margin: const EdgeInsets.only(right: 10.0),
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                        alignment: Alignment.center,
                        child: new Icon(CupertinoIcons.check_mark_circled,
                            color: kPrimaryColorBlue, size: 25.0),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ExitBillList()));
                      }
                  ),
                if(storeCatID == "12")
                  ExpansionTile(
                    title: Text("ParkingLot Management"),
                    expandedAlignment: Alignment.centerRight,
                    leading: Container(
                      width: 35.0,
                      height: 35.0,
                      margin: const EdgeInsets.only(right: 10.0),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.circular(25.0),
                      ),
                      alignment: Alignment.center,
                      child: new Icon(CupertinoIcons.car_detailed,
                          color: kPrimaryColorBlue, size: 25.0),
                    ),
                    maintainState: true,
                    children: [
                      ListTile(
                        dense: true,
                        title: Text("Manage Vehicle Type"),
                        onTap: (){
                          Navigator.of(context).pop();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ManageVehicleType()));
                        },
                      ),
                      ListTile(
                        dense: true,
                        title: Text("Manage Parking Space"),
                        onTap: (){
                          Navigator.of(context).pop();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ManageParkingSpace()));
                        },
                      ),
                      ListTile(
                        dense: true,
                        title: Text("Manage Charges"),
                        onTap: (){
                          Navigator.of(context).pop();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ManageCharges()));
                        },
                      )
                    ],
                  ),
                if(storeCatID == "11")
                  ListTile(
                      dense: false,
                      title: Text("Manage Products"),
                      leading: Container(
                        width: 35.0,
                        height: 35.0,
                        margin: const EdgeInsets.only(right: 10.0),
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                        alignment: Alignment.center,
                        child: new Icon(CupertinoIcons.bolt_circle,
                            color: kPrimaryColorBlue, size: 25.0),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => ManageProducts()));
                      }
                  ),
                if(storeCatID == "11")
                  ListTile(
                      dense: false,
                      title: Text("Addon Products"),
                      leading: Container(
                        width: 35.0,
                        height: 35.0,
                        margin: const EdgeInsets.only(right: 10.0),
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                        alignment: Alignment.center,
                        child: new Icon(CupertinoIcons.cube_box,
                            color: kPrimaryColorBlue, size: 25.0),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => AddonProducts()));
                      }
                  ),
                if(storeCatID == "11")
                  ListTile(
                      dense: false,
                      title: Text("Manage Nozzle"),
                      leading: Container(
                        width: 35.0,
                        height: 35.0,
                        margin: const EdgeInsets.only(right: 10.0),
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                        alignment: Alignment.center,
                        child: new Icon(CupertinoIcons.drop,
                            color: kPrimaryColorBlue, size: 25.0),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        fetchNozzleCount().then((value) => showNozzleDialog(context));
                      }
                  ),
                ListTile(
                    dense: false,
                    title: Text("Add User"),
                    leading: Container(
                      width: 35.0,
                      height: 35.0,
                      margin: const EdgeInsets.only(right: 10.0),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.circular(25.0),
                      ),
                      alignment: Alignment.center,
                      child: new Icon(CupertinoIcons.person_add,
                          color: kPrimaryColorBlue, size: 25.0),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ViewAllUsers()));
                    }
                ),
                if(storeCatID != "11" && storeCatID != "12")
                  ListTile(
                      dense: false,
                      title: Text("Digital Marketing"),
                      leading: Container(
                        width: 35.0,
                        height: 35.0,
                        margin: const EdgeInsets.only(right: 10.0),
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.circular(25.0),
                        ),
                        alignment: Alignment.center,
                        child: new Icon(CupertinoIcons.speaker_zzz,
                            color: kPrimaryColorBlue, size: 25.0),
                      ),
                      onTap: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DmEnquiry(
                                    "${profileFName.text} ${profileLName.text}",
                                    profileMob.text)));
                      }),
                // ListTile(
                //     dense: false,
                //     title: Text("Offers"),
                //     leading: Container(
                //       width: 35.0,
                //       height: 35.0,
                //       margin: const EdgeInsets.only(right: 10.0),
                //       decoration: new BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: new BorderRadius.circular(25.0),
                //       ),
                //       alignment: Alignment.center,
                //       child: new Icon(CupertinoIcons.gift,
                //           color: kPrimaryColorBlue, size: 25.0),
                //     ),
                //     onTap: () {
                //       // Navigator.of(context).pop();
                //     }),
                ListTile(
                    dense: false,
                    title: Text("Refer a Store"),
                    leading: Container(
                      width: 35.0,
                      height: 35.0,
                      margin: const EdgeInsets.only(right: 10.0),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.circular(25.0),
                      ),
                      alignment: Alignment.center,
                      child: new Icon(CupertinoIcons.shopping_cart,
                          color: kPrimaryColorBlue, size: 25.0),
                    ),
                    onTap: () {
                      print("Refer a Store");
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ReferralPage()));
                    }),
                ListTile(
                    dense: false,
                    title: Text("Share a Word"),
                    leading: Container(
                      width: 35.0,
                      height: 35.0,
                      margin: const EdgeInsets.only(right: 10.0),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.circular(25.0),
                      ),
                      alignment: Alignment.center,
                      child: new Icon(CupertinoIcons.arrowshape_turn_up_right,
                          color: kPrimaryColorBlue, size: 25.0),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ShareAWord()));
                    }),
                // ListTile(
                //     dense: false,
                //     title: Text("Feedback"),
                //     leading: Container(
                //       width: 35.0,
                //       height: 35.0,
                //       margin: const EdgeInsets.only(right: 10.0),
                //       decoration: new BoxDecoration(
                //         color: Colors.white,
                //         borderRadius: new BorderRadius.circular(25.0),
                //       ),
                //       alignment: Alignment.center,
                //       child: new Icon(CupertinoIcons.text_bubble,
                //           color: kPrimaryColorBlue, size: 25.0),
                //     ),
                //     onTap: () {
                //       Navigator.of(context).pop();
                //       Navigator.push(context,
                //           MaterialPageRoute(builder: (context) => Feedback1()));
                //     }),
                ListTile(
                    dense: false,
                    title: Text("Settings"),
                    leading: Container(
                      width: 35.0,
                      height: 35.0,
                      margin: const EdgeInsets.only(right: 10.0),
                      decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.circular(25.0),
                      ),
                      alignment: Alignment.center,
                      child: new Icon(CupertinoIcons.settings,
                          color: kPrimaryColorBlue, size: 25.0),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Settings()));
                    }),
              ],
            )),
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _page = index);
        },
        children: <Widget>[
          HomePage(),
          BillsTab(storeCatID,length),
          PayLinks(),
          TabBarPromotions(),
          HistoryTab(),

        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        height: 60.0,
        animationDuration: Duration(milliseconds: 450),
        backgroundColor: Colors.white,
        buttonBackgroundColor: kPrimaryColorBlue,
        color: kPrimaryColorBlue,
        items: <Widget>[
          (_page == 0)
              ? Icon(
            CupertinoIcons.home,
            color: Colors.white,
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                CupertinoIcons.home,
                color: Colors.white,
              ),
              Text(
                "Home",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.0,
                    fontFamily: "PoppinsMedium"),
              ),
              SizedBox(
                height: 10.0,
              )
            ],
          ),
          (_page == 1)
              ? Icon(
            CupertinoIcons.doc_plaintext,
            color: Colors.white,
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                CupertinoIcons.doc_plaintext,
                color: Colors.white,
              ),
              Text(
                "Bills",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.0,
                    fontFamily: "PoppinsMedium"),
              ),
              SizedBox(
                height: 10.0,
              )
            ],
          ),
          (_page == 2)
              ? Icon(
            FontAwesomeIcons.rupeeSign,
            color: Colors.white,
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                FontAwesomeIcons.rupeeSign,
                color: Colors.white,
              ),
              Text(
                "Pay Links",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.0,
                    fontFamily: "PoppinsMedium"),
              ),
              SizedBox(
                height: 10.0,
              )
            ],
          ),
          (_page == 3)
              ? Icon(
            CupertinoIcons.ticket,
            color: Colors.white,
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                CupertinoIcons.ticket,
                color: Colors.white,
              ),
              Text(
                "Promotions",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.0,
                    fontFamily: "PoppinsMedium"),
              ),
              SizedBox(
                height: 10.0,
              )
            ],
          ),
          (_page == 4)
              ? Icon(
            CupertinoIcons.arrow_right_arrow_left_circle,
            color: Colors.white,
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                CupertinoIcons.arrow_right_arrow_left_circle,
                color: Colors.white,
              ),
              Text(
                "History",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.0,
                    fontFamily: "PoppinsMedium"),
              ),
              SizedBox(
                height: 10.0,
              )
            ],
          ),
        ],
        onTap: (index) {
          setState(() {
            _page = index;
            _pageController.jumpToPage(index);
          });
        },
      ),
    );
  }

  void profileView() {
    Navigator.of(context).pop();
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => PersonalInfo(profile.text, profileUid.text)))
        .then((value) => value ? setData() : null);
  }
}
