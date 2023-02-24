import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imgur/data/repositories/favorites_repository.dart';
import 'package:imgur/data/repositories/images_repository.dart';
import 'package:imgur/ui/home_page/cubit/home_state.dart';
import 'package:imgur/ui/home_page/models/imgur_image.dart';

class HomePageCubit extends Cubit<HomePageState> {
  HomePageCubit(
      {required this.imagesRepository, required this.favoritesRepository})
      : super(HomePageState(isLoading: true)) {
    fetchMostPopularImages();
  }
  ImagesRepository imagesRepository;
  List<ImgurImage> listImages = [];
  List<ImgurImage> copyListImages = [];
  Set<ImgurImage> setFavorites = {};
  Set<String> setSearches = {};
  int currentPage = 0;
  FavoritesRepository favoritesRepository;

  Future<void> fetchMostPopularImages({int? page}) async {
    emit(state.copyWith(isLoading: true));
    try {
      List<ImgurImage> list =
          await imagesRepository.fetchMostPopularImages(page: page);
      copyListImages = list
          .where((element) =>
              element.imagesDetails?.first.type.split('/').first == 'image')
          .toList();
      refreshLists();
      listImages = copyListImages;
    } catch (e) {
      throw Exception(e);
    } finally {
      emit(state.copyWith(listImages: listImages, isLoading: false));
    }
  }

  int incrementPage() {
    currentPage++;
    return currentPage;
  }

  int resetPage() {
   return currentPage = 0;
  }

  Future<void> searchImages(String query, {int? page}) async {
    emit(state.copyWith(isLoading: true));
    try {
      List<ImgurImage> list =
          await imagesRepository.getQueryImages(query, page: page);
      copyListImages = list
          .where((element) =>
              element.imagesDetails?.first.type.split('/').first == 'image')
          .toList();
    } catch (e) {
      throw Exception('Error getting imgur list: $e');
    } finally {
      emit(state.copyWith(isLoading: false, listImages: _matchFavorites()));
    }
  }

  List<ImgurImage> _matchFavorites() {
    List<ImgurImage> newList = [];
    newList.addAll(copyListImages.map((image) {
      if (setFavorites.contains(image)) {
        image.favorite = true;
      } else {
        image.favorite = false;
      }
      return image;
    }));
    return newList;
  }

  Future<void> refreshLists() async {
    setFavorites = await favoritesRepository.getFavorites();
    emit(state.copyWith(
        listFavorites: setFavorites.toList(), listImages: _matchFavorites()));
  }

  Future<void> addFavorite(ImgurImage favorite) async {
    try {
      await favoritesRepository.addFavorite(favorite);
      refreshLists();
    } catch (e) {
      throw Exception('Error adding favorite: $e');
    }
  }

  Future<void> removeFavorite(ImgurImage favorite) async {
    await favoritesRepository.removeFavorite(favorite);
    refreshLists();
  }

  Future<void> refreshRecentSearches() async {
    setSearches = await favoritesRepository.getRecentSearches();
    emit(state.copyWith(listSearches: setSearches.toList()));
  }

  Future<void> addRecentSearch(String recentSearch) async {
    await favoritesRepository.addRecentSearch(recentSearch);
    refreshRecentSearches();
  }

  Future<void> removeRecentSearch(String recentSearch) async {
    await favoritesRepository.removeRecentSearch(recentSearch);
    refreshRecentSearches();
  }

  void changeFocus(bool hasFocus) {
    emit(state.copyWith(hasFocus: hasFocus));
  }
}
