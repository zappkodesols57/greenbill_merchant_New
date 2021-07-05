import 'dart:math';
import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/ui/login/login_Page_Merchant.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Liquid_Swipes extends StatefulWidget {
  static final style = TextStyle(
      fontFamily: "Poppins-Bold",
      color: Colors.black,
      fontSize: 30.0,
      letterSpacing: 1.0
  );

  static final style1 = TextStyle(
    fontSize: 15,
    color: Colors.black,
    fontWeight: FontWeight.w600,
  );

  @override
  _Liquid_SwipesState createState() => _Liquid_SwipesState();
}

class _Liquid_SwipesState extends State<Liquid_Swipes> {
  int page = 0;
  LiquidController liquidController;
  UpdateType updateType;

  @override
  void initState() {
    liquidController = LiquidController();
    super.initState();
  }

  final pages = [
    Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                top: 0.0, bottom: 0.0, left: 35.0, right: 35.0),
            child:  Image.asset(
              'assets/onboardingDesigns/bills.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
          ),
          Column(
            children: <Widget>[
              Text(
                "Green & Digital Bills",
                style: Liquid_Swipes.style,
              ),
              SizedBox(height: 5.0,),
              Text(
                "Send Bills & Receipts Digitally to your Customers",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                top: 0.0, bottom: 0.0, left: 35.0, right: 35.0),
            child:  Image.asset(
              'assets/onboardingDesigns/analytics.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
          ),
          Column(
            children: <Widget>[
              Text(
                "Business Analytics",
                style: Liquid_Swipes.style,
              ),
              SizedBox(height: 5.0,),
              Text(
                "Get Business Analytics at your Fingertips",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    Container(
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
              Text(
                "Promote your Business",
                style: Liquid_Swipes.style,
              ),
              SizedBox(height: 5.0,),
              Text(
                "Start Promoting via SMS, emails and Banners",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  ];

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((page ?? 0) - index).abs(),
      ),
    );
    double zoom = 1.0 + (2.0 - 1.0) * selectedness;
    return new Container(
      width: 25.0,
      child: new Center(
        child: new Material(
          color: Colors.black,
          type: MaterialType.circle,
          child: new Container(
            width: 8.0 * zoom,
            height: 8.0 * zoom,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: <Widget>[
            LiquidSwipe(
              pages: pages,
              enableLoop: false,
              onPageChangeCallback: pageChangeCallback,
              waveType: WaveType.liquidReveal,
              liquidController: liquidController,
              ignoreUserGestureWhileAnimating: true,
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  Expanded(child: SizedBox()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List<Widget>.generate(pages.length, _buildDot),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: FlatButton(
                  onPressed: () {
                    if(page == 2){
                      jump();
                    }
                    // liquidController.animateToPage(
                    //     page: pages.length - 1, duration: 500);
                    liquidController.jumpToPage(
                        page: liquidController.currentPage + 1);
                  },
                  child: (page == 2) ? Text("Start", style: Liquid_Swipes.style1,) : Text("Next", style: Liquid_Swipes.style1,),
                  // color: Colors.black.withOpacity(0.01),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: FlatButton(
                  onPressed: () {
                   jump();
                  },
                  child: Text("Skip",
                    style: Liquid_Swipes.style1,
                  ),
                  // color: Colors.black.withOpacity(0.01),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  pageChangeCallback(int lpage) {
    setState(() {
      page = lpage;
    });
  }

  Future<void> jump() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("intro", true);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Login_Merchant();
        },
      ),
    );

  }

}
