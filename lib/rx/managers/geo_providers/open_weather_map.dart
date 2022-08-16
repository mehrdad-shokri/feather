import 'package:client/models/location.dart';
import 'package:client/rx/managers/geo_api.dart';

class OpenWeatherMapGeoApi extends GeoApi {
  final String appId;

  OpenWeatherMapGeoApi(this.appId, String lang)
      : super('https://api.openweathermap.org/geo/1.0', lang);

  @override
  Future<Location?> reverseGeocode(double lat, double lon) async {
    List data = (await apiClient.instance.get(
      '/reverse',
      queryParameters: {
        'lat': lat,
        'lon': lon,
        'appid': appId,
      },
    ))
        .data as List;
    if (data.isNotEmpty) {
      return Location.fromOpenWeatherMapReverseGeocode(
          data.first, lat, lon, lang);
    }
    return null;
  }

  @override
  Future<List<Location>> searchByQuery(String query) async {
    List data = (await apiClient.instance.get(
      '/direct',
      queryParameters: {'appid': appId, 'q': query, 'limit': 100},
    ))
        .data as List;
    if (data.isNotEmpty) {
      return data
          .map((e) => Location.fromOpenWeatherMapGeocode(e, lang))
          .toList();
    }
    return [];
  }
}
