import 'package:client/components/hourly_forecast.dart';
import 'package:client/models/weather_forecast.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class HourlyForecasts extends StatelessWidget {
  final AppLocalizations t;
  final Stream<List<WeatherForecast>> hourlyForecast;
  final Stream<bool> isUpdating;

  const HourlyForecasts(
      {Key? key,
      required this.t,
      required this.hourlyForecast,
      required this.isUpdating})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      color: backgroundColor(context),
      child: Column(
        children: [
          Padding(
            padding: Constants.PAGE_PADDING,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.today,
                  style: TextStyle(
                      color: headingColor(context),
                      fontWeight: Constants.MEDIUM_FONT_WEIGHT,
                      fontSize: Constants.H5_FONT_SIZE),
                ),
                PlatformTextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/7days');
                  },
                  padding: EdgeInsets.zero,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        t.next7Days,
                        style: TextStyle(
                            color: textColor(context),
                            fontWeight: Constants.BOLD_FONT_WEIGHT,
                            fontSize: Constants.S1_FONT_SIZE),
                      ),
                      Icon(
                        isCupertino(context)
                            ? Icons.arrow_forward_ios
                            : Icons.arrow_forward,
                        color: textColor(context),
                        size: Constants.ICON_SMALL_SIZE,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          StreamBuilder(
            stream: isUpdating,
            builder: (context, snapshot) {
              bool? updating = snapshot.data as bool?;
              if (updating != null && updating) {
                return LoadingAnimationWidget.inkDrop(
                    color: Constants.SECONDARY_COLOR,
                    size: Constants.ICON_LARGE_SIZE);
              }
              return StreamBuilder(
                stream: hourlyForecast,
                builder: (context, snapshot) {
                  List<WeatherForecast>? forecasts =
                      snapshot.data as List<WeatherForecast>?;
                  print('forecasts ${forecasts?.length}');
                  if (forecasts == null) {
                    return Container();
                  }
                  return Expanded(
                      child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: ListView.builder(
                      itemCount: forecasts.length,
                      scrollDirection: Axis.horizontal,
                      itemExtent: 115,
                      itemBuilder: (context, index) => HourlyForecast(
                        forecasts.elementAt(index),
                        key: Key(forecasts.elementAt(index).id),
                      ),
                    ),
                  ));
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
