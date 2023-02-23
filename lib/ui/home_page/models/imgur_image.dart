import 'dart:convert';

class ImgurImage {
  final String id;
  final String title;
  final String link;
  final int views;
  final String? description;
  final List<Images>? imagesDetails;
  bool favorite;
  ImgurImage(
      {required this.id,
      required this.title,
      required this.link,
      required this.views,
      this.description,
      required this.imagesDetails,
      this.favorite = false});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'link': link,
      'views': views,
      'description': description,
      'images': imagesDetails?.map((x) => x.toMap()).toList(),
      'boolFavorite': favorite
    };
  }

  factory ImgurImage.fromMap(Map<String, dynamic> map) {
    return ImgurImage(
        id: map['id'] ?? '',
        title: map['title'] ?? '',
        link: map['link'] ?? '',
        views: map['views'] ?? 0,
        description: map['description'] ?? '',
        imagesDetails: map['images'] != null
            ? List<Images>.from(map['images']?.map((x) => Images.fromMap(x)))
            : null,
        favorite: map['boolFavorite'] ?? false);
  }

  Map<String, dynamic> toJson() => toMap();

  factory ImgurImage.fromJson(Map<String, dynamic> map) =>
      ImgurImage.fromMap(map);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ImgurImage &&
        other.id == id &&
        other.title == title &&
        other.link == link;
  }

  @override
  int get hashCode {
    return id.hashCode ^ title.hashCode ^ link.hashCode;
  }

  ImgurImage copyWith({
    String? id,
    String? title,
    String? link,
    int? views,
    String? description,
    List<Images>? imagesDetails,
    bool? boolFavorite,
  }) {
    return ImgurImage(
      id: this.id,
      title: this.title,
      link: this.link,
      views: this.views,
      description: this.description,
      imagesDetails: this.imagesDetails,
      favorite: this.favorite,
    );
  }
}

class Images {
  final String link;
  final String type;
  Images({required this.link, required this.type});

  Map<String, dynamic> toMap() {
    return {'link': link, 'type': type};
  }

  factory Images.fromMap(Map<String, dynamic> map) {
    return Images(
      link: map['link'] ?? '',
      type: map['type'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Images.fromJson(String source) => Images.fromMap(json.decode(source));

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Images && other.link == link && other.type == type;
  }

  @override
  int get hashCode => link.hashCode ^ type.hashCode;
}
