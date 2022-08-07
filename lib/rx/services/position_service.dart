import 'package:client/rx/services/rx_service.dart';
import 'package:geolocator/geolocator.dart';

class PositionService extends RxService {
  late LocationPermission hasPermission;

  @override
  Future<void> onCreate() async {
    hasPermission = await Geolocator.checkPermission();
  }

  Future<Position> getCurrentPosition() {
    return Geolocator.getCurrentPosition();
  }

  Future<LocationPermission> requestPermission() {
    return Geolocator.requestPermission();
  }

  Future<LocationPermission> checkPermission() {
    return Geolocator.checkPermission();
  }

  @override
  Future<void> onTerminate() async {}
}
