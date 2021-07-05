import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../login/login_Page_Merchant.dart';

class Congrats extends StatefulWidget {
  final String msg;
  Congrats(this.msg);
  @override
  CongratsState createState() => CongratsState(msg);
}

class CongratsState extends State<Congrats> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final String msg;
  CongratsState(this.msg);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Center(
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      top: 0.0, bottom: 0.0, left: 25.0, right: 35.0),
                  child:  Image.asset(
                    'assets/onboardingDesigns/promote.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                ),
                Column(
                  children: <Widget>[
                    Text(msg,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "PoppinsMedium",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5.0,),
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
                              Color(0xFFA0D66F),
                              Color(0xFFA0D66F),
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
                              "Login",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22.0,
                                  fontFamily: "PoppinsBold"),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Login_Merchant();
                                },
                              ),
                            );
                          }
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }


}