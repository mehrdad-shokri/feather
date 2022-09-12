import 'package:client/components/organisms/about_detail_dialog.dart';
import 'package:client/components/organisms/about_detail_dialog.dart';
import 'package:client/models/weather_forecast.dart';
import 'package:client/types/weather_providers.dart';
import 'package:client/types/weather_units.dart';
import 'package:client/utils/feather_icons.dart';
import 'package:client/utils/hex_color.dart';
import 'package:client/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class HomeAppbar extends StatelessWidget {
  final List<WeatherApiProvider> apiProviders;
  final Function(WeatherApiProvider) onApiProviderChanged;
  final Function(WeatherUnits) onWeatherUnitChanged;
  final Function(ThemeMode) onThemeChange;
  final Function(Locale) onLocaleChange;
  final Stream<WeatherApiProvider> apiProvider;
  final Stream<Locale> locale;
  final Stream<WeatherUnits> weatherUnit;
  final List<ThemeMode> themes;
  final List<Locale> locales;
  final Stream<ThemeMode> theme;
  final Stream<WeatherForecast> currentForecast;
  final AppLocalizations t;

  const HomeAppbar(
      {Key? key,
      required this.onApiProviderChanged,
      required this.onWeatherUnitChanged,
      required this.apiProvider,
      required this.apiProviders,
      required this.locale,
      required this.weatherUnit,
      required this.themes,
      required this.theme,
      required this.onThemeChange,
      required this.locales,
      required this.onLocaleChange,
      required this.currentForecast,
      required this.t})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: currentForecast,
      builder: (context, snapshot) {
        WeatherForecast? weatherForecast = snapshot.data as WeatherForecast?;
        return SliverAppBar(
          elevation: 0,
          primary: true,
          bottom: null,
          backgroundColor: weatherForecast != null
              ? weatherForecast.colorGradient.first
              : HexColor.fromHex('#06c7f1'),
          actions: [
            PlatformPopupMenu(
                options: [
                  PopupMenuOption(
                      onTap: (_) {
                        showPlatformActionSheet(
                            context: context,
                            title: t.dataSource,
                            items: apiProviders,
                            cancelText: t.cancel,
                            value: apiProvider,
                            translateItem: (WeatherApiProvider e) =>
                                translateWeatherProvider(e, t),
                            onSelect: (WeatherApiProvider e) =>
                                onApiProviderChanged(e));
                      },
                      material: (context, target) =>
                          MaterialPopupMenuOptionData(
                              child: Text(t.dataSource)),
                      cupertino: (context, target) =>
                          CupertinoPopupMenuOptionData(
                              child: Text(t.dataSource))),
                  PopupMenuOption(
                      onTap: (_) {
                        showPlatformActionSheet(
                            context: context,
                            title: t.theme,
                            items: themes,
                            cancelText: t.cancel,
                            value: theme,
                            translateItem: (ThemeMode e) =>
                                translateThemeMode(e, t),
                            onSelect: (ThemeMode e) => onThemeChange(e));
                      },
                      material: (context, target) =>
                          MaterialPopupMenuOptionData(child: Text(t.theme)),
                      cupertino: (context, target) =>
                          CupertinoPopupMenuOptionData(child: Text(t.theme))),
                  PopupMenuOption(
                      onTap: (_) {
                        showPlatformActionSheet(
                            context: context,
                            title: t.language,
                            items: locales,
                            cancelText: t.cancel,
                            value: locale,
                            translateItem: (Locale e) => translatedLocale(e, t),
                            onSelect: (Locale e) => onLocaleChange(e));
                      },
                      material: (context, target) =>
                          MaterialPopupMenuOptionData(child: Text(t.language)),
                      cupertino: (context, target) =>
                          CupertinoPopupMenuOptionData(
                              child: Text(t.language))),
                  PopupMenuOption(
                      onTap: (_) {
                        showPlatformContentSheet(
                            context: context,
                            builder: (context) => AboutDetailDialog(
                                  t: t,
                                ));
                      },
                      material: (context, target) =>
                          MaterialPopupMenuOptionData(child: Text(t.about)),
                      cupertino: (context, target) =>
                          CupertinoPopupMenuOptionData(child: Text(t.about)))
                ],
                icon: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(
                    isMaterial(context)
                        ? Icons.more_vert
                        : CupertinoIcons.ellipsis_circle,
                    color: Colors.white,
                    size: 32,
                  ),
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
                            CupertinoPopupMenuOptionData(
                                child: Text(t.metric))),
                    PopupMenuOption(
                        onTap: (_) {
                          onWeatherUnitChanged(WeatherUnits.imperial);
                        },
                        label: t.imperial,
                        material: (context, target) =>
                            MaterialPopupMenuOptionData(
                                child: Text(t.imperial)),
                        cupertino: (context, target) =>
                            CupertinoPopupMenuOptionData(
                                child: Text(t.imperial)))
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
        );
      },
    );
  }
}
