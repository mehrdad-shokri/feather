// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:client/types/geo_providers.dart';
import 'package:client/types/weather_providers.dart';
import 'package:client/types/weather_units.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Constants {
  Constants._();

  static const String USER_LOCALE_PREFS = 'user_locale';
  static const String USER_LOCATION_PREFS = 'user_location';
  static const String IS_FIRST_VISIT_PREFS = 'is_first_visit';
  static const String WEATHER_API_PROVIDER_PREFS = 'weather_api_provider';
  static const String WEATHER_UNITS_PREFS = 'weather_api_units';
  static const String GEO_API_PROVIDER_PREFS = 'geo_api_provider';

  static final Color PRIMARY_COLOR = Colors.blue.shade300;
  static final Color PRIMARY_COLOR_DARK = Colors.blue.shade500;
  static final Color PRIMARY_COLOR_LIGHT = Colors.blue.shade200;

  static final Color SECONDARY_COLOR = Colors.yellow.shade800;
  static final Color SECONDARY_COLOR_DARK = Colors.yellow.shade900;
  static final Color SECONDARY_COLOR_LIGHT = Colors.yellow.shade700;

  static const Color ERROR_COLOR = Color.fromRGBO(237, 46, 126, 1);
  static const Color ERROR_COLOR_DARK = Color.fromRGBO(195, 0, 82, 1);
  static const Color ERROR_COLOR_LIGHT = Color.fromRGBO(255, 242, 247, 1);
  static const Color SUCCESS_COLOR = Color.fromRGBO(0, 186, 136, 1);
  static const Color SUCCESS_COLOR_DARK = Color.fromRGBO(0, 186, 136, 1);
  static const Color WARNING_COLOR = Color.fromRGBO(244, 183, 64, 1);
  static const Color WARNING_COLOR_LIGHT = Color.fromRGBO(255, 240, 212, 1);
  static const Color WARNING_COLOR_DARK = Color.fromRGBO(162, 107, 0, 1);

  static const Color TEXT_BLACK_COLOR = Color.fromRGBO(20, 20, 43, 1);
  static const Color TEXT_BLACK_COLOR_DARK = Color.fromRGBO(235, 235, 212, 1.0);
  static const Color TEXT_BODY_COLOR = Color.fromRGBO(78, 75, 102, 1.0);
  static const Color TEXT_BODY_COLOR_DARK = Color.fromRGBO(203, 203, 203, 1);
  static const Color TEXT_LABEL_COLOR = Color.fromRGBO(110, 113, 145, 1);
  static const Color TEXT_LABEL_COLOR_DARK = Color.fromRGBO(145, 142, 110, 1.0);
  static const Color PLACEHOLDER_COLOR = Color.fromRGBO(160, 163, 189, 1);
  static const Color PLACEHOLDER_COLOR_DARK = Color.fromRGBO(95, 92, 66, 1.0);
  static const Color LINE_COLOR = Color.fromRGBO(214, 216, 231, 1);
  static const Color LINE_COLOR_DARK = Color.fromRGBO(41, 39, 24, 1.0);

  static const Color BACKGROUND_COLOR = Color.fromRGBO(239, 243, 247, 1.0);
  static const Color BACKGROUND_COLOR_DARK = Color.fromRGBO(16, 12, 8, 1.0);
  static const Color INPUT_BACKGROUND_COLOR = Color.fromRGBO(239, 240, 246, 1);
  static const Color INPUT_BACKGROUND_COLOR_DARK =
      Color.fromRGBO(16, 15, 9, 1.0);

  static const double ICON_SMALL_SIZE = 18;
  static const double ICON_MEDIUM_SIZE = 24;
  static const double ICON_LARGE_SIZE = 32;
  static const double CAPTION_FONT_SIZE = 12;
  static const double S2_FONT_SIZE = 14;
  static const double S1_FONT_SIZE = 16;
  static const double H6_FONT_SIZE = 18;
  static const double H5_FONT_SIZE = 21;
  static const double H4_FONT_SIZE = 24;
  static const double H3_FONT_SIZE = 28;
  static const double H2_FONT_SIZE = 31;
  static const double H1_FONT_SIZE = 34;
  static const FontWeight REGULAR_FONT_WEIGHT = FontWeight.w400;
  static const FontWeight MEDIUM_FONT_WEIGHT = FontWeight.w500;
  static const FontWeight BOLD_FONT_WEIGHT = FontWeight.bold;
  static const String APPLICATION_DEFAULT_FONT = 'Roboto';
  static const List<String> APPLICATION_FALLBACK_FONTS = ['sans-serif'];
  static const EdgeInsets PAGE_PADDING = EdgeInsets.symmetric(horizontal: 16);
  static const EdgeInsets CARD_INNER_PADDING =
      EdgeInsets.symmetric(horizontal: 12, vertical: 12);
  static final ShapeBorder CARD_SHAPE =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(8));

  static const ToastGravity TOAST_DEFAULT_LOCATION = ToastGravity.BOTTOM;
  static const Locale DEFAULT_LOCALE = Locale('en');
  static const WeatherUnits DEFAULT_WEATHER_API_UNITS = WeatherUnits.metric;
  static const WeatherApiProvider DEFAULT_WEATHER_API_PROVIDER =
      WeatherApiProvider.openWeatherMap;

  static const GeoApiProvider DEFAULT_GEO_API_PROVIDER =
      GeoApiProvider.openWeatherMap;

  static const String OPEN_WEATHER_MAP_API_KEY_ENV = 'OPEN_WEATHER_MAP_API_KEY';

  static const List<Map<String, dynamic>> POPULAR_CITIES = [
    {"country": "GB", "name": "London", "lat": "51.51279", "lng": "-0.09184"},
    {"country": "FR", "name": "Paris", "lat": "48.85341", "lng": "2.3488"},
    {"country": "DE", "name": "Berlin", "lat": "52.52003", "lng": "13.4050"},
    {"country": "ES", "name": "Barcelona", "lat": "41.38879", "lng": "2.15899"},
    {"country": "NL", "name": "Amsterdam", "lat": "52.37403", "lng": "4.88969"},
    {
      "country": "US",
      "name": "New York City",
      "lat": "40.71427",
      "lng": "-74.00597"
    },
    {
      "country": "US",
      "name": "San Francisco",
      "lat": "37.77493",
      "lng": "-122.41942"
    },
    {"country": "JP", "name": "Tokyo", "lat": "35.6895", "lng": "139.69171"},
    {"country": "CN", "name": "Beijing", "lat": "39.9075", "lng": "116.39723"},
    {
      "country": "SE",
      "name": "Stockholm",
      "lat": "59.32938",
      "lng": "18.06871"
    },
  ];
}
