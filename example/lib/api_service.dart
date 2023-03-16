import 'dart:io';

import 'package:dio/dio.dart';

class APIService {
  static Dio? _dio;

  static Dio getInstance() {
    if (_dio == null) {
      _dio = Dio();
      var baseOptions =
          BaseOptions(baseUrl: "https://api.github.com/", headers: {
        'Authorization': 'Bearer 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',
        'Accept': 'application/vnd.github+json'
      });
      _dio!.options = baseOptions;
      _dio?.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          // Log the request method and URL
          print('${options.method} ${options.baseUrl}${options.path}');

          // Log the request headers
          print('Headers: ${options.headers}');

          // Log the request data (if any)
          if (options.data != null) {
            print('Data: ${options.data}');
          }

          // Pass the request to the next handler
          return handler.next(options);
        },
      ));
      return _dio!;
    } else {
      return _dio!;
    }
  }
}
