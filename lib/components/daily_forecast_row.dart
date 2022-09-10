import 'package:client/models/weather_forecast.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/date.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class DailyForecastRow extends StatefulWidget {
  final WeatherForecast forecast;
  final Duration animationDelay;

  const DailyForecastRow(
      {Key? key, required this.forecast, required this.animationDelay})
      : super(key: key);

  @override
  State<DailyForecastRow> createState() => _DailyForecastRowState();
}

class _DailyForecastRowState extends State<DailyForecastRow>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<Offset> offset;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));

    offset = Tween<Offset>(
            begin: const Offset(-1.0, 0.0), end: const Offset(0.0, 0.0))
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
    Future.delayed(widget.animationDelay, () => controller.forward());
  }

  @override
  void dispose() {
    controller.reverse();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: offset,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Text(
                formatDate(widget.forecast.date, format: 'EEEE'),
                style: TextStyle(
                    fontSize: Constants.S1_FONT_SIZE,
                    fontWeight: Constants.MEDIUM_FONT_WEIGHT,
                    color: textColor(context)),
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.center,
                children: [
                  Lottie.asset(
                      'assets/lottie/${widget.forecast.lottieAnimation}.json',
                      alignment: Alignment.center,
                      width: 40,
                      fit: BoxFit.contain),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    widget.forecast.weatherTitle,
                    style: TextStyle(
                        color: textColor(context),
                        fontSize: Constants.S2_FONT_SIZE,
                        fontWeight: Constants.BOLD_FONT_WEIGHT),
                  )
                ],
              ),
            ),
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Stack(
                fit: StackFit.loose,
                alignment: Alignment.centerRight,
                clipBehavior: Clip.none,
                children: [
                  Text(
                    '${widget.forecast.minTemp.round()}/${widget.forecast.maxTemp.round()}',
                    style: TextStyle(
                      color: textColor(context),
                    ),
                  ),
                  Positioned(
                    top: -2,
                    right: -4,
                    child: SvgPicture.asset(
                      'assets/svg/degrees.svg',
                      color: textColor(context),
                      width: 4,
                      height: 4,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
