import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_hSupportData.dart';
import 'package:greenbill_merchant/src/models/model_hSupportModules.dart';
import 'package:greenbill_merchant/src/ui/drawer/Settings/Help&Support/faqs.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';


class HelpAndSupport extends StatefulWidget {
  @override
  _HelpAndSupportState createState() => _HelpAndSupportState();
}

class _HelpAndSupportState extends State<HelpAndSupport> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token, uid,busId;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    getCredentials();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      busId = prefs.getString("businessID");
      token = prefs.getString("token");
      uid = prefs.getInt("userID").toString();
    });
    print('$token');
  }

  Future<List<Datum>> getList() async {
    final param = {
      "m_business_id": busId,
    };
    final res = await http.post(
        "http://157.230.228.250/merchant-get-support-and-faqs-modules-api/",
        body: param,
        headers: {HttpHeaders.authorizationHeader: "Token $token"});

    print(res.body);
    print(res.statusCode);
    if (200 == res.statusCode) {
      print(hSupportModulesFromJson(res.body).data.length);
      List<Datum> data = [];
      data.addAll(hSupportModulesFromJson(res.body).data.toList());
      data.add(Datum(id: "0", moduleName: "Still need help?"));
      return data;
    } else {
      throw Exception('Failed to load List');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Help & Support'),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<Datum>>(
        future: getList(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Datum>> snapshot) {
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
              child: Text("No Data Found"),
            );
          } else {
            if (snapshot.hasData && snapshot.data.isNotEmpty) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_controller.hasClients) {
                  _controller.animateTo(_controller.position.minScrollExtent,
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
                    itemCount: snapshot.data.length,
                    shrinkWrap: true,
                    reverse: false,
                    controller: _controller,
                    itemBuilder: (BuildContext context, int index) {
                      return (snapshot.data[index].id == "0") ?
                      Column(
                        children: [
                          new Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              new Container(
                                width: 30.0,
                                child: null,
                              ),
                              new Text(snapshot.data[index].moduleName, style: TextStyle(
                                  color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w600)),
                              new Expanded(child: new Container()),
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: new TextButton(
                                    onPressed: () async {
                                      PackageInfo packageInfo = await PackageInfo.fromPlatform();
                                      final Uri _emailLaunchUri = Uri(
                                          scheme: 'mailto',
                                          path: 'support@greenbill.in',
                                          queryParameters: {
                                            'subject': 'Query',
                                            'body': 'ID\t-\t$uid\nSent\tvia\tGreenBill\tApp\tv${packageInfo.version}'
                                          }
                                      );
                                      launch(_emailLaunchUri.toString());
                                    },
                                    child: Text("get in touch", style: TextStyle(
                                        color: kPrimaryColorBlue, fontSize: 13.0, fontWeight: FontWeight.w700),)
                                ),
                              ),
                            ],
                          ),
                          Divider(thickness: 1.0, indent: 10.0, endIndent: 10.0,),
                        ],
                      ) :
                      _buildListItem(snapshot.data[index].moduleName,
                              () {
                            fetchData(snapshot.data[index].id, snapshot.data[index].moduleName);
                          });
                    }),
              );
            } else //`snapShot.hasData` can be false if the `snapshot.data` is null
              return Center(
                child: Text("No Data Found"),
              );
          }
        },
      ),
    );
  }

  Widget _buildListItem(String title, VoidCallback action) {
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
                    width: 20.0,
                    child: null,
                  ),
                  new Text(title, style: textStyle),
                  new Expanded(child: new Container()),
                  new IconButton(
                      icon:
                      new Icon(Icons.chevron_right, color: Colors.black26),
                      onPressed: action)
                ],
              ),
              Divider(
                thickness: 1.0,
              ),
            ],
          )
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
            color: Colors.white, fontSize: 16.0, fontFamily: "PoppinsMedium"),
      ),
      backgroundColor: kPrimaryColorBlue,
      duration: Duration(seconds: 2),
    ));
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

  fetchData(String id, String moduleName) async {
    _showLoaderDialog(context);
    final param = {
      "module_id": id,
    };

    final response = await http.post(
      "http://157.230.228.250/merchant-get-support-and-faqs-data-api/",
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );

    print(response.statusCode);
    HSupportData data;
    var responseJson = json.decode(response.body);
    print(response.body);
    data = new HSupportData.fromJson(jsonDecode(response.body));
    Navigator.of(context, rootNavigator: true).pop();
    if (response.statusCode == 200) {
      print(responseJson);
      print("Fetch Successful");
      print(data.status);
      if (data.status == "success") {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Faqs(data.faqs)
        ));
      } else
        print(data.status);
    } else {
      print(data.status);
    }
  }

}
