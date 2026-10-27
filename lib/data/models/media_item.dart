class MediaItem {
  final String id;
  final String title;
  final String coverUrl;
  final String type; // manga, anime, movie
  final String sourceName;
  final String description;
  final String slug;

  const MediaItem({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.type,
    required this.sourceName,
    required this.description,
    required this.slug,
  });

  factory MediaItem.fromJson(Map<String, dynamic> json) {
    return MediaItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      coverUrl: json['coverUrl'] ?? '',
      type: json['type'] ?? 'manga',
      sourceName: json['sourceName'] ?? 'Unknown',
      description: json['description'] ?? '',
      slug: json['slug'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'coverUrl': coverUrl,
      'type': type,
      'sourceName': sourceName,
      'description': description,
      'slug': slug,
    };
  }
}
