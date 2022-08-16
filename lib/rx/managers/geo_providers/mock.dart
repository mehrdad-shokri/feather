import 'package:client/models/location.dart';
import 'package:client/rx/managers/geo_api.dart';

class MockGeoApi extends GeoApi {
  MockGeoApi() : super('', '');

  @override
  Future<Location?> reverseGeocode(double lat, double lon) {
    throw UnimplementedError();
  }

  @override
  Future<List<Location>> searchByQuery(String query) {
    throw UnimplementedError();
  }
}
