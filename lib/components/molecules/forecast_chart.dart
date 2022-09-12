import 'package:client/utils/colors.dart';
import 'package:client/utils/hex_color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ForecastChart extends StatelessWidget {
  final List<FlSpot> spots;

  late double minSpotX, maxSpotX;
  late double minSpotY, maxSpotY;
  late double averageY;

  ForecastChart({Key? key, required this.spots}) : super(key: key) {
    minSpotX = spots
        .reduce((value, element) => value.x < element.x ? value : element)
        .x;
    maxSpotX = spots
        .reduce((value, element) => value.x > element.x ? value : element)
        .x;
    minSpotY = spots
        .reduce((value, element) => value.y < element.y ? value : element)
        .y;
    maxSpotY = spots
        .reduce((value, element) => value.y > element.y ? value : element)
        .y;
    averageY = (minSpotY + maxSpotY) / 2;
    print(spots);
    print('$minSpotY $maxSpotY $minSpotX $maxSpotX');
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
          clipData: FlClipData.all(),
          baselineY: minSpotY,
          baselineX: minSpotX,
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromRGBO(255, 255, 255, .1),
                    Color.fromRGBO(255, 255, 255, .4),
                    Color.fromRGBO(255, 255, 255, .7),
                    Colors.white,
                    Color.fromRGBO(255, 255, 255, .7),
                    Color.fromRGBO(255, 255, 255, .4),
                    Color.fromRGBO(255, 255, 255, .1)
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                spots: spots,
                isCurved: true,
                isStrokeCapRound: true,
                isStrokeJoinRound: true,
                barWidth: 8,
                dotData: FlDotData(show: false),
                showingIndicators: []),
          ],
          minY: minSpotY - averageY / 16,
          maxY: maxSpotY + averageY / 16,
          maxX: maxSpotX,
          minX: minSpotX,
          titlesData: FlTitlesData(
            show: false,
          ),
          gridData: FlGridData(
              show: true,
              drawVerticalLine: true,
              drawHorizontalLine: false,
              checkToShowVerticalLine: (value) {
                if (value.toInt() == (maxSpotY + minSpotY).toInt()) {
                  return false;
                }
                return true;
              },
              getDrawingVerticalLine: (value) => FlLine(
                  color: const Color.fromRGBO(233, 233, 233, .4),
                  dashArray: [12, 24],
                  strokeWidth: .7)),
          showingTooltipIndicators: [],
          lineTouchData: LineTouchData(
            enabled: true,
            getTouchedSpotIndicator:
                (LineChartBarData barData, List<int> spotIndexes) {
              return spotIndexes.map((index) {
                return TouchedSpotIndicatorData(
                  FlLine(
                    color: Colors.pink,
                  ),
                  FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) =>
                        FlDotCirclePainter(
                      radius: 8,
                      color: backgroundColor(context),
                      strokeWidth: 2,
                      strokeColor: Colors.black,
                    ),
                  ),
                );
              }).toList();
            },
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.pink,
              tooltipRoundedRadius: 8,
              getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
                return lineBarsSpot.map((lineBarSpot) {
                  return LineTooltipItem(
                    lineBarSpot.y.toString(),
                    const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  );
                }).toList();
              },
            ),
          )),
      swapAnimationDuration: const Duration(milliseconds: 400),
      swapAnimationCurve: Curves.easeIn,
    );
  }
}
