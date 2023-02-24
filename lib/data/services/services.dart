import 'package:imgur/data/remote_api/remote_api.dart';
import 'package:imgur/ui/home_page/models/imgur_image.dart';

abstract class DataService {
  Future<List<ImgurImage>> fetchMostPopularImages({int? page});
  Future<List<ImgurImage>> getQueryImages(String query, {int? page});
}

class DataServiceImpl extends DataService {
  ImgurApi imgurApi;
  DataServiceImpl({
    required this.imgurApi,
  });

  @override
  Future<List<ImgurImage>> fetchMostPopularImages({int? page}) =>
      imgurApi.fetchMostPopularImages(page: page);
      
        @override
        Future<List<ImgurImage>> getQueryImages(String query, {int? page}) =>
        imgurApi.searchImages(query, page:page);
}
