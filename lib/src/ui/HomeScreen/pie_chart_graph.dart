import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/constants.dart';
import 'package:greenbill_merchant/src/models/model_pieChart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'constants.dart';

class PieChartCategory extends StatefulWidget {
  List<PiechartData> pieData;
  final Size size;
  final String title;
  PieChartCategory(this.pieData, this.size, this.title);
  @override
  _PieChartCategoryState createState() => _PieChartCategoryState();
}

class _PieChartCategoryState extends State<PieChartCategory> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.size.width * 0.47,
        height: widget.size.height * 0.35,
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
        child: SfCircularChart(
            title: ChartTitle(
                text: widget.title,
                textStyle: TextStyle(
                  color: kPrimaryColorBlue,
                  fontSize: widget.size.width * 0.04,
                  fontFamily: "PoppinsBold",
                )
            ),
            legend: Legend(
                isVisible: true,
                // Border color and border width of legend
                borderColor: Colors.transparent,
                overflowMode: LegendItemOverflowMode.wrap,
                position: LegendPosition.bottom,
                borderWidth: 0.5
            ),
            //tooltipBehavior: TooltipBehavior(enable: true),
            series: <CircularSeries>[
              // Render pie chart
              PieSeries<PiechartData, String>(
                radius: "${widget.size.width * 0.2}",
                enableSmartLabels: true,
                enableTooltip: true,
                dataSource: widget.pieData,
                pointColorMapper: (PiechartData data, _) =>
                    Color(Random().nextInt(0xffffffff)).withOpacity(1),
                xValueMapper: (PiechartData data, _) => data.x,
                yValueMapper: (PiechartData data, _) => data.y,
                dataLabelSettings:
                DataLabelSettings(isVisible: true, useSeriesColor: true),
              ),
            ])
    );
  }
}
