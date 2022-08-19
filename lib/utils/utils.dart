import 'dart:convert';
import 'dart:math';

import 'package:client/types/weather_providers.dart';
import 'package:client/types/weather_units.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

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

String currentLocale(BuildContext context) {
  return Localizations.localeOf(context).languageCode;
}

bool isRtl(BuildContext context) {
  return ['fa', 'ar', 'he'].contains(currentLocale(context)) ? true : false;
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

String translateThemeMode(ThemeMode themeMode, AppLocalizations t) {
  switch (themeMode) {
    case ThemeMode.light:
      return t.themeModeLight;
    case ThemeMode.dark:
      return t.themeModeDark;
    case ThemeMode.system:
      return t.themeModeSystem;
    default:
      return '';
  }
}

String translatedLocale(Locale locale, AppLocalizations t) {
  switch (locale.languageCode) {
    case 'en':
      return t.languageEn;
    default:
      return '';
  }
}

Brightness? themeModeToBrightness(ThemeMode themeMode) {
  switch (themeMode) {
    case ThemeMode.light:
      return Brightness.light;
    case ThemeMode.dark:
      return Brightness.dark;
    case ThemeMode.system:
      return null;
    default:
      return null;
  }
}

void showPlatformActionSheet<T>(
    {required BuildContext context,
    required List<T> items,
    required Function(T) onSelect,
    required Function(T) translateItem,
    required String title,
    required String cancelText}) {
  if (isCupertino(context)) {
    showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
              title: Text(title),
              actions: items
                  .map((e) => CupertinoActionSheetAction(
                      onPressed: () {
                        onSelect(e);
                        Navigator.pop(context);
                      },
                      child: Text(translateItem(e))))
                  .toList(),
            ));
  } else {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(cancelText))
              ],
              content: Column(
                children: items
                    .map((e) => TextButton(
                        onPressed: () {
                          onSelect(e);
                          Navigator.pop(context);
                        },
                        child: Text(translateItem(e))))
                    .toList(),
              ),
            ));
  }
}
