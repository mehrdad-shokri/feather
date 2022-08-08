import 'package:client/rx/blocs/rx_bloc.dart';
import 'package:client/rx/services/shared_prefs_service.dart';
import 'package:client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SettingsBloc extends RxBloc {
  final SharedPrefsService _sharedPrefsService;
  final _isFirstVisit = BehaviorSubject<bool>();
  final _locale = BehaviorSubject<Locale>();

  Stream<Locale> get locale => _locale.stream;

  Stream<bool> get isFirstVisit => _isFirstVisit.stream;

  SettingsBloc(this._sharedPrefsService) {
    _sharedPrefsService.instance.remove(Constants.IS_FIRST_VISIT_PREFS);
    _isFirstVisit.add(
        _sharedPrefsService.instance.getBool(Constants.IS_FIRST_VISIT_PREFS) ??
            true);
    _locale.add(Locale(
        _sharedPrefsService.instance.getString(Constants.USER_LOCALE_PREFS) ??
            'en'));
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
}
