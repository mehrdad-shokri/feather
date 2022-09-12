import 'package:client/utils/constants.dart';
import 'package:client/utils/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ForecastDetailWeekday extends StatelessWidget {
  final bool isActive;
  final String weekday;
  final Function onPress;

  const ForecastDetailWeekday(
      {Key? key,
      required this.isActive,
      required this.weekday,
      required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: isActive ? Constants.PRIMARY_COLOR : Colors.transparent),
      child: PlatformTextButton(
        onPressed: () => onPress(),
        padding: EdgeInsets.zero,
        child: Text(
          weekday,
          style: TextStyle(
              fontSize: Constants.S1_FONT_SIZE,
              fontWeight: Constants.MEDIUM_FONT_WEIGHT,
              color: isActive
                  ? HexColor.fromHex('#E8E8E8')
                  : const Color.fromRGBO(232, 232, 232, .7)),
        ),
      ),
    );
  }
}
