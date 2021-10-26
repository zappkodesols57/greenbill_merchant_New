import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/models/model_myOffers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants.dart';

class CardItemMyOffer extends StatefulWidget {

  final Datum data;
  final VoidCallback action;
  CardItemMyOffer( this.data, this.action);

  CardItemState createState() => CardItemState();
}

class CardItemState extends State<CardItemMyOffer> {

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
    Size size = MediaQuery.of(context).size;
    double cardDimenWidth = size.width * 0.5;
    double cardDimenHeight = size.height * 0.5;
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
        child: Image.network("http://157.230.228.250${widget.data.offerImage}", height: cardDimenHeight, width:cardDimenWidth,),

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