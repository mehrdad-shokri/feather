import 'dart:io';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'dart:convert';
import 'dart:math';

import 'package:client/types/weather_providers.dart';
import 'package:client/types/weather_units.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';

String languageCodeFromLocaleName(String localeName) =>
    localeName.split('_').first;

String countryFromLocaleName(String localeName) => localeName.split('_').last;

bool strNotEmpty(String? str) {
  return !strEmpty(str);
}

bool strEmpty(String? str) {
  return str == null || str.isEmpty;
}

String randString(int len) {
  var random = Random.secure();
  var values = List<int>.generate(len, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}

String toSHA256(String input) {
  var bytes = utf8.encode(input);
  var digest = sha256.convert(bytes);
  return digest.toString();
}

String timeTo2Digit(int? digit) {
  if (digit == null) return '';
  if (digit.toString().length == 1) {
    return '0$digit';
  } else {
    return digit.toString();
  }
}

TextDirection correctDirection(String input) {
  return input.startsWith(RegExp(r'[A-Za-z0-9]'))
      ? TextDirection.ltr
      : TextDirection.rtl;
}

TextAlign correctAlignment(String input) {
  return input.startsWith(RegExp(r'[A-Za-z0-9]'))
      ? TextAlign.left
      : TextAlign.right;
}

String currentLocale(BuildContext context) {
  return Localizations.localeOf(context).languageCode;
}

bool isRtl(BuildContext context) {
  return currentLocale(context) == 'fa' ? true : false;
}

T? firstOrNull<T>(Iterable<T> items, callback) {
  try {
    return items.firstWhere(callback);
  } catch (e) {
    return null;
  }
}

String windSpeedUnit(WeatherUnits metric) =>
    metric == WeatherUnits.metric ? ' km/h' : ' mph';

String translateWeatherProvider(
    WeatherApiProvider provider, AppLocalizations t) {
  switch (provider) {
    case WeatherApiProvider.openWeatherMap:
      return t.openWeatherMap;
    default:
      return '';
  }
}
