import 'package:client/components/city_card.dart';
import 'package:client/components/city_search_field.dart';
import 'package:client/models/location.dart';
import 'package:client/rx/blocs/geo_bloc.dart';
import 'package:client/rx/blocs/position_bloc.dart';
import 'package:client/rx/blocs/settings_bloc.dart';
import 'package:client/rx/blocs/weather_bloc.dart';
import 'package:client/rx/services/service_provider.dart';
import 'package:client/types/home_page_arguments.dart';
import 'package:client/utils/colors.dart';
import 'package:client/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CitySearchPage extends StatefulWidget {
  const CitySearchPage({Key? key}) : super(key: key);

  @override
  State<CitySearchPage> createState() => _CitySearchPageState();
}

class _CitySearchPageState extends State<CitySearchPage>
    with SingleTickerProviderStateMixin {
  String? searchedPhrase;
  AppLocalizations? appLocalizations;

  late GeoBloc geoBloc;
  late PositionBloc positionBloc;
  late WeatherBloc weatherBloc;
  late SettingsBloc settingsBloc;

  @override
  void initState() {
    super.initState();
    ServiceProvider provider = ServiceProvider.getInstance();
    settingsBloc = SettingsBloc(provider.sharedPrefsService);
    weatherBloc = WeatherBloc(provider.sharedPrefsService, provider.envService);
    geoBloc = GeoBloc(settingsBloc.locale, settingsBloc.geoApiProvider,
        provider.envService, weatherBloc);
    positionBloc = PositionBloc(provider.positionService);
    geoBloc.loadLocationsFromAsset();
  }

  void onLocationUpdated(Location location) {
    settingsBloc.onLocationChanged(location);
    settingsBloc.onFirstVisited();
    Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => true,
        arguments: HomePageArguments(location));
  }

  @override
  Widget build(BuildContext context) {
    appLocalizations ??= AppLocalizations.of(context);

    return PlatformScaffold(
        iosContentPadding: true,
        backgroundColor: backgroundColor(context),
        body: SafeArea(
            bottom: false,
            top: false,
            left: false,
            right: false,
            child: CustomScrollView(
              slivers: [
                PlatformWidget(
                  cupertino: (context, _) => CupertinoSliverNavigationBar(
                    padding: EdgeInsetsDirectional.zero,
                    largeTitle: SearchField(
                      cities: geoBloc.searchedLocations,
                      t: appLocalizations!,
                      onGetCurrentPosition: () {
                        positionBloc.getCurrentPosition(
                            onPositionReceived: (position) {
                              geoBloc.reverseGeoCode(
                                  position.latitude, position.longitude,
                                  onLocation: (location) {
                                onLocationUpdated(location);
                              });
                            },
                            onError: (e) {
                              Fluttertoast.showToast(
                                  msg: e.toString(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: Constants.TOAST_DEFAULT_LOCATION,
                                  timeInSecForIosWeb: 3,
                                  backgroundColor: Constants.ERROR_COLOR,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            },
                            onPermissionDenied: () {},
                            onPermissionDeniedForever: () {});
                      },
                      loadingCurrentPosition:
                          positionBloc.requestingCurrentLocation.mergeWith(
                              [positionBloc.requestingLocationPermission]),
                      onSearchCity: (query) {
                        setState(() {
                          searchedPhrase = query;
                        });
                        geoBloc.searchQuery(query);
                      },
                      onAutoCompleteCity: (query) {
                        setState(() {
                          searchedPhrase = query;
                        });
                        geoBloc.searchQuery(query);
                      },
                    ),
                    border: Border(
                        bottom:
                            BorderSide(color: dividerColor(context), width: 1)),
                    middle: Text(
                      appLocalizations!.chooseCity,
                      style: TextStyle(
                          color: headingColor(context),
                          fontSize: Constants.H6_FONT_SIZE,
                          fontWeight: Constants.MEDIUM_FONT_WEIGHT),
                    ),
                  ),
                  material: (context, _) => SliverAppBar(
                    title: Text(
                      appLocalizations!.chooseCity,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: headingColor(context),
                          fontSize: Constants.H6_FONT_SIZE,
                          fontWeight: Constants.MEDIUM_FONT_WEIGHT),
                    ),
                    iconTheme:
                        IconThemeData(color: appbarBackIconColor(context)),
                    pinned: true,
                    primary: true,
                    floating: false,
                    stretch: false,
                    elevation: 4,
                    forceElevated: true,
                    backgroundColor: barBackgroundColor(context),
                    expandedHeight: kToolbarHeight + 32,
                    collapsedHeight: kToolbarHeight + 32,
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(24),
                      child: SearchField(
                        cities: geoBloc.searchedLocations,
                        t: appLocalizations!,
                        onGetCurrentPosition: () {
                          positionBloc.getCurrentPosition(
                              onPositionReceived: (position) {
                                geoBloc.reverseGeoCode(
                                    position.latitude, position.longitude,
                                    onLocation: (location) {
                                  onLocationUpdated(location);
                                });
                              },
                              onError: (e) {
                                Fluttertoast.showToast(
                                    msg: e.toString(),
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: Constants.TOAST_DEFAULT_LOCATION,
                                    timeInSecForIosWeb: 3,
                                    backgroundColor: Constants.ERROR_COLOR,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                              },
                              onPermissionDenied: () {},
                              onPermissionDeniedForever: () {});
                        },
                        loadingCurrentPosition:
                            positionBloc.requestingCurrentLocation.mergeWith(
                                [positionBloc.requestingLocationPermission]),
                        onSearchCity: (query) {
                          setState(() {
                            searchedPhrase = query;
                            geoBloc.searchQuery(query);
                          });
                        },
                        onAutoCompleteCity: (query) {
                          searchedPhrase = query;
                          geoBloc.searchQuery(query);
                        },
                      ),
                    ),
                  ),
                ),
                PlatformWidget(
                  cupertino: (_, __) => CupertinoSliverRefreshControl(
                    refreshTriggerPullDistance: 250,
                    refreshIndicatorExtent: 50,
                    onRefresh: () async {
                      await geoBloc.onRefresh(searchedPhrase);
                    },
                  ),
                  material: (_, __) => const SliverToBoxAdapter(),
                ),
                StreamBuilder(
                  stream: geoBloc.searchingLocations,
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
                        clipBehavior: Clip.none,
                        margin: const EdgeInsets.only(top: 8),
                        child: PlatformCircularProgressIndicator(),
                      ),
                      secondChild: Container(
                        height: 0,
                      ),
                    ));
                  },
                ),
                StreamBuilder(
                  stream: geoBloc.searchedLocations,
                  builder: (context, snapshot) {
                    List<Location>? locations =
                        snapshot.data as List<Location>?;
                    if (locations == null) {
                      return SliverToBoxAdapter(
                        child: Container(),
                      );
                    }
                    if (locations.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 64, horizontal: 16),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Lottie.asset('assets/lottie/astronaut.json',
                                  alignment: Alignment.center,
                                  width: 240,
                                  fit: BoxFit.contain),
                              const SizedBox(
                                height: 16,
                              ),
                              Text(
                                'City not found',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: Constants.H6_FONT_SIZE,
                                    fontWeight: Constants.MEDIUM_FONT_WEIGHT,
                                    color: textColor(context)),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                'Make sure it\'s been founded by the time you search it, you know...',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: secondaryTextColor(context),
                                  fontSize: Constants.S1_FONT_SIZE,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                                  location: locations.elementAt(index),
                                  key: Key(locations.elementAt(index).id),
                                  shouldAddMargin: index <= 1,
                                  onPress: () {
                                    onLocationUpdated(
                                        locations.elementAt(index));
                                  },
                                ),
                            childCount: locations.length),
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

  @override
  void dispose() {
    super.dispose();
    geoBloc.dispose();
    weatherBloc.dispose();
    settingsBloc.dispose();
    positionBloc.dispose();
  }
}
