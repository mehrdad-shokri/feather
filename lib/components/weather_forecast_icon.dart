import 'package:client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WeatherForecastIcon extends StatelessWidget {
  final String assetDir;
  final String title;
  final String value;

  const WeatherForecastIcon(
      {Key? key,
      required this.title,
      required this.value,
      required this.assetDir})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(
          assetDir,
          height: Constants.ICON_MEDIUM_SIZE,
          width: Constants.ICON_MEDIUM_SIZE,
          fit: BoxFit.contain,
          color: Colors.grey.shade300,
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          value,
          style: const TextStyle(
              color: Colors.white,
              fontSize: Constants.S2_FONT_SIZE,
              fontWeight: Constants.MEDIUM_FONT_WEIGHT),
        ),
        const SizedBox(
          height: 2,
        ),
        Text(
          title,
          style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: Constants.S2_FONT_SIZE,
              fontWeight: Constants.MEDIUM_FONT_WEIGHT),
        )
      ],
    );
  }
}
