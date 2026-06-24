import '../models/sequencia_model.dart';

// ─────────────────────────────────────────────
// SEQUÊNCIAS DE ENTRADA E SAÍDA
// ─────────────────────────────────────────────
const List<Sequencia> sequenciasEntradaSaida = [
  Sequencia(
    numero: 1,
    movimentos: [
      Movimento(nomeA: 'Ginga', nomeB: 'Ginga', atacante: Atacante.a),
      Movimento(nomeA: 'Meia lua de frente', nomeB: 'Cocorinha', atacante: Atacante.a),
      Movimento(nomeA: 'Aú (saída)', nomeB: 'Ginga (retorno)', atacante: Atacante.b),
    ],
    observacao: 'Sequência básica de entrada pelo pé do berimbau.',
  ),
  Sequencia(
    numero: 2,
    movimentos: [
      Movimento(nomeA: 'Ginga', nomeB: 'Ginga', atacante: Atacante.a),
      Movimento(nomeA: 'Benção', nomeB: 'Esquiva lateral', atacante: Atacante.a),
      Movimento(nomeA: 'Ginga (retorno)', nomeB: 'Aú (saída)', atacante: Atacante.b),
    ],
    observacao: 'Entrada com benção e saída pelo aú.',
  ),
  Sequencia(
    numero: 3,
    movimentos: [
      Movimento(nomeA: 'Ginga', nomeB: 'Ginga', atacante: Atacante.a),
      Movimento(nomeA: 'Queixada', nomeB: 'Aú', atacante: Atacante.a),
      Movimento(nomeA: 'Rolê (saída)', nomeB: 'Ginga (retorno)', atacante: Atacante.b),
    ],
  ),
];

// ─────────────────────────────────────────────
// SEQUÊNCIAS DE BIMBA (8 sequências clássicas)
// ─────────────────────────────────────────────
const List<Sequencia> sequenciasBimba = [
  Sequencia(
    numero: 1,
    movimentos: [
      Movimento(nomeA: 'Meia lua de frente', nomeB: 'Cocorinha', atacante: Atacante.a),
      Movimento(nomeA: 'Galopante', nomeB: 'Mola resistência', atacante: Atacante.a),
      Movimento(nomeA: 'Tesoura de frente', nomeB: 'Queda', atacante: Atacante.a),
    ],
    observacao: 'Sequência de abertura com tesoura de finalização.',
  ),
  Sequencia(
    numero: 2,
    movimentos: [
      Movimento(nomeA: 'Benção', nomeB: 'Esquiva lateral', atacante: Atacante.a),
      Movimento(nomeA: 'Mola', nomeB: 'Rabo de arraia', atacante: Atacante.b),
      Movimento(nomeA: 'Meia lua de compasso', nomeB: 'Aú', atacante: Atacante.a),
      Movimento(nomeA: 'Martelo no chão', nomeB: 'Queda', atacante: Atacante.a),
    ],
  ),
  Sequencia(
    numero: 3,
    movimentos: [
      Movimento(nomeA: 'Queixada', nomeB: 'Aú', atacante: Atacante.a),
      Movimento(nomeA: 'Cocorinha', nomeB: 'Armada', atacante: Atacante.b),
      Movimento(nomeA: 'Galopante', nomeB: 'Mola', atacante: Atacante.a),
      Movimento(nomeA: 'Giro', nomeB: 'Cintura desprezada', atacante: Atacante.b),
    ],
    observacao: 'Sequência com inversão de ataque e cintura desprezada.',
  ),
  Sequencia(
    numero: 4,
    movimentos: [
      Movimento(nomeA: 'Meia lua de frente', nomeB: 'Cocorinha', atacante: Atacante.a),
      Movimento(nomeA: 'Esquiva', nomeB: 'Rabo de arraia', atacante: Atacante.b),
      Movimento(nomeA: 'Armada', nomeB: 'Cocorinha', atacante: Atacante.a),
      Movimento(nomeA: 'Martelo', nomeB: 'Queda', atacante: Atacante.a),
    ],
  ),
  Sequencia(
    numero: 5,
    movimentos: [
      Movimento(nomeA: 'Benção', nomeB: 'Desvio lateral', atacante: Atacante.a),
      Movimento(nomeA: 'Meia lua de compasso', nomeB: 'Aú', atacante: Atacante.a),
      Movimento(nomeA: 'Queda de rins', nomeB: 'Meia lua de frente', atacante: Atacante.b),
      Movimento(nomeA: 'Tesoura de costas', nomeB: 'Queda', atacante: Atacante.a),
    ],
    observacao: 'Contra-ataque com tesoura de costas.',
  ),
  Sequencia(
    numero: 6,
    movimentos: [
      Movimento(nomeA: 'Queixada', nomeB: 'Aú', atacante: Atacante.a),
      Movimento(nomeA: 'Armada', nomeB: 'Cocorinha', atacante: Atacante.a),
      Movimento(nomeA: 'Mola', nomeB: 'Galopante', atacante: Atacante.b),
      Movimento(nomeA: 'Meia lua de compasso', nomeB: 'Aú', atacante: Atacante.a),
      Movimento(nomeA: 'Rasteira', nomeB: 'Queda', atacante: Atacante.a),
    ],
  ),
  Sequencia(
    numero: 7,
    movimentos: [
      Movimento(nomeA: 'Meia lua de frente', nomeB: 'Cocorinha', atacante: Atacante.a),
      Movimento(nomeA: 'Pulada', nomeB: 'Rabo de arraia', atacante: Atacante.b),
      Movimento(nomeA: 'Benção', nomeB: 'Desvio', atacante: Atacante.a),
      Movimento(nomeA: 'Queda de rins', nomeB: 'Rabo de arraia', atacante: Atacante.b),
      Movimento(nomeA: 'Tesoura de costas', nomeB: 'Queda', atacante: Atacante.a),
    ],
    observacao: 'Sequência longa com dois contra-ataques.',
  ),
  Sequencia(
    numero: 8,
    movimentos: [
      Movimento(nomeA: 'Armada', nomeB: 'Cocorinha', atacante: Atacante.a),
      Movimento(nomeA: 'Godeme', nomeB: 'Esquiva', atacante: Atacante.a),
      Movimento(nomeA: 'Benção', nomeB: 'Desvio lateral', atacante: Atacante.a),
      Movimento(nomeA: 'Meia lua de compasso', nomeB: 'Aú', atacante: Atacante.a),
      Movimento(nomeA: 'Rasteira', nomeB: 'Queda', atacante: Atacante.a),
    ],
    observacao: 'Sequência de pressão contínua de A com rasteira final.',
  ),
];

// ─────────────────────────────────────────────
// SEQUÊNCIAS DO GRUPO
// ─────────────────────────────────────────────
const List<Sequencia> sequenciasGrupo = [
  Sequencia(
    numero: 1,
    movimentos: [
      Movimento(nomeA: 'Ginga', nomeB: 'Ginga', atacante: Atacante.a),
      Movimento(nomeA: 'Meia lua de frente', nomeB: 'Cocorinha', atacante: Atacante.a),
      Movimento(nomeA: 'Mola', nomeB: 'Rabo de arraia', atacante: Atacante.b),
      Movimento(nomeA: 'Meia lua de compasso', nomeB: 'Aú', atacante: Atacante.a),
      Movimento(nomeA: 'Rasteira', nomeB: 'Queda', atacante: Atacante.a),
    ],
  ),
  Sequencia(
    numero: 2,
    movimentos: [
      Movimento(nomeA: 'Ginga', nomeB: 'Ginga', atacante: Atacante.a),
      Movimento(nomeA: 'Queixada', nomeB: 'Aú', atacante: Atacante.a),
      Movimento(nomeA: 'Cocorinha', nomeB: 'Armada', atacante: Atacante.b),
      Movimento(nomeA: 'Galopante', nomeB: 'Mola', atacante: Atacante.a),
      Movimento(nomeA: 'Tesoura de frente', nomeB: 'Queda', atacante: Atacante.a),
    ],
  ),
  Sequencia(
    numero: 3,
    movimentos: [
      Movimento(nomeA: 'Ginga', nomeB: 'Ginga', atacante: Atacante.a),
      Movimento(nomeA: 'Benção', nomeB: 'Esquiva lateral', atacante: Atacante.a),
      Movimento(nomeA: 'Esquiva', nomeB: 'Rabo de arraia', atacante: Atacante.b),
      Movimento(nomeA: 'Armada', nomeB: 'Cocorinha', atacante: Atacante.a),
      Movimento(nomeA: 'Godeme', nomeB: 'Esquiva', atacante: Atacante.a),
      Movimento(nomeA: 'Rasteira', nomeB: 'Queda', atacante: Atacante.a),
    ],
    observacao: 'Sequência longa do grupo com finalização em rasteira.',
  ),
];

// ─────────────────────────────────────────────
// CATEGORIAS
// ─────────────────────────────────────────────
const List<CategoriaSequencias> categoriasSequencias = [
  CategoriaSequencias(
    nome: 'Entrada e Saída',
    descricao: 'Sequências básicas de entrada e saída do jogo',
    pdfAssetPath: 'assets/apostilas/sequencias.pdf',
    sequencias: sequenciasEntradaSaida,
  ),
  CategoriaSequencias(
    nome: 'Sequências de Bimba',
    descricao: '8 sequências clássicas criadas por Mestre Bimba',
    pdfAssetPath: 'assets/apostilas/sequencias.pdf',
    sequencias: sequenciasBimba,
  ),
  CategoriaSequencias(
    nome: 'Sequências do Grupo',
    descricao: 'Sequências desenvolvidas pelo Raiz dos Palmares',
    pdfAssetPath: 'assets/apostilas/sequencias.pdf',
    sequencias: sequenciasGrupo,
  ),
];
