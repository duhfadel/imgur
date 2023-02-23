import 'package:dio/dio.dart';
import 'package:imgur/ui/home_page/models/imgur_image.dart';

class ImgurApi {
  //final String _clientId = '93580c60c7916dc';
  final Dio _dio;

  ImgurApi()
      : _dio = Dio(BaseOptions(
          baseUrl: 'https://api.imgur.com/3/',
          headers: {'Authorization': 'Client-ID 93580c60c7916dc'},
        ));

Future<List<ImgurImage>> fetchMostPopularImages({int? page }) async {
  final response = await _dio.get('gallery/hot/viral/day?page=$page');
  if (response.statusCode == 200) {
    final data = response.data['data'] as List<dynamic>;
    return data.map((json) => ImgurImage.fromJson(json)).toList();
  } else {
    throw Exception('Failed to fetch images');
  }
}

Future<List<ImgurImage>> searchImages(String query, {int? page}) async {
    final response = await _dio.get('gallery/search/$page',
        queryParameters: {'q': query});

    if (response.statusCode == 200) {
      final data = response.data['data'] as List<dynamic>;
      return data.map((json) => ImgurImage.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search images');
    }
  }


}