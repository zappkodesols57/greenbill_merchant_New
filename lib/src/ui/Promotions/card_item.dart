import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/models/model_couponsList.dart';
import 'package:greenbill_merchant/src/ui/HomeScreen/widgets/data_viz/circle/neuomorphic_circle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';
import "dart:math" show pi;

class CardItem extends StatefulWidget {
  final Size size;
  final Datum data;
  final VoidCallback action;
  CardItem(this.size, this.data, this.action);

  CardItemState createState() => CardItemState();
}

class CardItemState extends State<CardItem> {

  String storeName;

  @override
  void initState() {
    super.initState();
    getCredentials();
  }

  getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      storeName = prefs.getString("businessName");
    });
  }

  @override
  Widget build(BuildContext context) {
    double cardDimenWidth = widget.size.width * 0.43;
    double cardDimenHeight = widget.size.width * 0.43;
    double cardTitle = cardDimenWidth * 0.115;
    double cardSubTitle = cardDimenWidth * 0.075;
    double iconDimen = cardDimenWidth * 0.25;
    double iconSize = iconDimen * 0.6;
    return InkWell(
      onTap: widget.action,
      child: Container(
        height: cardDimenHeight,
        width: cardDimenWidth,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: softHighlightColor,
                  offset: Offset(-5, -5),
                  spreadRadius: 0,
                  blurRadius: 5),
              BoxShadow(
                  color: softShadowColor,
                  offset: Offset(2, 2),
                  spreadRadius: 0,
                  blurRadius: 5)
            ]
        ),
        child: Stack(
          children: <Widget>[
            new Opacity(
              opacity: 0.2,
              child: new Align(
                alignment: Alignment.centerRight,
                child: new Transform.rotate(
                  angle: -pi / 9.0,
                  alignment: Alignment.centerRight,
                  child: new ClipPath(
                    clipper: new _BackgroundImageClipper(),
                    child: new Container(
                      padding: const EdgeInsets.only(
                          bottom: 20.0, right: 10.0, left: 60.0),
                      child: new Image(
                        width: 100.0,
                        height: 100.0,
                        image: AssetImage("assets/images/prize.png"),
                      ),
                    ),
                  ),
                ),
              ),
            ), // END BACKGROUND IMAGE
            new Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 5.0, left: 10.0, right: 0.0),
                      child: (widget.data.amountIn == "percentage") ?
                      Text(
                        "${widget.data.couponValue} off\non $storeName",
                        style: TextStyle(
                          fontSize: cardTitle,
                          fontFamily: "PoppinsMedium",
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ) :
                      Text(
                        "₹${widget.data.couponValue} off\non $storeName",
                        style: TextStyle(
                          fontSize: cardTitle,
                          fontFamily: "PoppinsMedium",
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(child: Container()),
                    Container(
                      height: iconDimen,
                      width: iconDimen,
                      child: NeuomorphicCircle(
                        innerShadow: false,
                        outerShadow: true,
                        backgroundColor: Colors.white,
                        shadowColor: softShadowColor,
                        highlightColor: highlightColor,
                        child: Image.network("http://157.230.228.250${widget.data.couponLogo}", height: iconSize, width: iconSize,),
                      ),
                    ),
                  ],
                )
            ),
          ],
        )
      ),
    );
  }
}

class _BackgroundImageClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = new Path();
    path.moveTo(0.0, 50.0);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;

}