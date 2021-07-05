import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/models/model_offersList.dart';
import 'package:greenbill_merchant/src/ui/HomeScreen/widgets/data_viz/circle/neuomorphic_circle.dart';
import 'package:intl/intl.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../../constants.dart';

class OffersDetails extends StatefulWidget {
  final Datum data;
  const OffersDetails(this.data, {Key key}) : super(key: key);

  @override
  _OffersDetailsState createState() => _OffersDetailsState();
}

class _OffersDetailsState extends State<OffersDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // final double _initFabHeight = 230.0;
  // double _fabHeight = 0;
  double _panelHeightOpen;
  double _panelHeightClosed;
  bool value = false;

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
  
  Color shades;

  @override
  void initState() {
    shades = palette[Random().nextInt(palette.length)];
    super.initState();
    // _fabHeight = _initFabHeight;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    _panelHeightClosed = size.height * 0.45;
    _panelHeightOpen = size.height * 0.7;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black87,
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          SlidingUpPanel(
            maxHeight: _panelHeightOpen,
            minHeight: _panelHeightClosed,
            parallaxEnabled: false,
            parallaxOffset: .5,
            color: Colors.white,
            body: _body(size),
            panelBuilder: (sc) => _panel(sc, size),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
            // onPanelSlide: (double pos) => setState((){
            //   _fabHeight = (1.0 - pos) * (_panelHeightOpen - _panelHeightClosed) + _initFabHeight - 130;
            // }),
          ),
          Positioned(
            bottom: 5.0,
            left: 25.0,
            right: 25.0,
            child: Container(
              height: 35.0,
              width: size.width,
              child: ElevatedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(CupertinoIcons.fullscreen_exit, color: Colors.white,),
                    SizedBox(width: 5.0,),
                    Center(
                      child: Text(
                        "CLose",
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.white,
                          fontFamily: "PoppinsMedium",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(5.0),
                    primary: Colors.blueAccent,
                    elevation: 0.0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(90)))
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              decoration: BoxDecoration(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(24.0),
                boxShadow: [
                  BoxShadow(
                      color: Colors.white, blurRadius: 50.0, spreadRadius: 20.0)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _panel(ScrollController sc, Size size){
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          children: [
            SizedBox(height: 12.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.all(Radius.circular(12.0))
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                controller: sc,
                children: <Widget>[
                  Row(
                    children: [
                      Container(
                        height: size.width * 0.1,
                        width: size.height * 0.1,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.black
                        ),
                        child: NeuomorphicCircle(
                          innerShadow: false,
                          outerShadow: false,
                          backgroundColor: Colors.white,
                          shadowColor: softShadowColor,
                          highlightColor: highlightColor,
                          child: Image.network(widget.data.mBusinessLogo, height: size.width * 0.07, width: size.width * 0.07,),
                        ),
                      ),
                      Text(
                        widget.data.mBusinessName.toUpperCase(),
                        style: TextStyle(
                          fontSize: 16.0,
                          fontFamily: "PoppinsMedium",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 5.0, left: 25.0, right: 25.0),
                      child: Text(
                        widget.data.offerName,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontFamily: "PoppinsMedium",
                        ),
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 0.0, bottom: 5.0, left: 25.0, right: 25.0),
                      child: Text(
                        widget.data.offerCaption,
                        style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: "PoppinsMedium",
                        ),
                      )
                  ),
                  Divider(thickness: 1.0, indent: 20.0, endIndent: 20.0,),
                  Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 5.0, left: 25.0, right: 25.0),
                      child: Text(
                        "⏳   Expires ${getDate(widget.data.validThrough)}",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: "PoppinsMedium",
                          fontWeight: FontWeight.bold
                        ),
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 5.0, left: 25.0, right: 25.0),
                      child: Text(
                        "Details",
                        style: TextStyle(
                          fontSize: 13.0,
                          fontFamily: "PoppinsMedium",
                            fontWeight: FontWeight.bold
                        ),
                      )
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 0.0, bottom: 5.0, left: 25.0, right: 25.0),
                      child: Text(
                        "Type: ${widget.data.offerType}",
                        style: TextStyle(
                          fontSize: 15.0,
                          fontFamily: "PoppinsMedium",
                        ),
                      )
                  ),
                  SizedBox(height: 70.0,)
                ],
              ),
            ),
          ],
        )
    );
  }

  Widget _body(Size size){
    double cardDimenWidth = size.width * 0.55;
    double cardDimenHeight = size.width * 0.55;
    double iconDimen = cardDimenWidth * 0.06;
    double iconSize = iconDimen * 0.6;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 45.0, left: 20.0, right: 20.0),
          child: Row(
            children: [
              IconButton(
                  icon: Icon(CupertinoIcons.clear, color: Colors.white,),
                  onPressed: (){
                    Navigator.pop(context, value);
                  }
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 20.0),
          child: Container(
            padding: EdgeInsets.only(bottom: 10.0),
            height: cardDimenHeight,
            width: cardDimenWidth,
            decoration: BoxDecoration(
              color: Colors.primaries[Random().nextInt(Colors.primaries.length)].withOpacity(0.4),
              borderRadius: BorderRadius.all(Radius.circular(10)),
              border: Border.all(color: Colors.white12, width: 0.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Container()),
                Container(
                  height: size.width * 0.1,
                  width: size.height * 0.1,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black
                  ),
                  child: NeuomorphicCircle(
                    innerShadow: false,
                    outerShadow: false,
                    backgroundColor: Colors.white,
                    shadowColor: softShadowColor,
                    highlightColor: highlightColor,
                    child: Image.network(widget.data.mBusinessLogo, height: size.width * 0.06, width: size.width * 0.06,),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  String getDate(String validThrough) {
    var exp = validThrough.split("-");
    final date = DateTime(int.parse(exp[2]), int.parse(exp[1]), int.parse(exp[0]));
    return DateFormat('d MMM yyyy ( EEEE )').format(date);
  }
  
}
