import 'package:dio/src/dio_mixin.dart';
import 'package:fx_dio/fx_dio.dart';
import 'package:lover/app/config.dart';

class NetClient extends DioClient {
  @override
  Interceptor? getAuthInterceptor() {
    return null;
  }

  @override
  String getBaseUrl() {
    return Config.baseUrl;
  }

  @override
  Interceptor? getResponseInterceptor() {
    return null;
  }
}
