import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ApostilaScreen extends StatefulWidget {
  final String title;
  final String assetPath;
  // PDF fundo claro (formatada)
  final String? pdfAssetPath;
  // PDF original (scan/doc original)
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
      setState(() { _content = text; _loading = false; });
    } catch (e) {
      setState(() { _content = '> Erro ao carregar o conteúdo.'; _loading = false; });
    }
  }

  // Extrai o PDF do bundle de assets para um arquivo temporário e retorna o path
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

  void _mostrarMenuPdf(BuildContext context, {required bool isDownload}) {
    final temFormatada = widget.pdfAssetPath != null;
    final temOriginal  = widget.pdfOriginalAssetPath != null;

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
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isDownload ? 'Baixar PDF' : 'Compartilhar PDF',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Escolha a versão:',
                  style: TextStyle(color: Colors.white54, fontSize: 13),
                ),
                const SizedBox(height: 16),
                if (temFormatada)
                  _PdfOpcao(
                    icon: Icons.brightness_high_outlined,
                    titulo: 'Fundo Claro',
                    subtitulo: 'Versão formatada — ideal para leitura',
                    onTap: () {
                      Navigator.pop(context);
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
                      Navigator.pop(context);
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
    final temPdf = widget.pdfAssetPath != null || widget.pdfOriginalAssetPath != null;

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Text(widget.title,
            style: const TextStyle(color: Colors.white, fontSize: 16)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (temPdf) ...[
            // Compartilhar
            _sharing
                ? const Padding(
                    padding: EdgeInsets.all(14),
                    child: SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.amber, strokeWidth: 2),
                    ),
                 