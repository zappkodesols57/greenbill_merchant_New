import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_Common.dart';
import 'package:greenbill_merchant/src/models/model_suggestStoreList.dart';
import 'package:greenbill_merchant/src/ui/widgets/background.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class SuggestABrand extends StatefulWidget {
  @override
  _SuggestABrandState createState() => _SuggestABrandState();
}

class _SuggestABrandState extends State<SuggestABrand> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, id, storeID, storeCatID;

  final ScrollController _controller = ScrollController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController mobController = new TextEditingController();
  TextEditingController addController = new TextEditingController();


  final FocusNode myFocusNodeName = FocusNode();
  final FocusNode myFocusNodeMob = FocusNode();
  final FocusNode myFocusNodeAdd = FocusNode();

  @override
  void initState() {
    getCredentials();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    mobController.dispose();
    addController.dispose();
    _controller.dispose();

    myFocusNodeName.dispose();
    myFocusNodeMob.dispose();
    myFocusNodeAdd.dispose();


    super.dispose();
  }

  getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      id = prefs.getInt("userID").toString();
      storeID = prefs.getString("businessID");
      storeCatID = prefs.getString("businessCategoryID");
    });
    print('$token\n$id');
  }

  Future<SuggestStoreList> list() async {

    final param = {
      "m_business_id": storeID,
      "user_id": id,
    };

    final res = await http.post(
      "http://157.230.228.250/suggest-business-list-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(res.body);
    print(res.statusCode);
    if(200 == res.statusCode){
      print(suggestStoreListFromJson(res.body).data.length);
      return suggestStoreListFromJson(res.body);
    } else{
      throw Exception('Failed to load Products List');
    }
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Suggest A Brand'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Background(
          child: Column(
            children: [
              Center(
                child: Container(
                  width: size.width * 0.95,
                  padding: EdgeInsets.only(left: 0.0, right: 0.0, bottom: 10.0, top: 20.0),
                  child: new TextField(
                    maxLength: 20,
                    focusNode: myFocusNodeName,
                    controller: nameController,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.storefront,
                        color: kPrimaryColorBlue,
                      ),
                      labelText: "Name of the Brand",
                      labelStyle: TextStyle(
                          fontFamily: "PoppinsMedium",
                          fontSize: 13.0,
                          color: kPrimaryColorBlue),
                      border: InputBorder.none,
                      counterStyle: TextStyle(
                        height: double.minPositive,
                      ),
                      counterText: "",
                      contentPadding:
                      const EdgeInsets.symmetric(vertical: 13.0, horizontal: 5),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                        BorderSide(color: kPrimaryColorBlue, width: 0.5),
                        borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                      ),
                      focusedBorder: new OutlineInputBorder(
                        borderSide:
                        BorderSide(color: kPrimaryColorBlue, width: 0.5),
                        borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(left: 0.0, right: 0.0, bottom: 10.0, top: 0.0),
                child: new TextField(
                  controller: mobController,
                  focusNode: myFocusNodeMob,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      FontAwesomeIcons.mobileAlt,
                      color: kPrimaryColorBlue,
                    ),
                    labelText: "Brand Mobile No.",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsMedium",
                        fontSize: 13.0,
                        color: kPrimaryColorBlue),
                    border: InputBorder.none,
                    counterStyle: TextStyle(
                      height: double.minPositive,
                    ),
                    counterText: "",
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 13.0, horizontal: 5),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide:
                      BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                  ),
                ),
              ),
              Container(
                width: size.width * 0.95,
                child: TextField(
                  controller: addController,
                  focusNode: myFocusNodeAdd,
                  cursorColor: kPrimaryColorBlue,
                  textInputAction: TextInputAction.newline,
                  maxLength: 200,
                  maxLines: 5,
                  decoration: InputDecoration(
                    // prefixIcon: Icon(
                    //   Icons.location_on_outlined,
                    //   color: kPrimaryColorBlue,
                    // ),
                    border: InputBorder.none,
                    hintText: 'Address',
                    hintStyle: TextStyle(
                        fontFamily: "PoppinsMedium",
                        fontSize: 13.0,
                        color: kPrimaryColorBlue),
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 13.0, horizontal: 50.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide:
                      BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Container(
                  width: size.width,
                  decoration: new BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(35.0)),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(1.0, 6.0),
                          blurRadius: 20.0,
                        ),
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(1.0, 6.0),
                          blurRadius: 20.0,
                        ),
                      ],
                      color: kPrimaryColorBlue
                  ),
                  child: MaterialButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 42.0),
                        child: Text(
                          "Submit",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500,
                              fontFamily: "PoppinsMedium"),
                        ),
                      ),
                      onPressed: () {
                        submit();
                      }),
                ),
              ),
            ],
          ),
        ),
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

  Future<void> submit() async {
    if(nameController.text.isEmpty){
      showInSnackBar("Please enter Brand Name");
      return null;
    }
    if(mobController.text.isEmpty){
      showInSnackBar("Please enter Mobile Number");
      return null;
    }
    if(mobController.text.length < 10){
      showInSnackBar("Please enter valid Mobile Number");
      return null;
    }
    if(addController.text.isEmpty){
      showInSnackBar("Please enter Address");
      return null;
    }

    final param = {
      "brand": nameController.text,
      "contact_no": mobController.text,
      "mobile_no": mobController.text,
      "location": addController.text,
    };

    final response = await http.post(
      "http://157.230.228.250/merchant-suggest-brand-api/",
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
        showInSnackBar("Submitted Successfully");
        nameController.clear();
        mobController.clear();
        addController.clear();
      } else showInSnackBar(data.message);
    } else {
      print(data.status);
      print(data.message);
      showInSnackBar(data.message);
      return null;
    }
  }

}
