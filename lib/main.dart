import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/splashscreen.dart';
import 'package:greenbill_merchant/src/ui/HomeScreen/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  // var status = preferences.getString("isLogin");

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MaterialApp(
      theme: ThemeData(
        canvasColor: Colors.white,
        primaryColor: kPrimaryColorBlue,
      ),
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ));
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GB Business',
      theme: ThemeData(
        canvasColor: Colors.white,
        primaryColor: kPrimaryColorBlue,
      ),
      debugShowCheckedModeBanner: false,
      home: Splashscreen(),
    );
  }
}