import 'package:client/components/city_card.dart';
import 'package:client/components/city_search_field.dart';
import 'package:client/models/weather_forecast.dart';
import 'package:client/rx/blocs/geo_bloc.dart';
import 'package:client/rx/blocs/location_bloc.dart';
import 'package:client/rx/blocs/position_bloc.dart';
import 'package:client/rx/blocs/weather_bloc.dart';
import 'package:client/rx/services/service_provider.dart';
import 'package:client/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';

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
    geoBloc.loadPopularCities();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    offset = Tween<Offset>(begin: const Offset(0, -20), end: const Offset(0, 1))
        .animate(controller);
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        iosContentPadding: true,
        body: SafeArea(
            bottom: false,
            top: false,
            left: false,
            right: false,
            child: CustomScrollView(
              slivers: [
                CupertinoSliverNavigationBar(
                  largeTitle: SearchField(
                    cities: geoBloc.searchedLocations,
                    onGetCurrentPosition: () {
                      locationBloc.onLoadingCurrentLocation();
                      positionBloc.getCurrentPosition((position) {
                        geoBloc.reverseGeoCode(
                            position.latitude, position.longitude, (location) {
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
                  middle: const Text('Choose a city'),
                ),
                CupertinoSliverRefreshControl(
                  onRefresh: () async {},
                  refreshIndicatorExtent: 16,
                ),
                StreamBuilder(
                  stream: geoBloc.searchingLocations
                      .mergeWith([weatherBloc.loadingCitiesForecasts]),
                  builder: (context, snapshot) {
                    bool? loading = snapshot.data as bool?;
                    return SliverToBoxAdapter(
                        child: AnimatedCrossFade(
                      duration: const Duration(milliseconds: 250),
                      reverseDuration: const Duration(milliseconds: 250),
                      crossFadeState: loading != null && loading
                          ? CrossFadeState.showFirst
                          : CrossFadeState.showSecond,
                      firstChild: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 8),
                        child: const CupertinoActivityIndicator(),
                      ),
                      secondChild: Container(
                        height: 0,
                      ),
                    ));
                  },
                ),
                StreamBuilder(
                  stream: weatherBloc.citiesWeatherForecast,
                  builder: (context, snapshot) {
                    List<WeatherForecast>? forecasts =
                        snapshot.data as List<WeatherForecast>?;
                    if (forecasts == null) {
                      return SliverToBoxAdapter(
                        child: Container(),
                      );
                    }
                    return SliverPadding(
                      padding: Constants.PAGE_PADDING,
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                crossAxisCount: 2,
                                childAspectRatio: 1),
                        delegate: SliverChildBuilderDelegate(
                            (context, index) => CityCard(
                                weatherForecast: forecasts.elementAt(index),
                                key: Key('$index'),
                                shouldAddMargin: index <= 1),
                            childCount: forecasts.length),
                      ),
                    );
                  },
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: 24,
                  ),
                )
              ],
            )));
  }
}
