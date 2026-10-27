import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../../data/models/media_detail.dart';
import '../../data/models/media_item.dart';

class ReaderScreen extends StatefulWidget {
  final MediaItem media;
  final List<ChapterItem> chapters;
  final int initialChapterIndex;

  const ReaderScreen({
    super.key,
    required this.media,
    required this.chapters,
    this.initialChapterIndex = 0,
  });

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  late int currentChapterIndex;

  @override
  void initState() {
    super.initState();
    currentChapterIndex = widget.initialChapterIndex;
  }

  @override
  Widget build(BuildContext context) {
    final chapter = widget.chapters[currentChapterIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.media.title} - ${chapter.title}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              itemCount: chapter.pages.length,
              itemBuilder: (context, index) {
                final url = chapter.pages[index];
                return ExtendedImage.network(
                  url,
                  fit: BoxFit.contain,
                  mode: ExtendedImageMode.gesture,
                  cache: true,
                  loadStateChanged: (state) {
                    if (state.extendedImageLoadState == LoadState.loading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return null;
                  },
                );
              },
            ),
          ),
          Container(
            height: 70,
            color: Colors.black12,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                IconButton(
                  onPressed: currentChapterIndex > 0
                      ? () {
                          setState(() {
                            currentChapterIndex--;
                          });
                        }
                      : null,
                  icon: const Icon(Icons.arrow_back_ios_new),
                ),
                Expanded(
                  child: Center(
                    child: Text(chapter.title, overflow: TextOverflow.ellipsis),
                  ),
                ),
                IconButton(
                  onPressed: currentChapterIndex < widget.chapters.length - 1
                      ? () {
                          setState(() {
                            currentChapterIndex++;
                          });
                        }
                      : null,
                  icon: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
