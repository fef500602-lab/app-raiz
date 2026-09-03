import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'screens/videos_tab_screen.dart';
import 'screens/sequencias_tab_screen.dart';
import 'screens/apostilas_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// ── Paleta Stitch ─────────────────────────────────────────────────────────────
const _primary       = Color(0xFF9F3C16); // terracota
const _onPrimary     = Color(0xFFFFFFFF);
const _secondary     = Color(0xFF3B6752); // verde folhagem
const _onSecondary   = Color(0xFFFFFFFF);
const _surface       = Color(0xFFFDF9F3); // linho claro
const _onSurface     = Color(0xFF1C1C18); // carvão solo
const _surfaceContainer     = Color(0xFFF1EDE7);
const _surfaceContainerHigh = Color(0xFFEBE8E2);
const _surfaceContainerHighest = Color(0xFFE6E2DC);
const _outline       = Color(0xFF8A726A);
const _outlineVariant = Color(0xFFDEC0B7);
const _onSurfaceVariant = Color(0xFF57423B);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTextTheme = GoogleFonts.plusJakartaSansTextTheme();
    final headingStyle = GoogleFonts.bricolageGrotesque();

    return MaterialApp(
      title: 'Raiz dos Palmares',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: _primary,
          onPrimary: _onPrimary,
          primaryContainer: Color(0xFFFFDBCF),
          onPrimaryContainer: Color(0xFF390C00),
          secondary: _secondary,
          onSecondary: _onSecondary,
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
          surface: _surface,
          onSurface: _onSurface,
          surfaceContainerHighest: _surfaceContainerHighest,
          outline: _outline,
          outlineVariant: _outlineVariant,
          onSurfaceVariant: _onSurfaceVariant,
        ),
        textTheme: baseTextTheme.copyWith(
          displayLarge: headingStyle.copyWith(fontWeight: FontWeight.w800),
          displayMedium: headingStyle.copyWith(fontWeight: FontWeight.w800),
          displaySmall: headingStyle.copyWith(fontWeight: FontWeight.w800),
          headlineLarge: headingStyle.copyWith(fontWeight: FontWeight.w700),
          headlineMedium: headingStyle.copyWith(fontWeight: FontWeight.w700),
          headlineSmall: headingStyle.copyWith(fontWeight: FontWeight.w600),
          titleLarge: headingStyle.copyWith(fontWeight: FontWeight.w700),
          titleMedium: headingStyle.copyWith(fontWeight: FontWeight.w600),
        ),
        scaffoldBackgroundColor: _surface,
        appBarTheme: AppBarTheme(
          backgroundColor: _surface,
          foregroundColor: _onSurface,
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: GoogleFonts.bricolageGrotesque(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _onSurface,
          ),
          iconTheme: const IconThemeData(color: _onSurface),
        ),
        tabBarTheme: TabBarThemeData(
          labelColor: _primary,
          unselectedLabelColor: _onSurfaceVariant,
          indicatorColor: _primary,
          labelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          dividerColor: _outlineVariant,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: _surface,
          selectedItemColor: _primary,
          unselectedItemColor: _onSurfaceVariant,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
        ),
        cardTheme: CardThemeData(
          color: _surfaceContainer,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: _outlineVariant, width: 0.5),
          ),
        ),
        dividerColor: _outlineVariant,
        dividerTheme: const DividerThemeData(color: _outlineVariant),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

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
          onTap: (index) => setState(() => _selectedIndex = index),
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
