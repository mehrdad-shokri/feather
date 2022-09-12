import 'dart:math';

import 'package:client/components/atoms/bottom_sheet_scroll_indicator.dart';
import 'package:client/components/atoms/forecast_detail_weekday.dart';
import 'package:client/components/atoms/weather_measure.dart';
import 'package:client/components/molecules/forecast_chart.dart';
import 'package:client/models/location.dart';
import 'package:client/models/weather_forecast.dart';
import 'package:client/types/weather_units.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/date.dart';
import 'package:client/utils/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ForecastDetailDialog extends StatefulWidget {
  final AppLocalizations t;
  final Stream<List<WeatherForecast>> dailyForecast;
  final Stream<List<WeatherForecast>> hourlyForecast;
  final Stream<WeatherForecast> currentForecast;
  final DateTime initialDate;
  final Location location;
  final Stream<WeatherUnits> unit;

  const ForecastDetailDialog(
      {Key? key,
      required this.t,
      required this.initialDate,
      required this.dailyForecast,
      required this.hourlyForecast,
      required this.location,
      required this.unit,
      required this.currentForecast})
      : super(key: key);

  @override
  State<ForecastDetailDialog> createState() => _ForecastDetailDialogState();
}

class _ForecastDetailDialogState extends State<ForecastDetailDialog> {
  final List<String> measures = ['temp', 'wind', 'humidity'];
  DateTime selectedDateTime = DateTime.now();
  int activeMeasureIndex = 0;
  static const int WEEK_DAYS_PAGER_PER_PAGER = 4;

  @override
  void initState() {
    super.initState();
    selectedDateTime = widget.initialDate;
  }

  @override
  void dispose() {
    super.dispose();
  }

  String translateMeasure(String measure) {
    switch (measure) {
      case 'temp':
        return widget.t.temperature;
      case 'wind':
        return widget.t.wind;
      case 'humidity':
        return widget.t.humidity;
      default:
        return '';
    }
  }

  String dataPointUnit(WeatherUnits unit) {
    switch (measures[activeMeasureIndex]) {
      case 'wind':
        return windSpeedUnit(unit);
      case 'temp':
        return temperatureUnit(unit);
      case 'humidity':
        return ' %';
    }
    return '';
  }

  List<FlSpot> dataPointToSpots(List<WeatherForecast> forecasts) {
    // return const [
    //   FlSpot(0, 1),
    //   FlSpot(2, 5),
    //   FlSpot(4, 3),
    //   FlSpot(6, 5),
    // ];
    List<WeatherForecast> filteredForecast = forecasts
        .where((element) => isSameDay(element.date, selectedDateTime))
        .toList();
    filteredForecast.sort((e1, e2) => e1.date.compareTo(e2.date));
    switch (measures[activeMeasureIndex]) {
      case 'temp':
        return filteredForecast
            .map((e) => FlSpot(
                diffInMinutes(e.date, filteredForecast.first.date).toDouble() /
                    240,
                e.tempFeelsLike?.toDouble() ?? 0.0))
            .toList();
      case 'wind':
        return filteredForecast
            .map((e) => FlSpot(
                diffInMinutes(e.date, filteredForecast.first.date).toDouble() /
                    240,
                e.windSpeed.toDouble() ?? 0.0))
            .toList();
      case 'humidity':
        return filteredForecast
            .map((e) => FlSpot(
                diffInMinutes(e.date, filteredForecast.first.date).toDouble() /
                    240,
                e.humidityPercent.toDouble() ?? 0.0))
            .toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: ModalScrollController.of(context),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 32, left: 16, right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatDateRelatively(selectedDateTime, widget.t,
                      format: 'MMM d'),
                  style: TextStyle(
                      color: secondaryTextColor(context),
                      fontSize: Constants.H6_FONT_SIZE,
                      fontWeight: Constants.REGULAR_FONT_WEIGHT),
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  widget.location.cityName,
                  style: TextStyle(
                      color: textColor(context),
                      fontSize: Constants.H5_FONT_SIZE,
                      fontWeight: Constants.MEDIUM_FONT_WEIGHT),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            width: double.maxFinite,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: isDark(context) ? Colors.grey.shade900 : Colors.grey,
                    offset: const Offset(0.0, 1.0),
                    spreadRadius: 4,
                    blurRadius: 6.0,
                  ),
                ],
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32)),
                color: Constants.PRIMARY_COLOR_DARK),
            padding: const EdgeInsets.only(top: 16),
            child: Column(
              children: [
                const BottomSheetScrollIndicator(),
                Container(
                  width: double.maxFinite,
                  alignment: Alignment.center,
                  height: 56,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: measures.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => WeatherMeasure(
                          key: Key(measures[index]),
                          onPress: () {
                            setState(() {
                              activeMeasureIndex = index;
                            });
                          },
                          isActive: index == activeMeasureIndex,
                          measure: translateMeasure(measures[index]))),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 240,
                  child: StreamBuilder(
                    stream: widget.unit,
                    builder: (context, snapshot) {
                      WeatherUnits? unit = snapshot.data as WeatherUnits?;
                      if (unit == null) return Container();
                      return StreamBuilder(
                        stream: widget.hourlyForecast,
                        builder: (context, snapshot) {
                          List<WeatherForecast>? forecasts =
                              snapshot.data as List<WeatherForecast>?;
                          if (forecasts == null) {
                            return PlatformCircularProgressIndicator();
                          }
                          return ForecastChart(
                            spots: dataPointToSpots(forecasts),
                            yAxisUnit: dataPointUnit(unit),
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  height: 40,
                  padding: Constants.PAGE_PADDING,
                  child: StreamBuilder(
                    stream: widget.hourlyForecast,
                    builder: (context, snapshot) {
                      List<WeatherForecast>? forecasts =
                          snapshot.data as List<WeatherForecast>?;
                      if (forecasts == null) return Container();
                      List<DateTime> dates = [];
                      for (var i = 0; i < forecasts.length; i++) {
                        if (i == 0) {
                          dates.add(forecasts.elementAt(i).date);
                        } else if (!isSameDay(forecasts.elementAt(i).date,
                            forecasts.elementAt(i - 1).date)) {
                          dates.add(forecasts.elementAt(i).date);
                        }
                      }
                      dates.sort((date1, date2) => date1.compareTo(date2));
                      return PageView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          for (var i = 0;
                              i <
                                  (dates.length / WEEK_DAYS_PAGER_PER_PAGER)
                                      .ceil();
                              i++)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                for (var j = 0;
                                    j <
                                        min(
                                            dates.length -
                                                i * WEEK_DAYS_PAGER_PER_PAGER,
                                            WEEK_DAYS_PAGER_PER_PAGER);
                                    j++)
                                  ForecastDetailWeekday(
                                      key: Key(
                                          '${dates[i * WEEK_DAYS_PAGER_PER_PAGER + j].microsecondsSinceEpoch}'),
                                      isActive: isSameDay(
                                          dates[i * WEEK_DAYS_PAGER_PER_PAGER +
                                              j],
                                          selectedDateTime),
                                      onPress: () {
                                        print(
                                            'on press ${dates[i * WEEK_DAYS_PAGER_PER_PAGER + j]}');
                                        setState(() {
                                          selectedDateTime = dates[
                                              i * WEEK_DAYS_PAGER_PER_PAGER +
                                                  j];
                                        });
                                      },
                                      weekday: formatDate(
                                          dates[i * WEEK_DAYS_PAGER_PER_PAGER +
                                              j],
                                          format: 'E'))
                              ],
                            )
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
