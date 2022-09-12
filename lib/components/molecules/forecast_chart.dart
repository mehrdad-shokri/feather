import 'package:client/utils/colors.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/hex_color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ForecastChart extends StatelessWidget {
  final List<FlSpot> spots;
  final List<int> indicatorIndexes = [];
  final String yAxisUnit;
  late double minSpotX, maxSpotX;
  late double minSpotY, maxSpotY;
  late double averageY;

  ForecastChart({Key? key, required this.spots, required this.yAxisUnit})
      : super(key: key) {
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

    int maxYIndex =
        spots.indexOf(spots.firstWhere((element) => element.y == maxSpotY));
    int minYIndex =
        spots.indexOf(spots.firstWhere((element) => element.y == minSpotY));
    indicatorIndexes.add(normalizeIndex(spots, maxYIndex));
    indicatorIndexes.add(normalizeIndex(spots, minYIndex));
  }

  int normalizeIndex(List spots, int index) {
    if (index == 0) {
      return 1;
    } else if (index == spots.length - 1) {
      return index - 1;
    }
    return index;
  }

  @override
  Widget build(BuildContext context) {
    var lineBarsData = [
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
          showingIndicators: indicatorIndexes),
    ];
    return LineChart(
      LineChartData(
        clipData: FlClipData.all(),
        baselineY: minSpotY,
        baselineX: minSpotX,
        borderData: FlBorderData(show: false),
        lineBarsData: lineBarsData,
        lineTouchData: LineTouchData(
          enabled: false,
          getTouchedSpotIndicator:
              (LineChartBarData barData, List<int> spotIndexes) {
            return spotIndexes.map((index) {
              return TouchedSpotIndicatorData(
                FlLine(color: Colors.transparent, strokeWidth: 0),
                FlDotData(
                  show: true,
                  getDotPainter: (spot, percent, barData, index) =>
                      FlDotCirclePainter(
                    radius: 3,
                    color: Colors.white,
                    strokeWidth: 5,
                    strokeColor: const Color.fromRGBO(255, 255, 255, .5),
                  ),
                ),
              );
            }).toList();
          },
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: Constants.PRIMARY_COLOR.withOpacity(.7),
            tooltipRoundedRadius: 16,
            tooltipPadding:
                const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            getTooltipItems: (List<LineBarSpot> lineBarsSpot) {
              return lineBarsSpot.map((lineBarSpot) {
                return LineTooltipItem(
                  '${lineBarSpot.y.round().toString()}$yAxisUnit',
                  const TextStyle(
                      color: Colors.white,
                      fontSize: Constants.S2_FONT_SIZE,
                      fontWeight: Constants.BOLD_FONT_WEIGHT),
                );
              }).toList();
            },
          ),
        ),
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
        showingTooltipIndicators: indicatorIndexes
            .map((index) => ShowingTooltipIndicators([
                  LineBarSpot(
                      lineBarsData.first, 0, lineBarsData.first.spots[index])
                ]))
            .toList(),
      ),
      swapAnimationDuration: const Duration(milliseconds: 400),
      swapAnimationCurve: Curves.easeIn,
    );
  }
}
