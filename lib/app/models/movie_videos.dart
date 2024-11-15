class MovieVideosModel {
  final int? id;
  final List<VideoResultModel>? results;
  MovieVideosModel({this.id, this.results});
  factory MovieVideosModel.fromJson(Map<String, dynamic> json) {
    return MovieVideosModel(
      id: json['id'] as int?,
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => VideoResultModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'results': results?.map((e) => e.toJson()).toList(),
    };
  }
}

class VideoResultModel {
  final String? iso6391;
  final String? iso31661;
  final String? name;
  final String? key;
  final String? site;
  final int? size;
  final String? type;
  final bool? official;
  final DateTime? publishedAt;
  final String? id;

  VideoResultModel({
    this.iso6391,
    this.iso31661,
    this.name,
    this.key,
    this.site,
    this.size,
    this.type,
    this.official,
    this.publishedAt,
    this.id,
  });

  factory VideoResultModel.fromJson(Map<String, dynamic> json) {
    return VideoResultModel(
      iso6391: json['iso_639_1'] as String?,
      iso31661: json['iso_3166_1'] as String?,
      name: json['name'] as String?,
      key: json['key'] as String?,
      site: json['site'] as String?,
      size: json['size'] as int?,
      type: json['type'] as String?,
      official: json['official'] as bool?,
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'])
          : null,
      id: json['id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'iso_639_1': iso6391,
      'iso_3166_1': iso31661,
      'name': name,
      'key': key,
      'site': site,
      'size': size,
      'type': type,
      'official': official,
      'published_at': publishedAt?.toIso8601String(),
      'id': id,
    };
  }
}
