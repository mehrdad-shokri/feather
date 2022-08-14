import 'package:client/components/city_card.dart';
import 'package:client/components/city_search_field.dart';
import 'package:client/models/weather_forecast.dart';
import 'package:client/rx/blocs/geo_bloc.dart';
import 'package:client/rx/blocs/location_bloc.dart';
import 'package:client/rx/blocs/position_bloc.dart';
import 'package:client/rx/blocs/weather_bloc.dart';
import 'package:client/rx/services/service_provider.dart';
import 'package:client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CitySearchPage extends StatefulWidget {
  const CitySearchPage({Key? key}) : super(key: key);

  @override
  State<CitySearchPage> createState() => _CitySearchPageState();
}

class _CitySearchPageState extends State<CitySearchPage>
    with SingleTickerProviderStateMixin {
  late GeoBloc geoBloc;
  late PositionBloc positionBloc;
  late LocationBloc locationBloc;
  late WeatherBloc weatherBloc;
  late AnimationController controller;
  late Animation<Offset> offset;

  @override
  void initState() {
    super.initState();
    ServiceProvider provider = ServiceProvider.getInstance();
    geoBloc = GeoBloc(provider.sharedPrefsService, provider.envService);
    positionBloc = PositionBloc(provider.positionService);
    locationBloc = LocationBloc(provider.sharedPrefsService);
    weatherBloc = WeatherBloc(provider.sharedPrefsService, provider.envService,
        geoBloc: geoBloc);
    geoBloc.getPopularCities();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    offset = Tween<Offset>(begin: const Offset(0, -20), end: const Offset(0, 1))
        .animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      iosContentPadding: false,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Choose a city'),
            flexibleSpace: SearchField(
              cities: geoBloc.searchedLocations,
              onGetCurrentPosition: () {
                locationBloc.onLoadingCurrentLocation();
                positionBloc.getCurrentPosition((position) {
                  geoBloc.reverseGeoCode(position.latitude, position.longitude,
                      (location) {
                    locationBloc.onLocationUpdated(location);
                  });
                }, (e) {
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
              loadingCurrentCity: locationBloc.updatingCurrentLocation,
              onSearchCity: (query) => geoBloc.searchQuery(query),
              onAutoCompleteCity: (query) => geoBloc.searchQuery(query),
            ),
          ),
          StreamBuilder(
            stream: weatherBloc.citiesWeatherForecast,
            builder: (context, snapshot) {
              List<WeatherForecast>? forecasts =
                  snapshot.data as List<WeatherForecast>?;
              return forecasts == null
                  ? SliverToBoxAdapter(
                      child: Container(),
                    )
                  : SliverGrid(
                      delegate: SliverChildBuilderDelegate((context, index) =>
                          CityCard(
                              weatherForecast: forecasts.elementAt(index),
                              key: Key('$index'),
                              shouldAddMargin: index <= 1)),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              crossAxisCount: 2,
                              childAspectRatio: 1));
            },
          ),
        ],
      ),
    );
  }
}
/*
Column(
mainAxisSize: MainAxisSize.max,
children: [
Expanded(
child: Padding(
padding: Constants.PAGE_PADDING,
child: Stack(
alignment: Alignment.topCenter,
fit: StackFit.loose,
children: [
StreamBuilder(
stream: weatherBloc.citiesWeatherForecast,
builder: (context, snapshot) {
List<WeatherForecast>? forecasts =
snapshot.data as List<WeatherForecast>?;
return RefreshIndicator(
child: GridView.builder(
itemCount: forecasts.length,
primary: true,
shrinkWrap: false,
padding: EdgeInsets.zero,
gridDelegate:
const SliverGridDelegateWithFixedCrossAxisCount(
crossAxisSpacing: 16,
mainAxisSpacing: 16,
crossAxisCount: 2,
childAspectRatio: 1),
itemBuilder: (context, index) {
return CityCard(
weatherForecast:
forecasts.elementAt(index),
key: Key('${index}'),
shouldAddMargin: index <= 1);
},
),
onRefresh: () async {
return Future.delayed(Duration(seconds: 3));
// geoBloc.getPopularCities();
});
},
),
StreamBuilder(
stream: weatherBloc.loadingCitiesForecasts,
builder: (context, snapshot) {
bool? loading = snapshot.data as bool?;
if (loading != null && loading) {
controller.forward();
} else {
controller.reverse();
}
return AnimatedSwitcher(
duration: const Duration(milliseconds: 500),
reverseDuration:
const Duration(milliseconds: 500),
child: loading != null && loading
? Container(
margin: const EdgeInsets.symmetric(
vertical: 8),
child:
PlatformCircularProgressIndicator(),
)
    : null,
);
},
)
],
),
),
),
],
)*/
