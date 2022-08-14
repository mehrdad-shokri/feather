import 'package:client/components/temperature_icon.dart';
import 'package:client/models/weather_forecast.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class CityCard extends StatelessWidget {
  final WeatherForecast weatherForecast;
  final bool shouldAddMargin;

  const CityCard(
      {Key? key, required this.weatherForecast, required this.shouldAddMargin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: shouldAddMargin ? const EdgeInsets.only(top: 16) : null,
        child: PlatformElevatedButton(
            color: Colors.white,
            onPressed: () {},
            padding: Constants.CARD_INNER_PADDING,
            material: (_, __) => MaterialElevatedButtonData(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                )))),
            cupertino: (_, __) => CupertinoElevatedButtonData(
                borderRadius: BorderRadius.circular(16)),
            child: Stack(
              alignment: Alignment.topRight,
              fit: StackFit.loose,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                    top: 16,
                    right: -8,
                    child: Lottie.asset(
                        'assets/lottie/${weatherForecast.lottieAnimation}.json',
                        alignment: Alignment.center,
                        width: 72,
                        height: 72,
                        fit: BoxFit.contain)),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(weatherForecast.cityName ?? '',
                        softWrap: false,
                        overflow: TextOverflow.fade,
                        style: TextStyle(
                            color: textColor(context),
                            fontWeight: Constants.MEDIUM_FONT_WEIGHT,
                            fontSize: Constants.H6_FONT_SIZE)),
                    const SizedBox(
                      height: 4,
                    ),
                    if (strNotEmpty(weatherForecast.countryCode))
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                              'icons/flags/png/${weatherForecast.countryCode}.png',
                              width: 24,
                              height: 16,
                              package: 'country_icons'),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(weatherForecast.countryCode!.toUpperCase(),
                              style: TextStyle(
                                  color: placeholderColor(context),
                                  fontWeight: Constants.REGULAR_FONT_WEIGHT,
                                  fontSize: Constants.CAPTION_FONT_SIZE)),
                        ],
                      ),
                    const SizedBox(
                      height: 16,
                    ),
                    if (weatherForecast.temp != null) ...[
                      TemperatureIcon(
                          unit: weatherForecast.unit,
                          temperature: weatherForecast.temp!.toString()),
                      const SizedBox(
                        height: 4,
                      ),
                    ],
                    Text(
                      weatherForecast.weatherTitle,
                      style: TextStyle(
                          fontSize: Constants.S2_FONT_SIZE,
                          fontWeight: Constants.REGULAR_FONT_WEIGHT,
                          color: secondaryTextColor(context)),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/svg/humidity.svg',
                              width: Constants.ICON_SMALL_SIZE,
                              height: Constants.ICON_SMALL_SIZE,
                              fit: BoxFit.contain,
                              color: Colors.blue.shade500,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              '${weatherForecast.humidityPercent}%',
                              style: TextStyle(
                                  color: secondaryTextColor(context),
                                  fontSize: Constants.S2_FONT_SIZE,
                                  fontWeight: Constants.REGULAR_FONT_WEIGHT),
                            )
                          ],
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            SvgPicture.asset(
                              'assets/svg/wind.svg',
                              height: Constants.ICON_SMALL_SIZE,
                              width: Constants.ICON_SMALL_SIZE,
                              fit: BoxFit.contain,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              '${weatherForecast.humidityPercent.toStringAsFixed(0)}${windSpeedUnit(weatherForecast.unit)}',
                              style: TextStyle(
                                  color: secondaryTextColor(context),
                                  fontSize: Constants.S2_FONT_SIZE,
                                  fontWeight: Constants.REGULAR_FONT_WEIGHT),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            )));
  }
}
