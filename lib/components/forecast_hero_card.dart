import 'package:client/components/weather_forecast_icon.dart';
import 'package:client/models/location.dart';
import 'package:client/models/weather_forecast.dart';
import 'package:client/types/weather_units.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/date.dart';
import 'package:client/utils/feather_icons.dart';
import 'package:client/utils/hex_color.dart';
import 'package:client/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

class ForecastHeroCard extends StatelessWidget {
  final Stream<Location> location;
  final Function onLocationChangeRequest;
  final Stream<bool> isUpdating;
  final Stream<WeatherForecast> weatherForecast;
  final Stream<List<WeatherForecast>> hourlyForecast;
  final Stream<WeatherUnits> weatherUnit;
  final AppLocalizations t;

  const ForecastHeroCard(
      {Key? key,
      required this.location,
      required this.onLocationChangeRequest,
      required this.isUpdating,
      required this.weatherForecast,
      required this.hourlyForecast,
      required this.weatherUnit,
      required this.t})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor(context),
      child: StreamBuilder(
          stream: weatherForecast,
          builder: (context, snapshot) {
            WeatherForecast? forecast = snapshot.data as WeatherForecast?;
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
                mainAxisSize: MainAxisSize.max,
                children: [
                  PlatformTextButton(
                    onPressed: () {
                      onLocationChangeRequest();
                    },
                    padding: EdgeInsets.zero,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Feather.location,
                          size: Constants.ICON_MEDIUM_SIZE,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        StreamBuilder(
                          stream: location,
                          builder: (context, snapshot) {
                            Location? location = snapshot.data as Location?;
                            return Text(
                              location?.cityName ?? '',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: Constants.MEDIUM_FONT_WEIGHT,
                                  fontSize: Constants.H6_FONT_SIZE),
                            );
                          },
                        )
                      ],
                    ),
                  ),
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
                          secondChild: Container(),
                          crossFadeState: (updating != null && updating)
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          duration: const Duration(milliseconds: 250));
                    },
                  ),
                  StreamBuilder(
                    stream: weatherForecast,
                    builder: (context, snapshot) {
                      WeatherForecast? forecast =
                          snapshot.data as WeatherForecast?;
                      return Expanded(
                          child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: forecast == null
                            ? Container()
                            : Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                      child: Lottie.asset(
                                          'assets/lottie/${forecast.lottieAnimation}.json',
                                          alignment: Alignment.center,
                                          fit: BoxFit.contain)),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Stack(
                                    alignment: Alignment.topRight,
                                    clipBehavior: Clip.none,
                                    children: [
                                      Text(
                                        '${forecast.tempFeelsLike?.round()}',
                                        style: const TextStyle(
                                            fontSize: Constants.H2_FONT_SIZE,
                                            color: Colors.white,
                                            fontWeight:
                                                Constants.MEDIUM_FONT_WEIGHT),
                                      ),
                                      Positioned(
                                        top: 0,
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
                                          color:
                                              Constants.SECONDARY_COLOR_LIGHT,
                                          fontSize: Constants.H1_FONT_SIZE,
                                          fontWeight:
                                              Constants.MEDIUM_FONT_WEIGHT)),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    formatDate(DateTime.now().toUtc().add(
                                        Duration(seconds: forecast.timezone))),
                                    style: TextStyle(
                                        color: HexColor.fromHex('#E8E8E8'),
                                        fontWeight:
                                            Constants.REGULAR_FONT_WEIGHT,
                                        fontSize: Constants.S2_FONT_SIZE),
                                  ),
                                  const Divider(
                                    color: Colors.white,
                                    indent: 16,
                                    endIndent: 16,
                                    height: 32,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      WeatherForecastIcon(
                                        assetDir: 'assets/svg/wind.svg',
                                        value: forecast.windSpeed == 0
                                            ? '-'
                                            : '${forecast.windSpeed.toStringAsFixed(0)}${windSpeedUnit(forecast.unit)}',
                                        title: t.wind,
                                      ),
                                      StreamBuilder(
                                        stream: hourlyForecast,
                                        builder: (context, snapshot) {
                                          List<WeatherForecast>? forecasts =
                                              snapshot.data
                                                  as List<WeatherForecast>?;
                                          if (forecasts == null ||
                                              forecasts.isEmpty ||
                                              forecasts.first.pop == null) {
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
                                              value: forecasts.first.pop == 0
                                                  ? '-'
                                                  : '${((forecasts.first.pop!) * 100).toInt()}%',
                                              title: t.chanceOfRain,
                                            );
                                          }
                                        },
                                      ),
                                      WeatherForecastIcon(
                                        assetDir: 'assets/svg/humidity.svg',
                                        value: '${forecast.humidityPercent}%',
                                        title: t.humidity,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                      ));
                    },
                  )
                ],
              ),
            );
          }),
    );
  }
}
