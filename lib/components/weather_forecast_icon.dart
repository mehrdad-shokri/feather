import 'package:client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WeatherForecastIcon extends StatelessWidget {
  final String? assetDir;
  final String title;
  final String value;
  final IconData? icon;

  const WeatherForecastIcon(
      {Key? key,
      required this.title,
      required this.value,
      this.assetDir,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (assetDir != null)
          SvgPicture.asset(
            assetDir!,
            height: Constants.ICON_MEDIUM_SIZE,
            width: Constants.ICON_MEDIUM_SIZE,
            fit: BoxFit.contain,
            color: Colors.grey.shade300,
          ),
        if (icon != null)
          Icon(
            icon,
            color: Colors.grey.shade300,
            size: Constants.ICON_MEDIUM_SIZE,
          ),
        const SizedBox(
          height: 8,
        ),
        Text(
          value,
          style: const TextStyle(
              color: Colors.white,
              fontSize: Constants.S2_FONT_SIZE,
              fontWeight: Constants.MEDIUM_FONT_WEIGHT),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          title,
          style: TextStyle(
              color: Colors.white.withAlpha(180),
              fontSize: Constants.S2_FONT_SIZE,
              fontWeight: Constants.REGULAR_FONT_WEIGHT),
        )
      ],
    );
  }
}
