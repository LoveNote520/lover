import 'package:dio/dio.dart';

import '../ext/exceptions.dart';

class CommonResponseInterceptor extends InterceptorsWrapper {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode != 200) {
      throw NetworkError(response.statusCode ?? -1, "${response.statusMessage}", response);
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (_isNetworkError(err)) {
      throw NetworkError(err.response?.statusCode ?? -1, err.type.toPrettyDescription(), err);
    } else {
      super.onError(err, handler);
    }
  }
}

bool _isNetworkError(DioException err) {
  return err.type != DioExceptionType.unknown;
}

extension _DioErrorTypeExtension on DioExceptionType {
  String toPrettyDescription() {
    switch (this) {
      case DioExceptionType.connectionTimeout:
        return 'connection timeout';
      case DioExceptionType.sendTimeout:
        return 'send timeout';
      case DioExceptionType.receiveTimeout:
        return 'receive timeout';
      case DioExceptionType.badCertificate:
        return 'bad certificate';
      case DioExceptionType.badResponse:
        return 'bad response';
      case DioExceptionType.cancel:
        return 'request cancelled';
      case DioExceptionType.connectionError:
        return 'connection error';
      case DioExceptionType.unknown:
        return 'unknown';
    }
  }
}
