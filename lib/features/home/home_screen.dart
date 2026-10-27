import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/media_item.dart';
import '../../data/repositories/media_repository.dart';
import '../detail/detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = context.read<MediaRepository>();
    final manga = repo.getMediaByType('manga');
    final anime = repo.getMediaByType('anime');
    final movie = repo.getMediaByType('movie');

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Woilah'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Manga'),
              Tab(text: 'Anime'),
              Tab(text: 'Movie'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildGrid(manga, context),
            _buildGrid(anime, context),
            _buildGrid(movie, context),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(List<MediaItem> items, BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailScreen(item: item),
              ),
            );
          },
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image.network(
                    item.coverUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.sourceName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
