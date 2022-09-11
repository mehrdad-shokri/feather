import 'package:client/types/weather_units.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/feather_icons.dart';
import 'package:flutter/material.dart';

class TemperatureIcon extends StatelessWidget {
  final WeatherUnits unit;
  final String temperature;

  const TemperatureIcon(
      {Key? key, required this.unit, required this.temperature})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      clipBehavior: Clip.none,
      children: [
        Text(
          temperature,
          style: TextStyle(
              color: textColor(context),
              fontSize: Constants.S1_FONT_SIZE,
              fontWeight: Constants.MEDIUM_FONT_WEIGHT),
        ),
        Positioned(
            top: -6,
            right: -18,
            child: Icon(
              unit == WeatherUnits.metric
                  ? Feather.celcius
                  : Feather.fahrenheit,
              color: placeholderColor(context),
              size: 24,
            ))
      ],
    );
  }
}
