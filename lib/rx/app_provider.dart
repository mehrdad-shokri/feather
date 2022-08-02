import 'package:client/rx/services/connectivity_service.dart';
import 'package:client/rx/services/location_service.dart';
import 'package:client/rx/services/shared_prefs_service.dart';

class AppProvider {
  late ConnectivityService connectivityService;
  late LocationService locationService;
  late SharedPrefsService sharedPrefsService;
  void onCreate() async {}
}
