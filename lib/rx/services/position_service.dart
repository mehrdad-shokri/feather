import 'package:client/rx/services/rx_service.dart';
import 'package:geolocator/geolocator.dart';

class PositionService extends RxService {
  @override
  Future<void> onCreate() async {}

  Future<Position> getCurrentPosition() {
    return Geolocator.getCurrentPosition();
  }

  Future<LocationPermission> requestPermission() {
    return Geolocator.requestPermission();
  }

  Future<LocationPermission> checkPermission() {
    return Geolocator.checkPermission();
  }

  Future<void> openAppSettings() {
    return Geolocator.openAppSettings();
  }

  @override
  Future<void> onTerminate() async {}
}
