import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'theme_notifier.dart';
import 'screens/videos_tab_screen.dart';
import 'screens/sequencias_tab_screen.dart';
import 'screens/apostilas_screen.dart';
import 'services/update_checker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// ── Esquemas de cores ─────────────────────────────────────────────────────────

/// Tema claro — paleta Stitch (linho + terracota)
final _lightScheme = const ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF9F3C16),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFBF542C),
  onPrimaryContainer: Color(0xFF390C00),
  secondary: Color(0xFF3B6752),
  onSecondary: Color(0xFFFFFFFF),
  secondaryContainer: Color(0xFFBAEBD0),
  onSecondaryContainer: Color(0xFF3F6B57),
  tertiary: Color(0xFF7B5500),
  onTertiary: Color(0xFFFFFFFF),
  tertiaryContainer: Color(0xFF9B6B00),
  onTertiaryContainer: Color(0xFFFFFFFF),
  error: Color(0xFFBA1A1A),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFFFDAD6),
  onErrorContainer: Color(0xFF93000A),
  surface: Color(0xFFFDF9F3),
  onSurface: Color(0xFF1C1C18),
  surfaceContainerHighest: Color(0xFFE6E2DC),
  surfaceContainerHigh: Color(0xFFEBE8E2),
  surfaceContainer: Color(0xFFF1EDE7),
  surfaceContainerLow: Color(0xFFF7F3ED),
  surfaceContainerLowest: Color(0xFFFFFFFF),
  inverseSurface: Color(0xFF31302D),
  onInverseSurface: Color(0xFFF4F0EA),
  inversePrimary: Color(0xFFFFB59C),
  outline: Color(0xFF8A726A),
  outlineVariant: Color(0xFFDEC0B7),
  onSurfaceVariant: Color(0xFF57423B),
  shadow: Color(0xFF000000),
  scrim: Color(0xFF000000),
);

/// Tema escuro — terracota quente (gerado de fromSeed)
final _darkScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFF9F3C16),
  brightness: Brightness.dark,
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: appThemeMode,
      builder: (_, mode, __) => MaterialApp(
        title: 'Raiz dos Palmares',
        debugShowCheckedModeBanner: false,
        themeMode: mode,
        theme: buildAppTheme(_lightScheme),
        darkTheme: buildAppTheme(_darkScheme),
        home: const HomeScreen(),
      ),
    );
  }
}

// ── Tela raiz com BottomNavigationBar ─────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Verifica atualização após o primeiro frame (context disponível)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      UpdateChecker.check(context);
    });
  }

  static const List<Widget> _screens = [
    VideosTabScreen(),
    SequenciasTabScreen(),
    ApostilasScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          border: Border(
            top: BorderSide(color: cs.outlineVariant, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (i) => setState(() => _selectedIndex = i),
          backgroundColor: cs.surface,
          selectedItemColor: cs.primary,
          unselectedItemColor: cs.onSurface.withOpacity(0.45),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.play_circle_outline),
              activeIcon: Icon(Icons.play_circle),
              label: 'Vídeos',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.format_list_bulleted_outlined),
              activeIcon: Icon(Icons.format_list_bulleted),
              label: 'Sequências',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book),
              label: 'Apostila',
            ),
          ],
        ),
      ),
    );
  }
}
