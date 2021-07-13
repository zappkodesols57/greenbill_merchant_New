import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:greenbill_merchant/src/models/model_offersList.dart';
import 'package:greenbill_merchant/src/ui/HomeScreen/widgets/data_viz/circle/neuomorphic_circle.dart';
import 'package:intl/intl.dart';
import '../../constants.dart';

class OffersCard extends StatefulWidget {
  final Size size;
  final Datum data;
  final VoidCallback action;
  OffersCard(this.size, this.data, this.action);

  OffersCardState createState() => OffersCardState();

}

class OffersCardState extends State<OffersCard> {
  bool _isCopied = false;
  List<Color> palette = [
    Color.fromRGBO(75, 135, 185, 1),
    Color.fromRGBO(192, 108, 132, 1),
    Color.fromRGBO(246, 114, 128, 1),
    Color.fromRGBO(248, 177, 149, 1),
    Color.fromRGBO(116, 180, 155, 1),
    Color.fromRGBO(0, 168, 181, 1),
    Color.fromRGBO(73, 76, 162, 1),
    Color.fromRGBO(255, 205, 96, 1),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double cardDimenWidth = widget.size.width * 0.43;
    double cardDimenHeight = widget.size.width * 0.43;
    double cardTitle = cardDimenWidth * 0.105;
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
                        child:  Image.network(widget.data.offerImage, height: 100.0, width: 100.0,),
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
                        child:
                        Text(
                          "${widget.data.offerName}"+" at "+" ${widget.data.mBusinessName} ",
                          style: TextStyle(
                            fontSize: cardTitle,
                            fontFamily: "PoppinsMedium",
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ),
                      Expanded(child: Container()),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: iconDimen,
                            width: iconDimen,
                            child: NeuomorphicCircle(
                              innerShadow: false,
                              outerShadow: true,
                              backgroundColor: Colors.white,
                              shadowColor: softShadowColor,
                              highlightColor: highlightColor,
                              child: Image.network(widget.data.mBusinessLogo, height: iconSize, width: iconSize,),
                            ),
                          ),
                         // if(widget.data.status != null)
                           // Container(
                            //  padding: EdgeInsets.only(left: 10.0),
                           //   height: 40.0,
                            //  width: cardDimenWidth * 0.65,
                            //  decoration: BoxDecoration(
                             //     color: Color(0xFFF7F7F7),
                               //   borderRadius: BorderRadius.all(Radius.circular(25.0))
                              //),
                             // child: Row(
                              //  crossAxisAlignment: CrossAxisAlignment.center,
                             //   children: [
                             //     Text(
                              //      widget.data.status,
                             //       style: TextStyle(
                              //        fontSize: 13.0,
                             //         color: Colors.black54,
                             //         fontWeight: FontWeight.bold,
                               //     ),
                             //     ),
                              //    Expanded(
                               //     child: Container(),
                              //    ),
                               // ],
                             // ),
                            //)
                        ],
                      ),
                    ],
                  )
              ),
            ],
          )
      ),
    );
  }

  String getDate(String validThrough) {
    var exp = validThrough.split("-");
    final date = DateTime(int.parse(exp[2]), int.parse(exp[1]), int.parse(exp[0]));
    return DateFormat('d MMM yyyy ( EEEE )').format(date);
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