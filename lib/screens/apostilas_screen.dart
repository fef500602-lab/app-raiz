import 'package:flutter/material.dart';
import 'apostila_screen.dart';
import 'sequencia_list_screen.dart';
import '../data/sequencias_data.dart';

// ──────────────────────────────────────────────
// Item genérico da lista de apostilas
// ──────────────────────────────────────────────
abstract class _ApostilaItem {
  String get titulo;
  String get subtitulo;
  IconData get icone;
  void abrir(BuildContext context);
}

class _ApostilaMarkdown extends _ApostilaItem {
  @override final String titulo;
  @override final String subtitulo;
  @override final IconData icone;
  final String assetPath;
  final String? pdfAssetPath;

  _ApostilaMarkdown({
    required this.titulo,
    required this.subtitulo,
    this.icone = Icons.auto_stories_outlined,
    required this.assetPath,
    this.pdfAssetPath,
  });

  @override
  void abrir(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ApostilaScreen(
          title: titulo,
          assetPath: assetPath,
          pdfAssetPath: pdfAssetPath,
        ),
      ),
    );
  }
}

class _ApostilaSequencias extends _ApostilaItem {
  @override final String titulo;
  @override final String subtitulo;
  @override final IconData icone;
  final int categoriaIndex;

  _ApostilaSequencias({
    required this.titulo,
    required this.subtitulo,
    required this.icone,
    required this.categoriaIndex,
  });

  @override
  void abrir(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SequenciaListScreen(
          categoria: categoriasSequencias[categoriaIndex],
        ),
      ),
    );
  }
}

final List<_ApostilaItem> _itens = [
  _ApostilaMarkdown(
    titulo: 'Apostila Raiz dos Palmares',
    subtitulo: 'História, golpes, graduação e muito mais',
    assetPath: 'assets/apostilas/apostila_raiz_dos_palmares.md',
    pdfAssetPath: 'assets/apostilas/Apostila_Raiz_dos_Palmares_Fundo_Claro.pdf',
  ),
  _ApostilaSequencias(
    titulo: 'Sequências de Entrada e Saída',
    subtitulo: 'Técnicas de entrada e saída do jogo',
    icone: Icons.compare_arrows_rounded,
    categoriaIndex: 0,
  ),
  _ApostilaSequencias(
    titulo: 'Sequências de Bimba',
    subtitulo: '8 sequências clássicas de Mestre Bimba',
    icone: Icons.loop_rounded,
    categoriaIndex: 1,
  ),
  _ApostilaSequencias(
    titulo: 'Sequências do Grupo',
    subtitulo: 'Sequências do Raiz dos Palmares',
    icone: Icons.groups_outlined,
    categoriaIndex: 2,
  ),
];

// ──────────────────────────────────────────────
// Tela principal de Apostilas
// ──────────────────────────────────────────────
class ApostilasScreen extends StatelessWidget {
  const ApostilasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Apostilas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _itens.length,
        itemBuilder: (context, index) {
          if (index == 1) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'SEQUÊNCIAS',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
                _ApostilaCard(item: _itens[index]),
                const SizedBox(height: 12),
              ],
            );
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ApostilaCard(item: _itens[index]),
          );
        },
      ),
    );
  }
}

class _ApostilaCard extends StatelessWidget {
  final _ApostilaItem item;
  const _ApostilaCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => item.abrir(context),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icone, color: Colors.amber, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.titulo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitulo,
                    style: const TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white38),
          ],
        ),
      ),
    );
  }
}
