import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../theme_notifier.dart';
import 'videos_tab_screen.dart' show buildLogoTitle;

class ApostilasScreen extends StatefulWidget {
  const ApostilasScreen({super.key});

  @override
  State<ApostilasScreen> createState() => _ApostilasScreenState();
}

class _ApostilasScreenState extends State<ApostilasScreen> {
  static const _assetPath =
      'assets/apostilas/apostila_raiz_dos_palmares.md';
  static const _pdfLight =
      'assets/apostilas/Apostila_Raiz_dos_Palmares_Fundo_Claro.pdf';
  static const _pdfOriginal =
      'assets/apostilas/Apostila_Raiz_dos_Palmares.pdf';

  String? _content;
  bool _loading = true;
  bool _sharing = false;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    try {
      final text = await rootBundle.loadString(_assetPath);
      if (mounted) setState(() { _content = text; _loading = false; });
    } catch (_) {
      if (mounted) setState(() { _content = '> Erro ao carregar o conteúdo.'; _loading = false; });
    }
  }

  Future<File?> _extrairPdf(String assetPath, String nome) async {
    try {
      final bytes = await rootBundle.load(assetPath);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$nome');
      await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
      return file;
    } catch (_) { return null; }
  }

  Future<void> _compartilhar(String assetPath, String nome) async {
    if (_sharing) return;
    setState(() => _sharing = true);
    try {
      final file = await _extrairPdf(assetPath, nome);
      if (file == null) throw Exception('Não foi possível extrair o PDF.');
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'application/pdf')],
        subject: 'Apostila Raiz dos Palmares',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao compartilhar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _sharing = false);
    }
  }

  void _mostrarMenuPdf(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: cs.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Escolha a versão do PDF',
                  style: GoogleFonts.bricolageGrotesque(
                    color: cs.onSurface, fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text('Disponível para compartilhar ou salvar',
                  style: GoogleFonts.plusJakartaSans(
                    color: cs.onSurfaceVariant, fontSize: 13)),
              const SizedBox(height: 16),
              _PdfOpcao(
                icon: Icons.brightness_high_outlined,
                titulo: 'Fundo Claro',
                subtitulo: 'Versão formatada — ideal para leitura',
                onTap: () {
                  Navigator.pop(ctx);
                  _compartilhar(_pdfLight, 'Apostila_Raiz_dos_Palmares_Fundo_Claro.pdf');
                },
              ),
              const SizedBox(height: 8),
              _PdfOpcao(
                icon: Icons.description_outlined,
                titulo: 'Original',
                subtitulo: 'Versão original do documento',
                onTap: () {
                  Navigator.pop(ctx);
                  _compartilhar(_pdfOriginal, 'Apostila_Raiz_dos_Palmares_Original.pdf');
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  MarkdownStyleSheet _buildMarkdownStyle(ColorScheme cs) {
    return MarkdownStyleSheet(
      p: GoogleFonts.plusJakartaSans(color: cs.onSurface, fontSize: 16, height: 1.7),
      h1: GoogleFonts.bricolageGrotesque(
          color: cs.primary, fontSize: 24, fontWeight: FontWeight.w800, height: 2.0),
      h2: GoogleFonts.bricolageGrotesque(
          color: cs.primary, fontSize: 20, fontWeight: FontWeight.w700, height: 2.0),
      h3: GoogleFonts.bricolageGrotesque(
          color: cs.primaryContainer, fontSize: 17, fontWeight: FontWeight.w600, height: 1.8),
      strong: GoogleFonts.plusJakartaSans(
          color: cs.onSurface, fontWeight: FontWeight.bold),
      em: GoogleFonts.plusJakartaSans(
          color: cs.onSurfaceVariant, fontStyle: FontStyle.italic),
      blockquote: GoogleFonts.plusJakartaSans(
          color: cs.onSurfaceVariant, fontSize: 15, fontStyle: FontStyle.italic, height: 1.6),
      blockquoteDecoration: BoxDecoration(
        border: Border(left: BorderSide(color: cs.primary, width: 4)),
        color: cs.surfaceContainer,
      ),
      blockquotePadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      listBullet: GoogleFonts.plusJakartaSans(color: cs.primary, fontSize: 16),
      code: TextStyle(
          color: cs.onSurfaceVariant, fontSize: 13, fontFamily: 'monospace'),
      codeblockDecoration: BoxDecoration(
          color: cs.surfaceContainerHigh, borderRadius: BorderRadius.circular(8)),
      codeblockPadding: const EdgeInsets.all(16),
      horizontalRuleDecoration: BoxDecoration(
        border: Border(top: BorderSide(color: cs.outlineVariant, width: 1)),
      ),
      tableHead: GoogleFonts.bricolageGrotesque(
          color: cs.onSurface, fontWeight: FontWeight.w700, fontSize: 14),
      tableBody: GoogleFonts.plusJakartaSans(
          color: cs.onSurfaceVariant, fontSize: 14),
      tableBorder: TableBorder.all(color: cs.outlineVariant, width: 1),
      tableHeadAlign: TextAlign.left,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        automaticallyImplyLeading: false,
        title: buildLogoTitle(context, 'Apostila'),
        actions: [
          buildThemeToggle(context),
          if (_sharing)
            Padding(
              padding: const EdgeInsets.all(14),
              child: SizedBox(
                width: 20, height: 20,
                child: CircularProgressIndicator(color: cs.primary, strokeWidth: 2),
              ),
            )
          else ...[
            IconButton(
              icon: Icon(Icons.share_outlined, color: cs.primary),
              tooltip: 'Compartilhar PDF',
              onPressed: () => _mostrarMenuPdf(context),
            ),
            IconButton(
              icon: Icon(Icons.download_outlined, color: cs.primary),
              tooltip: 'Baixar PDF',
              onPressed: () => _mostrarMenuPdf(context),
            ),
          ],
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: cs.outlineVariant),
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: cs.primary))
          : Markdown(
              data: _content ?? '',
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              styleSheet: _buildMarkdownStyle(cs),
            ),
    );
  }
}

// ── Opção de PDF no bottom sheet ─────────────────────────────────────────────
class _PdfOpcao extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;

  const _PdfOpcao({
    required this.icon,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cs.surfaceContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: cs.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: cs.primary, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo,
                      style: GoogleFonts.bricolageGrotesque(
                          color: cs.onSurface, fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitulo,
                      style: GoogleFonts.plusJakartaSans(
                          color: cs.onSurfaceVariant, fontSize: 12)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: cs.outline, size: 20),
          ],
        ),
      ),
    );
  }
}
