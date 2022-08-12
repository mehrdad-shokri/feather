import 'package:client/models/weather_forecast.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/feather_icons.dart';
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
        child: Stack(
          alignment: Alignment.topRight,
          fit: StackFit.loose,
          children: [
            PlatformElevatedButton(
              color: Colors.white,
              onPressed: () {},
              padding: const EdgeInsets.all(16),
              material: (_, __) => MaterialElevatedButtonData(
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              )))),
              cupertino: (_, __) => CupertinoElevatedButtonData(
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        weatherForecast.temp?.toString() ?? '',
                        style: TextStyle(
                            color: textColor(context),
                            fontSize: Constants.S1_FONT_SIZE,
                            fontWeight: Constants.MEDIUM_FONT_WEIGHT),
                      ),
                      Icon(
                        Feather.celcius,
                        color: secondaryTextColor(context),
                        size: 24,
                      )
                    ],
                  ),
                  Text(
                    weatherForecast.weatherTitle,
                    style: TextStyle(
                        fontSize: Constants.S2_FONT_SIZE,
                        fontWeight: Constants.REGULAR_FONT_WEIGHT,
                        color: textColor(context)),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(weatherForecast.cityName ?? '',
                      style: TextStyle(
                          color: textColor(context),
                          fontWeight: Constants.MEDIUM_FONT_WEIGHT,
                          fontSize: Constants.S2_FONT_SIZE)),
                  const SizedBox(
                    height: 4,
                  ),
                  if (strNotEmpty(weatherForecast.countryCode))
                    Row(
                      children: [
                        Text(weatherForecast.countryCode!,
                            style: TextStyle(
                                color: secondaryTextColor(context),
                                fontWeight: Constants.REGULAR_FONT_WEIGHT,
                                fontSize: Constants.S2_FONT_SIZE)),
                        const SizedBox(
                          width: 4,
                        ),
/*
                                  Image.asset(
                                      'icons/flags/png/${weatherForecast.countryCode}.png',
                                      width: 32,
                                      package: 'country_icons')
*/
                      ],
                    ),
                  Spacer(),
                  Row(
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/svg/drop.svg',
                            width: 16,
                            fit: BoxFit.contain,
                            color: Colors.blue.shade400,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            '${weatherForecast.humidityPercent}%',
                            style: TextStyle(
                                color: textColor(context),
                                fontSize: Constants.CAPTION_FONT_SIZE,
                                fontWeight: Constants.REGULAR_FONT_WEIGHT),
                          )
                        ],
                      ),
                      Spacer(),
                      Row(
                        children: [
                          SvgPicture.asset(
                            'assets/svg/windspeed.svg',
                            height: 16,
                            fit: BoxFit.contain,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            '${weatherForecast.windSpeed.toStringAsFixed(2)}${windSpeedUnit(weatherForecast.unit)}',
                            style: TextStyle(
                                color: textColor(context),
                                fontSize: Constants.CAPTION_FONT_SIZE,
                                fontWeight: Constants.REGULAR_FONT_WEIGHT),
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            Column(
              children: [
                Lottie.asset(
                    'assets/lottie/${weatherForecast.lottieAnimation}.json',
                    alignment: Alignment.center,
                    width: 64,
                    height: 64,
                    fit: BoxFit.contain),
              ],
            )
          ],
        ));
  }
}
