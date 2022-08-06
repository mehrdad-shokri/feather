import 'package:client/models/location.dart';
import 'package:client/rx/managers/geo_providers/open_weather_map.dart';
import 'package:client/rx/services/env_service.dart';
import 'package:client/utils/constants.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late EnvService envService;
  late String openWeatherMapApiKey;
  List<double> lats = [
    35,
    35.7219,
    40.7128,
    37.773972,
    52.520008,
    52.3676,
    51.9244
  ];
  List<double> lons = [
    139,
    51.3347,
    -74.0060,
    -122.431297,
    13.404954,
    4.9041,
    4.4777
  ];
  double londonLat = 51.5073219;
  double londonLon = -0.1276474;
  setUp(() async {
    envService = EnvService('.env.test', true);
    await envService.onCreate();
    openWeatherMapApiKey =
        envService.envs[Constants.OPEN_WEATHER_MAP_API_KEY_ENV]!;
  });
  group('OpenWeatherMap Geo test', () {
    test('It reverse geocodes a latitude/longitude', () async {
      for (int i = 0; i < lats.length; i++) {
        double lat = lats[i];
        double lon = lons[i];
        OpenWeatherMapGeoApi openWeatherMap =
            OpenWeatherMapGeoApi(openWeatherMapApiKey, 'en');
        Location? location = await openWeatherMap.reverseGeocode(lat, lon);
        expect(location, isNot(null));
        if (location == null) throw Error();
        expect(location.cityName, isNot(null));
        expect(location.country, isNot(null));
        expect(location.lat, equals(lat));
        expect(location.lon, equals(lon));
      }
    });
    test('It reverse geocodes London', () async {
      OpenWeatherMapGeoApi openWeatherMap =
          OpenWeatherMapGeoApi(openWeatherMapApiKey, 'en');
      Location? location =
          await openWeatherMap.reverseGeocode(londonLat, londonLon);
      expect(location, isNot(null));
      if (location == null) throw Error();
      expect(location.cityName, equalsIgnoringCase('London'));
      expect(location.country, equalsIgnoringCase('GB'));
      expect(location.state, equalsIgnoringCase('England'));
      expect(location.lat, equals(londonLat));
      expect(location.lon, equals(londonLon));
    });
    test('It reverse geocodes by correct language', () async {
      OpenWeatherMapGeoApi openWeatherMap =
          OpenWeatherMapGeoApi(openWeatherMapApiKey, 'fa');
      Location? location =
          await openWeatherMap.reverseGeocode(londonLat, londonLon);
      expect(location, isNot(null));
      if (location == null) throw Error();
      expect(location.cityName, equalsIgnoringCase('لندن'));
    });
    test('It geocodes by correct language', () async {
      OpenWeatherMapGeoApi openWeatherMap =
          OpenWeatherMapGeoApi(openWeatherMapApiKey, 'fa');
      List<Location>? locations = await openWeatherMap.searchByQuery('لندن');
      expect(locations, isNot(null));
      if (locations == null) throw Error();
      expect(locations.length, greaterThan(1));
      expect(locations.first.cityName, equalsIgnoringCase('لندن'));
      expect(locations.first.lat, equals(londonLat));
      expect(locations.first.lon, equals(londonLon));
    });
    test('It gets a set of cities by query', () async {
      OpenWeatherMapGeoApi openWeatherMap =
          OpenWeatherMapGeoApi(openWeatherMapApiKey, 'en');
      List<Location>? locations = await openWeatherMap.searchByQuery('London');
      expect(locations, isNot(null));
      if (locations == null) throw Error();
      expect(locations.length, greaterThan(1));
      expect(locations.first.cityName, equalsIgnoringCase('London'));
      expect(locations.first.country, equalsIgnoringCase('GB'));
      expect(locations.first.state, equalsIgnoringCase('England'));
    });
  });
}
