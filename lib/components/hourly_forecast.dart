import 'package:client/models/weather_forecast.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/date.dart';
import 'package:client/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class HourlyForecast extends StatelessWidget {
  final EdgeInsets? margin;
  final WeatherForecast weatherForecast;

  const HourlyForecast(this.weatherForecast, {Key? key, this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 8),
      width: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
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
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            formatTime(weatherForecast.date),
            style: const TextStyle(
                color: Colors.white,
                fontWeight: Constants.MEDIUM_FONT_WEIGHT,
                fontSize: Constants.CAPTION_FONT_SIZE),
          ),
          Text(
            formatDate(weatherForecast.date, format: 'MMMM d'),
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white.withAlpha(200),
                fontWeight: Constants.REGULAR_FONT_WEIGHT,
                fontSize: 12),
          ),
          Expanded(
              child: Lottie.asset(
                  'assets/lottie/${weatherForecast.lottieAnimation}.json',
                  alignment: Alignment.center,
                  fit: BoxFit.contain)),
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topRight,
            children: [
              Text(
                '${weatherForecast.tempFeelsLike?.round()}',
                style: const TextStyle(
                    fontWeight: Constants.MEDIUM_FONT_WEIGHT,
                    fontSize: Constants.S2_FONT_SIZE,
                    color: Colors.white),
              ),
              Positioned(
                top: 0,
                right: -4,
                child: SvgPicture.asset(
                  'assets/svg/degrees.svg',
                  color: Colors.white,
                  width: 4,
                  height: 4,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
