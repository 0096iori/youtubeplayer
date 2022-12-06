import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:youtube_player_iframe_example/full_screen_player_page.dart';

const List<String> _videoIds = [
  'Gbz2C2gQREI',
  'M6gcoDN9jBc',
  'M2cckDmNLMI',
];

///
class VideoListPage extends StatefulWidget {
  ///
  const VideoListPage({super.key});

  @override
  State<VideoListPage> createState() => _VideoListPageState();
}

class _VideoListPageState extends State<VideoListPage> {
  late final List<YoutubePlayerController> _controllers;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      _videoIds.length,
      (index) => YoutubePlayerController.fromVideoId(
        videoId: _videoIds[index],
        autoPlay: false,
        params: const YoutubePlayerParams(showFullscreenButton: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('再生リスト'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: _controllers.length,
        itemBuilder: (context, index) {
          final controller = _controllers[index];

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: YoutubePlayer(
                key: ObjectKey(controller),
                aspectRatio: 16 / 9,
                enableFullScreenOnVerticalDrag: false,
                controller: controller
                  ..onFullscreenChange = (_) async {
                    final videoData = await controller.videoData;
                    final startSeconds = await controller.currentTime;

                    final currentTime = await Navigator.push<double>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenPlayerPage(
                          videoId: videoData.videoId,
                          startSeconds: startSeconds,
                        ),
                      ),
                    );

                    if (currentTime != null) {
                      controller.seekTo(seconds: currentTime);
                    }
                  },
              ),
            ),
          );
        },
        separatorBuilder: (context, _) => const SizedBox(height: 16),
      ),
    );
  }
}
