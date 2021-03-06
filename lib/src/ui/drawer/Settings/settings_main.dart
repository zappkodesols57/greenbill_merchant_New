import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/ui/MySubcription/newSubFile.dart';
import 'package:greenbill_merchant/src/ui/Profile/generalSetting.dart';
import 'package:greenbill_merchant/src/ui/drawer/Settings/feedback.dart';
import 'package:greenbill_merchant/src/ui/drawer/Settings/suggestBrand.dart';
import 'package:greenbill_merchant/src/ui/drawer/Settings/updatePass.dart';
import 'package:greenbill_merchant/src/ui/login/login_Page_Merchant.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Help&Support/helpAndSupport.dart';

class Settings extends StatefulWidget {
  @override
  SettingsState createState() => SettingsState();
}

class SettingsState extends State<Settings> {
  String version = '';
  String aboutUS = 'http://www.greenbill.in/';
  String  TC = 'http://www.greenbill.in/terms-conditions/';

  @override
  void initState() {
    super.initState();
    getVersion();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> getVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      version = packageInfo.version;
    });
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget continueButton = FlatButton(
      child: Text(
        "Yes, Logout!",
        style: TextStyle(color: kPrimaryColorBlue),
      ),
      onPressed: () async {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.getKeys();
        for (String key in preferences.getKeys()) {
          if (key != "mob" && key != "password" && key != "intro") {
            preferences.remove(key);
          }
        }
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Login_Merchant()),
              (Route<dynamic> route) => false,
        );
      },
    );
    Widget cancelButton = FlatButton(
      child: Text(
        "Cancel",
        style: TextStyle(color: kPrimaryColorBlue),
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm Log out"),
      content: Text(
          "By clicking continue you have to login again to use Green Bill services."),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> aboutBoxChildren = <Widget>[
      SizedBox(
        height: 20,
      ),
      Text('App information'),
      Text('App Privacy Policy'),
      Text('App Terms of Service'),
      RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(
                style: TextStyle(color: kPrimaryColorBlue), text: 'Site URL'),
          ],
        ),
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: new ListView(
        padding: const EdgeInsets.only(left: 5.0),
        children: <Widget>[
          SizedBox(
            height: 15.0,
          ),
          _buildListItem("Business Settings", CupertinoIcons.settings, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GeneralSetting()));
          }),
          Divider(
            thickness: 1.0,
          ),
          // _buildListItem("Payment Settings", FontAwesomeIcons.rupeeSign, () {
          //   Navigator.push(context,
          //       MaterialPageRoute(builder: (context) => PaymentSetting()));
          // }),
          // Divider(
          //   thickness: 1.0,
          // ),
          _buildListItem("My Subscription", CupertinoIcons.purchased, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => subUpdated()));
          }),
          Divider(
            thickness: 1.0,
          ),
          _buildListItem("About Us", CupertinoIcons.info, () {
              launch(aboutUS);
            // Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewScreen("About Us", "http://www.greenbill.in/about-us/")));
          }),
          Divider(
            thickness: 1.0,
          ),
          _buildListItem("Terms & Conditions", CupertinoIcons.question, () {
            launch(TC);
            // Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewScreen("T&C", "http://www.greenbill.in/terms-conditions/")));
          }),
          Divider(
            thickness: 1.0,
          ),
          _buildListItem("Change Password", CupertinoIcons.lock, () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => UpdatePass()));
          }),
          Divider(
            thickness: 1.0,
          ),
          _buildListItem("Suggest a brand", CupertinoIcons.shopping_cart, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SuggestABrand()));
          }),

          Divider(
            thickness: 1.0,
          ),
          _buildListItem("Feedback", CupertinoIcons.text_bubble, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Feedback1()));
          }),
          Divider(
            thickness: 1.0,
          ),
          _buildListItem('Help & Support', CupertinoIcons.wrench, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => HelpAndSupport()));
          }),
          Divider(
            thickness: 1.0,
          ),
          _buildListItem("Log out", CupertinoIcons.arrow_right_square, () {
            showAlertDialog(context);
          }),
          Divider(
            thickness: 1.0,
          ),
          Image.asset(
            'assets/logo.jpeg',
            height: 40.0,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            "V $version",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(String title, IconData iconData, VoidCallback action) {
    final textStyle = new TextStyle(
        color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w600);

    return new InkWell(
      onTap: action,
      child: new Padding(
          padding: const EdgeInsets.only(
              left: 10.0, right: 10.0, bottom: 0.0, top: 0.0),
          child: new Column(
            children: [
              new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    width: 35.0,
                    height: 35.0,
                    margin: const EdgeInsets.only(right: 10.0),
                    decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.circular(25.0),
                    ),
                    alignment: Alignment.center,
                    child: new Icon(iconData, color: kPrimaryColorBlue, size: 20.0),
                  ),
                  new Text(title, style: textStyle),
                  new Expanded(child: new Container()),
                  new IconButton(
                      icon:
                          new Icon(Icons.chevron_right, color: Colors.black26),
                      onPressed: action)
                ],
              ),
            ],
          )),
    );
  }
}
