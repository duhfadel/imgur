import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:imgur/ui/home_page/models/imgur_image.dart';

abstract class ImgurApi {
  Future<List<ImgurImage>> fetchMostPopularImages({int? page});
  Future<List<ImgurImage>> searchImages(String query, {int? page});
}

class ImgurApiImpl implements ImgurApi {
  final Dio dio;
  ImgurApiImpl({required this.dio});

  @override
  Future<List<ImgurImage>> fetchMostPopularImages({int? page}) async{
    final Response response = await dio.get('gallery/hot/viral/day?page=$page');
    if (response.statusCode == 200) {
      final data = response.data['data'] as List<dynamic>;
      return data.map((json) => ImgurImage.fromJson(json)).toList();
    } else {
      throw Exception('errorFetchImages'.tr());
    }
  }

  @override
  Future<List<ImgurImage>> searchImages(String query, {int? page}) async {
    final Response response =
        await dio.get('gallery/search/$page', queryParameters: {'q': query});
    if (response.statusCode == 200) {
      final data = response.data['data'] as List<dynamic>;
      return data.map((json) => ImgurImage.fromJson(json)).toList();
    } else {
      throw Exception('errorFetchImages'.tr());
    }
  }
}
