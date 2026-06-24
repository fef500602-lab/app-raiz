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
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Sequências de Capoeira — Raiz dos Palmares',
      );
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
      body: categoria.ehDrill
          ? _DrillView(drills: categoria.drills)
          : _SequenciasView(sequencias: categoria.sequencias),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VIEW: Drills individuais (Entrada e Saída)
// ─────────────────────────────────────────────────────────────────────────────
class _DrillView extends StatelessWidget {
  final List<GrupoDrills> drills;
  const _DrillView({required this.drills});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.amber.withOpacity(0.2)),
          ),
          child: const Text(
            'Execute cada movimento no ritmo da ginga, alternando os lados conforme indicado.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
          ),
        ),
        for (final grupo in drills) ...[
          _GrupoDrillCard(grupo: grupo),
          const SizedBox(height: 16),
        ],
      ],
    );
  }
}

class _GrupoDrillCard extends StatelessWidget {
  final GrupoDrills grupo;
  const _GrupoDrillCard({required this.grupo});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.12),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Text(
              grupo.titulo.toUpperCase(),
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
          ...List.generate(grupo.movimentos.length, (i) {
            final mov = grupo.movimentos[i];
            final isLast = i == grupo.movimentos.length - 1;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.amber.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${i + 1}',
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          mov.nome,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C2C2C),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          mov.repeticoes,
                          style: const TextStyle(color: Colors.white60, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  const Divider(height: 1, color: Color(0xFF2C2C2C), indent: 56),
              ],
            );
          }),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// VIEW: Sequências pareadas (A vs B)
// ─────────────────────────────────────────────────────────────────────────────
class _SequenciasView extends StatelessWidget {
  final List<Sequencia> sequencias;
  const _SequenciasView({required this.sequencias});

  @override
  Widget build(BuildContext context) {
    return Column(
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
              _LegendaBadge(cor: const Color(0xFFFFB300), letra: 'A', label: 'Aluno A'),
              const SizedBox(width: 24),
              _LegendaBadge(cor: const Color(0xFF29B6F6), letra: 'B', label: 'Aluno B'),
              const SizedBox(width: 24),
              Row(children: [
                const Icon(Icons.arrow_forward, color: Colors.white38, size: 16),
                const SizedBox(width: 4),
                const Text('ataca', style: TextStyle(color: Colors.white38, fontSize: 12)),
              ]),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: sequencias.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) => _SequenciaCard(sequencia: sequencias[index]),
          ),
        ),
      ],
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
            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 6, offset: const Offset(0, 3)),
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
                    child: Text('${seq.numero}',
                        style: const TextStyle(
                            color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 14)),
                  ),
                  const SizedBox(width: 10),
                  Text('${seq.numero}ª Sequência',
                      style: const TextStyle(
                          color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text('${seq.movimentos.length} mov.',
                      style: const TextStyle(color: Colors.white38, fontSize: 12)),
                  const SizedBox(width: 8),
                  Icon(_expandido ? Icons.expand_less : Icons.expand_more,
                      color: Colors.white38, size: 20),
                ],
              ),
            ),

            // Preview colapsado
            if (!_expandido)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: seq.movimentos.map((m) {
                    if (m.ehFinalizacao) {
                      final nome = m.nomeA.isNotEmpty ? m.nomeA : m.nomeB;
                      return _GolpeChip(nome: nome, corBorda: Colors.white38);
                    }
                    final atacaA = m.atacante == Atacante.a;
                    return _GolpeChip(
                      nome: atacaA ? m.nomeA : m.nomeB,
                      corBorda: atacaA ? const Color(0xFFFFB300) : const Color(0xFF29B6F6),
                    );
                  }).toList(),
                ),
              ),

            // Expandido
            if (_expandido) ...[
              const Divider(color: Color(0xFF2C2C2C), height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: Column(
                  children: List.generate(seq.movimentos.length, (i) {
                    return _MovimentoRow(mov: seq.movimentos[i]);
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
                    child: Text(seq.observacao!,
                        style: const TextStyle(
                            color: Colors.white60, fontSize: 12.5, fontStyle: FontStyle.italic)),
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
  const _MovimentoRow({required this.mov});

  @override
  Widget build(BuildContext context) {
    const corA = Color(0xFFFFB300);
    const corB = Color(0xFF29B6F6);

    // Movimento de finalização (só um lado)
    if (mov.ehFinalizacao) {
      final isA = mov.nomeA.isNotEmpty;
      final nome = isA ? mov.nomeA : mov.nomeB;
      final cor = isA ? corA : corB;
      final letra = isA ? 'A' : 'B';
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: cor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: cor.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 20, height: 20,
                      decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: Text(letra,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.sports_martial_arts, color: Colors.amber, size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(nome,
                          style: TextStyle(
                              color: cor, fontSize: 12.5, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Movimento pareado normal
    final atacaA = mov.atacante == Atacante.a;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: _GolpeBox(
              nome: mov.nomeA,
              cor: corA,
              destaque: atacaA,
              alinhaDireita: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: atacaA
                ? const Icon(Icons.arrow_forward, color: Color(0xFFFFB300), size: 18)
                : const Icon(Icons.arrow_back, color: Color(0xFF29B6F6), size: 18),
          ),
          Expanded(
            flex: 4,
            child: _GolpeBox(
              nome: mov.nomeB,
              cor: corB,
              destaque: !atacaA,
              alinhaDireita: false,
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
  final bool alinhaDireita;

  const _GolpeBox({
    required this.nome,
    required this.cor,
    required this.destaque,
    required this.alinhaDireita,
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
        ),
      ),
      child: Text(
        nome,
        textAlign: alinhaDireita ? TextAlign.right : TextAlign.left,
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
        border: Border.all(color: corBorda.withOpacity(0.4)),
      ),
      child: Text(nome, style: TextStyle(color: corBorda, fontSize: 11)),
    );
  }
}
