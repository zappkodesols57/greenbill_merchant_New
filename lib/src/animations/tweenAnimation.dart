import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:greenbill_merchant/src/ui/login/login_Page_Merchant.dart';
import 'package:greenbill_merchant/src/ui/values/values.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_intro.dart';

class Opacityanimate extends StatefulWidget {
  @override
  _OpacityanimateState createState() => _OpacityanimateState();
}

class _OpacityanimateState extends State<Opacityanimate> {
  Tween<double> tween = Tween(begin: 0.0, end: 1.0);
  @override
  Widget build(BuildContext context) {
    Size size = Get.mediaQuery.size;
    return Center(
      child: TweenAnimationBuilder(
        duration: const Duration(seconds: 2),
        tween: tween,
        builder: (BuildContext context, double opacity, Widget child) {
          return Opacity(
            opacity: opacity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  ImagePath.splashImage,
                  height: size.width * 0.6,
                ),
              ],
            ),
          );
        },
        onEnd: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          bool check = (prefs.getBool("intro") == null) ? false : prefs.getBool("intro");
          if(check){
            Get.off(Login_Merchant());
          } else{
            Get.off(Liquid_Swipes());
          }

        },
      ),
    );
  }
}
