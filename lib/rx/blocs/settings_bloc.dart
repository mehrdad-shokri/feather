import 'package:client/models/location.dart';
import 'package:client/rx/blocs/rx_bloc.dart';
import 'package:client/rx/services/shared_prefs_service.dart';
import 'package:client/types/geo_providers.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/utils.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SettingsBloc extends RxBloc {
  final Brightness _DEFAULT_THEME =
      WidgetsBinding.instance.window.platformBrightness;
  final SharedPrefsService _sharedPrefsService;
  final _isFirstVisit = BehaviorSubject<bool>();
  final _locale = BehaviorSubject<Locale>();
  final _activeLocation = BehaviorSubject<Location>();
  final _geoApiProvider = BehaviorSubject<GeoApiProvider>();
  final _themeMode = BehaviorSubject<Brightness>();

  Stream<Locale> get locale => _locale.stream;

  Stream<bool> get isFirstVisit => _isFirstVisit.stream;

  Stream<Location> get activeLocation => _activeLocation.stream;

  Stream<GeoApiProvider> get geoApiProvider => _geoApiProvider.stream;

  Stream<Brightness> get themeMode => _themeMode.stream;

  SettingsBloc(this._sharedPrefsService) {
    // _sharedPrefsService.instance.remove(Constants.IS_FIRST_VISIT_PREFS);
    _isFirstVisit.add(
        _sharedPrefsService.instance.getBool(Constants.IS_FIRST_VISIT_PREFS) ??
            true);
    String? localePrefs =
        _sharedPrefsService.instance.getString(Constants.USER_LOCALE_PREFS);
    _locale.add(strNotEmpty(localePrefs)
        ? Locale.fromSubtags(languageCode: localePrefs!)
        : Constants.DEFAULT_LOCALE);
    String? locationPrefs =
        _sharedPrefsService.instance.getString(Constants.USER_LOCATION_PREFS);
    if (strNotEmpty(locationPrefs)) {
      _activeLocation.add(Location.fromPrefsJson(locationPrefs!));
    }
    String? geoApiProvider = _sharedPrefsService.instance
        .getString(Constants.GEO_API_PROVIDER_PREFS);
    GeoApiProvider provider = geoApiProvider != null
        ? EnumToString.fromString(GeoApiProvider.values, geoApiProvider)!
        : Constants.DEFAULT_GEO_API_PROVIDER;
    _geoApiProvider.add(provider);
    String? themeMode =
        _sharedPrefsService.instance.getString(Constants.USER_THEME_PREFS);
    _themeMode.add(strNotEmpty(themeMode)
        ? EnumToString.fromString(Brightness.values, themeMode!) ??
            _DEFAULT_THEME
        : _DEFAULT_THEME);
  }

  void onLocaleChanged(Locale locale) {
    _locale.add(locale);
    addFutureSubscription(_sharedPrefsService.instance
        .setString(Constants.USER_LOCALE_PREFS, locale.languageCode));
  }

  void onThemeChanged(Brightness? brightness) {
    _themeMode.add(brightness ?? _DEFAULT_THEME);
    if (brightness != null) {
      addFutureSubscription(_sharedPrefsService.instance.setString(
          Constants.USER_THEME_PREFS,
          EnumToString.convertToString(brightness)));
    }
  }

  void onFirstVisited() {
    _isFirstVisit.add(false);
    addFutureSubscription(_sharedPrefsService.instance
        .setBool(Constants.IS_FIRST_VISIT_PREFS, false));
  }

  void onLocationChanged(Location location) {
    _activeLocation.add(location);
    addFutureSubscription(_sharedPrefsService.instance
        .setString(Constants.USER_LOCATION_PREFS, location.toPrefsJson()));
  }

  void onGeoApiProviderChanged(GeoApiProvider geoApiProvider) {
    _geoApiProvider.add(geoApiProvider);
    addFutureSubscription(_sharedPrefsService.instance.setString(
        Constants.GEO_API_PROVIDER_PREFS,
        EnumToString.convertToString(geoApiProvider)));
  }
}
