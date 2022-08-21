import 'package:client/rx/services/connectivity_service.dart';
import 'package:client/rx/services/env_service.dart';
import 'package:client/rx/services/position_service.dart';
import 'package:client/rx/services/shared_prefs_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ServiceProvider {
  late ConnectivityService connectivityService;
  late PositionService positionService;
  late SharedPrefsService sharedPrefsService;
  late EnvService envService;
  Function? themeChangeCallback;
  Function? localeChangeCallback;

  ServiceProvider() {
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
    GetIt.I
        .registerSingleton<ServiceProvider>(this, instanceName: 'appProvider');
  }

  static ServiceProvider getInstance() =>
      GetIt.I.get<ServiceProvider>(instanceName: 'appProvider');

  void setThemeChangeListener(Function(ThemeMode theme) callback) =>
      themeChangeCallback = callback;

  void setLocaleChangeListener(Function(Locale theme) callback) =>
      localeChangeCallback = callback;
}
