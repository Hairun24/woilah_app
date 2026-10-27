import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/source_manifest.dart';

class SourceRepository {
  static const String _key = 'installed_sources';

  Future<List<SourceManifest>> loadSources() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? [];

    final items = <SourceManifest>[];

    for (final value in raw) {
      try {
        final map = jsonDecode(value);
        items.add(SourceManifest.fromJson(map));
      } catch (_) {
        // ignore invalid data
      }
    }

    return items;
  }

  Future<void> saveSources(List<SourceManifest> sources) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = sources.map((source) => jsonEncode(source.toJson())).toList();
    await prefs.setStringList(_key, encoded);
  }

  Future<void> addSource(SourceManifest source) async {
    final sources = await loadSources();
    final index = sources.indexWhere((item) => item.id == source.id);

    if (index >= 0) {
      sources[index] = source;
    } else {
      sources.add(source);
    }

    await saveSources(sources);
  }

  Future<void> removeSource(String sourceId) async {
    final sources = await loadSources();
    sources.removeWhere((item) => item.id == sourceId);
    await saveSources(sources);
  }

  Future<void> toggleEnabled(String sourceId, bool enabled) async {
    final sources = await loadSources();
    final index = sources.indexWhere((item) => item.id == sourceId);

    if (index < 0) return;

    final current = sources[index];
    final updated = SourceManifest(
      id: current.id,
      name: current.name,
      version: current.version,
      type: current.type,
      baseUrl: current.baseUrl,
      entryScriptUrl: current.entryScriptUrl,
      author: current.author,
      enabled: enabled,
    );

    sources[index] = updated;
    await saveSources(sources);
  }

  Future<List<SourceManifest>> enabledSources() async {
    final sources = await loadSources();
    return sources.where((item) => item.enabled).toList();
  }
}
