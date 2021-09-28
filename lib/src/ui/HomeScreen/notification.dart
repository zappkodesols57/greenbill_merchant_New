import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String token,id;
  final ScrollController _controller = ScrollController();
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
    query.dispose();
  }

  getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString("token");
      id = prefs.getInt("userID").toString();

    });
    print("$token");
    print('USERID------------------------$id');
  }

  Future<List<Bell>> getNotification() async {
    final param = {
      "user_id": id.toString(),

    };

    final res = await http.post(
      Uri.parse("http://157.230.228.250/get-merchant-notice-board-list-api/"),
      body: param,
      headers: {HttpHeaders.authorizationHeader: "Token $token"},
    );
    print("$param");
    print(res.body);
    print(res.statusCode);
    if (200 == res.statusCode) {
      print(notificationFromJson(res.body).data.length);
      return notificationFromJson(res.body).data.where((element) =>
          element.createdAt.toString().toLowerCase().contains(query.text) ||
          element.name.toString().toLowerCase().contains(query.text)
      )
          .toList();
    } else {
      throw Exception('Failed to load Bills');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      backgroundColor: Colors.white,
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Notifications'),
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            Container(
              width: size.width * 0.95,
              padding: EdgeInsets.only(
                  top: 10.0, bottom: 10.0, left: 0.0, right: 0.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
              ),
              child: TextField(
                controller: query,
                onChanged: (value) {
                 // getBills();
                  getNotification();
                  setState(() {});
                },
                style: TextStyle(
                    fontFamily: "PoppinsMedium",
                    fontSize: 15.0,
                    color: kPrimaryColorBlue),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  counterStyle: TextStyle(
                    height: double.minPositive,
                  ),
                  counterText: "",
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 13.0, horizontal: 20.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: kPrimaryColorBlue, width: 1.0),
                    borderRadius:
                    const BorderRadius.all(Radius.circular(35.0)),
                  ),
                  focusedBorder: new OutlineInputBorder(
                    borderSide:
                    BorderSide(color: kPrimaryColorBlue, width: 1.0),
                    borderRadius:
                    const BorderRadius.all(Radius.circular(35.0)),
                  ),
                  suffixIcon: GestureDetector(
                    onTap: () {},
                    child: Icon(
                      CupertinoIcons.search,
                      color: kPrimaryColorBlue,
                      size: 25.0,
                    ),
                  ),
                  hintText: "Search",
                  hintStyle: TextStyle(
                      fontFamily: "PoppinsMedium",
                      fontSize: 15.0,
                      color: kPrimaryColorBlue),
                ),
              ),
            ),

            Flexible(
              child: FutureBuilder<List<Bell>>(
                future: getNotification(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: Center(
                          child: CircularProgressIndicator(
                            valueColor:
                            AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),
                          )
                      ),
                    );
                  else {
                    if (snapshot.data != null) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (_controller.hasClients) {
                          _controller.animateTo(
                              _controller.position.minScrollExtent,
                              duration: Duration(milliseconds: 1),
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
                          shrinkWrap: true,
                          reverse: false,
                          controller: _controller,
                          itemBuilder: (bui, index) {
                            return new Card(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    dense: false,
                                    title: Text('${snapshot.data[index].noticeTitle}',
                                        style: TextStyle(fontSize: 15.0,fontFamily: "PoppinsBold",color: kPrimaryColorBlue)),
                                    isThreeLine: false,
                                    subtitle: Text('Sent By : ${snapshot.data[index].name.toString()}\nMessage : ${snapshot.data[index].message.toString()}',
                                        style: TextStyle(fontSize: 11.0,fontFamily: "PoppinsLight",color: kPrimaryColorBlue)),
                                    trailing: Wrap(
                                      spacing: 5, // space between two icons
                                      crossAxisAlignment: WrapCrossAlignment.end,
                                      children: <Widget>[
                                          Text(
                                              '${snapshot
                                                  .data[index].createdAt.toString()}',
                                              style: TextStyle(
                                                color: kPrimaryColorBlue,
                                                  fontFamily: "PoppinsBold",
                                                  fontSize: 15.0)
                                          ),

                                      ],
                                    ),
                                    onTap: () {

                                    },
                                  ),
                                ),
                            );
                          },
                          itemCount: snapshot.data.length,
                        ),
                      );
                    } else {
                      return Container(
                        child: Center(
                          child: Text("No Notifications Found!"),
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ));
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
          fontFamily: "PoppinsMedium",
          fontWeight: FontWeight.bold,
          fontSize: 12.0,
        ),
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      duration: Duration(seconds: 2),
    ));
  }


}
