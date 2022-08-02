import 'package:client/rx/services/rx_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService extends RxService {
  late SharedPreferences sharedPreferences;

  @override
  Future<void> onCreate() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Future<void> onTerminate() async {}
}
