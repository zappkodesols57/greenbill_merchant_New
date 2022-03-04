import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/models/model_States.dart';
import 'package:greenbill_merchant/src/ui/BillInfo/ViewBill.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constants.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({Key key}) : super(key: key);

  @override
  _AddCustomerState createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final ScrollController _controller = ScrollController();

  String state, city,userID,BusID,token;

  TextEditingController signupFirstController = new TextEditingController();
  TextEditingController signupLastController = new TextEditingController();
  TextEditingController signupStateController = new TextEditingController();
  TextEditingController signupCityController = new TextEditingController();
  TextEditingController signupDistrictController = new TextEditingController();
  TextEditingController signupMobileController = new TextEditingController();
  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupPinController = new TextEditingController();

  @override
  void initState() {
    getCredentials();
    super.initState();
  }

  getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      userID = prefs.getInt("userID").toString();
    });
    print('$token\n$userID');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Add Customer"),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: 25.0,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Center(
          child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: size.width * 0.9,
                    padding: EdgeInsets.only(
                        top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                    child: TextField(
                      controller: signupFirstController,
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(20),
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))
                      ],
                      style: TextStyle(
                          fontFamily: "PoppinsLight",
                          fontSize: 13.0,
                          color: kPrimaryColorBlue),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 13.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                        ),
                        focusedBorder: new OutlineInputBorder(
                          borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                        ),
                        prefixIcon: Icon(
                          FontAwesomeIcons.user,
                          color: kPrimaryColorBlue,
                          size: 20.0,
                        ),
                        labelText: "First Name*",
                        labelStyle: TextStyle(
                            fontFamily: "PoppinsLight",
                            fontSize: 13.0,
                            color: kPrimaryColorBlue),
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * 0.9,
                    padding: EdgeInsets.only(
                        top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                    child: TextField(
                      controller: signupLastController,
                      keyboardType: TextInputType.text,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(20),
                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]"))
                      ],
                      style: TextStyle(
                          fontFamily: "PoppinsLight",
                          fontSize: 13.0,
                          color: kPrimaryColorBlue),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 13.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                        ),
                        focusedBorder: new OutlineInputBorder(
                          borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                        ),
                        prefixIcon: Icon(
                          FontAwesomeIcons.user,
                          color: kPrimaryColorBlue,
                          size: 20.0,
                        ),
                        labelText: "Last Name*",
                        labelStyle: TextStyle(
                            fontFamily: "PoppinsLight",
                            fontSize: 13.0,
                            color: kPrimaryColorBlue),
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * 0.9,
                    padding: EdgeInsets.only(
                        top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                    child: TextField(
                      controller: signupMobileController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      onChanged: (value) {},
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      style: TextStyle(
                          fontFamily: "PoppinsLight",
                          fontSize: 13.0,
                          color: kPrimaryColorBlue),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterStyle: TextStyle(
                          height: double.minPositive,
                        ),
                        counterText: "",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 13.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                        ),
                        focusedBorder: new OutlineInputBorder(
                          borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                        ),
                        prefixIcon: Icon(
                          FontAwesomeIcons.mobileAlt,
                          color: kPrimaryColorBlue,
                          size: 20.0,
                        ),
                        labelText: "Mobile Number *",
                        labelStyle: TextStyle(
                            fontFamily: "PoppinsLight",
                            fontSize: 13.0,
                            color: kPrimaryColorBlue),
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * 0.9,
                    padding: EdgeInsets.only(
                        top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                    child: TextField(
                      controller: signupEmailController,
                      keyboardType: TextInputType.emailAddress,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(30)
                      ],
                      style: TextStyle(
                          fontFamily: "PoppinsLight",
                          fontSize: 13.0,
                          color: kPrimaryColorBlue),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 13.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                        ),
                        focusedBorder: new OutlineInputBorder(
                          borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                        ),
                        prefixIcon: Icon(
                          FontAwesomeIcons.envelope,
                          color: kPrimaryColorBlue,
                          size: 20.0,
                        ),
                        labelText: "Email *",
                        labelStyle: TextStyle(
                            fontFamily: "PoppinsLight",
                            fontSize: 13.0,
                            color: kPrimaryColorBlue),
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * 0.9,
                    child: TextField(
                      focusNode: new AlwaysDisabledFocusNode(),
                      controller: signupStateController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                          fontFamily: "PoppinsLight",
                          fontSize: 13.0,
                          color: kPrimaryColorBlue),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 13.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                        ),
                        focusedBorder: new OutlineInputBorder(
                          borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                        ),
                        prefixIcon: Icon(
                          FontAwesomeIcons.map,
                          color: kPrimaryColorBlue,
                          size: 20.0,
                        ),
                        labelText: "State*",
                        labelStyle: TextStyle(
                            fontFamily: "PoppinsLight",
                            fontSize: 13.0,
                            color: kPrimaryColorBlue),
                      ),
                      onTap: () {
                        stateDialog(context);
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: size.width * 0.9,
                    child: TextField(
                      focusNode: new AlwaysDisabledFocusNode(),
                      controller: signupCityController,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                          fontFamily: "PoppinsLight",
                          fontSize: 13.0,
                          color: kPrimaryColorBlue),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 13.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                        ),
                        focusedBorder: new OutlineInputBorder(
                          borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                        ),
                        prefixIcon: Icon(
                          FontAwesomeIcons.city,
                          color: kPrimaryColorBlue,
                          size: 20.0,
                        ),
                        labelText: "City*",
                        labelStyle: TextStyle(
                            fontFamily: "PoppinsLight",
                            fontSize: 13.0,
                            color: kPrimaryColorBlue),
                      ),
                      onTap: () {
                        cityDialog(context);
                      },
                    ),
                  ),
                  Container(
                    width: size.width * 0.9,
                    padding: EdgeInsets.only(
                        top: 10.0, bottom: 10.0, left: 0.0, right: 0.0),
                    child: TextField(
                      controller: signupDistrictController,
                      keyboardType: TextInputType.text,
                      inputFormatters: [LengthLimitingTextInputFormatter(30)],
                      style: TextStyle(
                          fontFamily: "PoppinsLight",
                          fontSize: 13.0,
                          color: kPrimaryColorBlue),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 13.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                        ),
                        focusedBorder: new OutlineInputBorder(
                          borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                        ),
                        prefixIcon: Icon(
                          FontAwesomeIcons.mapPin,
                          color: kPrimaryColorBlue,
                          size: 20.0,
                        ),
                        labelText: "Area*",
                        labelStyle: TextStyle(
                            fontFamily: "PoppinsLight",
                            fontSize: 13.0,
                            color: kPrimaryColorBlue),
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * 0.9,
                    child: TextField(
                      controller: signupPinController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      onChanged: (value) {
                        // if (value.length >= 6)
                        // getUserData(signupPinController.text);
                      },
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      style: TextStyle(
                          fontFamily: "PoppinsLight",
                          fontSize: 13.0,
                          color: kPrimaryColorBlue),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        counterStyle: TextStyle(
                          height: double.minPositive,
                        ),
                        counterText: "",
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 13.0),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                        ),
                        focusedBorder: new OutlineInputBorder(
                          borderSide:
                          BorderSide(color: kPrimaryColorBlue, width: 0.5),
                          borderRadius:
                          const BorderRadius.all(Radius.circular(35.0)),
                        ),
                        prefixIcon: Icon(
                          FontAwesomeIcons.searchLocation,
                          color: kPrimaryColorBlue,
                          size: 20.0,
                        ),
                        labelText: "Pin Code*",
                        labelStyle: TextStyle(
                            fontFamily: "PoppinsLight",
                            fontSize: 13.0,
                            color: kPrimaryColorBlue),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 20.0),
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
                      gradient: new LinearGradient(
                          colors: [
                            kPrimaryColorBlue,
                            kPrimaryColorBlue,
                          ],
                          begin: const FractionalOffset(0.2, 0.2),
                          end: const FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
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
                                fontSize: 22.0,
                                fontFamily: "PoppinsBold"),
                          ),
                        ),
                        onPressed: () {
                          validates();
                        }),
                  ),
                  SizedBox(
                    height: 13.0,
                  ),
                ],
              )),
        ));
  }

  stateDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Select State',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w800,
                  fontSize: 15.0,
                  fontFamily: "PoppinsMedium"),
            ),
            content: stateDialoagContainer(),
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

  Widget stateDialoagContainer() {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: FutureBuilder<List<Datumii>>(
        future: statesSelect(),
        builder: (BuildContext context, AsyncSnapshot<List<Datumii>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        kPrimaryColorBlue),
                  )),
            );
          else if (snapshot.hasError) {
            return Center(
              child: Text("No State Found"),
            );
          } else {
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
                          title: Text(
                            snapshot.data[index].state,
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                          leading: CircleAvatar(
                            foregroundColor: Colors.white,
                            backgroundColor: kPrimaryColorBlue,
                            child: Text(
                              snapshot.data[index].state
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // trailing: Wrap(
                          //   spacing: 12, // space between two icons
                          //   children: <Widget>[
                          //     Icon(FontAwesomeIcons.rupeeSign, size: 16.0, color: Colors.black,),
                          //     Text('${snapshot.data.data[index].productCost} /Lit', style: TextStyle(fontWeight: FontWeight.bold)),
                          //     // Icon(Icons.message),
                          //   ],
                          // ),
                          onTap: () async {
                            signupStateController.text =
                                snapshot.data[index].state;
                            setState(() {
                              state = snapshot.data[index].state;
                              signupCityController.clear();
                            });
                            Navigator.of(context).pop();
                          },
                        );
                      }));
            } else {
              return Center(
                child: Text("No state Found"),
              );
            }
          }
        },
      ),
    );
  }

  cityDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Select City',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w800,
                  fontSize: 15.0,
                  fontFamily: "PoppinsMedium"),
            ),
            content: cityDialoagContainer(),
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

  Widget cityDialoagContainer() {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: FutureBuilder<List<Datumoo>>(
        future: citiesSelect(),
        builder: (BuildContext context, AsyncSnapshot<List<Datumoo>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        kPrimaryColorBlue),
                  )),
            );
          else if (snapshot.hasError) {
            return Center(
              child: Text("No City Found"),
            );
          } else {
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
                          title: Text(
                            snapshot.data[index].city,
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          ),
                          leading: CircleAvatar(
                            foregroundColor: Colors.white,
                            backgroundColor: kPrimaryColorBlue,
                            child: Text(
                              snapshot.data[index].city
                                  .substring(0, 1)
                                  .toUpperCase(),
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // trailing: Wrap(
                          //   spacing: 12, // space between two icons
                          //   children: <Widget>[
                          //     Icon(FontAwesomeIcons.rupeeSign, size: 16.0, color: Colors.black,),
                          //     Text('${snapshot.data.data[index].productCost} /Lit', style: TextStyle(fontWeight: FontWeight.bold)),
                          //     // Icon(Icons.message),
                          //   ],
                          // ),
                          onTap: () async {
                            signupCityController.text =
                                snapshot.data[index].city;
                            setState(() {
                              city = snapshot.data[index].city;
                            });
                            Navigator.of(context).pop();
                          },
                        );
                      }));
            } else {
              return Center(
                child: Text("No City Found"),
              );
            }
          }
        },
      ),
    );
  }

  Future<List<Datumii>> statesSelect() async {
    final param = {
      "state": "",
    };

    final res = await http.post(
      Uri.parse("http://157.230.228.250/get-user-cities-by-states-api/"),
      body: param,
    );

    print(res.body);
    if (200 == res.statusCode) {
      print(statesFromJson(res.body).stateee.length);
      return statesFromJson(res.body).stateee;
    } else {
      throw Exception('Failed to load Stores List');
    }
  }

  Future<List<Datumoo>> citiesSelect() async {
    final param = {
      "state": state,
    };

    final res = await http.post(
      Uri.parse("http://157.230.228.250/get-user-cities-by-states-api/"),
      body: param,
    );

    print(res.body);
    if (200 == res.statusCode) {
      print(statesFromJson(res.body).cityyy.length);
      return statesFromJson(res.body).cityyy;
    } else {
      throw Exception('Failed to load Stores List');
    }
  }

  void showInSnackBar(String value, int sec) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white, fontSize: 16.0, fontFamily: "PoppinsMedium"),
      ),
      backgroundColor: kPrimaryColorBlue,
      duration: Duration(seconds: sec),
    ));
  }

  bool validateEmail(String value) {
    String pattern =
        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  Future<void> validates() async {
    if (signupFirstController.text.isEmpty) {
      showInSnackBar("Please enter First Name", 2);
      return null;
    }
    if (signupLastController.text.isEmpty) {
      showInSnackBar("Please enter Last Name", 2);
      return null;
    }
    if (signupMobileController.text.isEmpty) {
      showInSnackBar("Please enter Number", 2);
      return null;
    }
    if (signupMobileController.text.length < 10) {
      showInSnackBar("Please enter Valid Number", 2);
      return null;
    }
    if (signupEmailController.text.isEmpty) {
      showInSnackBar("Please enter the Email ID", 2);
      return null;
    }
    if (signupEmailController.text.isNotEmpty) {
      if (signupEmailController.text.contains('com') ||
          signupEmailController.text.contains('net') ||
          signupEmailController.text.contains('edu') ||
          signupEmailController.text.contains('org') ||
          signupEmailController.text.contains('mil') ||
          signupEmailController.text.contains('gov')) {
        if (validateEmail(signupEmailController.text) == false) {
          showInSnackBar('Invalid Email', 2);
          return null;
        }
      } else {
        showInSnackBar("Invalid Email", 2);
        return null;
      }
    }

    if (signupPinController.text.isNotEmpty) {
      if (signupPinController.text.length < 6) {
        showInSnackBar("Please enter valid Pin Code", 2);
        return null;
      }
    }
    if (signupPinController.text.isEmpty) {
      showInSnackBar("Please enter Pin Code", 2);
      return null;
    }
    if (signupPinController.text.length < 6) {
      showInSnackBar("Please enter valid Pin Code", 2);
      return null;
    }
    if (signupStateController.text.isEmpty) {
      showInSnackBar("Please select State", 2);
      return null;
    }
    if (signupCityController.text.isEmpty) {
      showInSnackBar("Please select City", 2);
      return null;
    }
    if (signupDistrictController.text.isEmpty) {
      showInSnackBar("Please enter District", 2);
      return null;
    }

    final param = {
      "cust_mobile_num": signupMobileController.text ,
      "user_id": userID,
      "cust_email": signupEmailController.text,
      "customer_state": signupStateController.text,
      "customer_city":signupCityController.text,
      "customer_area": signupDistrictController.text,
      "customer_pin_code": signupPinController.text,
      "cust_first_name": signupFirstController.text,
      "cust_last_lname": signupLastController.text,

    };
    print(param);

    final response = await http.post(
      "http://157.230.228.250/cust_info_api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );
    print(response.statusCode);

    var responseJson = json.decode(response.body);
    print(response.body);

    print(responseJson);

    print(response.statusCode);

    var responseJs = json.decode(response.body);
    print(response.body);

    if (response.statusCode == 200) {

        showInSnackBar(responseJs['status'], 2);
        setState(() {
          signupFirstController.clear();
          signupLastController.clear();
          signupMobileController.clear();
          signupEmailController.clear();
          signupStateController.clear();
          signupCityController.clear();
          signupDistrictController.clear();
          signupPinController.clear();
        });
        Future.delayed(const Duration(milliseconds: 2000),() {
          Navigator.pop(context);
        });
    } else {
      print("Error");

    }

  }
}
