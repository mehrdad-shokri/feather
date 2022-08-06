import 'dart:io';

import 'package:client/rx/services/rx_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvService extends RxService {
  final String _envFileName;
  final bool test;

  EnvService([this._envFileName = ".env", this.test = false]);

  Map<String, String> get envs => dotenv.env;

  @override
  Future<void> onCreate() async {
    if (test) {
      dotenv.testLoad(fileInput: File(_envFileName).readAsStringSync());
    } else {
      await dotenv.load(fileName: _envFileName);
    }
  }

  @override
  Future<void> onTerminate() async {
    dotenv.clean();
  }
}
