import 'package:fx_dio/fx_dio.dart';

import '../net_client.dart';

class LoginApi {
  static Future<Response> login() {
    return NetClient().dio.post("/login",data: { "userName":"","passWord":""});
  }
}
