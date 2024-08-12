import 'package:dio/dio.dart';

import 'exceptions.dart';

extension DioErrorExtension on DioException {
  Exception handleError() {
    if (error is NetworkError) return error! as NetworkError;
    if (error is GeneralError) return error! as GeneralError;
    return this;
  }
}
