import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Video {
  final String id;
  final String title;
  final String subtitle;

  const Video({
    required this.id,
    required this.title,
    required this.subtitle,
  });

  String get youtubeUrl => 'https://www.youtube.com/watch?v=$id';
  String get thumbnailUrl => 'https://img.youtube.com/vi/$id/mqdefault.jpg';
}

const List<Video> videos = [
  Video(
    id: 'lrTkynvAJnE',
    title: 'Sequências de Bimba',
    subtitle: 'Técnicas e movimentos tradicionais',
  ),
  Video(
    id: 'W5uFp8m1F4U',
    title: 'Sequências do Grupo',
    subtitle: 'Movimentos do nosso grupo',
  ),
];

class VideosScreen extends StatelessWidget {
  const VideosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Vídeos',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: videos.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          return _VideoCard(video: videos[index]);
        },
      ),
    );
  }
}

class _VideoCard extends StatelessWidget {
  final Video video;
  const _VideoCard({required this.video});

  Future<void> _openYoutube(BuildContext context) async {
    final uri = Uri.parse(video.youtubeUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível abrir o vídeo.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openYoutube(context),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    video.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFF2C2C2C),
                      child: const Icon(Icons.video_library,
                          color: Colors.white38, size: 48),
                    ),
                  ),
                  Container(color: Colors.black.withOpacity(0.2)),
                  Center(
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.play_arrow_rounded,
                          color: Color(0xFF1E1E1E), size: 36),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.open_in_new,
                              color: Colors.white70, size: 12),
                          SizedBox(width: 4),
                          Text('YouTube',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(video.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(video.subtitle,
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
