import 'dart:convert';

import 'package:flutter_js/flutter_js.dart';
import 'package:http/http.dart' as http;

class JsExtensionRunner {
  final JavascriptRuntime runtime = JavascriptRuntime();

  Future<void> loadScriptFromUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Gagal memuat script extension');
    }

    await runtime.evaluate(response.body);
  }

  Future<Map<String, dynamic>> invokeManifest() async {
    final result = await runtime.evaluate('''
      (function() {
        try {
          if (typeof window.__woilah_extension__ === 'undefined') {
            return JSON.stringify({ ok: false, error: 'extension_not_registered' });
          }
          if (typeof window.__woilah_extension__.manifest !== 'function') {
            return JSON.stringify({ ok: false, error: 'manifest_missing' });
          }
          return JSON.stringify({ ok: true, data: window.__woilah_extension__.manifest() });
        } catch (e) {
          return JSON.stringify({ ok: false, error: String(e) });
        }
      })()
    ''');

    final parsed = _parseResponse(result.stringResult);
    if (parsed['ok'] != true) {
      throw Exception(parsed['error'] ?? 'manifest error');
    }

    return Map<String, dynamic>.from(parsed['data'] as Map);
  }

  Future<List<Map<String, dynamic>>> invokeSearch(String query) async {
    final result = await runtime.evaluate('''
      (function() {
        try {
          if (typeof window.__woilah_extension__ === 'undefined') {
            return JSON.stringify({ ok: false, error: 'extension_not_registered' });
          }
          if (typeof window.__woilah_extension__.search !== 'function') {
            return JSON.stringify({ ok: false, error: 'search_missing' });
          }
          return JSON.stringify({ ok: true, data: window.__woilah_extension__.search(${jsonEncode(query)}) });
        } catch (e) {
          return JSON.stringify({ ok: false, error: String(e) });
        }
      })()
    ''');

    final parsed = _parseResponse(result.stringResult);
    if (parsed['ok'] != true) {
      throw Exception(parsed['error'] ?? 'search error');
    }

    final data = parsed['data'];
    if (data is List) {
      return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    return [];
  }

  Future<Map<String, dynamic>> invokeDetail(String slug) async {
    final result = await runtime.evaluate('''
      (function() {
        try {
          if (typeof window.__woilah_extension__ === 'undefined') {
            return JSON.stringify({ ok: false, error: 'extension_not_registered' });
          }
          if (typeof window.__woilah_extension__.detail !== 'function') {
            return JSON.stringify({ ok: false, error: 'detail_missing' });
          }
          return JSON.stringify({ ok: true, data: window.__woilah_extension__.detail(${jsonEncode(slug)}) });
        } catch (e) {
          return JSON.stringify({ ok: false, error: String(e) });
        }
      })()
    ''');

    final parsed = _parseResponse(result.stringResult);
    if (parsed['ok'] != true) {
      throw Exception(parsed['error'] ?? 'detail error');
    }

    return Map<String, dynamic>.from(parsed['data'] as Map);
  }

  Future<List<Map<String, dynamic>>> invokeChapters(String slug) async {
    final result = await runtime.evaluate('''
      (function() {
        try {
          if (typeof window.__woilah_extension__ === 'undefined') {
            return JSON.stringify({ ok: false, error: 'extension_not_registered' });
          }
          if (typeof window.__woilah_extension__.chapters !== 'function') {
            return JSON.stringify({ ok: false, error: 'chapters_missing' });
          }
          return JSON.stringify({ ok: true, data: window.__woilah_extension__.chapters(${jsonEncode(slug)}) });
        } catch (e) {
          return JSON.stringify({ ok: false, error: String(e) });
        }
      })()
    ''');

    final parsed = _parseResponse(result.stringResult);
    if (parsed['ok'] != true) {
      throw Exception(parsed['error'] ?? 'chapters error');
    }

    final data = parsed['data'];
    if (data is List) {
      return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    }
    return [];
  }

  Map<String, dynamic> _parseResponse(String raw) {
    if (raw.isEmpty) {
      return {'ok': false, 'error': 'empty_result'};
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return {'ok': false, 'error': 'invalid_json_format'};
    } catch (_) {
      return {'ok': false, 'error': 'invalid_json_format'};
    }
  }
}
