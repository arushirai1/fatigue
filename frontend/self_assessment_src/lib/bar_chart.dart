import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PricePoint {
  double x;
  double y;

  PricePoint(this.x, this.y);
}

// import 'package:flutter_chart_demo/data/price_point.dart';
class BarChartWidget extends StatefulWidget {
  const BarChartWidget({Key? key, required this.points}) : super(key: key);

  final List<PricePoint> points;

  @override
  State<BarChartWidget> createState() =>
      _BarChartWidgetState(points: this.points);
}

class _BarChartWidgetState extends State<BarChartWidget> {
  final List<PricePoint> points;

  _BarChartWidgetState({required this.points});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(20.0), // Applies padding uniformly on all sides
        child: AspectRatio(
          aspectRatio: 1,
          child: BarChart(
            BarChartData(
              barGroups: _chartGroups(),
              borderData: FlBorderData(
                  border:
                      const Border(bottom: BorderSide(), left: BorderSide())),
              gridData: FlGridData(show: true),
              titlesData: FlTitlesData(
                bottomTitles: AxisTitles(sideTitles: _bottomTitles),
                leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
            ),
          ),
        ));
  }

  List<BarChartGroupData> _chartGroups() {
    return points
        .map((point) => BarChartGroupData(
            x: point.x.toInt(),
            barRods: [BarChartRodData(toY: point.y, width: 50)]))
        .toList();
  }

  SideTitles get _bottomTitles => SideTitles(
      showTitles: true,
      getTitlesWidget: (value, meta) {
        print(value);
        String text = '';
        switch (value.toInt()) {
          case 0.0:
            text = 'Morning';
            break;
          case 1.0:
            text = 'Afternoon';
            break;
          case 2.0:
            text = 'Evening';
            break;
        }

        return Text(text);
      },
      reservedSize: 30);
}
