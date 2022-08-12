import 'package:client/components/forecast_hero_appbar.dart';
import 'package:client/components/forecast_hero_card.dart';
import 'package:client/models/location.dart';
import 'package:client/rx/blocs/geo_bloc.dart';
import 'package:client/rx/blocs/location_bloc.dart';
import 'package:client/rx/blocs/settings_bloc.dart';
import 'package:client/rx/blocs/weather_bloc.dart';
import 'package:client/rx/services/service_provider.dart';
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
    ServiceProvider appProvider = ServiceProvider.getInstance();
    locationBloc = LocationBloc(appProvider.sharedPrefsService);
    geoBloc = GeoBloc(appProvider.sharedPrefsService, appProvider.envService);
    weatherBloc =
        WeatherBloc(appProvider.sharedPrefsService, appProvider.envService);
    settingsBloc = SettingsBloc(appProvider.sharedPrefsService);
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: forecastHeroAppBar(
          context: context,
          weatherUnit: weatherBloc.units,
          onWeatherUnitChanged: (unit) => weatherBloc.onUnitsChanged(unit),
          onApiProviderChanged: (provider) =>
              weatherBloc.onWeatherApiProviderChanged(provider),
          apiProvider: weatherBloc.apiProvider,
          apiProviders: WeatherApiProvider.values),
      iosContentPadding: true,
      body: StreamBuilder(
        stream: locationBloc.activeLocation,
        builder: (context, snapshot) {
          Location? location = snapshot.data as Location?;
          return Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Flexible(
                flex: 326,
                fit: FlexFit.tight,
                child: ForecastHeroCard(
                  location: locationBloc.activeLocation,
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
          );
        },
      ),
    );
  }
}
