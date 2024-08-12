import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';


import '../model/api_auth.dart';

class AuthInterceptor extends InterceptorsWrapper {
  final ApiAuth auth;

  AuthInterceptor({required this.auth});

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // TODO Add TOKEN

    handler.next(options);
  }


}
