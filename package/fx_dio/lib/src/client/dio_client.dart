import 'package:dio/dio.dart';

import '../interceptor/common_response_interceptor.dart';
import '../interceptor/log_interceptor.dart';
import 'http_proxy.dart';

abstract class DioClient {
  late Dio _dio;

  Dio get dio => _dio;

  DioClient() {
    _dio = Dio();
    _dio.options.baseUrl = getBaseUrl();
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.sendTimeout = const Duration(seconds: 10);
    _dio.options.receiveDataWhenStatusError = true;
    _dio.options.validateStatus = (status) {
      return status! > 0;
    };
    // set proxy
    Proxy.setProxy(_dio);

    final authInterceptor = getAuthInterceptor();
    if (authInterceptor != null) {
      _dio.interceptors.add(authInterceptor);
    }
    _dio.interceptors.add(HttpLogInterceptor());
    final responseInterceptor = getResponseInterceptor();
    if (responseInterceptor != null) {
      _dio.interceptors.add(responseInterceptor);
    }
    _dio.interceptors.add(CommonResponseInterceptor());
  }

  void changeBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  String getBaseUrl();

  Interceptor? getAuthInterceptor();

  Interceptor? getResponseInterceptor();
}
