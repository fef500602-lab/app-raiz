import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import '../models/sequencia_model.dart';

// Cores funcionais A/B — adaptam ao tema
Color _corA(BuildContext ctx) {
  final brightness = Theme.of(ctx).colorScheme.brightness;
  return brightness == Brightness.dark
      ? const Color(0xFFE07A4A) // terracota mais claro no escuro
      : const Color(0xFFBF542C); // terracota no claro
}

Color _corB(BuildContext ctx) {
  final brightness = Theme.of(ctx).colorScheme.brightness;
  return brightness == Brightness.dark
      ? const Color(0xFF5DA882) // verde mais claro no escuro
      : const Color(0xFF3B6752); // verde no claro
}

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
      await Share.shareXFiles([XFile(file.path)],
          text: 'Sequências de Capoeira — Raiz dos Palmares');
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
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        title: Text(categoria.nome,
            style: GoogleFonts.bricolageGrotesque(
                color: cs.onSurface, fontWeight: FontWeight.w700, fontSize: 18)),
        iconTheme: IconThemeData(color: cs.onSurface),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: cs.outlineVariant),
        ),
        actions: [
          if (categoria.pdfAssetPath != null)
            IconButton(
              icon: Icon(Icons.share_outlined, color: cs.primary),
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
class _DrillView extends StatelessWidget {
  final List<GrupoDrills> drills;
  const _DrillView({required this.drills});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: cs.primary.withOpacity(0.07),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.primary.withOpacity(0.2)),
          ),
          child: Text(
            'Execute cada movimento no ritmo da ginga, alternando os lados conforme indicado.',
            style: GoogleFonts.plusJakartaSans(
                color: cs.onSurfaceVariant, fontSize: 13, height: 1.5),
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
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainer,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant, width: 0.5),
        boxShadow: [
          BoxShadow(color: cs.primary.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(0.1),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Text(grupo.titulo.toUpperCase(),
                style: GoogleFonts.plusJakartaSans(
                    color: cs.primary, fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1.5)),
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
                        width: 28, height: 28,
                        decoration: BoxDecoration(
                            color: cs.primary.withOpacity(0.12), shape: BoxShape.circle),
                        alignment: Alignment.center,
                        child: Text('${i + 1}',
                            style: GoogleFonts.plusJakartaSans(
                                color: cs.primary, fontSize: 12, fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(mov.nome,
                            style: GoogleFonts.plusJakartaSans(
                                color: cs.onSurface, fontSize: 14, fontWeight: FontWeight.w500)),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                            color: cs.surfaceContainerHigh, borderRadius: BorderRadius.circular(20)),
                        child: Text(mov.repeticoes,
                            style: GoogleFonts.plusJakartaSans(color: cs.onSurfaceVariant, fontSize: 12)),
                      ),
                    ],
                  ),
                ),
                if (!isLast) Divider(height: 1, color: cs.outlineVariant, indent: 56),
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
class _SequenciasView extends StatelessWidget {
  final List<Sequencia> sequencias;
  const _SequenciasView({required this.sequencias});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final corAv = _corA(context);
    final corBv = _corB(context);
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: cs.surfaceContainer,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cs.outlineVariant, width: 0.5),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendaBadge(cor: corAv, letra: 'A', label: 'Aluno A'),
              const SizedBox(width: 24),
              _LegendaBadge(cor: corBv, letra: 'B', label: 'Aluno B'),
              const SizedBox(width: 24),
              Row(children: [
                Icon(Icons.arrow_forward, color: cs.onSurface.withOpacity(0.3), size: 16),
                const SizedBox(width: 4),
                Text('ataca',
                    style: GoogleFonts.plusJakartaSans(color: cs.onSurfaceVariant, fontSize: 12)),
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
            itemBuilder: (ctx, i) => _SequenciaCard(sequencia: sequencias[i]),
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
          width: 22, height: 22,
          decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text(letra,
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 6),
        Text(label,
            style: GoogleFonts.plusJakartaSans(
                color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
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
    final cs = Theme.of(context).colorScheme;
    final corAv = _corA(context);
    final corBv = _corB(context);

    return GestureDetector(
      onTap: () => setState(() => _expandido = !_expandido),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: cs.surfaceContainer,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _expandido ? cs.primary.withOpacity(0.5) : cs.outlineVariant,
            width: _expandido ? 1.5 : 0.5,
          ),
          boxShadow: [
            BoxShadow(color: cs.primary.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
              child: Row(
                children: [
                  Container(
                    width: 32, height: 32,
                    decoration: BoxDecoration(
                        color: cs.primary.withOpacity(0.12), shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: Text('${seq.numero}',
                        style: GoogleFonts.bricolageGrotesque(
                            color: cs.primary, fontWeight: FontWeight.w700, fontSize: 14)),
                  ),
                  const SizedBox(width: 10),
                  Text('${seq.numero}ª Sequência',
                      style: GoogleFonts.bricolageGrotesque(
                          color: cs.onSurface, fontSize: 15, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  Text('${seq.movimentos.length} mov.',
                      style: GoogleFonts.plusJakartaSans(color: cs.onSurfaceVariant, fontSize: 12)),
                  const SizedBox(width: 8),
                  Icon(_expandido ? Icons.expand_less : Icons.expand_more,
                      color: cs.onSurfaceVariant, size: 20),
                ],
              ),
            ),

            if (!_expandido)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
                child: Wrap(
                  spacing: 6, runSpacing: 4,
                  children: seq.movimentos.map((m) {
                    if (m.ehFinalizacao) {
                      final nome = m.nomeA.isNotEmpty ? m.nomeA : m.nomeB;
                      return _GolpeChip(nome: nome, corBorda: cs.onSurfaceVariant.withOpacity(0.5));
                    }
                    final atacaA = m.atacante == Atacante.a;
                    return _GolpeChip(nome: atacaA ? m.nomeA : m.nomeB,
                        corBorda: atacaA ? corAv : corBv);
                  }).toList(),
                ),
              ),

            if (_expandido) ...[
              Divider(color: cs.outlineVariant, height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                child: Column(
                  children: seq.movimentos
                      .map((m) => _MovimentoRow(mov: m, corA: corAv, corB: corBv))
                      .toList(),
                ),
              ),
              if (seq.observacao != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: cs.primary.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(8),
                      border: Border(left: BorderSide(color: cs.primary.withOpacity(0.5), width: 3)),
                    ),
                    child: Text(seq.observacao!,
                        style: GoogleFonts.plusJakartaSans(
                            color: cs.onSurfaceVariant, fontSize: 12.5,
                            fontStyle: FontStyle.italic)),
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
  final Color corA;
  final Color corB;
  const _MovimentoRow({required this.mov, required this.corA, required this.corB});

  @override
  Widget build(BuildContext context) {
    if (mov.ehFinalizacao) {
      final isA = mov.nomeA.isNotEmpty;
      final nome = isA ? mov.nomeA : mov.nomeB;
      final cor = isA ? corA : corB;
      final letra = isA ? 'A' : 'B';
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: cor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: cor.withOpacity(0.35)),
          ),
          child: Row(
            children: [
              Container(
                width: 20, height: 20,
                decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text(letra,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              Icon(Icons.sports_martial_arts, color: cor, size: 14),
              const SizedBox(width: 6),
              Expanded(
                child: Text(nome,
                    style: GoogleFonts.plusJakartaSans(
                        color: cor, fontSize: 12.5, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      );
    }

    final atacaA = mov.atacante == Atacante.a;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(flex: 4,
              child: _GolpeBox(nome: mov.nomeA, cor: corA, destaque: atacaA, alinhaDireita: true)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Icon(atacaA ? Icons.arrow_forward : Icons.arrow_back,
                color: atacaA ? corA : corB, size: 18),
          ),
          Expanded(flex: 4,
              child: _GolpeBox(nome: mov.nomeB, cor: corB, destaque: !atacaA, alinhaDireita: false)),
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
  const _GolpeBox({required this.nome, required this.cor, required this.destaque, required this.alinhaDireita});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: destaque ? cor.withOpacity(0.12) : cs.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: destaque ? cor.withOpacity(0.45) : Colors.transparent),
      ),
      child: Text(nome,
          textAlign: alinhaDireita ? TextAlign.right : TextAlign.left,
          style: GoogleFonts.plusJakartaSans(
            color: destaque ? cor : cs.onSurfaceVariant,
            fontSize: 12.5,
            fontWeight: destaque ? FontWeight.bold : FontWeight.normal,
          )),
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
        color: corBorda.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: corBorda.withOpacity(0.35)),
      ),
      child: Text(nome,
          style: GoogleFonts.plusJakartaSans(color: corBorda, fontSize: 11)),
    );
  }
}
