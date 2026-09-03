import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'videos_screen.dart' show Video, videosHistoria; // modelo + dados História

// ── Novos vídeos de Técnicas (YouTube Shorts do grupo) ────────────────────────
const List<Video> videosTecnicas = [
  Video(
    id: 'tYYLh8Kqwbs',
    title: 'Sequência de Entrada',
    subtitle: 'Movimentos de entrada no jogo',
  ),
  Video(
    id: 'x81wNaS_tS0',
    title: 'Sequência de Saída',
    subtitle: 'Movimentos de saída do jogo',
  ),
  Video(
    id: 'u1-vQo6I0BE',
    title: 'Sequências de Bimba',
    subtitle: 'Técnicas e movimentos tradicionais',
  ),
  Video(
    id: '0ZB3exeBtZM',
    title: 'Sequências do Grupo',
    subtitle: 'Movimentos do Raiz dos Palmares',
  ),
];

// ── Logo + título reutilizável ─────────────────────────────────────────────────
Widget buildLogoTitle(String title) {
  return Row(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.asset(
          'assets/logo_raiz_palmares.jpg',
          height: 32,
          width: 32,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const SizedBox(
            width: 32,
            height: 32,
            child: Icon(Icons.star, color: Colors.amber, size: 24),
          ),
        ),
      ),
      const SizedBox(width: 10),
      Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    ],
  );
}

// ── Tela principal de Vídeos (com abas História / Técnicas) ───────────────────
class VideosTabScreen extends StatelessWidget {
  const VideosTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF121212),
        appBar: AppBar(
          backgroundColor: const Color(0xFF1E1E1E),
          automaticallyImplyLeading: false,
          title: buildLogoTitle('Raiz dos Palmares'),
          bottom: const TabBar(
            labelColor: Colors.amber,
            unselectedLabelColor: Colors.white54,
            indicatorColor: Colors.amber,
            tabs: [
              Tab(text: 'História'),
              Tab(text: 'Técnicas'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Aba 1: documentários — abre YouTube externo
            _VideoListView(videos: videosHistoria, embedded: false),
            // Aba 2: Shorts do grupo — player embarcado
            _VideoListView(videos: videosTecnicas, embedded: true),
          ],
        ),
      ),
    );
  }
}

// ── Lista de vídeos ───────────────────────────────────────────────────────────
class _VideoListView extends StatelessWidget {
  final List<Video> videos;
  final bool embedded;

  const _VideoListView({required this.videos, required this.embedded});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: videos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) =>
          _VideoCard(video: videos[index], embedded: embedded),
    );
  }
}

// ── Card de vídeo ─────────────────────────────────────────────────────────────
class _VideoCard extends StatelessWidget {
  final Video video;
  final bool embedded;

  const _VideoCard({required this.video, required this.embedded});

  Future<void> _openYoutube(BuildContext context) async {
    final uri = Uri.parse(video.youtubeUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o vídeo.')),
      );
    }
  }

  void _openEmbedded(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VideoPlayerScreen(
          videoId: video.id,
          title: video.title,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          embedded ? _openEmbedded(context) : _openYoutube(context),
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
                      child: const Icon(
                        Icons.play_arrow_rounded,
                        color: Color(0xFF1E1E1E),
                        size: 36,
                      ),
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
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            embedded
                                ? Icons.play_circle_outline
                                : Icons.open_in_new,
                            color: Colors.white70,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            embedded ? 'Assistir' : 'YouTube',
                            style: const TextStyle(
                                color: Colors.white70, fontSize: 11),
                          ),
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
                  Text(
                    video.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    video.subtitle,
                    style:
                        const TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Player embarcado (Shorts em 9:16) ─────────────────────────────────────────
class VideoPlayerScreen extends StatefulWidget {
  final String videoId;
  final String title;

  const VideoPlayerScreen({
    super.key,
    required this.videoId,
    required this.title,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late final YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerScaffold(
      controller: _controller,
      aspectRatio: 9 / 16,
      builder: (context, player) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: const Color(0xFF1E1E1E),
            title: Text(
              widget.title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(child: player),
        );
      },
    );
  }
}
