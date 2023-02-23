import 'package:imgur/data/services/services.dart';
import 'package:imgur/ui/home_page/models/imgur_image.dart';

abstract class ImagesRepository {
  Future<List<ImgurImage>> fetchMostPopularImages({int? page});
  Future<List<ImgurImage>> getQueryImages(String query, {int? page});
}

class ImagesRepositoryImpl extends ImagesRepository {
  final DataService dataService;
  ImagesRepositoryImpl({
    required this.dataService,
  });

  @override
  Future<List<ImgurImage>> fetchMostPopularImages({int? page}) =>
      dataService.fetchMostPopularImages(page: page);

  @override
  Future<List<ImgurImage>> getQueryImages(String query, {int? page}) =>
    dataService.getQueryImages(query, page: page);
  
}
