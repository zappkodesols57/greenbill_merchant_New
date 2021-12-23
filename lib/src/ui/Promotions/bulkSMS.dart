import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_BulkSMS.dart';
import 'package:greenbill_merchant/src/models/model_area.dart';
import 'package:greenbill_merchant/src/models/model_city.dart';
import 'package:greenbill_merchant/src/models/model_header.dart';
import 'package:greenbill_merchant/src/models/model_state.dart';
import 'package:greenbill_merchant/src/models/model_template.dart';
import 'package:greenbill_merchant/src/ui/BillInfo/ViewBill.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BulkSMS extends StatefulWidget {
  @override
  BulkSMSState createState() => BulkSMSState();
}

class BulkSMSState extends State<BulkSMS> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, id, storeID;
  String radioItem;
  String message;
  String header,template,state,city,area;
  bool custom=false;
  final ScrollController _controller = ScrollController();
  File media;
  Dio dio = new Dio();
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
    headerController.dispose();
    CampaignController.dispose();
    templateController.dispose();
    messageController.dispose();
    radioController.dispose();
    stateController.dispose();
    cityController.dispose();
    areaController.dispose();
    query.dispose();
  }

  TextEditingController headerController = new TextEditingController();
  TextEditingController CampaignController = new TextEditingController();
  TextEditingController templateController = new TextEditingController();
  TextEditingController messageController = new TextEditingController();
  TextEditingController radioController = new TextEditingController();
  TextEditingController stateController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController areaController = new TextEditingController();

  getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      id = prefs.getInt("userID").toString();
      storeID = prefs.getString("businessID");
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Bulk SMS'),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: (){
              create();
            },
            child: Text("SEND", style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
                Container(
                  width: size.width,
                  padding: EdgeInsets.only(left: 20.0),
                  child: RichText(
                    text: TextSpan(
                        text: 'SMS Type',
                        style: TextStyle(
                          fontFamily: "PoppinsLight",
                          fontSize: 13.0,
                          color: kPrimaryColorBlue,
                          fontWeight: FontWeight.bold,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: '*',
                            style: TextStyle(
                              color: kPrimaryColorBlue,
                              fontStyle: FontStyle.normal,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ]),
                    ),
                ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(
                    top: 0.0, bottom: 10.0, left: 0.0, right: 0.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: size.width * 0.95,
                      alignment: Alignment.centerLeft,
                      child: RadioListTile(
                        dense: true,
                        groupValue: radioItem,
                        title: Text('Transactional',style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0, color: kPrimaryColorBlue),),

                        value: 'transactional',
                        onChanged: (val) {
                          setState(() {
                            radioItem = val;
                            custom=true;
                          });
                        },
                      ),
                    ),

                    Container(
                      width: size.width * 0.95,
                      alignment: Alignment.centerLeft,

                      child:RadioListTile(
                        dense: true,
                        groupValue: radioItem,
                        title: Text('Promotional',style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0, color: kPrimaryColorBlue),),
                        value: 'promotional',
                        onChanged: (val) {
                          setState(() {
                            custom=false;
                            radioItem = val;
                          });
                        },
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(
                    top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: new TextField(
                  onTap: (){},
                  // enableInteractiveSelection: false, // will disable paste operation
                  // focusNode: new AlwaysDisabledFocusNode(),
                  controller: CampaignController,
                  style: TextStyle(
                      fontFamily: "PoppinsBold",
                      fontSize: 17.0,
                      color: kPrimaryColorBlue),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterStyle: TextStyle(height: double.minPositive,),
                    counterText: "",
                    contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      Icons.perm_contact_calendar_outlined,
                      color: kPrimaryColorBlue,
                      size: 20.0,
                    ),
                    labelText: "Campaign Name *",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0,color: kPrimaryColorBlue),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(
                    top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: new TextField(
                  onTap: (){
                    if(radioItem != null) {
                      smsHeaderDialog(context);
                    }else{
                      showInSnackBar("Please Select SMS Type");
                    }
                  },
                  enableInteractiveSelection: false, // will disable paste operation
                  focusNode: new AlwaysDisabledFocusNode(),
                  controller: headerController,
                  style: TextStyle(
                      fontFamily: "PoppinsBold",
                      fontSize: 17.0,
                      color: kPrimaryColorBlue),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterStyle: TextStyle(height: double.minPositive,),
                    counterText: "",
                    contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      FontAwesomeIcons.sms,
                      color: kPrimaryColorBlue,
                      size: 20.0,
                    ),
                    labelText: "SMS Header *",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0,color: kPrimaryColorBlue),
                  ),
                ),
              ),

              SizedBox(
                height: 10,
              ),

              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(
                    top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: new TextField(
                  onTap: (){
                    if(headerController.text.isNotEmpty) {
                      templateDialog(context);
                    }else{
                      showInSnackBar("Please Select SMS Header");
                    }
                  },
                  enableInteractiveSelection: false, // will disable paste operation
                  focusNode: new AlwaysDisabledFocusNode(),
                  controller: templateController,
                  style: TextStyle(
                      fontFamily: "PoppinsBold",
                      fontSize: 17.0,
                      color: kPrimaryColorBlue),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterStyle: TextStyle(height: double.minPositive,),
                    counterText: "",
                    contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      FontAwesomeIcons.list,
                      color: kPrimaryColorBlue,
                      size: 20.0,
                    ),
                    labelText: "Template *",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0,color: kPrimaryColorBlue),
                  ),
                ),
              ),

            SizedBox(height: 10,
              ),
              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(
                    top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: TextField(
                  enableInteractiveSelection: false,
                  focusNode: new AlwaysDisabledFocusNode(),
                  controller: templateController,
                  textInputAction: TextInputAction.newline,
                  inputFormatters: [LengthLimitingTextInputFormatter(140),],
                  maxLines: 4,
                  decoration: InputDecoration(
                    // prefixIcon: Icon(
                    //   Icons.comment,
                    //   color: kPrimaryColorBlue,
                    // ),
                    border: InputBorder.none,
                    labelText: 'Message',
                    labelStyle:
                    TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 14.0,color: kPrimaryColorBlue),
                    alignLabelWithHint: true,
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                    ),
                  ),
                ),
              ),

             SizedBox(
             height: 10,
              ),

              Container(
                width: size.width * 0.95,
                padding: EdgeInsets.only(
                    top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                child: new TextField(
                  onTap: (){
                    stateDialog(context);
                  },
                  enableInteractiveSelection: false, // will disable paste operation
                  focusNode: new AlwaysDisabledFocusNode(),
                  controller: stateController,
                  style: TextStyle(
                      fontFamily: "PoppinsBold",
                      fontSize: 17.0,
                      color: kPrimaryColorBlue),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    counterStyle: TextStyle(height: double.minPositive,),
                    counterText: "",
                    contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    focusedBorder: new OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColorBlue, width: 0.5),
                      borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                    ),
                    prefixIcon: Icon(
                      FontAwesomeIcons.building,
                      color: kPrimaryColorBlue,
                      size: 20.0,
                    ),
                    labelText: "State *",
                    labelStyle: TextStyle(
                        fontFamily: "PoppinsLight", fontSize: 13.0,color: kPrimaryColorBlue),
                  ),
                ),
              ),

                SizedBox(
                  height: 10,
                ),

                Container(
                width: size.width * 0.95,
                 padding: EdgeInsets.only(
                top: 0.0, bottom: 20.0, left: 0.0, right: 0.0),
         child: Row(
                 children: <Widget>[
                   Container(
                     width: size.width * 0.45,
                     padding: EdgeInsets.only(
                         top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(5),
                     ),
                     child: new TextField(
                       onTap: (){
                         cityDialog(context);
                       },
                       enableInteractiveSelection: false, // will disable paste operation
                       focusNode: new AlwaysDisabledFocusNode(),
                       controller: cityController,
                       style: TextStyle(
                           fontFamily: "PoppinsBold",
                           fontSize: 17.0,
                           color: kPrimaryColorBlue),
                       decoration: InputDecoration(
                         border: InputBorder.none,
                         counterStyle: TextStyle(height: double.minPositive,),
                         counterText: "",
                         contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                         enabledBorder: OutlineInputBorder(
                           borderSide: BorderSide(color: kPrimaryColorBlue, width: 0.5),
                           borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                         ),
                         focusedBorder: new OutlineInputBorder(
                           borderSide: BorderSide(color: kPrimaryColorBlue, width: 0.5),
                           borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                         ),
                         prefixIcon: Icon(
                           FontAwesomeIcons.city,
                           color: kPrimaryColorBlue,
                           size: 20.0,
                         ),
                         labelText: "City",
                         labelStyle: TextStyle(
                             fontFamily: "PoppinsLight", fontSize: 13.0,color: kPrimaryColorBlue),
                       ),
                     ),
                   ),

                   SizedBox(
                     width: 15,
                   ),

                   Container(
                     width: size.width * 0.45,
                     padding: EdgeInsets.only(
                         top: 0.0, bottom: 0.0, left: 0.0, right: 0.0),
                     decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(5),
                     ),
                     child: new TextField(
                       onTap: (){
                         areaDialog(context);
                       },
                       enableInteractiveSelection: false, // will disable paste operation
                       focusNode: new AlwaysDisabledFocusNode(),
                       controller: areaController,
                       style: TextStyle(
                           fontFamily: "PoppinsBold",
                           fontSize: 17.0,
                           color: kPrimaryColorBlue),
                       decoration: InputDecoration(
                         border: InputBorder.none,
                         counterStyle: TextStyle(height: double.minPositive,),
                         counterText: "",
                         contentPadding: const EdgeInsets.symmetric(vertical: 0.0),
                         enabledBorder: OutlineInputBorder(
                           borderSide: BorderSide(color: kPrimaryColorBlue, width: 0.5),
                           borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                         ),
                         focusedBorder: new OutlineInputBorder(
                           borderSide: BorderSide(color: kPrimaryColorBlue, width: 0.5),
                           borderRadius: const BorderRadius.all(Radius.circular(35.0)),
                         ),
                         prefixIcon: Icon(
                           FontAwesomeIcons.home,
                           color: kPrimaryColorBlue,
                           size: 20.0,
                         ),
                         labelText: "Area",
                         labelStyle: TextStyle(
                             fontFamily: "PoppinsLight", fontSize: 13.0,color: kPrimaryColorBlue),
                       ),
                     ),
                   ),
                   ],
                   )
                )
            ],
          ),
        ),
      ),
    );
  }

  smsHeaderDialog(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Select Header',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w800,
                  fontSize: 15.0,
                  fontFamily: "PoppinsMedium"
              ),
            ),
            content: headerDialoagContainer(),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel', style: TextStyle(color: kPrimaryColorBlue)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }


  Future<Header> getHeaderLists() async {

    final param = {
      "user_id": id,
      "header_type": radioItem,
    };

    print(">>>>>>>>>$id\n$token");

    final res = await http.post(
      Uri.parse("http://157.230.228.250/merchant-get-SMSHeaderList-api/"),
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(res.body);
    if(200 == res.statusCode){
      print(headerFromJson(res.body).data.length);
      return headerFromJson(res.body);
    } else{
      throw Exception('Failed to load Headers List');
    }
  }

  Widget headerDialoagContainer() {
    return Container(
      height: 230.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: FutureBuilder<Header>(
        future: getHeaderLists(),
        builder: (BuildContext context, AsyncSnapshot<Header> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),
                  )),
            );
          else if (snapshot.hasError) {
            return Center(
              child: Text("No Headers Found"),
            );
          } else{
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Scrollbar(
                  radius: Radius.circular(5.0),
                  isAlwaysShown: true,
                  controller: _controller,
                  thickness: 3.0,
                  child: ListView.builder(
                      controller: _controller,
                      itemCount: snapshot.data.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            snapshot.data.data[index].headerContent,
                            style: TextStyle(fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                           leading: CircleAvatar(
                            foregroundColor: Colors.white,
                            backgroundColor: kPrimaryColorBlue,
                            child: Text(
                              snapshot.data.data[index].headerContent.substring(0,1).toUpperCase(),
                              style: TextStyle(fontSize: 18.0,
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

                            headerController.text = snapshot.data.data[index].headerContent;
                            setState(() {
                              header = snapshot.data.data[index].headerContent.toString();
                            });
                            Navigator.of(context).pop();
                          },
                        );
                      }
                  )
              );
            } else {
              return Center(child: Text("No Headers Found"),);
            }
          }

        },
      ),
    );
  }

  templateDialog(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Select Template',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w800,
                  fontSize: 15.0,
                  fontFamily: "PoppinsMedium"
              ),
            ),
            content: templateDialoagContainer(),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel', style: TextStyle(color: kPrimaryColorBlue)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
  Future<Template> getTemplateLists() async {

    final param = {
      "user_id": id,
      "SMSheader": header,
    };

    print(">>>>>>>>>$id\n$token");

    final res = await http.post(
      Uri.parse("http://157.230.228.250/merchant-get-SMSTemplateList-api/"),
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(res.body);
    if(200 == res.statusCode){
      print(templateFromJson(res.body).data.length);
      return templateFromJson(res.body);
    } else{
      throw Exception('Failed to load Template List');
    }
  }

  Widget templateDialoagContainer() {
    return Container(
      height: 230.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: FutureBuilder<Template>(
        future: getTemplateLists(),
        builder: (BuildContext context, AsyncSnapshot<Template> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),
                  )),
            );
          else if (snapshot.hasError) {
            return Center(
              child: Text("No Template Found"),
            );
          } else{
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Scrollbar(
                  radius: Radius.circular(5.0),
                  isAlwaysShown: true,
                  controller: _controller,
                  thickness: 3.0,
                  child: ListView.builder(
                      controller: _controller,
                      itemCount: snapshot.data.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            snapshot.data.data[index].templateContent,
                            style: TextStyle(fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: CircleAvatar(
                            foregroundColor: Colors.white,
                            backgroundColor: kPrimaryColorBlue,
                            child: Text(
                              snapshot.data.data[index].templateContent.substring(0,1).toUpperCase(),
                              style: TextStyle(fontSize: 18.0,
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
                            templateController.text = snapshot.data.data[index].templateContent;
                            setState(() {
                              template = snapshot.data.data[index].templateID.toString();
                            });
                            Navigator.of(context).pop();
                          },
                        );
                      }
                  )
              );
            } else {
              return Center(child: Text("No Template Found"),);
            }
          }

        },
      ),
    );
  }


  stateDialog(BuildContext context){
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
                  fontFamily: "PoppinsMedium"
              ),
            ),
            content: stateDialoagContainer(),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel', style: TextStyle(color: kPrimaryColorBlue)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<StateM> getStateLists() async {

    final param = {
      "user_id": id,
    };

    print(">>>>>>>>>$id\n$token");

    final res = await http.post(
      Uri.parse("http://157.230.228.250/get-customer-state/"),
      // body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(res.body);
    if(200 == res.statusCode){
      print(stateMFromJson(res.body).data.length);
      return stateMFromJson(res.body);
    } else{
      throw Exception('Failed to load Template List');
    }
  }

  Widget stateDialoagContainer() {
    return Container(
      height: 230.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: FutureBuilder<StateM>(
        future: getStateLists(),
        builder: (BuildContext context, AsyncSnapshot<StateM> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),
                  )),
            );
          else if (snapshot.hasError) {
            return Center(
              child: Text("No State Found"),
            );
          } else{
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Scrollbar(
                  radius: Radius.circular(5.0),
                  isAlwaysShown: true,
                  controller: _controller,
                  thickness: 3.0,
                  child: ListView.builder(
                      controller: _controller,
                      itemCount: snapshot.data.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            snapshot.data.data[index].cState,
                            style: TextStyle(fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: CircleAvatar(
                            foregroundColor: Colors.white,
                            backgroundColor: kPrimaryColorBlue,
                            child: Text(
                              snapshot.data.data[index].cState.substring(0,1).toUpperCase(),
                              style: TextStyle(fontSize: 18.0,
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
                            stateController.text = snapshot.data.data[index].cState;
                            setState(() {
                              state = snapshot.data.data[index].cState;
                            });
                            Navigator.of(context).pop();
                          },
                        );
                      }
                  )
              );
            } else {
              return Center(child: Text("No state Found"),);
            }
          }

        },
      ),
    );
  }

  cityDialog(BuildContext context){
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
                  fontFamily: "PoppinsMedium"
              ),
            ),
            content: cityDialoagContainer(),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel', style: TextStyle(color: kPrimaryColorBlue)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<CityM> getCityLists() async {

    final param = {
      "state_value": state,
    };

    print(">>>>>>>>>$id\n$token");

    final res = await http.post(
      Uri.parse("http://157.230.228.250/get-customer-city-by-state/"),
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(res.body);
    if(200 == res.statusCode){
      print(cityMFromJson(res.body).data.length);
      return cityMFromJson(res.body);
    } else{
      throw Exception('Failed to load Template List');
    }
  }

  Widget cityDialoagContainer() {
    return Container(
      height: 230.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: FutureBuilder<CityM>(
        future: getCityLists(),
        builder: (BuildContext context, AsyncSnapshot<CityM> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),
                  )),
            );
          else if (snapshot.hasError) {
            return Center(
              child: Text("No City Found"),
            );
          } else{
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Scrollbar(
                  radius: Radius.circular(5.0),
                  isAlwaysShown: true,
                  controller: _controller,
                  thickness: 3.0,
                  child: ListView.builder(
                      controller: _controller,
                      itemCount: snapshot.data.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          title: Text(
                            snapshot.data.data[index].cCity,
                            style: TextStyle(fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: CircleAvatar(
                            foregroundColor: Colors.white,
                            backgroundColor: kPrimaryColorBlue,
                            child: Text(
                              snapshot.data.data[index].cCity.substring(0,1).toUpperCase(),
                              style: TextStyle(fontSize: 18.0,
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
                            cityController.text = snapshot.data.data[index].cCity;
                            setState(() {
                              city = snapshot.data.data[index].cCity;
                            });
                            Navigator.of(context).pop();
                          },
                        );
                      }
                  )
              );
            } else {
              return Center(child: Text("No City Found"),);
            }
          }
        },
      ),
    );
  }

  areaDialog(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Select area',
              style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w800,
                  fontSize: 15.0,
                  fontFamily: "PoppinsMedium"
              ),
            ),
            content: areaDialoagContainer(),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel', style: TextStyle(color: kPrimaryColorBlue)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<AreaM> getAreaLists() async {

    final param = {
      "city_value": city,
    };

    print(">>>>>>>>>$id\n$token");

    final res = await http.post(
      Uri.parse("http://157.230.228.250/get-customer-area-by-city/"),
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(res.body);
    if(200 == res.statusCode){
      print(areaMFromJson(res.body).data.length);
      return areaMFromJson(res.body);
    } else{
      throw Exception('Failed to load Template List');
    }
  }

  Widget areaDialoagContainer() {
    return Container(
      height: 230.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: FutureBuilder<AreaM>(
        future: getAreaLists(),
        builder: (BuildContext context, AsyncSnapshot<AreaM> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),
                  )),

            );

          else if (snapshot.hasError) {
            return Center(
              child: Text("No City Found"),
            );
          }
          else{
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return Scrollbar(
                  radius: Radius.circular(5.0),
                  isAlwaysShown: true,
                  controller: _controller,
                  thickness: 3.0,
                  child: ListView.builder(
                      controller: _controller,
                      itemCount: snapshot.data.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        snapshot.data.data[index].cArea.toString();
                        return ListTile(
                          title: Text(
                            snapshot.data.data[index].cArea,
                            style: TextStyle(fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: CircleAvatar(
                            foregroundColor: Colors.white,
                            backgroundColor: kPrimaryColorBlue,
                            child: Text(
                              snapshot.data.data[index].cArea.characters.getRange(0,1).toString().toUpperCase(),
                              style: TextStyle(fontSize: 18.0,
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
                            areaController.text = snapshot.data.data[index].cArea;
                            setState(() {
                              area = snapshot.data.data[index].cArea;
                            });
                            Navigator.of(context).pop();
                          },
                        );
                      }
                  )
              );
            } else {
              return Center(child: Text("No City Found"),);
            }
          }

        },
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
                  )));
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
            color: Colors.white, fontSize: 16.0, fontFamily: "PoppinsMedium"),
      ),
      backgroundColor: kPrimaryColorBlue,
      duration: Duration(seconds: 2),
    ));
  }

  create() async {

    if(radioItem == null){
      showInSnackBar("Please Select SMS Type");
      return null;
    }

    if(CampaignController.text.isEmpty){
      showInSnackBar("Please Enter Campaign Name");
      return null;
    }
    if(headerController.text.isEmpty){
      showInSnackBar("Please Select Header");
      return null;
    }
    if(templateController.text.isEmpty){
      showInSnackBar("Please Select Template");
      return null;
    }

    // if(messageController.text.isEmpty){
    //   showInSnackBar("Please Enter Message");
    //   return null;
    // }
    if(stateController.text.isEmpty){
      showInSnackBar("Please enter State");
      return null;
    }
    // if(cityController.text.isEmpty){
    //   showInSnackBar("Please enter City");
    //   return null;
    // }
    // if(areaController.text.isEmpty){
    //   showInSnackBar("Please enter Area");
    //   return null;
    // }

    _showLoaderDialog(context);

    final params = {
      "user_id":id,
      "transactional":radioItem,
      "customer":"customer",
      "smsheader":header,
      "template_id":template,
      "message":templateController.text,
      "customer_state_value":state,
      "campaign_name":CampaignController.text,
      "customer_city_value":city == null ? "" : city,
      "customer_area_value":area == null ? "" : area,

    };

    print(">>>>$params");


    final response = await http.post("http://157.230.228.250/merchant-send-bulksms-api/",
      body: params, headers: {HttpHeaders.authorizationHeader: "Token $token"});

    print(response.statusCode);
    if(response.statusCode == 500){
      Navigator.of(context, rootNavigator: true).pop();
      showInSnackBar("Error From Server");
    }
    Bulk data;
    var responseJson = json.decode(response.body);
    print(response.body);
    print(responseJson);

    if (response.statusCode == 200) {
      Navigator.of(context, rootNavigator: true).pop();
      data = new Bulk.fromJson(jsonDecode(response.body));
      print(responseJson);
      print(data.status);
        showInSnackBar(data.message);
        setState(() {
          radioItem = null;
          headerController.clear();
          templateController.clear();
          messageController.clear();
          stateController.clear();
          cityController.clear();
          areaController.clear();
        });
    } else {
      data = new Bulk.fromJson(jsonDecode(response.body));
      Navigator.of(context, rootNavigator: true).pop();
      showInSnackBar(data.message);
      }
  }
}