import 'package:client/components/weather_forecast_icon.dart';
import 'package:client/models/location.dart';
import 'package:client/models/weather_forecast.dart';
import 'package:client/types/weather_units.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/date.dart';
import 'package:client/utils/hex_color.dart';
import 'package:client/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

class ForecastSecondaryCard extends StatelessWidget {
  final Stream<Location> location;
  final Function onLocationChangeRequest;
  final Stream<bool> isUpdating;
  final Stream<List<WeatherForecast>> dailyForecast;
  final Stream<List<WeatherForecast>> hourlyForecast;
  final Stream<WeatherUnits> weatherUnit;
  final AppLocalizations t;

  const ForecastSecondaryCard(
      {Key? key,
      required this.location,
      required this.onLocationChangeRequest,
      required this.isUpdating,
      required this.dailyForecast,
      required this.hourlyForecast,
      required this.weatherUnit,
      required this.t})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      color: backgroundColor(context),
      constraints:
          BoxConstraints(minHeight: MediaQuery.of(context).size.height * .3),
      child: StreamBuilder(
          stream: dailyForecast,
          builder: (context, snapshot) {
            List<WeatherForecast>? forecasts =
                snapshot.data as List<WeatherForecast>?;
            WeatherForecast? forecast = firstOrNull(
                forecasts,
                (forecast) => isSameDay(forecast.date,
                    DateTime.now().add(const Duration(days: 1))));
            return Container(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 24),
              margin: const EdgeInsets.only(bottom: 8),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(
                      color:
                          isDark(context) ? Colors.grey.shade900 : Colors.grey,
                      offset: const Offset(0.0, 1.0),
                      spreadRadius: 4,
                      blurRadius: 6.0,
                    ),
                  ],
                  gradient: LinearGradient(
                      colors: forecast != null
                          ? forecast.colorGradient
                          : [
                              HexColor.fromHex('#06c7f1'),
                              HexColor.fromHex('#07b9e0'),
                              HexColor.fromHex('#0648f1')
                            ],
                      begin: const FractionalOffset(0.5, 0),
                      end: const FractionalOffset(0.5, 1.0),
                      stops: const [0.0, .31, .95],
                      tileMode: TileMode.clamp)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StreamBuilder(
                    stream: isUpdating,
                    builder: (context, snapshot) {
                      bool? updating = snapshot.data as bool?;
                      return AnimatedCrossFade(
                          firstChild: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                    color: Constants.SUCCESS_COLOR_DARK
                                        .withAlpha(150),
                                    borderRadius: BorderRadius.circular(16)),
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    LoadingAnimationWidget.inkDrop(
                                        color: Colors.white, size: 16),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    const Text(
                                      'Loading',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight:
                                              Constants.MEDIUM_FONT_WEIGHT,
                                          fontSize:
                                              Constants.CAPTION_FONT_SIZE),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          secondChild: Container(
                            height: 16,
                          ),
                          crossFadeState: (updating != null && updating)
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 250));
                    },
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: forecast == null
                        ? Container()
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Lottie.asset(
                                      'assets/lottie/${forecast.lottieAnimation}.json',
                                      alignment: Alignment.center,
                                      height: 120,
                                      fit: BoxFit.contain),
                                  const SizedBox(
                                    width: 32,
                                  ),
                                  Expanded(
                                      flex: 8,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(t.tomorrow,
                                              style: const TextStyle(
                                                  fontSize:
                                                      Constants.H5_FONT_SIZE,
                                                  color: Colors.white,
                                                  fontWeight: Constants
                                                      .MEDIUM_FONT_WEIGHT)),
                                          const SizedBox(
                                            height: 24,
                                          ),
                                          Stack(
                                            alignment: Alignment.topRight,
                                            clipBehavior: Clip.none,
                                            fit: StackFit.loose,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    '${forecast.maxTemp.round()}',
                                                    style: const TextStyle(
                                                        fontSize: 40,
                                                        color: Colors.white,
                                                        height: .7,
                                                        fontWeight: Constants
                                                            .MEDIUM_FONT_WEIGHT),
                                                  ),
                                                  Text(
                                                      '/${forecast.minTemp.round()}',
                                                      style: const TextStyle(
                                                          fontSize: Constants
                                                              .H2_FONT_SIZE,
                                                          color: Colors.white,
                                                          fontWeight: Constants
                                                              .MEDIUM_FONT_WEIGHT))
                                                ],
                                              ),
                                              Positioned(
                                                top: -4,
                                                right: -8,
                                                child: SvgPicture.asset(
                                                  'assets/svg/degrees.svg',
                                                  color: Colors.white,
                                                  width: 8,
                                                  height: 8,
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(forecast.weatherTitle,
                                              style: TextStyle(
                                                  color: HexColor.fromHex(
                                                      '#E5E5E5'),
                                                  fontSize:
                                                      Constants.H5_FONT_SIZE,
                                                  fontWeight: Constants
                                                      .REGULAR_FONT_WEIGHT))
                                        ],
                                      ))
                                ],
                              ),
                              // const SizedBox(
                              //   height: 8,
                              // ),
                              const Divider(
                                color: Colors.white,
                                indent: 16,
                                endIndent: 16,
                                height: 32,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: WeatherForecastIcon(
                                      assetDir: 'assets/svg/wind.svg',
                                      value: forecast.windSpeed == 0
                                          ? '-'
                                          : '${forecast.windSpeed.toStringAsFixed(0)}${windSpeedUnit(forecast.unit)}',
                                      title: t.wind,
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: StreamBuilder(
                                      stream: hourlyForecast,
                                      builder: (context, snapshot) {
                                        if (forecast.pop == null) {
                                          return WeatherForecastIcon(
                                            assetDir:
                                                'assets/svg/chance-of-rain.svg',
                                            value: '-',
                                            title: t.chanceOfRain,
                                          );
                                        } else {
                                          return WeatherForecastIcon(
                                            assetDir:
                                                'assets/svg/chance-of-rain.svg',
                                            value: forecast.pop == 0
                                                ? '-'
                                                : '${((forecast.pop!) * 100).toInt()}%',
                                            title: t.chanceOfRain,
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.tight,
                                    child: WeatherForecastIcon(
                                      assetDir: 'assets/svg/humidity.svg',
                                      value: '${forecast.humidityPercent}%',
                                      title: t.humidity,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                  )
                ],
              ),
            );
          }),
    );
  }
}
