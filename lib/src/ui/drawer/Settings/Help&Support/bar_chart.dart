import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/ui/drawer/Settings/Help&Support/reviews.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
      backgroundColor: Colors.transparent,
      tooltipBehavior: TooltipBehavior(enable: true),
      primaryXAxis: CategoryAxis(
        // edgeLabelPlacement: EdgeLabelPlacement.shift,
        labelRotation: 60,
          maximumLabels: 200,
          labelPlacement: LabelPlacement.betweenTicks,
        tickPosition: TickPosition.outside,

      ),
      series: <CartesianSeries>[
        ColumnSeries<BarData, String>(
          dataSource: widget.dataSourse,
          xValueMapper: (BarData data, _) => data.x,
          yValueMapper: (BarData data, _) => data.y,
          // Map color for each data points from the data source
          pointColorMapper: (BarData data, _) => data.color,
          enableTooltip: true,
        )
      ],
    );
  }
}
