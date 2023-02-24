import 'package:dio/dio.dart';

class DioHttpClient {
  final Dio dio = Dio();

  DioHttpClient() {
    _setupDio();
  }

  String baseUrl = 'https://api.imgur.com/3/';
  String authorization = 'Authorization';
  String clientId = 'Client-ID 93580c60c7916dc';

  void _setupDio() {
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.headers = {authorization: clientId};
  }
}
