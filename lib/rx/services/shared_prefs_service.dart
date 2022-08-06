import 'package:client/rx/services/rx_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService extends RxService {
  late SharedPreferences instance;

  @override
  Future<void> onCreate() async {
    instance = await SharedPreferences.getInstance();
  }

  @override
  Future<void> onTerminate() async {}
}
