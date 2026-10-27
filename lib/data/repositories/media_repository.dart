import '../models/media_detail.dart';
import '../models/media_item.dart';

class MediaRepository {
  List<MediaItem> getAllMedia() {
    return [
      MediaItem(
        id: 'm1',
        title: 'One Piece',
        coverUrl:
            'https://images.unsplash.com/photo-1578632767115-351597cf2477?auto=format&fit=crop&w=800&q=80',
        type: 'manga',
        sourceName: 'Demo Manga',
        description: 'Petualangan laut yang dipenuhi aksi dan emosi.',
        slug: 'one-piece',
      ),
      MediaItem(
        id: 'm2',
        title: 'Solo Leveling',
        coverUrl:
            'https://images.unsplash.com/photo-1515879218367-8466d910aaa4?auto=format&fit=crop&w=800&q=80',
        type: 'manga',
        sourceName: 'Demo Manga',
        description: 'Manga dengan level up dan pertarungan intens.',
        slug: 'solo-leveling',
      ),
      MediaItem(
        id: 'a1',
        title: 'Demon Slayer',
        coverUrl:
            'https://images.unsplash.com/photo-1542204165-65bf26472b9b?auto=format&fit=crop&w=800&q=80',
        type: 'anime',
        sourceName: 'Demo Anime',
        description: 'Perjuangan melawan iblis dengan kekuatan besar.',
        slug: 'demon-slayer',
      ),
      MediaItem(
        id: 'a2',
        title: 'Attack on Titan',
        coverUrl:
            'https://images.unsplash.com/photo-1608889175123-8ee362201f81?auto=format&fit=crop&w=800&q=80',
        type: 'anime',
        sourceName: 'Demo Anime',
        description: 'Cerita perang, strategi, dan survival.',
        slug: 'attack-on-titan',
      ),
      MediaItem(
        id: 'v1',
        title: 'Spider-Man: Across the Spider-Verse',
        coverUrl:
            'https://images.unsplash.com/photo-1497032628192-86f99bcd76bc?auto=format&fit=crop&w=800&q=80',
        type: 'movie',
        sourceName: 'Demo Movie',
        description: 'Petualangan multiverse dengan visual yang memukau.',
        slug: 'spider-man-across-the-spider-verse',
      ),
    ];
  }

  List<MediaItem> getMediaByType(String type) {
    return getAllMedia().where((item) => item.type == type).toList();
  }

  List<MediaItem> searchMedia(String query) {
    final q = query.trim().toLowerCase();
    final items = getAllMedia();

    if (q.isEmpty) {
      return items;
    }

    return items.where((item) {
      return item.title.toLowerCase().contains(q) ||
          item.description.toLowerCase().contains(q) ||
          item.sourceName.toLowerCase().contains(q);
    }).toList();
  }

  MediaDetail getDetailFor(MediaItem item) {
    final images = [
      'https://images.unsplash.com/photo-1517849845537-4d257902454a?auto=format&fit=crop&w=900&q=80',
      'https://images.unsplash.com/photo-1522202176988-66273c2fd55f?auto=format&fit=crop&w=900&q=80',
      'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?auto=format&fit=crop&w=900&q=80',
    ];

    if (item.type == 'manga') {
      return MediaDetail(
        id: item.id,
        title: item.title,
        coverUrl: item.coverUrl,
        type: item.type,
        sourceName: item.sourceName,
        description: item.description,
        status: 'Ongoing',
        genres: ['Action', 'Adventure', 'Fantasy'],
        chapters: [
          ChapterItem(id: 'ch1', title: 'Chapter 1', pages: images),
          ChapterItem(id: 'ch2', title: 'Chapter 2', pages: images),
          ChapterItem(id: 'ch3', title: 'Chapter 3', pages: images),
        ],
        streams: [],
      );
    }

    return MediaDetail(
      id: item.id,
      title: item.title,
      coverUrl: item.coverUrl,
      type: item.type,
      sourceName: item.sourceName,
      description: item.description,
      status: 'Completed',
      genres: ['Action', 'Drama', 'Adventure'],
      chapters: [],
      streams: [
        StreamSource(
          id: '480',
          label: '480p',
          url: 'https://samplelib.com/lib/preview/mp4/sample-5s.mp4',
        ),
        StreamSource(
          id: '720',
          label: '720p',
          url: 'https://samplelib.com/lib/preview/mp4/sample-10s.mp4',
        ),
      ],
    );
  }
}
