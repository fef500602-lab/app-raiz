import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/sequencias_data.dart';
import '../theme_notifier.dart';
import 'sequencia_list_screen.dart';
import 'videos_tab_screen.dart' show buildLogoTitle;

class SequenciasTabScreen extends StatelessWidget {
  const SequenciasTabScreen({super.key});

  static const _icons = [
    Icons.compare_arrows_rounded,
    Icons.loop_rounded,
    Icons.groups_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        automaticallyImplyLeading: false,
        title: buildLogoTitle(context, 'Sequências'),
        actions: [buildThemeToggle(context)],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: cs.outlineVariant),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: categoriasSequencias.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final cat = categoriasSequencias[index];
          return _SequenciaCard(
            titulo: cat.nome,
            subtitulo: cat.descricao,
            icone: _icons[index],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SequenciaListScreen(categoria: cat),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _SequenciaCard extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final IconData icone;
  final VoidCallback onTap;

  const _SequenciaCard({
    required this.titulo,
    required this.subtitulo,
    required this.icone,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cs.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: cs.primary.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icone, color: cs.primary, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo,
                      style: GoogleFonts.bricolageGrotesque(
                          color: cs.onSurface, fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(subtitulo,
                      style: GoogleFonts.plusJakartaSans(
                          color: cs.onSurfaceVariant, fontSize: 13)),
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
