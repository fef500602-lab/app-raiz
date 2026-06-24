import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
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
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Escolha a versão do PDF',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Disponível para compartilhar ou salvar',
                  style: TextStyle(color: Colors.white54, fontSize: 13),
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
    final temPdf =
        widget.pdfAssetPath != null || widget.pdfOriginalAssetPath != null;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text(widget.title,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: _buildActions(context, temPdf),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : Markdown(
              data: _content ?? '',
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(
                    color: Color(0xFFE0E0E0), fontSize: 16, height: 1.7),
                h1: const TextStyle(
                    color: Colors.amber,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    height: 2.0),
                h2: const TextStyle(
                    color: Colors.amber,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 2.0),
                h3: const TextStyle(
                    color: Color(0xFFFFCC80),
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    height: 1.8),
                strong: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
                em: const TextStyle(
                    color: Color(0xFFBDBDBD), fontStyle: FontStyle.italic),
                blockquote: const TextStyle(
                    color: Color(0xFFBDBDBD),
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    height: 1.6),
                blockquoteDecoration: const BoxDecoration(
                  border: Border(
                      left: BorderSide(color: Colors.amber, width: 4)),
                  color: Color(0xFF1E1E1E),
                ),
                blockquotePadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                listBullet:
                    const TextStyle(color: Colors.amber, fontSize: 16),
                code: const TextStyle(
                    color: Color(0xFFE0E0E0),
                    fontSize: 13,
                    fontFamily: 'monospace'),
                codeblockDecoration: BoxDecoration(
                    color: const Color(0xFF2C2C2C),
                    borderRadius: BorderRadius.circular(8)),
                codeblockPadding: const EdgeInsets.all(16),
                horizontalRuleDecoration: const BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Color(0xFF333333), width: 1)),
                ),
                tableHead: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                tableBody: const TextStyle(
                    color: Color(0xFFE0E0E0), fontSize: 14),
                tableBorder: TableBorder.all(
                    color: const Color(0xFF333333), width: 1),
                tableHeadAlign: TextAlign.left,
              ),
            ),
    );
  }

  List<Widget> _buildActions(BuildContext context, bool temPdf) {
    if (!temPdf) return [];
    if (_sharing) {
      return [
        const Padding(
          padding: EdgeInsets.all(14),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
                color: Colors.amber, strokeWidth: 2),
          ),
        ),
      ];
    }
    return [
      IconButton(
        icon: const Icon(Icons.share_outlined, color: Colors.amber),
        tooltip: 'Compartilhar / Baixar PDF',
        onPressed: () => _mostrarMenuPdf(context),
      ),
      IconButton(
        icon: const Icon(Icons.download_outlined, color: Colors.amber),
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
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A2A),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.amber.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: Colors.amber, size: 24),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(titulo,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(subtitulo,
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white38),
          ],
        ),
      ),
    );
  }
}
