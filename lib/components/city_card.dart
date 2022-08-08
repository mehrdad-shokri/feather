import 'package:client/models/weather_forecast.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

class CityCard extends StatelessWidget {
  final WeatherForecast weatherForecast;

  const CityCard({Key? key, required this.weatherForecast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
      // margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: PlatformElevatedButton(
        color: Colors.white,
        onPressed: () {},
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(children: [
                  Text(
                    weatherForecast.cityName ?? '',
                    style: TextStyle(
                        color: textColor(context),
                        fontSize: Constants.S2_FONT_SIZE,
                        fontWeight: Constants.MEDIUM_FONT_WEIGHT),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(weatherForecast.cityName ?? '',
                      style: TextStyle(
                          color: textColor(context),
                          fontWeight: Constants.REGULAR_FONT_WEIGHT,
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
                                fontSize: Constants.CAPTION_FONT_SIZE)),
                        const SizedBox(
                          width: 4,
                        ),
                        Image.asset(
                            'icons/flags/png/${weatherForecast.countryCode}.png',
                            width: 32,
                            package: 'country_icons')
                      ],
                    )
                ]),
                Expanded(
                    child: Lottie.asset(
                  'assets/lottie/${weatherForecast.lottieAnimation}.json',
                ))
              ],
            ),
            Row(
              children: [
                Expanded(
                    child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/humidity.svg',
                      color: headingColor(context),
                      width: 16,
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
                )),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/svg/wind.svg',
                      color: headingColor(context),
                      width: 16,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      '${weatherForecast.windSpeed}${windSpeedUnit(weatherForecast.unit)}',
                      style: TextStyle(
                          color: textColor(context),
                          fontSize: Constants.CAPTION_FONT_SIZE,
                          fontWeight: Constants.REGULAR_FONT_WEIGHT),
                    )
                  ],
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
