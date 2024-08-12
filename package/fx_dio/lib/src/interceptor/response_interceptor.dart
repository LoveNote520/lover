import 'package:dio/dio.dart';

import '../ext/exceptions.dart';

class ResponseInterceptor extends InterceptorsWrapper {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final code = response.data["error_code"] as int?;
    if (code == 0) {
      final data = response.data["data"];
      response.data = data is List ? {} : data;
    } else if (code == 403) {
      throw InvalidAuthError(code!, "${response.data["message"]}", response);
    } else {
      final errorMessage = "url:'${response.realUri}'  data:$response";
      final error = GeneralError(code ?? -1, errorMessage, response);
      // Sentry.captureException(error, stackTrace: StackTrace.current);
      throw GeneralError(code ?? -1, "${response.data["message"]}", response);
    }
    super.onResponse(response, handler);
  }
}
