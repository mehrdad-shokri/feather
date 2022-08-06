import 'package:client/rx/blocs/rx_bloc.dart';
import 'package:client/rx/services/shared_prefs_service.dart';
import 'package:client/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SettingsBloc extends RxBloc {
  final SharedPrefsService sharedPrefsService;
  final _isFirstVisit = BehaviorSubject<bool>();
  final _locale = BehaviorSubject<Locale>();

  Stream<Locale> get locale => _locale.stream;

  SettingsBloc(this.sharedPrefsService) {
    _isFirstVisit.add(
        sharedPrefsService.instance.getBool(Constants.IS_FIRST_VISIT_PREFS) ??
            true);
    _locale.add(Locale(
        sharedPrefsService.instance.getString(Constants.USER_LOCALE_PREFS) ??
            'en'));
  }

  void onLocaleChanged(Locale locale) {
    _locale.add(locale);
    addFutureSubscription(
        sharedPrefsService.instance
            .setString(Constants.USER_LOCALE_PREFS, locale.languageCode),
        () {},
        (e) {});
  }
}
