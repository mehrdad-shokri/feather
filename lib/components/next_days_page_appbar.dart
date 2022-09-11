import 'package:client/models/weather_forecast.dart';
import 'package:client/types/weather_providers.dart';
import 'package:client/types/weather_units.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/date.dart';
import 'package:client/utils/feather_icons.dart';
import 'package:client/utils/hex_color.dart';
import 'package:client/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class NextDaysPageAppbar extends StatelessWidget {
  final Stream<List<WeatherForecast>> dailyForecast;
  final AppLocalizations t;

  const NextDaysPageAppbar(
      {Key? key, required this.dailyForecast, required this.t})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: dailyForecast,
      builder: (context, snapshot) {
        List<WeatherForecast>? weatherForecasts =
            snapshot.data as List<WeatherForecast>?;
        WeatherForecast? forecast = firstOrNull(
            weatherForecasts,
            (item) => isSameDay(
                item.date, DateTime.now().add(const Duration(days: 1))));
        return SliverAppBar(
          elevation: 0,
          primary: true,
          bottom: null,
          centerTitle: true,
          title: Text(
            t.next7Days,
            style: const TextStyle(
                fontWeight: Constants.BOLD_FONT_WEIGHT,
                fontSize: Constants.H4_FONT_SIZE),
          ),
          backgroundColor: forecast != null
              ? forecast.colorGradient.first
              : HexColor.fromHex('#06c7f1'),
          automaticallyImplyLeading: true,
        );
      },
    );
  }
}
