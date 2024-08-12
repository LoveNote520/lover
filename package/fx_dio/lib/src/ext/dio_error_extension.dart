import 'package:dio/dio.dart';

import 'exceptions.dart';

extension DioErrorExtension on DioError {
  Exception handleError() {
    if (error is NetworkError) return error! as NetworkError;
    if (error is GeneralError) return error! as GeneralError;
    return this;
  }
}
