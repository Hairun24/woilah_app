import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/media_item.dart';
import '../../data/repositories/favorites_repository.dart';
import '../../data/repositories/media_repository.dart';
import '../player/player_screen.dart';
import '../reader/reader_screen.dart';

class DetailScreen extends StatefulWidget {
  final MediaItem item;

  const DetailScreen({super.key, required this.item});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final FavoritesRepository favoritesRepository;
  late final MediaRepository mediaRepository;
  bool isFavorite = false;
  bool isLoading = true;
  late final detail;

  @override
  void initState() {
    super.initState();
    favoritesRepository = context.read<FavoritesRepository>();
    mediaRepository = context.read<MediaRepository>();
    _load();
  }

  Future<void> _load() async {
    final favorites = await favoritesRepository.getFavorites();
    setState(() {
      isFavorite = favorites.contains(widget.item.id);
      detail = mediaRepository.getDetailFor(widget.item);
      isLoading = false;
    });
  }

  Future<void> _toggleFavorite() async {
    await favoritesRepository.toggleFavorite(widget.item.id);
    final favorites = await favoritesRepository.getFavorites();
    setState(() {
      isFavorite = favorites.contains(widget.item.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                detail.coverUrl,
                fit: BoxFit.cover,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isFavorite ? Colors.red : Colors.white,
                ),
                onPressed: () async {
                  await _toggleFavorite();
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    detail.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.deepPurple.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          detail.type.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(detail.status),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(detail.description, style: const TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: detail.genres
                        .map((genre) => Chip(label: Text(genre)))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  if (detail.type == 'manga') ...[
                    ElevatedButton.icon(
                      onPressed: () {
                        if (detail.chapters.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ReaderScreen(
                                media: widget.item,
                                chapters: detail.chapters,
                              ),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.menu_book),
                      label: const Text('Baca'),
                    ),
                  ] else ...[
                    ElevatedButton.icon(
                      onPressed: () {
                        if (detail.streams.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PlayerScreen(
                                media: widget.item,
                                streams: detail.streams,
                              ),
                            ),
                          );
                        }
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Tonton'),
                    ),
                  ],
                  const SizedBox(height: 24),
                  const Text(
                    'Daftar',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (detail.type == 'manga')
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: detail.chapters.length,
                      itemBuilder: (context, index) {
                        final chapter = detail.chapters[index];
                        return ListTile(
                          leading: CircleAvatar(child: Text('${index + 1}')),
                          title: Text(chapter.title),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ReaderScreen(
                                  media: widget.item,
                                  chapters: detail.chapters,
                                  initialChapterIndex: index,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: detail.streams.length,
                      itemBuilder: (context, index) {
                        final stream = detail.streams[index];
                        return ListTile(
                          leading: CircleAvatar(child: Text('${index + 1}')),
                          title: Text(stream.label),
                          subtitle: const Text('Video stream'),
                          trailing: const Icon(Icons.play_circle_outline),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PlayerScreen(
                                  media: widget.item,
                                  streams: detail.streams,
                                  initialStreamIndex: index,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
