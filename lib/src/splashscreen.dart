import 'package:flutter/material.dart';
import 'animations/tweenAnimation.dart';

class Splashscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Opacityanimate(),
    );
  }
}