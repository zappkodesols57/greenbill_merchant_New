import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:greenbill_merchant/src/models/model_payLink.dart';
import 'package:greenbill_merchant/src/ui/HomeScreen/widgets/data_viz/circle/neuomorphic_circle.dart';
import '../../constants.dart';

class PayLinksCard extends StatefulWidget {
  final Size size;
  final Datum data;
  double cardDimenHeight;
  final VoidCallback action, actionTwo;
  PayLinksCard(this.size, this.data, this.action, this.actionTwo);

  @override
  PayLinksCardState createState() => PayLinksCardState();
}

class PayLinksCardState extends State<PayLinksCard> {
  double cardDimenHeight;
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
    getCredentials();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

  }

  getCredentials() async {

    if((widget.data.paymentDone)){
      setState(() {
        cardDimenHeight=widget.size.width * 0.38;
      });
    }else{
       cardDimenHeight = widget.size.width * 0.45;
    }
  }

  @override
  Widget build(BuildContext context) {
    double cardDimenWidth = widget.size.width * 0.9;
   // double cardDimenHeight = widget.size.width * 0.45;
    double cardTitle = cardDimenWidth * 0.115;
    double cardSubTitle = cardDimenWidth * 0.075;
    double iconDimen = cardDimenWidth * 0.06;
    double iconSize = iconDimen * 0.6;
    return Container(
      height: 200.0,
      width: cardDimenWidth,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        border: Border.all(color: Colors.grey[400], width: 0.5),
      ),
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: (cardDimenWidth * 0.11) + 15,
                    width: (cardDimenWidth * 0.11) + 15,
                    child: Stack(
                      children: <Widget>[
                        Container(
                            height: cardDimenWidth * 0.11,
                            width: cardDimenWidth * 0.11,
                            decoration: BoxDecoration(
                              color: palette[Random().nextInt(palette.length)]
                                  .withOpacity(0.9),
                              borderRadius: BorderRadius.all(Radius.circular(
                                  5)),
                            ),
                            child: Center(child: Icon(
                              FontAwesomeIcons.rupeeSign, color: Colors
                                .white,),)
                        ),
                        Positioned(
                          left: 25.0,
                          top: 26.0,
                          child: Container(
                            height: iconDimen,
                            width: iconDimen,
                            child: NeuomorphicCircle(
                                innerShadow: false,
                                outerShadow: false,
                                backgroundColor: Colors.white,
                                shadowColor: softShadowColor,
                                highlightColor: highlightColor,
                                child: (widget.data.paymentDone) ?
                                Icon(CupertinoIcons.smallcircle_circle_fill,
                                  color: kPrimaryColorGreen,) :
                                Icon(CupertinoIcons.smallcircle_circle,
                                  color: kPrimaryColorRed,)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          "${widget.data.name}\n${widget.data.mobileNo}",
                          style: TextStyle(
                            fontSize: cardDimenWidth * 0.05,
                            fontFamily: "PoppinsMedium",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          widget.data.email == null ? "" :widget.data.email,
                          style: TextStyle(
                            fontSize: cardDimenWidth * 0.04,
                            fontFamily: "PoppinsMedium",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: (cardDimenWidth * 0.11) + 25,),
                child: Text(
                  "Amount : ${"₹ "+widget.data.amount+".00"}\nDate : ${widget.data.createdAt.day}-${widget.data
                      .createdAt.month}-${widget.data.createdAt.year}",
                  style: TextStyle(
                    fontSize: cardDimenWidth * 0.04,
                    fontFamily: "PoppinsMedium",
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: (cardDimenWidth * 0.11) + 25,),
                child: Text(
                  "Description: ${(widget.data.description.length > 18) ? widget.data
                      .description.substring(0, 18) + '...' : widget.data
                      .description}",
                  style: TextStyle(
                    fontSize: cardDimenWidth * 0.04,
                    fontFamily: "PoppinsMedium",
                  ),
                ),
              ),
              (widget.data.paymentDone) ?
              Container(
                padding: EdgeInsets.only(left: (cardDimenWidth * 0.11) + 25,),
                child: Text(
                  "Status : Payment Successful",
                  style: TextStyle(
                    fontSize: cardDimenWidth * 0.04,
                    fontFamily: "PoppinsMedium",
                  ),
                ),
              ) : Expanded(
                child: Container(
                  alignment: Alignment.center,
                  width: widget.size.width * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Center(
                                  child: Container(
                                    height: 35.0,
                                    width:  widget.size.width * 0.3,
                                    child: ElevatedButton(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            CupertinoIcons.bubble_left,
                                            size: widget.size.height / 40,
                                            color: Colors.black87,
                                          ),
                                          SizedBox(
                                            width:  widget.size.width / 40,
                                          ),
                                          Text(
                                            "Send",
                                            style: TextStyle(
                                              color: Colors.black87,
                                              fontSize: widget.size.width * 0.03,
                                            ),
                                          )
                                        ],
                                      ),
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.grey[300],
                                          elevation: 0.0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.all(Radius.circular(90)))),
                                      onPressed: () {
                                        widget.action();
                                      },
                                    ),
                                  ),
                                ),
                              ),

                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Center(
                              child: Container(
                                height: 35.0,
                                width:  widget.size.width * 0.3,
                                child: ElevatedButton(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        CupertinoIcons.delete,
                                        size: widget.size.height / 40,
                                        color: Colors.black87,
                                      ),
                                      SizedBox(
                                        width: widget.size.width / 40,
                                      ),
                                      Text(
                                        "Delete",
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize:  widget.size.width * 0.03,
                                        ),
                                      )
                                    ],
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.grey[300],
                                      elevation: 0.0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.all(Radius.circular(90)))),
                                  onPressed: () {
                                    widget.actionTwo();
                                  },
                                ),
                              ),
                            ),
                          ),
                            ],
                          ),
                ),
                ),

            ],
          )
      ),
    );
  }

}