import 'dart:convert';

class Location {
  final double lat;
  final double lon;
  final String cityName;
  final String country;
  final String? state;

  Location(
      {required this.lat,
      required this.lon,
      required this.cityName,
      required this.state,
      required this.country});

  factory Location.fromJson(String lastCityPrefs) {
    Map<String, dynamic> locationJson = json.decode(lastCityPrefs);
    return Location(
        lat: locationJson['lat'],
        lon: locationJson['lon'],
        state: locationJson['state'],
        cityName: locationJson['cityName'],
        country: locationJson['country']);
  }

  String toJson() {
    return json.encode({
      'lat': lat,
      'lon': lon,
      'cityName': cityName,
      'state': state,
      'country': country
    });
  }

  factory Location.fromOpenWeatherMapReverseGeocode(
          Map<String, dynamic> data, double lat, double lon, String lang) =>
      Location(
          lat: lat,
          lon: lon,
          cityName: (data['local_names'] as Map<String, dynamic>)[lang] ??
              data['name'],
          country: data['country'],
          state: data['state']);

  factory Location.fromOpenWeatherMapGeocode(
          Map<String, dynamic> data, String lang) =>
      Location(
          lat: data['lat'],
          lon: data['lon'],
          cityName: (data['local_names'] as Map<String, dynamic>)[lang] ??
              data['name'],
          country: data['country'],
          state: data['state']);
}