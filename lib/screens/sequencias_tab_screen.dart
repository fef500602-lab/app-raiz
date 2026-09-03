import 'package:flutter/material.dart';
import '../data/sequencias_data.dart';
import 'sequencia_list_screen.dart';
import 'videos_tab_screen.dart' show buildLogoTitle;

class SequenciasTabScreen extends StatelessWidget {
  const SequenciasTabScreen({super.key});

  static const _icons = [
    Icons.compare_arrows_rounded,   // Entrada e Saída
    Icons.loop_rounded,             // Bimba
    Icons.groups_outlined,          // Grupo
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        automaticallyImplyLeading: false,
        title: buildLogoTitle('Sequências'),
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
    return GestureDetector(
      onTap: onTap,
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
              child: Icon(icone, color: Colors.amber, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitulo,
                    style:
                        const TextStyle(color: Colors.white54, fontSize: 13),
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
