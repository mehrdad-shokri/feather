import 'package:client/components/organisms/forecast_detail_dialog.dart';
import 'package:client/models/location.dart';
import 'package:client/models/weather_forecast.dart';
import 'package:client/types/weather_units.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/date.dart';
import 'package:client/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DailyForecastRow extends StatefulWidget {
  final AppLocalizations t;
  final WeatherForecast forecast;
  final Duration animationDelay;
  final Stream<List<WeatherForecast>> hourlyForecast;
  final Stream<List<WeatherForecast>> dailyForecast;
  final Stream<WeatherForecast> currentForecast;

  final Stream<WeatherUnits> weatherUnit;
  final Location location;

  const DailyForecastRow({
    Key? key,
    required this.t,
    required this.forecast,
    required this.animationDelay,
    required this.hourlyForecast,
    required this.dailyForecast,
    required this.weatherUnit,
    required this.location,
    required this.currentForecast,
  }) : super(key: key);

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
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: offset,
      child: PlatformTextButton(
        onPressed: () {
          showPlatformContentSheet(
              context: context,
              builder: (context) => ForecastDetailDialog(
                  t: widget.t,
                  location: widget.location,
                  unit: widget.weatherUnit,
                  initialDate: widget.forecast.date,
                  dailyForecast: widget.dailyForecast,
                  hourlyForecast: widget.hourlyForecast,
                  currentForecast: widget.currentForecast));
        },
        padding: EdgeInsets.zero,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatDate(widget.forecast.date, format: 'EEEE'),
                      style: TextStyle(
                          fontSize: Constants.S1_FONT_SIZE,
                          fontWeight: Constants.MEDIUM_FONT_WEIGHT,
                          color: textColor(context)),
                    ),
                    Text(
                      formatDate(widget.forecast.date, format: 'd MMM'),
                      style: TextStyle(
                          fontSize: Constants.S2_FONT_SIZE,
                          fontWeight: Constants.REGULAR_FONT_WEIGHT,
                          color: secondaryTextColor(context)),
                    )
                  ],
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
                          fontWeight: Constants.MEDIUM_FONT_WEIGHT),
                    )
                  ],
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Stack(
                      fit: StackFit.loose,
                      alignment: Alignment.centerRight,
                      clipBehavior: Clip.none,
                      children: [
                        Text(
                          '${widget.forecast.minTemp.round()}',
                          style: TextStyle(
                              color: textColor(context),
                              fontWeight: Constants.REGULAR_FONT_WEIGHT,
                              fontSize: Constants.S1_FONT_SIZE),
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
                    const SizedBox(width: 8),
                    Stack(
                      fit: StackFit.loose,
                      alignment: Alignment.centerRight,
                      clipBehavior: Clip.none,
                      children: [
                        Text(
                          '${widget.forecast.maxTemp.round()}',
                          style: TextStyle(
                              color: secondaryTextColor(context),
                              fontWeight: Constants.REGULAR_FONT_WEIGHT,
                              fontSize: Constants.S1_FONT_SIZE),
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
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
