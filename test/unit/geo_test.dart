import 'dart:convert';
import 'dart:io';

import 'package:client/types/location.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Geocoding test', () {
    test('It constructs Location from Openweathermap reverse geocoding', () {
      List json = jsonDecode(
          File('test/fixtures/open_weather_map_reverse_geo.json')
              .readAsStringSync()) as List;
      Location location = Location.fromOpenWeatherMapReverseGeocode(
          json.first as Map<String, dynamic>, 51.5073219, -0.1276474, 'en');
      expect(location.cityName, equals('London'));
      expect(location.country, equals('GB'));
      expect(location.state, equals('England'));
      expect(location.lat, equals(51.5073219));
      expect(location.lon, equals(-0.1276474));
    });
    test(
        'It constructs correct location language from Openweathermap reverse geocoding',
        () {
      List json = jsonDecode(
          File('test/fixtures/open_weather_map_reverse_geo.json')
              .readAsStringSync()) as List;
      Location location = Location.fromOpenWeatherMapReverseGeocode(
          json.first as Map<String, dynamic>, 51.5073219, -0.1276474, 'fr');
      expect(location.country, equals('GB'));
      expect(location.state, equals('England'));
      expect(location.cityName, equals('Londres'));
      expect(location.lat, equals(51.5073219));
      expect(location.lon, equals(-0.1276474));
    });
    test('It constructs a set of Locations from OpenWeatherMap geocoding', () {
      List json = jsonDecode(
          File('test/fixtures/open_weather_map_query_geo.json')
              .readAsStringSync()) as List;
      Location location = Location.fromOpenWeatherMapGeocode(
          json.first as Map<String, dynamic>, 'en');
      expect(location.country, equals('GB'));
      expect(location.state, equals('England'));
      expect(location.cityName, equals('London'));
      expect(location.lat, equals(51.5073219));
      expect(location.lon, equals(-0.1276474));
    });
  });
}
