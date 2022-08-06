import 'package:client/rx/app_provider.dart';
import 'package:client/rx/blocs/geo_bloc.dart';
import 'package:client/rx/blocs/location_bloc.dart';
import 'package:client/rx/blocs/settings_bloc.dart';
import 'package:client/rx/blocs/weather_bloc.dart';
import 'package:client/types/weather_units.dart';
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
      appBar: PlatformAppBar(
        leading: StreamBuilder(
          stream: weatherBloc.units,
          builder: (context, snapshot) {
            WeatherUnits unit = snapshot.data as WeatherUnits;
            return Text(unit.toString());
          },
        ),
      ),
      body: Column(
        children: const [
          Flexible(
            flex: 326,
            child: Text('main forecast'),
          ),
          Flexible(
            flex: 100,
            child: Text('7 days'),
          )
        ],
      ),
    );
  }
}
