enum Atacante { a, b }

// ── Sequências pareadas (A vs B) ──────────────────────
class Movimento {
  final String nomeA;
  final String nomeB;
  // null = movimento de finalização (só um lado)
  final Atacante? atacante;
  // true = contragolpe simultâneo (A e B atacam ao mesmo tempo)
  final bool simultaneo;

  const Movimento({
    this.nomeA = '',
    this.nomeB = '',
    this.atacante,
    this.simultaneo = false,
  });

  bool get ehFinalizacao => atacante == null;
}

class Sequencia {
  final int numero;
  final List<Movimento> movimentos;
  final String? observacao;

  const Sequencia({
    required this.numero,
    required this.movimentos,
    this.observacao,
  });
}

// ── Drills individuais (Entrada e Saída) ──────────────
class MovimentoDrill {
  final String nome;
  final String repeticoes;

  const MovimentoDrill({required this.nome, required this.repeticoes});
}

class GrupoDrills {
  final String titulo;
  final List<MovimentoDrill> movimentos;

  const GrupoDrills({required this.titulo, required this.movimentos});
}

// ── Categorias ────────────────────────────────────────
class CategoriaSequencias {
  final String nome;
  final String descricao;
  final String? pdfAssetPath;
  // Para sequências pareadas
  final List<Sequencia> sequencias;
  // Para drills individuais
  final List<GrupoDrills> drills;
  final bool ehDrill;

  const CategoriaSequencias({
    required this.nome,
    required this.descricao,
    this.pdfAssetPath,
    this.sequencias = const [],
    this.drills = const [],
    this.ehDrill = false,
  });
}
