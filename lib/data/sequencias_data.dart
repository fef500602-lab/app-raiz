import '../models/sequencia_model.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DRILLS DE ENTRADA E SAÍDA (exercícios individuais)
// ─────────────────────────────────────────────────────────────────────────────
const List<GrupoDrills> drillsEntradaSaida = [
  GrupoDrills(
    titulo: 'Entrada',
    movimentos: [
      MovimentoDrill(nome: 'Ginga',                    repeticoes: '4x'),
      MovimentoDrill(nome: 'Ponteira',                 repeticoes: '2x cada perna'),
      MovimentoDrill(nome: 'Martelo',                  repeticoes: '2x cada perna'),
      MovimentoDrill(nome: 'Benção',                   repeticoes: '2x cada perna'),
      MovimentoDrill(nome: 'Chapa',                    repeticoes: '2x cada perna'),
      MovimentoDrill(nome: 'Meia lua de frente',       repeticoes: '2x cada perna'),
      MovimentoDrill(nome: 'Queixada sem esquiva',     repeticoes: '2x cada perna'),
      MovimentoDrill(nome: 'Queixada com esquiva',     repeticoes: '2x cada perna'),
    ],
  ),
  GrupoDrills(
    titulo: 'Saída',
    movimentos: [
      MovimentoDrill(nome: 'Ginga',                    repeticoes: '4x'),
      MovimentoDrill(nome: 'Rasteira em pé',           repeticoes: '2x cada perna'),
      MovimentoDrill(nome: 'Esquiva lateral',          repeticoes: '2x cada perna'),
      MovimentoDrill(nome: 'Cocorinha',                repeticoes: '2x cada perna'),
      MovimentoDrill(nome: 'Mola',                     repeticoes: '2x cada perna'),
      MovimentoDrill(nome: 'Negativa',                 repeticoes: '2x cada perna'),
    ],
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// SEQUÊNCIAS DE BIMBA (8 sequências pareadas)
// ─────────────────────────────────────────────────────────────────────────────
const List<Sequencia> sequenciasBimba = [
  Sequencia(
    numero: 1,
    movimentos: [
      Movimento(nomeA: 'Meia lua de frente', nomeB: 'Cocorinha',            atacante: Atacante.a),
      Movimento(nomeA: 'Meia lua de frente', nomeB: 'Cocorinha',            atacante: Atacante.a),
      Movimento(nomeA: 'Armada',             nomeB: 'Negativa',             atacante: Atacante.a),
      Movimento(nomeA: 'Saída: Aú pelas costas'), // A finaliza
    ],
  ),
  Sequencia(
    numero: 2,
    movimentos: [
      Movimento(nomeA: 'Queixada',     nomeB: 'Cocorinha',   atacante: Atacante.a),
      Movimento(nomeA: 'Queixada',     nomeB: 'Cocorinha',   atacante: Atacante.a),
      Movimento(nomeA: 'Cocorinha',    nomeB: 'Armada',      atacante: Atacante.b),
      Movimento(nomeA: 'Benção',       nomeB: 'Negativa',    atacante: Atacante.a),
      Movimento(nomeA: 'Aú com rolê',  nomeB: 'Cabeçada',   atacante: Atacante.b),
    ],
  ),
  Sequencia(
    numero: 3,
    movimentos: [
      Movimento(nomeA: 'Martelo',      nomeB: 'Cutila',      atacante: Atacante.a),
      Movimento(nomeA: 'Martelo',      nomeB: 'Cutila',      atacante: Atacante.a),
      Movimento(nomeA: 'Cocorinha',    nomeB: 'Armada',      atacante: Atacante.b),
      Movimento(nomeA: 'Benção',       nomeB: 'Negativa',    atacante: Atacante.a),
      Movimento(nomeA: 'Aú com rolê',  nomeB: 'Cabeçada',   atacante: Atacante.b),
    ],
  ),
  Sequencia(
    numero: 4,
    movimentos: [
      Movimento(nomeA: 'Godeme',       nomeB: 'Palma',       atacante: Atacante.a),
      Movimento(nomeA: 'Godeme',       nomeB: 'Palma',       atacante: Atacante.a),
      Movimento(nomeA: 'Arrastão',     nomeB: 'Galopante',   atacante: Atacante.b),
      Movimento(nomeA: 'Aú com rolê',  nomeB: 'Negativa',   atacante: Atacante.b),
      Movimento(nomeB: 'Cabeçada'), // B finaliza
    ],
  ),
  Sequencia(
    numero: 5,
    movimentos: [
      Movimento(nomeA: 'Giro',         nomeB: 'Cabeçada',   atacante: Atacante.a),
      Movimento(nomeA: 'Joelhada',     nomeB: 'Negativa',   atacante: Atacante.a),
      Movimento(nomeA: 'Aú com rolê',  nomeB: 'Cabeçada',  atacante: Atacante.b),
    ],
  ),
  Sequencia(
    numero: 6,
    movimentos: [
      Movimento(nomeA: 'Meia lua de compasso', nomeB: 'Cocorinha',          atacante: Atacante.a),
      Movimento(nomeA: 'Cocorinha',            nomeB: 'Meia lua de compasso', atacante: Atacante.b),
      Movimento(nomeA: 'Joelhada',             nomeB: 'Negativa',           atacante: Atacante.a),
      Movimento(nomeA: 'Aú com rolê',          nomeB: 'Cabeçada',          atacante: Atacante.a),
    ],
  ),
  Sequencia(
    numero: 7,
    movimentos: [
      Movimento(nomeA: 'Armada',       nomeB: 'Cocorinha',  atacante: Atacante.a),
      Movimento(nomeA: 'Cocorinha',    nomeB: 'Armada',     atacante: Atacante.b),
      Movimento(nomeA: 'Benção',       nomeB: 'Negativa',   atacante: Atacante.a),
      Movimento(nomeA: 'Aú com rolê',  nomeB: 'Cabeçada',  atacante: Atacante.b),
    ],
  ),
  Sequencia(
    numero: 8,
    movimentos: [
      Movimento(nomeA: 'Benção',       nomeB: 'Negativa',   atacante: Atacante.a),
      Movimento(nomeA: 'Aú com rolê',  nomeB: 'Cabeçada',  atacante: Atacante.b),
    ],
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// SEQUÊNCIAS DO GRUPO (10 sequências pareadas)
// ─────────────────────────────────────────────────────────────────────────────
const List<Sequencia> sequenciasGrupo = [
  Sequencia(
    numero: 1,
    movimentos: [
      Movimento(nomeA: 'Meia lua de frente', nomeB: 'Cocorinha',   atacante: Atacante.a),
      Movimento(nomeA: 'Armada',             nomeB: 'Vingativa',   atacante: Atacante.a),
      Movimento(nomeA: 'Tesoura de costas'), // A finaliza
    ],
  ),
  Sequencia(
    numero: 2,
    movimentos: [
      Movimento(nomeA: 'Martelo', nomeB: 'Rasteira em pé',  atacante: Atacante.a),
      Movimento(nomeA: 'Armada',  nomeB: 'Banda de costas', atacante: Atacante.a),
    ],
  ),
  Sequencia(
    numero: 3,
    movimentos: [
      Movimento(nomeA: 'Queixada', nomeB: 'Rasteira em pé',   atacante: Atacante.a),
      Movimento(nomeA: 'Gancho',   nomeB: 'Rasteira baiana',  atacante: Atacante.a),
      Movimento(nomeA: 'Aú'), // A finaliza
    ],
  ),
  Sequencia(
    numero: 4,
    movimentos: [
      Movimento(nomeA: 'Martelo',            nomeB: 'Rasteira em pé',       atacante: Atacante.a),
      Movimento(nomeA: 'Meia lua de compasso', nomeB: 'Negativa com tesoura', atacante: Atacante.a),
      Movimento(nomeA: 'Aú'), // A finaliza
    ],
  ),
  Sequencia(
    numero: 5,
    movimentos: [
      Movimento(nomeA: 'Armada',                       nomeB: 'Rasteira baiana', atacante: Atacante.a),
      Movimento(nomeA: 'Salto giratório com joelhada', nomeB: 'Cavalete com rolê', atacante: Atacante.a),
    ],
  ),
  Sequencia(
    numero: 6,
    movimentos: [
      Movimento(nomeA: 'Martelo voador', nomeB: 'Chapéu de couro', atacante: Atacante.a),
      Movimento(nomeA: 'Tesoura de frente'), // A finaliza
    ],
  ),
  Sequencia(
    numero: 7,
    movimentos: [
      Movimento(nomeA: 'Martelo', nomeB: 'Chapa giratória', atacante: Atacante.a),
      Movimento(nomeA: 'Mola resistência'), // A finaliza
    ],
  ),
  Sequencia(
    numero: 8,
    movimentos: [
      Movimento(nomeA: 'Meia lua de compasso', nomeB: 'Meia lua solta', atacante: Atacante.a),
      Movimento(nomeA: 'Cabeçada',             nomeB: 'Rolê',           atacante: Atacante.a),
    ],
  ),
  Sequencia(
    numero: 9,
    movimentos: [
      Movimento(nomeA: 'Armada',         nomeB: 'Meia lua solta', atacante: Atacante.a),
      Movimento(nomeA: 'Tesoura de frente'), // A finaliza
    ],
  ),
  Sequencia(
    numero: 10,
    movimentos: [
      Movimento(nomeA: 'Meia lua de frente', nomeB: 'Cocorinha',              atacante: Atacante.a),
      Movimento(nomeA: 'Tesoura de costas',  nomeB: 'Meia lua de compasso',   atacante: Atacante.a),
    ],
    observacao: 'B responde com Meia lua de compasso durante a Tesoura.',
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// CATEGORIAS
// ─────────────────────────────────────────────────────────────────────────────
const List<CategoriaSequencias> categoriasSequencias = [
  CategoriaSequencias(
    nome: 'Entrada e Saída',
    descricao: 'Exercícios de entrada e saída do jogo',
    pdfAssetPath: 'assets/apostilas/sequencias.pdf',
    ehDrill: true,
    drills: drillsEntradaSaida,
  ),
  CategoriaSequencias(
    nome: 'Sequências de Bimba',
    descricao: '8 sequências clássicas de Mestre Bimba',
    pdfAssetPath: 'assets/apostilas/sequencias.pdf',
    sequencias: sequenciasBimba,
  ),
  CategoriaSequencias(
    nome: 'Sequências do Grupo',
    descricao: '10 sequências do Raiz dos Palmares',
    pdfAssetPath: 'assets/apostilas/sequencias.pdf',
    sequencias: sequenciasGrupo,
  ),
];
