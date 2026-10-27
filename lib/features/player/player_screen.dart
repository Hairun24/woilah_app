import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../../data/models/media_detail.dart';
import '../../data/models/media_item.dart';

class PlayerScreen extends StatefulWidget {
  final MediaItem media;
  final List<StreamSource> streams;
  final int initialStreamIndex;

  const PlayerScreen({
    super.key,
    required this.media,
    required this.streams,
    this.initialStreamIndex = 0,
  });

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late final Player player;
  late final VideoController controller;
  late int currentStreamIndex;

  @override
  void initState() {
    super.initState();
    currentStreamIndex = widget.initialStreamIndex;
    player = Player();
    controller = VideoController(player);
    _openCurrentStream();
  }

  Future<void> _openCurrentStream() async {
    final stream = widget.streams[currentStreamIndex];
    await player.open(Media(stream.url));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentStream = widget.streams[currentStreamIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.media.title),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 260,
            child: Video(controller: controller, fit: BoxFit.cover),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.media.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(widget.media.description),
                const SizedBox(height: 20),
                const Text(
                  'Pilih kualitas',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: widget.streams.map((stream) {
                    final selected = stream.id == currentStream.id;
                    return ChoiceChip(
                      label: Text(stream.label),
                      selected: selected,
                      onSelected: (value) {
                        if (!value) return;
                        final index = widget.streams.indexWhere(
                          (item) => item.id == stream.id,
                        );
                        if (index != -1) {
                          setState(() {
                            currentStreamIndex = index;
                          });
                          _openCurrentStream();
                        }
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
