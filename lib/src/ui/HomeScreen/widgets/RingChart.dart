import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_pieChart.dart';
import '../constants.dart';
import 'package:pie_chart/pie_chart.dart';
class RingChart extends StatefulWidget {
  Map<String, double> DataMap;
  final Size size;
  RingChart(this.DataMap, this.size);
  @override
  _RingChartCategoryState createState() => _RingChartCategoryState();
}

class _RingChartCategoryState extends State<RingChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.size.width * 0.5,
        width: widget.size.width ,

        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: Colors.white,
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
        child:PieChart(
          dataMap: widget.DataMap,
          animationDuration: Duration(milliseconds: 800),
          chartLegendSpacing: 32,
          chartRadius: MediaQuery.of(context).size.width / 3,
          initialAngleInDegree: 0,
          chartType: ChartType.ring,
          ringStrokeWidth: 32,
          legendOptions: LegendOptions(
            showLegendsInRow: false,
            legendPosition: LegendPosition.right,
            showLegends: true,
            legendTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          chartValuesOptions: ChartValuesOptions(
            showChartValueBackground: true,
            showChartValues: true,
            showChartValuesInPercentage: false,
            showChartValuesOutside: false,
            decimalPlaces: 1,
          ),
        )
    );
  }
}
