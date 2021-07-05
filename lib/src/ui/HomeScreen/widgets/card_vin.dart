

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:greenbill_merchant/src/models/model_parkingDashboard.dart';
import 'package:greenbill_merchant/src/models/model_petrolDashboard.dart';
import '../../../constants.dart';
import '../constants.dart';
import 'data_viz/circle/neuomorphic_circle.dart';

class CardVin extends StatelessWidget {
  final String title;
  final String category;
  final String categoryTwo;
  final String categoryThree;
  final IconData iconData;
  final Size size;
  final PetrolDashboardData data;
  final ParkingDashboardData parkingData;
  final String catID;

  const CardVin(this.size,
      {Key key, @required this.title, this.category, this.categoryTwo, this.categoryThree, @required this.iconData, this.data, this.parkingData, this.catID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double cardDimenWidth = size.width * 0.45;
    double cardDimenHeight = cardDimenWidth * 0.65;
    double cardTitle = cardDimenWidth * 0.09;
    double cardSubTitle = cardDimenWidth * 0.075;
    double iconDimen = cardDimenWidth * 0.2;
    double iconSize = iconDimen * 0.6;
    return Container(
      height: cardDimenHeight,
      width: cardDimenWidth,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [
                kPrimaryColorBlue,
                kPrimaryColorBlue,
                Colors.blueAccent.withOpacity(0.8)
              ]),
          boxShadow: [
            BoxShadow(
                color: Constants.softHighlightColor,
                offset: Offset(-10, -10),
                spreadRadius: 0,
                blurRadius: 10),
            BoxShadow(
                color: Constants.softShadowColor,
                offset: Offset(5, 5),
                spreadRadius: 0,
                blurRadius: 10)
          ]
      ),
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  height: iconDimen,
                  width: iconDimen,
                  child: NeuomorphicCircle(
                    innerShadow: false,
                    outerShadow: true,
                    backgroundColor: Colors.white,
                    shadowColor: Constants.softShadowColor,
                    highlightColor: Constants.highlightColor,
                    child:  Icon(
                      iconData,
                      size: iconSize,
                      color: Colors.deepOrange.withOpacity(0.6),
                    ),
                  ),
                ),
                SizedBox(width: size.width * 0.03,),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: cardTitle,
                    fontFamily: "PoppinsBold",
                  ),
                ),
              ],
            ),
            SizedBox(height: size.width * 0.03,),
          Expanded(
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  (category == null) ? SizedBox.shrink() :
                      Container(
                        alignment: Alignment.center,
                        child: Text(
                            category,
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 15,
                              fontFamily: "PoppinsBold",
                            )
                        ),
                      ),

                  (categoryTwo == null) ? SizedBox.shrink() :
                  Text(categoryTwo,
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: cardSubTitle,
                        fontFamily: "PoppinsBold",
                      )
                  ),
                  (categoryThree == null) ? SizedBox.shrink() :
                  Text(categoryThree,
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: cardSubTitle,
                        fontFamily: "PoppinsBold",
                      )
                  ),
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}