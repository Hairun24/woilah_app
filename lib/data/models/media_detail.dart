class ChapterItem {
  final String id;
  final String title;
  final List<String> pages;

  ChapterItem({
    required this.id,
    required this.title,
    required this.pages,
  });
}

class StreamSource {
  final String id;
  final String label;
  final String url;

  StreamSource({
    required this.id,
    required this.label,
    required this.url,
  });
}

class MediaDetail {
  final String id;
  final String title;
  final String coverUrl;
  final String type;
  final String sourceName;
  final String description;
  final String status;
  final List<String> genres;
  final List<ChapterItem> chapters;
  final List<StreamSource> streams;

  MediaDetail({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.type,
    required this.sourceName,
    required this.description,
    required this.status,
    required this.genres,
    required this.chapters,
    required this.streams,
  });
}
