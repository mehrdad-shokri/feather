import 'package:client/components/home_page_app_bar.dart';
import 'package:client/components/home_page_forecast.dart';
import 'package:client/rx/app_provider.dart';
import 'package:client/rx/blocs/geo_bloc.dart';
import 'package:client/rx/blocs/location_bloc.dart';
import 'package:client/rx/blocs/settings_bloc.dart';
import 'package:client/rx/blocs/weather_bloc.dart';
import 'package:client/types/weather_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late LocationBloc locationBloc;
  late SettingsBloc settingsBloc;
  late WeatherBloc weatherBloc;
  late GeoBloc geoBloc;

  @override
  void initState() {
    super.initState();
    AppProvider appProvider = AppProvider.getInstance();
    locationBloc = LocationBloc(appProvider.sharedPrefsService);
    geoBloc = GeoBloc(appProvider.sharedPrefsService, appProvider.envService);
    weatherBloc =
        WeatherBloc(appProvider.sharedPrefsService, appProvider.envService);
    settingsBloc = SettingsBloc(appProvider.sharedPrefsService);
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: homePageAppBar(
          context: context,
          weatherUnit: weatherBloc.units,
          onWeatherUnitChanged: (unit) => weatherBloc.onUnitsChanged(unit),
          onApiProviderChanged: (provider) =>
              weatherBloc.onWeatherApiProviderChanged(provider),
          apiProvider: weatherBloc.apiProvider,
          apiProviders: WeatherApiProvider.values),
      iosContentPadding: true,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            flex: 326,
            fit: FlexFit.tight,
            child: HomePageForecast(
              location: locationBloc.location,
              onLocationChangeRequest: () {},
              isUpdating: weatherBloc.isUpdating,
              weatherForecast: weatherBloc.currentForecast,
            ),
          ),
          const Flexible(
            flex: 100,
            fit: FlexFit.tight,
            child: Text('7 days'),
          )
        ],
      ),
    );
  }
}
