import 'dart:async';

import 'package:client/models/location.dart';
import 'package:client/rx/blocs/rx_bloc.dart';
import 'package:client/rx/managers/geo_api.dart';
import 'package:client/rx/managers/geo_providers/open_weather_map.dart';
import 'package:client/rx/services/env_service.dart';
import 'package:client/rx/services/shared_prefs_service.dart';
import 'package:client/types/geo_providers.dart';
import 'package:client/utils/constants.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:rxdart/rxdart.dart';

class GeoBloc extends RxBloc {
  final SharedPrefsService _sharedPrefsService;
  final EnvService _envService;
  final _geoApiProvider = BehaviorSubject<GeoApiProviders>();
  final _geoApi = BehaviorSubject<GeoApi>();
  final _lang = BehaviorSubject<String>();
  final _reverseGeoLocation = BehaviorSubject<Location>();
  final _searchedLocations = BehaviorSubject<List<Location>>();

  Stream<Location> get reverseGeoLocation => _reverseGeoLocation.stream;

  Stream<List<Location>> get searchedLocations => _searchedLocations.stream;

  GeoBloc(this._sharedPrefsService, this._envService) {
    String? geoApiProvider = _sharedPrefsService.instance
        .getString(Constants.GEO_API_PROVIDER_PREFS);
    String? lang =
        _sharedPrefsService.instance.getString(Constants.USER_LOCALE_PREFS) ??
            'en';
    GeoApiProviders provider = geoApiProvider != null
        ? EnumToString.fromString(GeoApiProviders.values, geoApiProvider)!
        : Constants.DEFAULT_GEO_API_PROVIDER;
    _geoApiProvider.add(provider);
    _lang.add(lang);
    _lang.listen((value) {
      _instantiateGeoApi(_geoApiProvider.value, value);
    });
    _geoApiProvider.listen((value) {
      _geoApi.add(_instantiateGeoApi(value, _lang.value));
    });
    _instantiateGeoApi(_geoApiProvider.value, _lang.value);
  }

  void reverseGeoCode(double lat, double lon, Function onData) {
    addFutureSubscription(_geoApi.value.reverseGeocode(lat, lon),
        (Location? location) {
      if (location != null) _reverseGeoLocation.add(location);
      onData(location);
    }, (e) {});
  }

  void searchQuery(String? query) {
    if (query != null && query.length >= 3) {
      addFutureSubscription(_geoApi.value.searchByQuery(query),
          (List<Location>? locations) {
        if (locations != null) _searchedLocations.add(locations);
      }, (e) {});
    }
  }

  void onGeoApiProviderChanged(GeoApiProviders geoApiProvider) {
    _geoApiProvider.add(geoApiProvider);
    addFutureSubscription(
        _sharedPrefsService.instance.setString(Constants.GEO_API_PROVIDER_PREFS,
            EnumToString.convertToString(geoApiProvider)),
        (_) {},
        (e) {});
  }

  void getPopularCities() {
    _searchedLocations.add(
        Constants.POPULAR_CITIES.map((e) => Location.fromAsset(e)).toList());
  }

  void onLangChanged(String lang) {
    _lang.add(lang);
  }

  GeoApi _instantiateGeoApi(GeoApiProviders provider, String lang) {
    switch (provider) {
      case GeoApiProviders.openWeatherMap:
        return OpenWeatherMapGeoApi(
            _envService.envs[Constants.OPEN_WEATHER_MAP_API_KEY_ENV] ?? '',
            lang);
      default:
        return OpenWeatherMapGeoApi(
            _envService.envs[Constants.OPEN_WEATHER_MAP_API_KEY_ENV] ?? '',
            lang);
    }
  }
}
