import 'package:client/rx/services/rx_service.dart';
import 'package:geolocator/geolocator.dart';

class LocationService extends RxService {
  late LocationPermission hasPermission;
  late bool isEnabled;

  get instance => Geolocator;

  @override
  Future<void> onCreate() async {
    hasPermission = await Geolocator.checkPermission();
    isEnabled = await Geolocator.isLocationServiceEnabled();
  }

  Future<Position> getCurrentPosition() {
    return Geolocator.getCurrentPosition();
  }

  @override
  Future<void> onTerminate() async {}
}
