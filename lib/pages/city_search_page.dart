import 'package:client/components/city_card.dart';
import 'package:client/components/city_search_field.dart';
import 'package:client/models/weather_forecast.dart';
import 'package:client/rx/app_provider.dart';
import 'package:client/rx/blocs/geo_bloc.dart';
import 'package:client/rx/blocs/location_bloc.dart';
import 'package:client/rx/blocs/position_bloc.dart';
import 'package:client/rx/blocs/weather_bloc.dart';
import 'package:client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CitySearchPage extends StatefulWidget {
  const CitySearchPage({Key? key}) : super(key: key);

  @override
  State<CitySearchPage> createState() => _CitySearchPageState();
}

class _CitySearchPageState extends State<CitySearchPage> {
  late GeoBloc geoBloc;
  late PositionBloc positionBloc;
  late LocationBloc locationBloc;
  late WeatherBloc weatherBloc;

  @override
  void initState() {
    super.initState();
    AppProvider provider = AppProvider.getInstance();
    geoBloc = GeoBloc(provider.sharedPrefsService, provider.envService);
    positionBloc = PositionBloc(provider.positionService);
    locationBloc = LocationBloc(provider.sharedPrefsService);
    weatherBloc = WeatherBloc(provider.sharedPrefsService, provider.envService,
        geoBloc: geoBloc);
    geoBloc.getPopularCities();
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: const Text('Select city'),
        cupertino: (_, __) =>
            CupertinoNavigationBarData(border: const Border()),
      ),
      iosContentPadding: true,
      body: SafeArea(
        bottom: false,
        top: false,
        left: false,
        right: false,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SearchField(
              cities: geoBloc.searchedLocations,
              onCityByLocationRequest: () {
                positionBloc.getCurrentPosition((e) {
                  Fluttertoast.showToast(
                      msg: e.toString(),
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: Constants.TOAST_DEFAULT_LOCATION,
                      timeInSecForIosWeb: 3,
                      backgroundColor: Constants.ERROR_COLOR,
                      textColor: Colors.white,
                      fontSize: 16.0);
                });
              },
              onSearchCity: (query) => geoBloc.searchQuery(query),
            ),
            Expanded(
              child: StreamBuilder(
                stream: weatherBloc.citiesWeatherForecast,
                builder: (context, snapshot) {
                  List<WeatherForecast>? forecasts =
                      snapshot.data as List<WeatherForecast>?;
                  if (forecasts == null) return Container();
                  return GridView.builder(
                    itemCount: forecasts.length,
                    primary: true,
                    shrinkWrap: false,
                    padding: EdgeInsets.zero,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 16,
                            crossAxisCount: 2,
                            childAspectRatio: 1),
                    itemBuilder: (context, index) {
                      return CityCard(
                          weatherForecast: forecasts.elementAt(index));
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
