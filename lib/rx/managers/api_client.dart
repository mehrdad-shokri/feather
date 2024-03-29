import 'dart:io';

import 'package:dio/dio.dart';

class ApiClient {
  final String baseUrl;
  final int sendTimeout;
  late Dio _dio;

  Dio get instance => _dio;

  ApiClient(this.baseUrl, {this.sendTimeout = 15000}) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      sendTimeout: sendTimeout,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json'
      },
    ));
  }
}
