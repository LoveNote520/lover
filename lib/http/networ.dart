import 'dart:async';
import 'package:dio/dio.dart';

class NetworkService {
  final Dio _dio = Dio();
  Timer? _debounceTimer;
  Completer<Response>? _completer;

  Future<Response> debouncedRequest(String url, {Duration delay = const Duration(milliseconds: 300)}) {
    if (_completer != null) {
      _completer!.completeError(Exception('Request canceled'));
    }

    _completer = Completer<Response>();

    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(delay, () async {
      try {
        final response = await _dio.get(url);
        _completer!.complete(response);
      } catch (error) {
        _completer!.completeError(error);
      }
    });

    return _completer!.future;
  }
}

// 使用示例
void main() async {
  final networkService = NetworkService();

  try {
    final response = await networkService.debouncedRequest('https://api.example.com/data');
    print('Response: ${response.data}');
  } catch (error) {
    print('Error: $error');
  }
}