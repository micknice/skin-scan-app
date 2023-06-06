import 'dart:io';

import 'package:dio/dio.dart';

void main() async {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://httpbin.org/',
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 10),
      // 5s
      headers: {
        HttpHeaders.userAgentHeader: 'dio',
        'api': '1.0.0',
      },
      contentType: Headers.jsonContentType,
      // Transform the response data to a String encoded with UTF8.
      // The default value is [ResponseType.JSON].
      responseType: ResponseType.plain,
    ),
  );
}
