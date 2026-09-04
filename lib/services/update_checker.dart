import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class UpdateChecker {
  static const _versionUrl =
      'https://raw.githubusercontent.com/fef500602-lab/app-raiz/main/version.json';

  /// Chama no initState da HomeScreen. Silencioso em caso de erro de rede.
  static Future<void> check(BuildContext context) async {
    try {
      final info = await PackageInfo.fromPlatform();
      final currentBuild = int.tryParse(info.buildNumber) ?? 0;

      final response = await http
          .get(Uri.parse(_versionUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return;

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final remoteBuild  = (data['build_number'] as int?) ?? 0;
      final remoteVersion = (data['version']      as String?) ?? '';
      final downloadUrl   = (data['download_url'] as String?) ?? '';
      final releaseNotes  = (data['release_notes'] as String?) ?? '';

      if (remoteBuild > currentBuild && context.mounted) {
        _showUpdateSheet(
          context,
          version: remoteVersion,
          downloadUrl: downloadUrl,
          releaseNotes: releaseNotes,
        );
      }
    } catch (_) {
      // falha silenciosa — sem internet, servidor fora, etc.
    }
  }

  static void _showUpdateSheet(
    BuildContext context, {
    required String version,
    required String downloadUrl,
    required String releaseNotes,
  }) {
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _UpdateSheet(
        version: version,
        downloadUrl: downloadUrl,
        releaseNotes: releaseNotes,
      ),
    );
  }
}

// ── Bottom sheet de atualização ───────────────────────────────────────────────
class _UpdateSheet extends StatelessWidget {
  final String version;
  final String downloadUrl;
  final String releaseNotes;

  const _UpdateSheet({
    required this.version,
    required this.downloadUrl,
    required this.releaseNotes,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(
          24, 20, 24, 32 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // barra de drag
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: cs.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),

          // ícone
          Container(
            width: 60, height: 60,
            decoration: BoxDecoration(
              color: cs.primary.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.system_update_outlined, color: cs.primary, size: 30),
          ),
          const SizedBox(height: 16),

          Text(
            'Nova versão disponível',
            style: GoogleFonts.bricolageGrotesque(
              color: cs.onSurface, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            'Versão $version',
            style: GoogleFonts.plusJakartaSans(
              color: cs.primary, fontSize: 14, fontWeight: FontWeight.w600),
          ),

          if (releaseNotes.isNotEmpty) ...[
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: cs.surfaceContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: cs.outlineVariant, width: 0.5),
              ),
              child: Text(
                releaseNotes,
                style: GoogleFonts.plusJakartaSans(
                  color: cs.onSurfaceVariant, fontSize: 13, height: 1.5),
              ),
            ),
          ],

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              icon: const Icon(Icons.download_outlined),
              label: const Text('Baixar atualização'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: () async {
                final uri = Uri.parse(downloadUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
          ),
          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Agora não',
                  style: GoogleFonts.plusJakartaSans(color: cs.onSurfaceVariant)),
            ),
          ),
        ],
      ),
    );
  }
}
