import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/ui/drawer/Settings/Help&Support/reviews.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../constants.dart';

class BarChartCategory extends StatefulWidget {
  List<BarData> dataSourse;
  BarChartCategory(this.dataSourse);
  @override
  _BarChartCategoryState createState() => _BarChartCategoryState();
}

class _BarChartCategoryState extends State<BarChartCategory> {
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      isTransposed: true,
      borderWidth: 0,
      plotAreaBorderWidth: 0,
      backgroundColor: Colors.transparent,
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: CategoryAxis(
        // edgeLabelPlacement: EdgeLabelPlacement.shift,
        // labelRotation: 45,
        axisLine: AxisLine(width: 0),
        maximumLabels: 5,
        labelPlacement: LabelPlacement.betweenTicks,
        tickPosition: TickPosition.inside,
        majorTickLines: MajorTickLines(width:0),
        majorGridLines: MajorGridLines(width:0),
        labelStyle: TextStyle(
          fontSize: 12.0,
        ),
      ),
      primaryYAxis: NumericAxis(
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(width: 0),
        isVisible: false,
      ),
      series: <CartesianSeries>[
        ColumnSeries<BarData, String>(
          dataSource: widget.dataSourse,
          xValueMapper: (BarData data, _) => data.x+"  ",
          yValueMapper: (BarData data, _) => double.parse(data.percentage),
          // Map color for each data points from the data source
          pointColorMapper: (BarData data, _) => kPrimaryColorRed,
          enableTooltip: true,
          width: 0.5,
          isTrackVisible: true,
          borderWidth: 0,
          borderColor: Colors.white,
          trackColor: Colors.grey.shade300,
        ),
      ],
    );
  }
}
