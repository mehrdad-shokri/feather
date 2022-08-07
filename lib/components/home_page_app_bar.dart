import 'package:client/types/weather_units.dart';
import 'package:client/utils/feather_icons.dart';
import 'package:client/utils/hex_color.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

PlatformAppBar homePageAppBar(
        {required BuildContext context,
        required Function(WeatherUnits) onWeatherUnitChanged,
        required Stream<WeatherUnits> weatherUnit}) =>
    PlatformAppBar(
      material: (context, _) => MaterialAppBarData(elevation: 0),
      cupertino: (context, _) =>
          CupertinoNavigationBarData(border: const Border()),
      trailingActions: [
        PlatformPopupMenu(
            options: [
              PopupMenuOption(
                  onTap: (_) {},
                  material: (context, target) => MaterialPopupMenuOptionData(
                      padding: EdgeInsets.zero,
                      child: Row(
                        children: [
                          Icon(
                            Icons.api,
                            size: 24,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text('API provider'),
                        ],
                      )),
                  cupertino: (context, target) => CupertinoPopupMenuOptionData(
                          child: Row(
                        children: const [
                          Icon(
                            Icons.api,
                            size: 24,
                            color: CupertinoColors.link,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text('API provider'),
                        ],
                      ))),
              PopupMenuOption(
                  onTap: (_) {},
                  material: (context, target) => MaterialPopupMenuOptionData(
                      padding: EdgeInsets.zero,
                      child: Row(
                        children: [
                          Icon(
                            Icons.info,
                            size: 24,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text('About'),
                        ],
                      )),
                  cupertino: (context, target) => CupertinoPopupMenuOptionData(
                          child: Row(
                        children: const [
                          Icon(
                            Icons.info,
                            size: 24,
                            color: CupertinoColors.link,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text('About'),
                        ],
                      )))
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
              options: [
                PopupMenuOption(
                    onTap: (_) {
                      onWeatherUnitChanged(WeatherUnits.metric);
                    },
                    material: (context, target) => MaterialPopupMenuOptionData(
                            child: const Icon(
                          Feather.celcius,
                          size: 40,
                        )),
                    cupertino: (context, target) =>
                        CupertinoPopupMenuOptionData(
                            child: const Icon(
                          Feather.celcius,
                          size: 40,
                        ))),
                PopupMenuOption(
                    onTap: (_) {
                      onWeatherUnitChanged(WeatherUnits.imperial);
                    },
                    label: 'celcius',
                    material: (context, target) => MaterialPopupMenuOptionData(
                            child: const Icon(
                          Feather.fahrenheit,
                          size: 40,
                        )),
                    cupertino: (context, target) =>
                        CupertinoPopupMenuOptionData(
                            child: const Icon(
                          Feather.fahrenheit,
                          size: 40,
                        )))
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
