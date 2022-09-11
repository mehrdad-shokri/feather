import 'package:client/components/bottom_sheet_scroll_indicator.dart';
import 'package:client/components/weather_measure.dart';
import 'package:client/models/weather_forecast.dart';
import 'package:client/rx/blocs/review_bloc.dart';
import 'package:client/rx/blocs/url_launcher_bloc.dart';
import 'package:client/rx/services/service_provider.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/feather_icons.dart';
import 'package:client/utils/hex_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ForecastDetailDialog extends StatefulWidget {
  final AppLocalizations t;
  final Stream<List<WeatherForecast>> dailyForecast;
  final Stream<List<WeatherForecast>> hourlyForecast;
  final Stream<WeatherForecast> currentForecast;
  final DateTime date;

  const ForecastDetailDialog(
      {Key? key,
      required this.t,
      required this.date,
      required this.dailyForecast,
      required this.hourlyForecast,
      required this.currentForecast})
      : super(key: key);

  @override
  State<ForecastDetailDialog> createState() => _ForecastDetailDialogState();
}

class _ForecastDetailDialogState extends State<ForecastDetailDialog> {
  final List<String> measures = ['temp', 'wind', 'humidity'];
  int activeMeasureIndex = 0;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  'Today, Sep 11',
                  style: TextStyle(
                      color: secondaryTextColor(context),
                      fontSize: Constants.H6_FONT_SIZE,
                      fontWeight: Constants.REGULAR_FONT_WEIGHT),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  'Tehran',
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
                const SizedBox(
                  height: 16,
                ),
                Container(
                  width: double.maxFinite,
                  alignment: Alignment.centerLeft,
                  padding: Constants.PAGE_PADDING,
                  height: 80,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: measures.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => WeatherMeasure(
                          onPress: () {
                            setState(() {
                              activeMeasureIndex = index;
                            });
                          },
                          isActive: index == activeMeasureIndex,
                          measure: translateMeasure(measures[index]))),
                ),
                const SizedBox(
                  height: 240,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
