import 'package:flutter/material.dart';
import 'apostila_screen.dart';

class ApostilaItem {
  final String title;
  final String subtitle;
  final String assetPath;
  final String? pdfAssetPath;
  final IconData icon;

  const ApostilaItem({
    required this.title,
    required this.subtitle,
    required this.assetPath,
    this.pdfAssetPath,
    this.icon = Icons.menu_book_outlined,
  });
}

const List<ApostilaItem> apostilas = [
  ApostilaItem(
    title: 'Apostila Raiz dos Palmares',
    subtitle: 'História, golpes, graduação e muito mais',
    assetPath: 'assets/apostilas/apostila_raiz_dos_palmares.md',
    pdfAssetPath: 'assets/apostilas/Apostila_Raiz_dos_Palmares.pdf',
    icon: Icons.auto_stories_outlined,
  ),
];

class ApostilasScreen extends StatelessWidget {
  const ApostilasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Apostilas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: apostilas.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final item = apostilas[index];
          return _ApostilaCard(item: item);
        },
      ),
    );
  }
}

class _ApostilaCard extends StatelessWidget {
  final ApostilaItem item;

  const _ApostilaCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ApostilaScreen(
              title: item.title,
              assetPath: item.assetPath,
              pdfAssetPath: item.pdfAssetPath,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, color: Colors.amber, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.subtitle,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 13,
                    ),
                  ),
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
