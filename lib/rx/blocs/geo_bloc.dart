import 'dart:async';

import 'package:client/models/location.dart';
import 'package:client/rx/blocs/rx_bloc.dart';
import 'package:client/rx/blocs/weather_bloc.dart';
import 'package:client/rx/managers/geo_api.dart';
import 'package:client/rx/managers/geo_providers/mock.dart';
import 'package:client/rx/managers/geo_providers/open_weather_map.dart';
import 'package:client/rx/services/env_service.dart';
import 'package:client/types/geo_providers.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class GeoBloc extends RxBloc {
  final EnvService _envService;
  final _reverseGeoLocation = BehaviorSubject<Location>();
  final _searchedLocations = BehaviorSubject<List<Location>>();
  final _searchingLocations = BehaviorSubject<bool>();
  final WeatherBloc weatherBloc;
  Timer? _citySearchDebounce;
  GeoApi _geoApi = MockGeoApi();
  GeoApiProvider _geoApiProvider = Constants.DEFAULT_GEO_API_PROVIDER;
  String _lang = Constants.DEFAULT_LOCALE.languageCode;

  Stream<Location> get reverseGeoLocation => _reverseGeoLocation.stream;

  Stream<List<Location>> get searchedLocations => _searchedLocations.stream;

  Stream<bool> get searchingLocations => _searchingLocations.stream;

  GeoBloc(Stream<Locale> locale, Stream<GeoApiProvider> provider,
      this._envService, this.weatherBloc) {
    // _geoApi = _instantiateGeoApi(_geoApiProvider, _lang);
    locale.listen((event) {
      _lang = event.languageCode;
      _geoApi = _instantiateGeoApi(_geoApiProvider, event.languageCode);
    });
    provider.listen((event) {
      _geoApiProvider = event;
      _geoApi = _instantiateGeoApi(event, _lang);
    });
  }

  void reverseGeoCode(double lat, double lon, Function onData) {
    addFutureSubscription(_geoApi.reverseGeocode(lat, lon),
        (Location? location) {
      if (location != null) _reverseGeoLocation.add(location);
      onData(location);
    }, (e) {});
  }

  void searchQuery(String? query) {
    if (_citySearchDebounce?.isActive ?? false) {
      _citySearchDebounce?.cancel();
    }
    _citySearchDebounce = Timer(const Duration(milliseconds: 800), () {
      _searchingLocations.add(true);
      print('searching ${query}');
      if (strEmpty(query) || query!.length < 3) {
        loadLocationsFromAsset();
      } else {
        addFutureSubscription(_geoApi.searchByQuery(query),
            (List<Location> event) {
          _searchingLocations.add(false);
          _searchedLocations.add(event);
          List<Location> locations = event;
          for (Location element in locations) {
            weatherBloc.getCurrentForecast(element.lat, element.lon,
                (forecast) {
              element.forecast = forecast;
              locations[locations.indexWhere((l) => l == element)] = element;
              _searchedLocations.add(locations);
            });
          }
        }, (e) {
          _searchingLocations.add(false);
        });
      }
    });
  }

  void loadLocationsFromAsset() {
    _searchingLocations.add(true);
    List<Location> locations =
        Constants.POPULAR_CITIES.map((e) => Location.fromAsset(e)).toList();
    _searchedLocations.add(locations);
    for (Location element in locations) {
      weatherBloc.getCurrentForecast(element.lat, element.lon, (forecast) {
        element.forecast = forecast;
        locations[locations.indexWhere((l) => l == element)] = element;
        _searchedLocations.add(locations);
      });
    }
    _searchingLocations.add(false);
  }

  GeoApi _instantiateGeoApi(GeoApiProvider provider, String lang) {
    switch (provider) {
      case GeoApiProvider.openWeatherMap:
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
