import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import '../models/sequencia_model.dart';

class SequenciaListScreen extends StatelessWidget {
  final CategoriaSequencias categoria;

  const SequenciaListScreen({super.key, required this.categoria});

  Future<void> _sharePdf(BuildContext context) async {
    if (categoria.pdfAssetPath == null) return;
    try {
      final bytes = await rootBundle.load(categoria.pdfAssetPath!);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/Sequencias_Capoeira.pdf');
      await file.writeAsBytes(bytes.buffer.asUint8List());
      await Share.shareXFiles([XFile(file.path)], text: 'Sequências de Capoeira — Raiz dos Palmares');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erro ao compartilhar o PDF.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text(
          categoria.nome,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (categoria.pdfAssetPath != null)
            IconButton(
              icon: const Icon(Icons.share_outlined, color: Colors.amber),
              tooltip: 'Compartilhar PDF',
              onPressed: () => _sharePdf(context),
            ),
        ],
      ),
      body: Column(
        children: [
          // Legenda
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _LegendaBadge(cor: const Color(0xFFFFB300), letra: 'A', label: 'Jogador A'),
                const SizedBox(width: 24),
                _LegendaBadge(cor: const Color(0xFF29B6F6), letra: 'B', label: 'Jogador B'),
                const SizedBox(width: 24),
                Row(children: [
                  const Icon(Icons.arrow_forward, color: Colors.white38, size: 16),
                  const SizedBox(width: 4),
                  Text('ataca', style: TextStyle(color: Colors.white38, fontSize: 12)),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              itemCount: categoria.sequencias.length,
              separatorBuilder: (_, __) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                return _SequenciaCard(sequencia: categoria.sequencias[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendaBadge extends StatelessWidget {
  final Color cor;
  final String letra;
  final String label;

  const _LegendaBadge({required this.cor, required this.letra, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text(letra,
              style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}

class _SequenciaCard extends StatefulWidget {
  final Sequencia sequencia;
  const _SequenciaCard({required this.sequencia});

  @override
  State<_SequenciaCard> createState() => _SequenciaCardState();
}

class _SequenciaCardState extends State<_SequenciaCard> {
  bool _expandido = false;

  @override
  Widget build(BuildContext context) {
    final seq = widget.sequencia;
    final isUltimoAtaque = seq.movimentos.isNotEmpty;
    final ultimo = isUltimoAtaque ? seq.movimentos.last : null;
    final ehFinalizacao = ultimo != null &&
        (ultimo.nomeB.toLowerCase().contains('queda') ||
            ultimo.nomeB.toLowerCase().contains('finaliz'));

    return GestureDetector(
      onTap: () => setState(() => _expandido = !_expandido),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _expandido ? Colors.amber.withOpacity(0.5) : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${seq.numero}',
                      style: const TextStyle(
                          color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Sequência ${seq.numero}',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text(
                    '${seq.movimentos.length} mov.',
                    style: const TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _expandido ? Icons.expand_less : Icons.expand_more,
                    color: Colors.white38,
                    size: 20,
                  ),
                ],
              ),
            ),

            // Preview colapsado: mostra só os golpes chave
            if (!_expandido) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: seq.movimentos
                      .map((m) => _GolpeChip(
                            nome: m.atacante == Atacante.a ? m.nomeA : m.nomeB,
                            corBorda: m.atacante == Atacante.a
                                ? const Color(0xFFFFB300)
                                : const Color(0xFF29B6F6),
                          ))
                      .toList(),
                ),
              ),
            ],

            // Expandido: mostra cada movimento em detalhe
            if (_expandido) ...[
              const Divider(color: Color(0xFF2C2C2C), height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: Column(
                  children: List.generate(seq.movimentos.length, (i) {
                    final mov = seq.movimentos[i];
                    final isLast = i == seq.movimentos.length - 1;
                    return _MovimentoRow(
                      mov: mov,
                      isLast: isLast,
                      ehFinalizacao: isLast && ehFinalizacao,
                    );
                  }),
                ),
              ),
              if (seq.observacao != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border(
                        left: BorderSide(color: Colors.amber.withOpacity(0.5), width: 3),
                      ),
                    ),
                    child: Text(
                      seq.observacao!,
                      style: const TextStyle(
                          color: Colors.white60, fontSize: 12.5, fontStyle: FontStyle.italic),
                    ),
                  ),
                )
              else
                const SizedBox(height: 14),
            ],
          ],
        ),
      ),
    );
  }
}

class _MovimentoRow extends StatelessWidget {
  final Movimento mov;
  final bool isLast;
  final bool ehFinalizacao;

  const _MovimentoRow({
    required this.mov,
    required this.isLast,
    required this.ehFinalizacao,
  });

  @override
  Widget build(BuildContext context) {
    const corA = Color(0xFFFFB300);
    const corB = Color(0xFF29B6F6);

    final atacaA = mov.atacante == Atacante.a;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          // Coluna A
          Expanded(
            flex: 4,
            child: _GolpeBox(
              nome: mov.nomeA,
              cor: corA,
              destaque: atacaA,
              alinhamento: CrossAxisAlignment.end,
            ),
          ),

          // Seta central
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Column(
              children: [
                if (ehFinalizacao)
                  const Icon(Icons.sports_martial_arts, color: Colors.amber, size: 18)
                else if (atacaA)
                  const Icon(Icons.arrow_forward, color: Color(0xFFFFB300), size: 18)
                else
                  const Icon(Icons.arrow_back, color: Color(0xFF29B6F6), size: 18),
              ],
            ),
          ),

          // Coluna B
          Expanded(
            flex: 4,
            child: _GolpeBox(
              nome: mov.nomeB,
              cor: corB,
              destaque: !atacaA,
              alinhamento: CrossAxisAlignment.start,
            ),
          ),
        ],
      ),
    );
  }
}

class _GolpeBox extends StatelessWidget {
  final String nome;
  final Color cor;
  final bool destaque;
  final CrossAxisAlignment alinhamento;

  const _GolpeBox({
    required this.nome,
    required this.cor,
    required this.destaque,
    required this.alinhamento,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: destaque ? cor.withOpacity(0.15) : const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: destaque ? cor.withOpacity(0.5) : Colors.transparent,
          width: 1,
        ),
      ),
      child: Text(
        nome,
        textAlign: alinhamento == CrossAxisAlignment.end ? TextAlign.right : TextAlign.left,
        style: TextStyle(
          color: destaque ? cor : Colors.white60,
          fontSize: 12.5,
          fontWeight: destaque ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

class _GolpeChip extends StatelessWidget {
  final String nome;
  final Color corBorda;

  const _GolpeChip({required this.nome, required this.corBorda});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: corBorda.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: corBorda.withOpacity(0.4), width: 1),
      ),
      child: Text(nome, style: TextStyle(color: corBorda, fontSize: 11)),
    );
  }
}
