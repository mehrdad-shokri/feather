import 'package:client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WeatherForecastIcon extends StatelessWidget {
  final String? assetDir;
  final String title;
  final String? value;
  final Axis direction;

  const WeatherForecastIcon(
      {Key? key,
      required this.title,
      this.value,
      this.assetDir,
      this.direction = Axis.vertical})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (direction == Axis.horizontal) {
      return Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            children: [
              if (assetDir != null)
                SvgPicture.asset(
                  assetDir!,
                  height: Constants.ICON_MEDIUM_SIZE,
                  width: Constants.ICON_MEDIUM_SIZE,
                  fit: BoxFit.contain,
                  color: Colors.white,
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
          ),
          const SizedBox(
            width: 8,
          ),
          if (value != null)
            Text(
              value!,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: Constants.S2_FONT_SIZE,
                  fontWeight: Constants.MEDIUM_FONT_WEIGHT),
            ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (assetDir != null)
          SvgPicture.asset(
            assetDir!,
            height: Constants.ICON_MEDIUM_SIZE,
            width: Constants.ICON_MEDIUM_SIZE,
            fit: BoxFit.contain,
            color: Colors.white,
          ),
        const SizedBox(
          height: 8,
        ),
        if (value != null)
          Text(
            value!,
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
