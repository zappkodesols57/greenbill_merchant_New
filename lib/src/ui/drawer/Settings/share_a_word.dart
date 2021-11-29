import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShareAWord extends StatefulWidget {
  @override
  _ShareAWordState createState() => _ShareAWordState();
}

class _ShareAWordState extends State<ShareAWord> {
  final GlobalKey<ScaffoldState> _scaffoldKe = new GlobalKey<ScaffoldState>();

  String profile, mobile, token, name = "";
  String text = "Hey,\n\nI have found this amazing App where you can send Bills, Cash memo, Receipts digitally and also track your business analytics at lower cost.  Also you can  engage with your customers and earn money with GreenBill.\n\n\nDownload GreenBill Merchant App now :\n\nPlay store : https://play.google.com/store/apps/details?id=com.tej.greenbill_merchant\n\nIos : https://apps.apple.com/in/app/green-bill-for-business/id1592288786\n\nWebsite :https://www.greenbill.in";

  TextEditingController wordController = new TextEditingController();
  String showDate = DateFormat('EEEE, d MMM, yyyy h:mm a').format(DateTime.now()); // prints Tuesday, 10 Dec, 2019


  @override
  void initState() {
    getCredentials();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    wordController.dispose();
  }

  getCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("fName");
      profile = prefs.getString("profile");
      mobile = prefs.getString("mobile");
      token = prefs.getString("token");
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color(0xFFF7F7F7),
      key: _scaffoldKe,
      appBar: AppBar(
        title: Text('Share A Word'),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Padding(
            //   padding: const EdgeInsets.only(top: 10.0, left: 10.0),
            //   child: Text("Preview",
            //     style: TextStyle(
            //       color: Colors.black,
            //       fontSize: 15.0,
            //       fontWeight: FontWeight.bold,
            //       fontFamily: "PoppinsMedium",
            //     ),
            //   ),
            // ),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                padding: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0, bottom: 10.0),
                height: size.height * 0.70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        (profile == null)
                            ? Container(
                                width: 45.0,
                                height: 45.0,
                                decoration: new BoxDecoration(
                                  borderRadius:
                                  new BorderRadius.circular(
                                      25.0),
                                ),
                                alignment: Alignment.center,
                                child: Icon(FontAwesomeIcons.userCircle, size: 45.0, color: kPrimaryColorBlue,),
                              )

                            : CircleAvatar(
                          backgroundImage: NetworkImage(profile),
                          radius: 20.0,
                          backgroundColor: kPrimaryColorBlue,
                        ),
                        SizedBox(width: 10.0,),
                        Text(name,
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "PoppinsBold",
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        width: size.width,
                        padding: EdgeInsets.all(10.0),
                        child: Text(text,
                        style: TextStyle(
                            fontSize: 15.0, color: Colors.black),
                      ),
                        // TextField(
                        //   controller: wordController,
                        //   autofocus: false,
                        //   maxLines: 10,
                        //   style: TextStyle(
                        //       fontSize: 15.0, color: Colors.black),
                        //   decoration: InputDecoration(
                        //     hintText: "Enter your message here...",
                        //     border: InputBorder.none,
                        //     counterText: "",
                        //     contentPadding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 5),
                        //   ),
                        // ),
                      ),
                    ),
                    Container(
                      width: size.width * 0.95,
                      child: Text(showDate,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: size.width * 0.035,
                          fontWeight: FontWeight.bold,
                          fontFamily: "PoppinsMedium",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 00.0, left: 10.0),
            //   child: Text("Most Requested",
            //     style: TextStyle(
            //       color: Colors.black,
            //       fontSize: 15.0,
            //       fontWeight: FontWeight.bold,
            //       fontFamily: "PoppinsMedium",
            //     ),
            //   ),
            // ),

            Padding(
              padding: const EdgeInsets.only(top: 30.0, left: 10.0,right: 10,bottom: 10),
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
                          vertical: 00.0, horizontal: 42.0),
                      child: Text(
                        "Share",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            fontFamily: "PoppinsMedium"),
                      ),
                    ),
                    onPressed: () {
                      share();
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKe.currentState?.removeCurrentSnackBar();
    _scaffoldKe.currentState.showSnackBar(new SnackBar(
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

  share() async {
    // if (wordController.text.isEmpty) {
    //   showInSnackBar("Please enter Message");
    //   return null;
    // }
    Share.share(text);

  }
}
