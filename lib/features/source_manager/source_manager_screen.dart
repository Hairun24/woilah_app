import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../data/models/source_manifest.dart';
import '../../data/repositories/source_repository.dart';

class SourceManagerScreen extends StatefulWidget {
  const SourceManagerScreen({super.key});

  @override
  State<SourceManagerScreen> createState() => _SourceManagerScreenState();
}

class _SourceManagerScreenState extends State<SourceManagerScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;
  List<SourceManifest> _sources = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = context.read<SourceRepository>();
    final sources = await repo.loadSources();
    setState(() {
      _sources = sources;
    });
  }

  Future<void> _addSource(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil manifest');
    }

    final json = jsonDecode(response.body);
    if (json['id'] == null || json['name'] == null || json['entryScriptUrl'] == null) {
      throw Exception('Manifest tidak valid');
    }

    final source = SourceManifest.fromJson(json);
    final repo = context.read<SourceRepository>();
    await repo.addSource(source);
    await _load();
  }

  Future<void> _toggle(String id, bool enabled) async {
    final repo = context.read<SourceRepository>();
    await repo.toggleEnabled(id, enabled);
    await _load();
  }

  Future<void> _remove(String id) async {
    final repo = context.read<SourceRepository>();
    await repo.removeSource(id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Source Extension'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Masukkan URL manifest',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    final url = _controller.text.trim();
                    if (url.isEmpty) return;

                    setState(() => _loading = true);

                    try {
                      await _addSource(url);
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Source berhasil ditambahkan')),
                      );
                    } catch (e) {
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Gagal: $e')),
                      );
                    } finally {
                      if (mounted) setState(() => _loading = false);
                    }
                  },
                  child: _loading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Tambah'),
                ),
              ],
            ),
          ),
          Expanded(
            child: _sources.isEmpty
                ? const Center(child: Text('Belum ada source'))
                : ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: _sources.length,
                    itemBuilder: (context, index) {
                      final source = _sources[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          source.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${source.type.toUpperCase()} • v${source.version}',
                                          style: const TextStyle(color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: source.enabled,
                                    onChanged: (value) {
                                      _toggle(source.id, value);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text('Author: ${source.author}'),
                              const SizedBox(height: 8),
                              Text(
                                source.entryScriptUrl,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextButton.icon(
                                      onPressed: () {},
                                      icon: const Icon(Icons.refresh),
                                      label: const Text('Refresh'),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextButton.icon(
                                      onPressed: () {
                                        _remove(source.id);
                                      },
                                      icon: const Icon(Icons.delete_outline),
                                      label: const Text('Hapus'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
