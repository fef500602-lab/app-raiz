# Product Requirements Document (PRD) — Raiz dos Palmares Mobile App

## 1. Visão Geral do Produto
- **Nome do Aplicativo**: Raiz dos Palmares
- **Tipo de Plataforma**: Mobile App (iOS & Android — React Native / Flutter / Expo / Web PWA)
- **Público-Alvo**: Praticantes, alunos, instrutores, mestres e entusiastas do Grupo de Capoeira Raiz dos Palmares (fundado pelo Mestre Arlindo).
- **Objetivo**: Proporcionar um centro de referência digital que una tradição oral, aprendizado técnico e memória ancestral da capoeiragem, permitindo o estudo de sequências de movimentos, reprodução de toques e ritmos, visualização de vídeos históricos/técnicos e leitura integral da apostila oficial do grupo, inclusive offline.

---

## 2. Identidade Visual & Design System (Tokens)
- **Tema**: Afro-Brazilian Heritage & Movement (Autêntico, orgânico, solene e enérgico).
- **Tipografia Principal**: `Bricolage Grotesque`, sans-serif (títulos de display e corpo expressivo com sabor editorial).
- **Paleta de Cores**:
  - `primary`: `#C85A32` (Terracota ancestral / argila da Bahia)
  - `primary-dark`: `#A3411F`
  - `surface`: `#FDF9F3` (Pergaminho / linho cru)
  - `surface-container-low`: `#F7F3ED` (Cards e divisores sutis)
  - `surface-container-high`: `#EFEAE0` (Estados selecionados e badges)
  - `accent-gold`: `#D97706` / `#F59E0B` (Ocre / ouro solar)
  - `accent-green`: `#2D6A4F` / `#D8F3DC` (Verde mata atlântica / folhas)
  - `text-main`: `#1F1D1A` (Grafite escuro de alto contraste)
  - `text-muted`: `#78716C`
- **Arredondamento**: `rounded-xl` (12px) e `rounded-2xl` (16px) em cards, `rounded-full` em botões de ação e chips.
- **Logotipo Oficial**: Emblema oficial com berimbau, bandeira do Brasil e silhuetas dos capoeiristas (`Fundado em 08 de Agosto de 1990 • Mestre Arlindo`).

---

## 3. Arquitetura da Informação e Navegação
Navegação persistente inferior (Bottom Navigation Bar) com 3 abas principais:
1. **Vídeos** (`/videos`)
2. **Sequências** (`/sequencias`)
3. **Apostila** (`/apostila`)

Telas secundárias / detalhadas:
- **Detalhes da Sequência** (`/sequencias/:id`)
- **Leitura da Apostila** (`/apostila/leitura`)

---

## 4. Requisitos Funcionais por Módulo

### 4.1. Aba: Vídeos (`/videos`)
- **Top App Bar**: Logotipo Raiz dos Palmares, título da seção ("Vídeos"), ícone de notificações e avatar do usuário.
- **Sub-abas (Segmented Control)**:
  - **História**: Documentários, memórias da Serra da Barriga/Quilombo dos Palmares, mestres pioneiros (Bimba, Pastinha) e fundamentos rituais.
  - **Técnicas**: Vídeos tutoriais de chutes (armada, queixada, meia-lua de compasso), esquivas (cocorinha, negativa) e floreios.
- **Cards de Vídeo**:
  - Thumbnail em formato 16:9 com badge de categoria/instrutor no topo esquerdo.
  - Badge de duração (ex: `18:45`) no canto inferior direito da imagem.
  - Botão central de Play sobreposto com transparência.
  - Título em destaque, módulo/subtítulo descritivo.
- **Comportamento**: O toque abre o modal ou player de vídeo nativo em tela cheia com suporte a buffering e controle de velocidade.

### 4.2. Aba: Sequências (`/sequencias`)
- **Top App Bar**: Logotipo oficial, título ("Sequências"), notificações e perfil.
- **Banner de Destaque**: Card promocional de treino diário ("Aperfeiçoe sua Mandinga" / Toque associado: São Bento Grande) com CTA "Praticar".
- **Lista de Módulos (3 Seções Principais)**:
  1. **Entrada e Saída**: Fundamentos de aproximação ao pé do berimbau, chamada e saída respeitosa da roda (4 movimentos • Iniciante).
  2. **Sequências de Bimba**: As 8 sequências clássicas da Capoeira Regional concebidas pelo Mestre Bimba (8 sequências completas • Intermediário/Avançado).
  3. **Sequências do Grupo**: Jogos combinados exclusivos da linhagem Raiz dos Palmares (6 combinações • Linhagem Palmares).
- **Card de Inspiração**: Citação filosófica da roda ("Dica da Roda").
- **Comportamento**: O toque em qualquer módulo navega para a tela de Detalhes da Sequência.

### 4.3. Tela: Detalhes da Sequência (`/sequencias/:id`)
- **Cabeçalho com Navegação**: Botão voltar (`<-`), logotipo do grupo e título da sequência com menu de opções.
- **Metadados**: Badges de nível (Iniciante a Graduado) e quantidade de passos/fases (ex: 4 Fases).
- **Player de Áudio do Toque**:
  - Mostrador de ritmo (ex: *São Bento Grande de Regional - 120 BPM*).
  - Botão de Play/Pause com metrônomo visual sonoro para treinar no ritmo exato do berimbau.
- **Mídia Demonstrativa**: Imagem ou vídeo em loop da execução sincronizada da dupla.
- **Diálogo Corporal Passo a Passo (Timeline Interativa)**:
  - Cada passo com marcador numérico sequencial.
  - Divisão explícita de papéis: **Atacante** vs. **Defensor**.
  - **Dica do Mestre / Postura / Guarda**: Caixa com orientações preventivas de lesão e marcialidade.
- **Ações Fixas no Rodapé**:
  - Botão primário: "Iniciar Modo Treino Interativo".
  - Botões secundários: "Salvar no Caderno" e "Próxima Sequência ->".

### 4.4. Aba: Apostila (`/apostila`)
- **Top App Bar**: Logotipo, título ("Apostila") e ações de usuário.
- **Aviso Oficial de Status**: Card explicativo "Memória e Fundamentos: O compêndio sagrado do grupo".
- **Card Principal em Destaque**:
  - Capa do livro oficial "Apostila Raiz dos Palmares" com arte tradicional.
  - Indicadores: Edição Oficial 2025, Suporte Offline, 64 Páginas, Ilustrado, Idioma Português.
  - CTA proeminente: **"Abrir Apostila Completa"** (leva diretamente para o leitor).
- **Sumário de Capítulos**:
  - Cap. I: História e Raízes de Palmares (pág. 04)
  - Cap. II: Instrumentos, Cantigas e Toques (pág. 18)
  - Cap. III: Movimentos Fundamentais e Golpes (pág. 34)
  - Cap. IV: Sistema de Graduação e Cordéis (pág. 52)
- **Status de Armazenamento Local**: Indicador de sincronização offline e tamanho do download (ex: `18.4 MB`).

### 4.5. Tela: Leitura da Apostila (`/apostila/leitura`)
- **Barra de Leitura Superior**:
  - Botão voltar, logo, indicador de página atual (`Pág 12 de 64`) com barra de progresso horizontal em terracota.
  - Ações rápidas: **Compartilhar** (`Share`) e **Baixar PDF Oficial** (`Download PDF`).
- **Área de Conteúdo Formatado (Tipografia Editorial)**:
  - Títulos com capitular ornamental ("Drop Cap").
  - Caixas de instrumentos (Berimbau Gunga, Médio e Viola) com timbres sonoros (Grave, Centro, Agudo) e botão "Ouvir Toque".
  - Seção poética de Ladainhas e Cantigas em itálico tradicional.
  - Tabela visual com a **Hierarquia dos Cordéis** (Cru, Amarelo, Laranja, Azul, Verde, Roxo, Marrom, Vermelho, Branco).
- **Barra Inferior de Controles de Leitura**:
  - Ajuste de zoom de texto (`A- / A+`).
  - Alternador de tema de leitura: Dia (pergaminho), Sépia, Noite (modo escuro).
  - Marcador de página (`Bookmark`).

---

## 5. Requisitos Não Funcionais & Técnicos
1. **Offline First**: Apostila em PDF e dados de texto das sequências devem ser armazenados em cache local (SQLite / WatermelonDB / AsyncStorage).
2. **Desempenho de Áudio**: Reprodução de áudio de baixa latência para os toques de berimbau (utilizando bibliotecas como `expo-av` ou `react-native-sound`).
3. **Acessibilidade**: Contraste mínimo WCAG AA em todas as cores de texto sobre superfícies terracota e pergaminho. Suporte a Dynamic Type / dimensionamento de fontes.
4. **Internacionalização (i18n)**: Idioma padrão Português (Brasil), com arquitetura preparada para suporte futuro a Inglês e Espanhol para alunos no exterior.

---

## 6. Sugestão de Prompt para o Claude Code
```text
Implement the mobile app for "Raiz dos Palmares" following the provided PRD and Stitch design specifications:
- Framework: React Native with Expo (or Flutter/Tailwind)
- Style: Warm Afro-Brazilian palette (primary: #C85A32, surface: #FDF9F3, container: #F7F3ED, font: Bricolage Grotesque)
- Navigation: Bottom tab navigator with 3 routes: VideosScreen, SequencesScreen, ApostilaScreen
- Stack screens: SequenceDetailScreen, ApostilaReaderScreen
- Ensure offline support for PDF reading and native audio playback for the berimbau rhythms.
```
