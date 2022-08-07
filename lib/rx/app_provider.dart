import 'package:client/rx/services/connectivity_service.dart';
import 'package:client/rx/services/env_service.dart';
import 'package:client/rx/services/position_service.dart';
import 'package:client/rx/services/shared_prefs_service.dart';
import 'package:get_it/get_it.dart';

class AppProvider {
  late ConnectivityService connectivityService;
  late PositionService positionService;
  late SharedPrefsService sharedPrefsService;
  late EnvService envService;

  AppProvider() {
    connectivityService = ConnectivityService();
    positionService = PositionService();
    sharedPrefsService = SharedPrefsService();
    envService = EnvService();
  }

  Future<void> onCreate() async {
    _registerSingleton();
    await positionService.onCreate();
    await sharedPrefsService.onCreate();
    await connectivityService.onCreate();
    await envService.onCreate();
  }

  void onDispose() {
    connectivityService.onTerminate();
    sharedPrefsService.onTerminate();
    envService.onTerminate();
    positionService.onTerminate();
  }

  void _registerSingleton() {
    GetIt.I.registerSingleton<AppProvider>(this, instanceName: 'appProvider');
  }

  static AppProvider getInstance() =>
      GetIt.I.get<AppProvider>(instanceName: 'appProvider');
}
