import 'package:flutter/foundation.dart';

import 'package:imgur/ui/home_page/models/imgur_image.dart';

class HomePageState {
  List<ImgurImage> listImages;
  List<ImgurImage> listFavorites;
  List<String> listSearches;
  bool isLoading = false;
  bool hasFocus;
  HomePageState(
      {required this.isLoading,
      this.hasFocus = false,
      this.listImages = const [],
      this.listFavorites = const [],
      this.listSearches = const []});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HomePageState &&
        other.listImages == listImages &&
        listEquals(other.listFavorites, listFavorites) &&
        listEquals(other.listSearches, listSearches) &&
        other.isLoading == isLoading &&
        other.hasFocus == hasFocus;
  }

  @override
  int get hashCode {
    return listImages.hashCode ^
        listFavorites.hashCode ^
        listSearches.hashCode ^
        isLoading.hashCode ^
        hasFocus.hashCode;
  }

  HomePageState copyWith({
    List<ImgurImage>? listImages,
    List<ImgurImage>? listFavorites,
    List<String>? listSearches,
    bool? isLoading,
    bool? hasFocus,
  }) {
    return HomePageState(
      listImages: listImages ?? this.listImages,
      listFavorites: listFavorites ?? this.listFavorites,
      listSearches: listSearches ?? this.listSearches,
      isLoading: isLoading ?? this.isLoading,
      hasFocus: hasFocus ?? this.hasFocus,
    );
  }
}
