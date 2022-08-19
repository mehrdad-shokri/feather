import 'package:client/types/weather_providers.dart';
import 'package:client/types/weather_units.dart';
import 'package:client/utils/feather_icons.dart';
import 'package:client/utils/hex_color.dart';
import 'package:client/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ForecastHeroAppbar extends StatelessWidget {
  final List<WeatherApiProvider> apiProviders;
  final Function(WeatherApiProvider) onApiProviderChanged;
  final Function(WeatherUnits) onWeatherUnitChanged;
  final Function(Brightness?) onThemeChange;
  final Function(Locale) onLocaleChange;
  final Stream<WeatherApiProvider> apiProvider;
  final Stream<WeatherUnits> weatherUnit;
  final List<ThemeMode> themes;
  final List<Locale> locales;
  final Stream<Brightness> theme;
  final AppLocalizations t;

  const ForecastHeroAppbar(
      {Key? key,
      required this.onApiProviderChanged,
      required this.onWeatherUnitChanged,
      required this.apiProvider,
      required this.apiProviders,
      required this.weatherUnit,
      required this.themes,
      required this.theme,
      required this.onThemeChange,
      required this.locales,
      required this.onLocaleChange,
      required this.t})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      elevation: 0,
      primary: true,
      actions: [
        PlatformPopupMenu(
            options: [
              PopupMenuOption(
                  onTap: (_) {
                    showPlatformActionSheet(
                        context: context,
                        title: t.dataSource,
                        items: apiProviders,
                        translateItem: (WeatherApiProvider e) =>
                            translateWeatherProvider(e, t),
                        onSelect: (WeatherApiProvider e) =>
                            onApiProviderChanged(e));
                  },
                  material: (context, target) => MaterialPopupMenuOptionData(
                      padding: EdgeInsets.zero, child: Text(t.dataSource)),
                  cupertino: (context, target) =>
                      CupertinoPopupMenuOptionData(child: Text(t.dataSource))),
              PopupMenuOption(
                  onTap: (_) {
                    showPlatformActionSheet(
                        context: context,
                        title: t.theme,
                        items: themes,
                        translateItem: (ThemeMode e) =>
                            translateThemeMode(e, t),
                        onSelect: (ThemeMode e) =>
                            onThemeChange(themeModeToBrightness(e)));
                  },
                  material: (context, target) => MaterialPopupMenuOptionData(
                      padding: EdgeInsets.zero, child: Text(t.theme)),
                  cupertino: (context, target) =>
                      CupertinoPopupMenuOptionData(child: Text(t.theme))),
              PopupMenuOption(
                  onTap: (_) {
                    showPlatformActionSheet(
                        context: context,
                        title: t.language,
                        items: locales,
                        translateItem: (Locale e) => translatedLocale(e, t),
                        onSelect: (Locale e) => onLocaleChange(e));
                  },
                  material: (context, target) => MaterialPopupMenuOptionData(
                      padding: EdgeInsets.zero, child: Text(t.language)),
                  cupertino: (context, target) =>
                      CupertinoPopupMenuOptionData(child: Text(t.language))),
              PopupMenuOption(
                  onTap: (_) {},
                  material: (context, target) => MaterialPopupMenuOptionData(
                      padding: EdgeInsets.zero, child: Text(t.about)),
                  cupertino: (context, target) =>
                      CupertinoPopupMenuOptionData(child: Text(t.about)))
            ],
            icon: const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(
                Icons.more_vert,
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
  }
}
