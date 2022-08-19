import 'package:client/components/forecast_hero_appbar.dart';
import 'package:client/components/forecast_hero_card.dart';
import 'package:client/components/hourly_forecasts.dart';
import 'package:client/rx/blocs/settings_bloc.dart';
import 'package:client/rx/blocs/weather_bloc.dart';
import 'package:client/rx/services/service_provider.dart';
import 'package:client/types/home_page_arguments.dart';
import 'package:client/types/weather_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class HomePage extends StatefulWidget {
  final HomePageArguments arguments;

  const HomePage(this.arguments, {Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SettingsBloc settingsBloc;
  late WeatherBloc weatherBloc;
  AppLocalizations? appLocalizations;
  double? deviceHeight;

  @override
  void initState() {
    super.initState();
    ServiceProvider provider = ServiceProvider.getInstance();
    settingsBloc = SettingsBloc(provider.sharedPrefsService);
    weatherBloc = WeatherBloc(provider.sharedPrefsService, provider.envService);
    weatherBloc.getCurrentForecast(widget.arguments.location,
        initialForecast: widget.arguments.location.forecast);
    weatherBloc.getHourlyForecast(widget.arguments.location);
  }

  @override
  void dispose() {
    super.dispose();
    weatherBloc.dispose();
    settingsBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations ??= AppLocalizations.of(context);
    deviceHeight ??= MediaQuery.of(context).size.height;
    print('${deviceHeight} ${deviceHeight! * .75}');
    return PlatformScaffold(
      iosContentPadding: true,
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          ForecastHeroAppbar(
              weatherUnit: weatherBloc.weatherUnit,
              onWeatherUnitChanged: (unit) {
                weatherBloc.onUnitsChanged(unit);
              },
              onApiProviderChanged: (provider) {
                weatherBloc.onWeatherApiProviderChanged(provider);
                weatherBloc.getCurrentForecast(widget.arguments.location);
              },
              apiProvider: weatherBloc.weatherApiProvider,
              apiProviders: WeatherApiProvider.values,
              theme: settingsBloc.themeMode,
              themes: ThemeMode.values,
              onThemeChange: (Brightness? brightness) =>
                  settingsBloc.onThemeChanged(brightness),
              t: appLocalizations!),
          SliverToBoxAdapter(
            child: SizedBox(
              height: deviceHeight! * .70,
              child: ForecastHeroCard(
                  location: settingsBloc.activeLocation,
                  onLocationChangeRequest: () {
                    Navigator.pushNamed(context, '/search');
                  },
                  isUpdating: weatherBloc.isUpdating,
                  weatherForecast: weatherBloc.currentForecast,
                  weatherUnit: weatherBloc.weatherUnit,
                  t: appLocalizations!),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: deviceHeight! * .3,
              child: HourlyForecasts(
                  t: appLocalizations!,
                  isUpdating: weatherBloc.isUpdating,
                  hourlyForecast: weatherBloc.hourlyForecast),
            ),
          )
        ],
      ),
    );
  }
}
