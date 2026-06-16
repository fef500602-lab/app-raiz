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

  const ApostilaScreen({
    super.key,
    required this.title,
    required this.assetPath,
    this.pdfAssetPath,
  });

  @override
  State<ApostilaScreen> createState() => _ApostilaScreenState();
}

class _ApostilaScreenState extends State<ApostilaScreen> {
  String? _content;
  bool _loading = true;

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

  Future<void> _sharePdf() async {
    if (widget.pdfAssetPath == null) return;
    try {
      final bytes = await rootBundle.load(widget.pdfAssetPath!);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${widget.title}.pdf');
      await file.writeAsBytes(bytes.buffer.asUint8List());
      await Share.shareXFiles([XFile(file.path)], text: widget.title);
    } catch (e) {
      if (mounted) {
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
          widget.title,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (widget.pdfAssetPath != null)
            IconButton(
              icon: const Icon(Icons.share_outlined, color: Colors.amber),
              tooltip: 'Compartilhar PDF',
              onPressed: _sharePdf,
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : Markdown(
              data: _content ?? '',
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              styleSheet: MarkdownStyleSheet(
                // Fundo e texto base
                p: const TextStyle(
                  color: Color(0xFFE0E0E0),
                  fontSize: 16,
                  height: 1.7,
                ),
                // Títulos
                h1: const TextStyle(
                  color: Colors.amber,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  height: 2.0,
                ),
                h2: const TextStyle(
                  color: Colors.amber,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 2.0,
                ),
                h3: const TextStyle(
                  color: Color(0xFFFFCC80),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  height: 1.8,
                ),
                // Destaque em negrito
                strong: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                // Itálico
                em: const TextStyle(
                  color: Color(0xFFBDBDBD),
                  fontStyle: FontStyle.italic,
                ),
                // Citações
                blockquote: const TextStyle(
                  color: Color(0xFFBDBDBD),
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  height: 1.6,
                ),
                blockquoteDecoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(color: Colors.amber, width: 4),
                  ),
                  color: Color(0xFF1E1E1E),
                ),
                blockquotePadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                // Listas
                listBullet: const TextStyle(
                  color: Colors.amber,
                  fontSize: 16,
                ),
                // Código (árvore genealógica)
                code: const TextStyle(
                  color: Color(0xFFE0E0E0),
                  fontSize: 13,
                  fontFamily: 'monospace',
                ),
                codeblockDecoration: BoxDecoration(
                  color: const Color(0xFF2C2C2C),
                  borderRadius: BorderRadius.circular(8),
                ),
                codeblockPadding: const EdgeInsets.all(16),
                // Divisória
                horizontalRuleDecoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xFF333333), width: 1),
                  ),
                ),
                // Tabelas
                tableHead: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                tableBody: const TextStyle(
                  color: Color(0xFFE0E0E0),
                  fontSize: 14,
                ),
                tableBorder: TableBorder.all(
                  color: const Color(0xFF333333),
                  width: 1,
                ),
                tableHeadAlign: TextAlign.left,
              ),
            ),
    );
  }
}
