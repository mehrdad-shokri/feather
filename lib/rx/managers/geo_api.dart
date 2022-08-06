import 'package:client/rx/managers/api_client.dart';
import 'package:client/types/location.dart';

abstract class GeoApi {
  final String lang;

  final ApiClient apiClient;

  GeoApi(String baseUrl, this.lang) : apiClient = ApiClient(baseUrl);

  Future<Location?> reverseGeocode(double lat, double lon);

  Future<List<Location>?> searchByQuery(String query);
}
