import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'apostila_screen.dart';
import 'videos_tab_screen.dart' show buildLogoTitle;

class ApostilasScreen extends StatelessWidget {
  const ApostilasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        automaticallyImplyLeading: false,
        title: buildLogoTitle('Apostila'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: cs.outlineVariant,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _ApostilaCard(
          titulo: 'Apostila Raiz dos Palmares',
          subtitulo: 'História, golpes, graduação e muito mais',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const ApostilaScreen(
                title: 'Apostila Raiz dos Palmares',
                assetPath: 'assets/apostilas/apostila_raiz_dos_palmares.md',
                pdfAssetPath:
                    'assets/apostilas/Apostila_Raiz_dos_Palmares_Fundo_Claro.pdf',
                pdfOriginalAssetPath:
                    'assets/apostilas/Apostila_Raiz_dos_Palmares.pdf',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ApostilaCard extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;

  const _ApostilaCard({
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF1EDE7), // surface-container
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFDEC0B7), // outline-variant
            width: 0.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9F3C16).withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Ícone livro
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.auto_stories_outlined,
                color: cs.primary,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: GoogleFonts.bricolageGrotesque(
                      color: cs.onSurface,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitulo,
                    style: GoogleFonts.plusJakartaSans(
                      color: cs.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: cs.outline, size: 20),
          ],
        ),
      ),
    );
  }
}
