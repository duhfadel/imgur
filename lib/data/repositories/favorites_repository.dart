import 'dart:convert';
import 'package:imgur/ui/home_page/models/imgur_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class FavoritesRepository {
  Future<void> addFavorite(ImgurImage favorite);
  Future<void> removeFavorite(ImgurImage favorite);
  Future<Set<ImgurImage>> getFavorites();
  Future<void> addRecentSearch(String recentSearch);
  Future<void> removeRecentSearch(String recentSearch);
  Future<Set<String>> getRecentSearches();
}

class FavoritesRepositoryImpl extends FavoritesRepository {
  FavoritesRepositoryImpl() {
    _getPreferences();
  }
  SharedPreferences? _prefs;

  Future<SharedPreferences> _getPreferences() async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  @override
  Future<Set<ImgurImage>> getFavorites() async {
    final String? favoritesJson =
        (await _getPreferences()).getString('favorites');
    if (favoritesJson != null) {
      final favorites = jsonDecode(favoritesJson) as List<dynamic>;
      return favorites.map((f) => ImgurImage.fromJson(f)).toSet();
    }
    return {};
  }

  @override
  Future<void> addFavorite(ImgurImage favorite) async {
    final Set<ImgurImage> favorites = await getFavorites();
    if (!favorites.add(favorite)) {
      await removeFavorite(favorite);
      return;
    }
    final String favoritesJson = jsonEncode(favorites.toList());
    (await _getPreferences()).setString('favorites', favoritesJson);
  }

  @override
  Future<void> removeFavorite(ImgurImage favorite) async {
    final Set<ImgurImage> favorites = await getFavorites();
    favorites.remove(favorite);
    final favoritesJson = jsonEncode(favorites.toList());
    (await _getPreferences()).setString('favorites', favoritesJson);
  }

  @override
  Future<void> addRecentSearch(String recentSearch) async {
    final Set<String> recentSearches = await getRecentSearches();
    recentSearches.add(recentSearch);
    final String recentSearchJson = jsonEncode(recentSearches.toList());
    (await _getPreferences()).setString('recentSearches', recentSearchJson);
  }

  @override
  Future<Set<String>> getRecentSearches() async {
    final String? recentSearchJson =
        (await _getPreferences()).getString('recentSearches');
    if (recentSearchJson != null) {
      final List<dynamic> recentSearchListDynamic =
          jsonDecode(recentSearchJson);
      final recentSearchList =
          recentSearchListDynamic.map((item) => item.toString()).toList();
      return recentSearchList.toSet();
    }
    return {};
  }

  @override
  Future<void> removeRecentSearch(String recentSearch) async {
    final Set<String> recentSearches = await getRecentSearches();
    recentSearches.remove(recentSearch);
    final String recentSearchJson = jsonEncode(recentSearches.toList());
    (await _getPreferences()).setString('recentSearches', recentSearchJson);
  }
}
