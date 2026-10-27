import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/media_item.dart';
import '../../data/repositories/favorites_repository.dart';
import '../../data/repositories/media_repository.dart';
import '../detail/detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late final FavoritesRepository favoritesRepository;
  late final MediaRepository mediaRepository;

  List<MediaItem> items = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    favoritesRepository = context.read<FavoritesRepository>();
    mediaRepository = context.read<MediaRepository>();
    _load();
  }

  Future<void> _load() async {
    final ids = await favoritesRepository.getFavorites();
    final all = mediaRepository.getAllMedia();
    setState(() {
      items = all.where((item) => ids.contains(item.id)).toList();
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : items.isEmpty
              ? const Center(child: Text('Belum ada item favorit'))
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return Card(
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.coverUrl,
                            width: 56,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(item.title),
                        subtitle: Text(item.type.toUpperCase()),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            await favoritesRepository.toggleFavorite(item.id);
                            _load();
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(item: item),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
