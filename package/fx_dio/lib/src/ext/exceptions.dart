mixin ErrorCode {
  int get code;
  String? get message;
  dynamic get data;
}

class NetworkError with ErrorCode implements Exception {
  @override
  final int code;
  @override
  final String message;
  @override
  final dynamic data;

  NetworkError(this.code, this.message, this.data);

  @override
  String toString() {
    return "NetworkError: $code, $message, $data";
  }
}

class GeneralError with ErrorCode implements Exception {
  @override
  final int code;
  @override
  final String message;
  @override
  final dynamic data;

  GeneralError(this.code, this.message, this.data);

  @override
  String toString() {
    return "GeneralError: $code, $message, $data";
  }
}

class InvalidAuthError extends GeneralError {
  InvalidAuthError(code, message, data) : super(code, message, data);

  @override
  String toString() {
    return "InvalidAuthError: $code, $message, $data";
  }
}
