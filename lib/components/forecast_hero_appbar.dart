import 'package:client/types/weather_providers.dart';
import 'package:client/types/weather_units.dart';
import 'package:client/utils/feather_icons.dart';
import 'package:client/utils/hex_color.dart';
import 'package:client/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

Widget forecastHeroAppBar(
        {required BuildContext context,
        required List<WeatherApiProvider> apiProviders,
        required Function(WeatherApiProvider) onApiProviderChanged,
        required Function(WeatherUnits) onWeatherUnitChanged,
        required Stream<WeatherApiProvider> apiProvider,
        required Stream<WeatherUnits> weatherUnit,
        required AppLocalizations t}) =>
    SliverAppBar(
      elevation: 0,
      primary: true,
      actions: [
        PlatformPopupMenu(
            options: [
              PopupMenuOption(
                  onTap: (_) {
                    if (isCupertino(context)) {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (context) => CupertinoActionSheet(
                                title: Text(t.dataSource),
                                actions: apiProviders
                                    .map((e) => CupertinoActionSheetAction(
                                        onPressed: () {
                                          onApiProviderChanged(e);
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                            translateWeatherProvider(e, t))))
                                    .toList(),
                              ));
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text(t.dataSource),
                                content: Column(
                                  children: apiProviders
                                      .map((e) => TextButton(
                                          onPressed: () {
                                            onApiProviderChanged(e);
                                          },
                                          child: Text(
                                              translateWeatherProvider(e, t))))
                                      .toList(),
                                ),
                              ));
                    }
                  },
                  material: (context, target) => MaterialPopupMenuOptionData(
                      padding: EdgeInsets.zero, child: Text(t.dataSource)),
                  cupertino: (context, target) =>
                      CupertinoPopupMenuOptionData(child: Text(t.dataSource))),
              PopupMenuOption(
                  onTap: (_) {},
                  material: (context, target) => MaterialPopupMenuOptionData(
                      padding: EdgeInsets.zero, child: Text(t.about)),
                  cupertino: (context, target) =>
                      CupertinoPopupMenuOptionData(child: Text(t.about)))
            ],
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
              size: 32,
            ))
      ],
      leading: StreamBuilder(
        stream: weatherUnit,
        builder: (context, snapshot) {
          WeatherUnits? unit = snapshot.data as WeatherUnits?;
          return PlatformPopupMenu(
              material: (_, __) => MaterialPopupMenuData(),
              cupertino: (_, __) => CupertinoPopupMenuData(
                    title: Text(t.units),
                  ),
              options: [
                PopupMenuOption(
                    onTap: (_) {
                      onWeatherUnitChanged(WeatherUnits.metric);
                    },
                    label: t.metric,
                    material: (context, target) =>
                        MaterialPopupMenuOptionData(child: Text(t.metric)),
                    cupertino: (context, target) =>
                        CupertinoPopupMenuOptionData(child: Text(t.metric))),
                PopupMenuOption(
                    onTap: (_) {
                      onWeatherUnitChanged(WeatherUnits.imperial);
                    },
                    label: t.imperial,
                    material: (context, target) =>
                        MaterialPopupMenuOptionData(child: Text(t.imperial)),
                    cupertino: (context, target) =>
                        CupertinoPopupMenuOptionData(child: Text(t.imperial)))
              ],
              icon: Icon(
                unit == WeatherUnits.metric
                    ? Feather.celcius
                    : Feather.fahrenheit,
                size: 54,
                color: Colors.white,
              ));
        },
      ),
      backgroundColor: HexColor.fromHex('#06c7f1'),
    );
