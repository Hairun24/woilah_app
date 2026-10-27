class SourceManifest {
  final String id;
  final String name;
  final String version;
  final String type;
  final String baseUrl;
  final String entryScriptUrl;
  final String author;
  final bool enabled;

  SourceManifest({
    required this.id,
    required this.name,
    required this.version,
    required this.type,
    required this.baseUrl,
    required this.entryScriptUrl,
    required this.author,
    this.enabled = true,
  });

  factory SourceManifest.fromJson(Map<String, dynamic> json) {
    return SourceManifest(
      id: json['id'] ?? '',
      name: json['name'] ?? 'Source',
      version: json['version'] ?? '1.0.0',
      type: json['type'] ?? 'manga',
      baseUrl: json['baseUrl'] ?? '',
      entryScriptUrl: json['entryScriptUrl'] ?? '',
      author: json['author'] ?? 'Unknown',
      enabled: json['enabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'version': version,
      'type': type,
      'baseUrl': baseUrl,
      'entryScriptUrl': entryScriptUrl,
      'author': author,
      'enabled': enabled,
    };
  }
}
