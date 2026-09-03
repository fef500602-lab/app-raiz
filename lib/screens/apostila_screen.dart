import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ApostilaScreen extends StatefulWidget {
  final String title;
  final String assetPath;
  final String? pdfAssetPath;
  final String? pdfOriginalAssetPath;

  const ApostilaScreen({
    super.key,
    required this.title,
    required this.assetPath,
    this.pdfAssetPath,
    this.pdfOriginalAssetPath,
  });

  @override
  State<ApostilaScreen> createState() => _ApostilaScreenState();
}

class _ApostilaScreenState extends State<ApostilaScreen> {
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
      final text = await rootBundle.loadString(widget.assetPath);
      setState(() {
        _content = text;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _content = '> Erro ao carregar o conteúdo.';
        _loading = false;
      });
    }
  }

  Future<File?> _extrairPdf(String assetPath, String nomeArquivo) async {
    try {
      final bytes = await rootBundle.load(assetPath);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$nomeArquivo');
      await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
      return file;
    } catch (e) {
      return null;
    }
  }

  Future<void> _compartilhar(String assetPath, String nomeArquivo) async {
    if (_sharing) return;
    setState(() => _sharing = true);
    try {
      final file = await _extrairPdf(assetPath, nomeArquivo);
      if (file == null) throw Exception('Não foi possível extrair o PDF.');
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'application/pdf')],
        subject: widget.title,
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
    final temFormatada = widget.pdfAssetPath != null;
    final temOriginal = widget.pdfOriginalAssetPath != null;

    if (!temFormatada && !temOriginal) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhum PDF disponível.')),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: cs.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Escolha a versão do PDF',
                  style: GoogleFonts.bricolageGrotesque(
                    color: cs.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Disponível para compartilhar ou salvar',
                  style: GoogleFonts.plusJakartaSans(
                    color: cs.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 16),
                if (temFormatada)
                  _PdfOpcao(
                    icon: Icons.brightness_high_outlined,
                    titulo: 'Fundo Claro',
                    subtitulo: 'Versão formatada — ideal para leitura',
                    onTap: () {
                      Navigator.pop(ctx);
                      _compartilhar(
                        widget.pdfAssetPath!,
                        'Apostila_Raiz_dos_Palmares_Fundo_Claro.pdf',
                      );
                    },
                  ),
                if (temFormatada && temOriginal) const SizedBox(height: 8),
                if (temOriginal)
                  _PdfOpcao(
                    icon: Icons.description_outlined,
                    titulo: 'Original',
                    subtitulo: 'Versão original do documento',
                    onTap: () {
                      Navigator.pop(ctx);
                      _compartilhar(
                        widget.pdfOriginalAssetPath!,
                        'Apostila_Raiz_dos_Palmares_Original.pdf',
                      );
                    },
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final temPdf =
        widget.pdfAssetPath != null || widget.pdfOriginalAssetPath != null;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        title: Text(
          widget.title,
          style: GoogleFonts.bricolageGrotesque(
            color: cs.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(color: cs.onSurface),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: cs.outlineVariant),
        ),
        actions: _buildActions(context, temPdf),
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(color: cs.primary),
            )
          : Markdown(
              data: _content ?? '',
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              styleSheet: MarkdownStyleSheet(
                p: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF1C1C18),
                  fontSize: 16,
                  height: 1.7,
                ),
                h1: GoogleFonts.bricolageGrotesque(
                  color: const Color(0xFF9F3C16),
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  height: 2.0,
                ),
                h2: GoogleFonts.bricolageGrotesque(
                  color: const Color(0xFF9F3C16),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  height: 2.0,
                ),
                h3: GoogleFonts.bricolageGrotesque(
                  color: const Color(0xFFBF542C),
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  height: 1.8,
                ),
                strong: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF1C1C18),
                  fontWeight: FontWeight.bold,
                ),
                em: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF57423B),
                  fontStyle: FontStyle.italic,
                ),
                blockquote: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF57423B),
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  height: 1.6,
                ),
                blockquoteDecoration: const BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Color(0xFF9F3C16), width: 4),
                  ),
                  color: Color(0xFFF1EDE7),
                ),
                blockquotePadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                listBullet: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF9F3C16),
                  fontSize: 16,
                ),
                code: const TextStyle(
                  color: Color(0xFF57423B),
                  fontSize: 13,
                  fontFamily: 'monospace',
                ),
                codeblockDecoration: BoxDecoration(
                  color: const Color(0xFFEBE8E2),
                  borderRadius: BorderRadius.circular(8),
                ),
                codeblockPadding: const EdgeInsets.all(16),
                horizontalRuleDecoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xFFDEC0B7), width: 1),
                  ),
                ),
                tableHead: GoogleFonts.bricolageGrotesque(
                  color: const Color(0xFF1C1C18),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                tableBody: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF57423B),
                  fontSize: 14,
                ),
                tableBorder: TableBorder.all(
                  color: const Color(0xFFDEC0B7),
                  width: 1,
                ),
                tableHeadAlign: TextAlign.left,
              ),
            ),
    );
  }

  List<Widget> _buildActions(BuildContext context, bool temPdf) {
    final cs = Theme.of(context).colorScheme;
    if (!temPdf) return [];
    if (_sharing) {
      return [
        Padding(
          padding: const EdgeInsets.all(14),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(color: cs.primary, strokeWidth: 2),
          ),
        ),
      ];
    }
    return [
      IconButton(
        icon: Icon(Icons.share_outlined, color: cs.primary),
        tooltip: 'Compartilhar / Baixar PDF',
        onPressed: () => _mostrarMenuPdf(context),
      ),
      IconButton(
        icon: Icon(Icons.download_outlined, color: cs.primary),
        tooltip: 'Baixar PDF',
        onPressed: () => _mostrarMenuPdf(context),
      ),
    ];
  }
}

// ─────────────────────────────────────────────────────────────────────────────
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
          color: const Color(0xFFF1EDE7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFDEC0B7), width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
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
                  Text(
                    titulo,
                    style: GoogleFonts.bricolageGrotesque(
                      color: cs.onSurface,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitulo,
                    style: GoogleFonts.plusJakartaSans(
                      color: cs.onSurfaceVariant,
                      fontSize: 12,
                    ),
                  ),
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
