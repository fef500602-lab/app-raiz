enum Atacante { a, b }

class Movimento {
  final String nomeA;
  final String nomeB;
  final Atacante atacante;

  const Movimento({
    required this.nomeA,
    required this.nomeB,
    required this.atacante,
  });
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

class CategoriaSequencias {
  final String nome;
  final String descricao;
  final String? pdfAssetPath;
  final List<Sequencia> sequencias;

  const CategoriaSequencias({
    required this.nome,
    required this.descricao,
    this.pdfAssetPath,
    required this.sequencias,
  });
}
