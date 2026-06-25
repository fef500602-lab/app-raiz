import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/videos_screen.dart';
import 'screens/apostilas_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raiz dos Palmares',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Raiz dos Palmares',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _MenuCard(
            icon: Icons.history_edu_outlined,
            title: 'História da Capoeira',
            subtitle: 'Documentários e grandes nomes',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const VideosScreen(
                  titulo: 'História da Capoeira',
                  videos: videosHistoria,
                ),
              ),
            ),
          ),
          _MenuCard(
            icon: Icons.play_circle_outline,
            title: 'Vídeos',
            subtitle: 'Técnicas e movimentos',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const VideosScreen(
                  titulo: 'Vídeos',
                  videos: videosTecnicas,
                ),
              ),
            ),
          ),
          _MenuCard(
            icon: Icons.menu_book_outlined,
            title: 'Apostilas',
            subtitle: 'Apostila oficial e sequências',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ApostilasScreen()),
            ),
          ),
          // Próximos módulos serão adicionados aqui
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.amber, size: 36),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  Text(subtitle,
                      style: const TextStyle(
                          color: Colors.white54, fontSize: 13)),
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
