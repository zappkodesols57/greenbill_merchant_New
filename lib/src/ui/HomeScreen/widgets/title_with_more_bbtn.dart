import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../constants.dart';

class TitleWithMoreBtn extends StatelessWidget {
  const TitleWithMoreBtn({
    Key key,
    this.title,
    this.press,
    this.size,
  }) : super(key: key);
  final String title;
  final Function press;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Row(
        children: <Widget>[
          TitleWithCustomUnderline(text: title, size: size),
          Spacer(),
          FlatButton(
            height: size.width * 0.09,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: kPrimaryColorBlue,
            onPressed: press,
            child: Icon(FontAwesomeIcons.syncAlt, color: Colors.white, size: size.width * 0.05,)
          ),
        ],
      ),
    );
  }
}

class TitleWithCustomUnderline extends StatelessWidget {
  const TitleWithCustomUnderline({
    Key key,
    this.text,
    this.size
  }) : super(key: key);

  final String text;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: kDefaultPadding / 4),
            child: Text(
              text,
              style: TextStyle(fontSize: size.width * 0.052, fontFamily: "PoppinsBold", fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            bottom: 3,
            left: 0,
            right: 0,
            child: Container(
              margin: EdgeInsets.only(right: size.width / 100),
              height: 7,

              color: Colors.transparent,
            ),
          )
        ],
      ),
    );
  }
}
