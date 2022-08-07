import 'package:client/components/home_page_app_bar.dart';
import 'package:client/rx/app_provider.dart';
import 'package:client/rx/blocs/geo_bloc.dart';
import 'package:client/rx/blocs/location_bloc.dart';
import 'package:client/rx/blocs/settings_bloc.dart';
import 'package:client/rx/blocs/weather_bloc.dart';
import 'package:client/utils/hex_color.dart';
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
      ),
      iosContentPadding: true,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Flexible(
            flex: 326,
            fit: FlexFit.tight,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        HexColor.fromHex('#06c7f1'),
                        HexColor.fromHex('#07b9e0'),
                        HexColor.fromHex('#0648f1')
                      ],
                      begin: FractionalOffset(0.5, 0),
                      end: FractionalOffset(0.5, 1.0),
                      stops: [0.0, .31, .95],
                      tileMode: TileMode.clamp)),
            ),
          ),
          Flexible(
            flex: 100,
            fit: FlexFit.tight,
            child: Text('7 days'),
          )
        ],
      ),
    );
  }
}
