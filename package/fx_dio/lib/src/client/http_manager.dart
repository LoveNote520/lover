import 'package:dio/dio.dart';

import '../interceptor/auth_interceptor.dart';
import '../interceptor/common_response_interceptor.dart';
import '../interceptor/log_interceptor.dart';
import '../interceptor/response_interceptor.dart';
import '../model/api_auth.dart';
import '../model/host.dart';
import 'http_proxy.dart';

bool isDev = true;

class HttpManager {
  HttpManager._();

  static final HttpManager i = HttpManager._();

  final Map<Host, Dio> _dioMap = {};

  void auth(ApiAuth auth) {
    for (Host host in _dioMap.keys) {
      addInterceptors(host);
    }
  }

  void authGithub(ApiAuth auth) {
    Host host = Host.github;
    this[host];
    addInterceptors(host,auth: auth,repInterceptorEnable: false);
  }

  Dio operator [](Host host) {
    Dio dio = _dioMap[host] ?? accept(host);
    return dio;
  }

  Dio accept(Host host) {
    Dio dio = _createClient(host);
    Proxy.setProxy(dio);

    _dioMap[host] = dio;
    return dio;
  }

  void addInterceptors(
    Host host, {
    ApiAuth? auth,
    bool logEnable = false,
    bool repInterceptorEnable = true,
  }) {
    Dio dio = this[host];
    dio.interceptors.clear();
    if (auth != null) {
      AuthInterceptor interceptor = AuthInterceptor(auth: auth);
      dio.interceptors.add(interceptor);
    }
    if (logEnable) {
      dio.interceptors.add(HttpLogInterceptor());
    }
    if (repInterceptorEnable) {
      dio.interceptors.add(ResponseInterceptor());
    } else {
      dio.interceptors.add(CommonResponseInterceptor());
    }
  }

  Dio _createClient(Host host) {
    Dio dio = Dio();
    dio.options.baseUrl = host.url(isDev: isDev);
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    dio.options.sendTimeout = const Duration(seconds: 10);
    dio.options.receiveDataWhenStatusError = true;
    dio.options.validateStatus = (status) {
      return status! > 0;
    };
    return dio;
  }
}
