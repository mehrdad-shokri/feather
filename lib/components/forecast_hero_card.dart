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
  final Stream<WeatherUnits> weatherUnit;
  final AppLocalizations t;

  const ForecastHeroCard(
      {Key? key,
      required this.location,
      required this.onLocationChangeRequest,
      required this.isUpdating,
      required this.weatherForecast,
      required this.weatherUnit,
      required this.t})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor(context),
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, bottom: 32),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24)),
            gradient: LinearGradient(
                colors: [
                  HexColor.fromHex('#06c7f1'),
                  HexColor.fromHex('#07b9e0'),
                  HexColor.fromHex('#0648f1')
                ],
                begin: const FractionalOffset(0.5, 0),
                end: const FractionalOffset(0.5, 1.0),
                stops: const [0.0, .31, .95],
                tileMode: TileMode.clamp)),
        child: Column(
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
                              color:
                                  Constants.SUCCESS_COLOR_DARK.withAlpha(150),
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
                                    fontWeight: Constants.MEDIUM_FONT_WEIGHT,
                                    fontSize: Constants.CAPTION_FONT_SIZE),
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
                WeatherForecast? forecast = snapshot.data as WeatherForecast?;
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  child: forecast == null
                      ? Container()
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Lottie.asset(
                                'assets/lottie/${forecast.lottieAnimation}.json',
                                alignment: Alignment.center,
                                height: 200,
                                fit: BoxFit.cover),
                            Stack(
                              alignment: Alignment.topRight,
                              clipBehavior: Clip.none,
                              children: [
                                Text(
                                  '${forecast.tempFeelsLike}',
                                  style: const TextStyle(
                                      fontSize: Constants.H2_FONT_SIZE,
                                      color: Colors.white,
                                      fontWeight: Constants.MEDIUM_FONT_WEIGHT),
                                ),
                                StreamBuilder(
                                  stream: weatherUnit,
                                  builder: (context, snapshot) {
                                    WeatherUnits? unit =
                                        snapshot.data as WeatherUnits?;
                                    return Positioned(
                                      top: -8,
                                      right: -16,
                                      child: SvgPicture.asset(
                                        'assets/svg/degrees.svg',
                                        color: Colors.white,
                                        width: 16,
                                        height: 16,
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(forecast.weatherTitle,
                                style: TextStyle(
                                    color: Constants.SECONDARY_COLOR_LIGHT,
                                    fontSize: Constants.H2_FONT_SIZE,
                                    fontWeight: Constants.MEDIUM_FONT_WEIGHT)),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              formatDate(DateTime.now()
                                  .toUtc()
                                  .add(Duration(seconds: forecast.timezone))),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: Constants.REGULAR_FONT_WEIGHT,
                                  fontSize: Constants.S1_FONT_SIZE),
                            ),
                            const Divider(
                              color: Colors.white,
                              indent: 16,
                              endIndent: 16,
                              height: 32,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                WeatherForecastIcon(
                                  assetDir: 'assets/svg/wind.svg',
                                  value:
                                      '${forecast.windSpeed.toStringAsFixed(0)}${windSpeedUnit(forecast.unit)}',
                                  title: t.wind,
                                ),
                                if (forecast.pop != null)
                                  WeatherForecastIcon(
                                    icon: Feather.na,
                                    value:
                                        '${forecast.pop?.toStringAsFixed(0)}',
                                    title: t.chanceOfRain,
                                  )
                                else
                                  WeatherForecastIcon(
                                    assetDir: 'assets/svg/chance-of-rain.svg',
                                    value: 'NAN',
                                    title: t.chanceOfRain,
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
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
