import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:greenbill_merchant/src/models/model_doughnutChart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../constants.dart';
import 'constants.dart';

class DoughnutChart extends StatefulWidget {
  List<DoughnutChartData> data;
  final Size size;
  final String title;
  DoughnutChart(this.data, this.size, this.title);
  @override
  _DoughnutChartState createState() => _DoughnutChartState();
}

class _DoughnutChartState extends State<DoughnutChart> {

  int startAngle = 270;
  int endAngle = 90;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.size.width * 0.95,
        height: widget.size.height * 0.3,
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
              position: LegendPosition.bottom,
              overflowMode: LegendItemOverflowMode.wrap,
              height: "${widget.size.width * 0.2}",
              width: "${widget.size.width * 0.9}"
          ),
          centerY: '100%',
          series: <DoughnutSeries<DoughnutChartData, String>>[
            DoughnutSeries<DoughnutChartData, String>(
                dataSource: widget.data,
                innerRadius: '70%',
                radius: '230%',
                startAngle: startAngle,
                endAngle: endAngle,
                xValueMapper: (DoughnutChartData data, _) => data.x,
                yValueMapper: (DoughnutChartData data, _) => double.parse(double.parse(data.y).toStringAsFixed(2)),
                dataLabelMapper: (DoughnutChartData data, _) => data.text,
                dataLabelSettings: DataLabelSettings(
                    isVisible: true, labelPosition: ChartDataLabelPosition.outside))
          ],
          tooltipBehavior: TooltipBehavior(enable: true),
        )
    );
  }
}
