import 'package:client/utils/constants.dart';
import 'package:client/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class WeatherMeasure extends StatelessWidget {
  final String measure;
  final bool isActive;
  final Function onPress;

  const WeatherMeasure(
      {Key? key,
      required this.onPress,
      required this.isActive,
      required this.measure})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PlatformTextButton(
      key: key,
      onPressed: () => onPress(),
      child: Text(
        measure,
        style: TextStyle(
            fontWeight: isActive
                ? Constants.MEDIUM_FONT_WEIGHT
                : Constants.REGULAR_FONT_WEIGHT,
            fontSize: Constants.H6_FONT_SIZE,
            color: isActive
                ? HexColor.fromHex('#E8E8E8')
                : const Color.fromRGBO(232, 232, 232, .7)),
      ),
    );
  }
}
