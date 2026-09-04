import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme_notifier.dart';
import 'videos_screen.dart' show Video, videosHistoria;

// ── Vídeos de Técnicas (YouTube Shorts do grupo) ──────────────────────────────
const List<Video> videosTecnicas = [
  Video(id: 'tYYLh8Kqwbs', title: 'Sequência de Entrada',  subtitle: 'Movimentos de entrada no jogo'),
  Video(id: 'x81wNaS_tS0', title: 'Sequência de Saída',    subtitle: 'Movimentos de saída do jogo'),
  Video(id: 'u1-vQo6I0BE', title: 'Sequências de Bimba',   subtitle: 'Técnicas e movimentos tradicionais'),
  Video(id: '0ZB3exeBtZM', title: 'Sequências do Grupo',   subtitle: 'Movimentos do Raiz dos Palmares'),
];

// ── Logo + título reutilizável ────────────────────────────────────────────────
Widget buildLogoTitle(BuildContext context, String title) {
  final cs = Theme.of(context).colorScheme;
  return Row(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.asset(
          'assets/logo_raiz_palmares.jpg',
          height: 32, width: 32, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: 32, height: 32,
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.star, color: Colors.white, size: 20),
          ),
        ),
      ),
      const SizedBox(width: 10),
      Text(
        title,
        style: GoogleFonts.bricolageGrotesque(
          color: cs.onSurface,
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
    ],
  );
}

// ── Tela de Vídeos (abas História / Técnicas) ─────────────────────────────────
class VideosTabScreen extends StatelessWidget {
  const VideosTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: cs.surface,
        appBar: AppBar(
          backgroundColor: cs.surface,
          automaticallyImplyLeading: false,
          title: buildLogoTitle(context, 'Raiz dos Palmares'),
          actions: [buildThemeToggle(context)],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(49),
            child: Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: cs.outlineVariant, width: 1)),
              ),
              child: TabBar(
                labelColor: cs.primary,
                unselectedLabelColor: cs.onSurfaceVariant,
                indicatorColor: cs.primary,
                indicatorWeight: 2,
                dividerColor: Colors.transparent,
                labelStyle: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600),
                unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontSize: 14),
                tabs: const [Tab(text: 'História'), Tab(text: 'Técnicas')],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _VideoListView(videos: videosHistoria, isShorts: false),
            _VideoListView(videos: videosTecnicas, isShorts: true),
          ],
        ),
      ),
    );
  }
}

// ── Lista de vídeos ───────────────────────────────────────────────────────────
class _VideoListView extends StatelessWidget {
  final List<Video> videos;
  final bool isShorts;
  const _VideoListView({required this.videos, required this.isShorts});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: videos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) => _VideoCard(video: videos[i], isShorts: isShorts),
    );
  }
}

// ── Card de vídeo ─────────────────────────────────────────────────────────────
class _VideoCard extends StatelessWidget {
  final Video video;
  final bool isShorts;
  const _VideoCard({required this.video, required this.isShorts});

  Future<void> _openVideo(BuildContext context) async {
    final url = isShorts
        ? 'https://www.youtube.com/shorts/${video.id}'
        : video.youtubeUrl;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o vídeo.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () => _openVideo(context),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: cs.primary.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    video.thumbnailUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: cs.surfaceContainerHigh,
                      child: Icon(Icons.video_library, color: cs.outlineVariant, size: 48),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter, end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Color(0x33000000)],
                      ),
                    ),
                  ),
                  // Botão play
                  Center(
                    child: Container(
                      width: 52, height: 52,
                      decoration: BoxDecoration(
                        color: cs.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: cs.primary.withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32),
                    ),
                  ),
                  // Badge (cores fixas — sobrepõe foto)
                  Positioned(
                    bottom: 8, right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(isShorts ? Icons.play_circle_outline : Icons.open_in_new,
                              color: const Color(0xFF9F3C16), size: 11),
                          const SizedBox(width: 3),
                          Text(
                            isShorts ? 'Shorts' : 'YouTube',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF1C1C18), fontSize: 10, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Texto
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(video.title,
                      style: GoogleFonts.bricolageGrotesque(
                          color: cs.onSurface, fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(video.subtitle,
                      style: GoogleFonts.plusJakartaSans(color: cs.onSurfaceVariant, fontSize: 13)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
