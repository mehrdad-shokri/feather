import 'package:client/models/location.dart';
import 'package:client/rx/blocs/rx_bloc.dart';
import 'package:client/rx/services/shared_prefs_service.dart';
import 'package:client/types/weather_providers.dart';
import 'package:client/types/weather_units.dart';
import 'package:client/utils/constants.dart';
import 'package:client/utils/utils.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SettingsBloc extends RxBloc {
  final SharedPrefsService _sharedPrefsService;
  final _isFirstVisit = BehaviorSubject<bool>();
  final _locale = BehaviorSubject<Locale>();
  final _activeLocation = BehaviorSubject<Location?>();
  late final _weatherApiProvider = BehaviorSubject<WeatherApiProvider>();
  late final _weatherApiUnits = BehaviorSubject<WeatherUnits>();

  Stream<Locale> get locale => _locale.stream;

  Stream<bool> get isFirstVisit => _isFirstVisit.stream;

  Stream<Location?> get activeLocation => _activeLocation.stream;

  SettingsBloc(this._sharedPrefsService) {
    _sharedPrefsService.instance.remove(Constants.IS_FIRST_VISIT_PREFS);
    _isFirstVisit.add(
        _sharedPrefsService.instance.getBool(Constants.IS_FIRST_VISIT_PREFS) ??
            true);
    _locale.add(Locale(
        _sharedPrefsService.instance.getString(Constants.USER_LOCALE_PREFS) ??
            'en'));
    String? locationPrefs =
        _sharedPrefsService.instance.getString(Constants.USER_LOCATION_PREFS);
    if (strNotEmpty(locationPrefs)) {
      _activeLocation.add(Location.fromPrefsJson(locationPrefs!));
    }
    String? weatherApiProviderPrefs = _sharedPrefsService.instance
        .getString(Constants.WEATHER_API_PROVIDER_PREFS);
    String? weatherUnitsPrefs =
        _sharedPrefsService.instance.getString(Constants.WEATHER_UNITS_PREFS);

    WeatherUnits weatherApiUnits = weatherUnitsPrefs != null
        ? EnumToString.fromString(WeatherUnits.values, weatherUnitsPrefs)!
        : Constants.DEFAULT_WEATHER_API_UNITS;
    WeatherApiProvider weatherApiProvider = weatherApiProviderPrefs != null
        ? EnumToString.fromString(
            WeatherApiProvider.values, weatherApiProviderPrefs)!
        : Constants.DEFAULT_WEATHER_API_PROVIDER;

    _weatherApiUnits.add(weatherApiUnits);
    _weatherApiProvider.add(weatherApiProvider);
  }

  void onLocaleChanged(Locale locale) {
    _locale.add(locale);
    addFutureSubscription(_sharedPrefsService.instance
        .setString(Constants.USER_LOCALE_PREFS, locale.languageCode));
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

  void onWeatherApiProviderChanged(WeatherApiProvider provider) {
    _weatherApiProvider.add(provider);
    addFutureSubscription(
        _sharedPrefsService.instance.setString(
            Constants.WEATHER_API_PROVIDER_PREFS,
            EnumToString.convertToString(provider)),
        (data) {},
        (e) {});
  }

  void onUnitsChanged(WeatherUnits unit) {
    _weatherApiUnits.add(unit);
    addFutureSubscription(
      _sharedPrefsService.instance.setString(
          Constants.WEATHER_UNITS_PREFS, EnumToString.convertToString(unit)),
    );
  }
}
