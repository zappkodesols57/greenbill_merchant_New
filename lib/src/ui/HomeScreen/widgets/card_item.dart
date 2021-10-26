import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/models/model_parkingDashboard.dart';
import 'package:greenbill_merchant/src/models/model_petrolDashboard.dart';
import '../../../constants.dart';
import '../constants.dart';
import 'data_viz/circle/neuomorphic_circle.dart';

class CardItem extends StatelessWidget {
  final String title;
  final String category;
  final String categoryTwo;
  final String categoryThree;
  final IconData iconData;
  final Size size;
  final PetrolDashboardData data;
  final ParkingDashboardData parkingData;
  final String catID;

  const CardItem(this.size,
      {Key key, @required this.title, this.category, this.categoryTwo, this.categoryThree, @required this.iconData, this.data, this.parkingData, this.catID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double cardDimenWidth = size.width * 0.45;
    double cardDimenHeight = cardDimenWidth * 0.75;
    double cardTitle = cardDimenWidth * 0.09;
    double cardSubTitle = cardDimenWidth * 0.075;
    double iconDimen = cardDimenWidth * 0.2;
    double iconSize = iconDimen * 0.6;
    return Container(
      height: cardDimenHeight,
      width: cardDimenWidth,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              colors: [
                Colors.white,
                Colors.white,
                Colors.white.withOpacity(0.8)
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
                    outerShadow: false,
                    backgroundColor: Colors.white,
                    shadowColor: Constants.softShadowColor,
                    highlightColor: Constants.highlightColor,
                    child:  Icon(
                      iconData,
                      size: iconSize,
                      color: Colors.deepOrange.withOpacity(0.8),
                    ),
                  ),
                ),
                SizedBox(width: size.width * 0.03,),
                Text(
                  title,
                  style: TextStyle(
                      color: kPrimaryColorBlue,
                      fontSize: cardTitle,
                      fontFamily: "PoppinsBold",
                      ),
                ),
              ],
            ),
            SizedBox(height: size.width * 0.03,),
            (catID == "11") ? Expanded(
              child: (title != "Sales" && title != "Rate") ?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  (category == null) ? SizedBox.shrink() :
                  Text(category,
                      style: TextStyle(
                        color: kPrimaryColorBlue,
                        fontSize: cardSubTitle,
                          fontFamily: "PoppinsBold",
                          )
                  ),
                  (categoryTwo == null) ? SizedBox.shrink() :
                  Text(categoryTwo,
                      style: TextStyle(
                          color: kPrimaryColorBlue,
                        fontSize: cardSubTitle,
                        fontFamily: "PoppinsBold",
                      )
                  ),
                  (categoryThree == null) ? SizedBox.shrink() :
                  Text(categoryThree,
                      style: TextStyle(
                        color: kPrimaryColorBlue,
                        fontSize: cardSubTitle,
                        fontFamily: "PoppinsBold",
                      )
                  ),
                ],
              ) :
              ((title == "Sales") ?
              ListView.builder(
                  itemCount: data.todaysSales.length,
                  shrinkWrap: true,
                  reverse: false,
                  itemBuilder: (BuildContext context, int index) {
                    return new Text("${data.todaysSales[index].productName} - ₹ ${data.todaysSales[index].totalAmountColleted}",
                        style: TextStyle(
                          color: kPrimaryColorBlue,
                          fontSize: cardSubTitle,
                          fontFamily: "PoppinsBold",
                        )
                    );
                  }
              ) :
              ListView.builder(
                  itemCount: data.todaysRate.length,
                  shrinkWrap: true,
                  reverse: false,
                  itemBuilder: (BuildContext context, int index) {
                    return new Text("${data.todaysRate[index].productName} - ₹ ${data.todaysRate[index].productCost}",
                        style: TextStyle(
                          color: kPrimaryColorBlue,
                          fontSize: cardSubTitle,
                          fontFamily: "PoppinsBold",
                        )
                    );
                  }
              )),
            ) : Expanded(
              child: (title != "Space" && title != "Not Exited") ?
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  (category == null) ? SizedBox.shrink() :
                  Text(category,
                      style: TextStyle(
                        color: kPrimaryColorBlue,
                        fontSize: cardSubTitle,
                        fontFamily: "PoppinsBold",
                      )
                  ),
                  (categoryTwo == null) ? SizedBox.shrink() :
                  Text(categoryTwo,
                      style: TextStyle(
                        color: kPrimaryColorBlue,
                        fontSize: cardSubTitle,
                        fontFamily: "PoppinsBold",
                      )
                  ),
                  (categoryThree == null) ? SizedBox.shrink() :
                  Text(categoryThree,
                      style: TextStyle(
                        color: kPrimaryColorBlue,
                        fontSize: cardSubTitle,
                        fontFamily: "PoppinsBold",
                      )
                  ),
                ],
              ) :
              ((title == "Space") ?
              ListView.builder(
                  itemCount: parkingData.spaceAvailable.length,
                  shrinkWrap: true,
                  reverse: false,
                  itemBuilder: (BuildContext context, int index) {
                    return new Text("${parkingData.spaceAvailable[index].vehicleType} - ${parkingData.spaceAvailable[index].availableParkingSpace}/${parkingData.spaceAvailable[index].totalSpace}",
                        style: TextStyle(
                          color: kPrimaryColorBlue,
                          fontSize: cardSubTitle,
                          fontFamily: "PoppinsBold",
                        )
                    );
                  }
              ) :
              ListView.builder(
                  itemCount: parkingData.notExited.length,
                  shrinkWrap: true,
                  reverse: false,
                  itemBuilder: (BuildContext context, int index) {
                    return new Text("${parkingData.notExited[index].vehicleType} - ${parkingData.notExited[index].spaceUsed}",
                        style: TextStyle(
                          color: kPrimaryColorBlue,
                          fontSize: cardSubTitle,
                          fontFamily: "PoppinsBold",
                        )
                    );
                  }
              )),
            ),
          ],
        ),
      ),
    );
  }
}