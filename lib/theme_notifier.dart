import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Notificador global — controla tema claro/escuro em toda a app.
/// Padrão: escuro.
final ValueNotifier<ThemeMode> appThemeMode = ValueNotifier(ThemeMode.dark);

/// Botão sol/lua para usar nos AppBars.
Widget buildThemeToggle(BuildContext context) {
  return ValueListenableBuilder<ThemeMode>(
    valueListenable: appThemeMode,
    builder: (ctx, mode, _) {
      final cs = Theme.of(ctx).colorScheme;
      final isDark = mode == ThemeMode.dark;
      return IconButton(
        icon: Icon(
          isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          color: cs.onSurface,
          size: 22,
        ),
        tooltip: isDark ? 'Tema Claro' : 'Tema Escuro',
        onPressed: () => appThemeMode.value =
            isDark ? ThemeMode.light : ThemeMode.dark,
      );
    },
  );
}

/// Constrói um ThemeData completo a partir de um ColorScheme.
/// Usado para criar tanto o tema claro quanto o escuro com a mesma estrutura.
ThemeData buildAppTheme(ColorScheme scheme) {
  final heading = GoogleFonts.bricolageGrotesque();
  final isDark = scheme.brightness == Brightness.dark;
  final baseText = isDark
      ? GoogleFonts.plusJakartaSansTextTheme(ThemeData.dark().textTheme)
      : GoogleFonts.plusJakartaSansTextTheme(ThemeData.light().textTheme);

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    textTheme: baseText.copyWith(
      displayLarge: heading.copyWith(fontWeight: FontWeight.w800),
      displayMedium: heading.copyWith(fontWeight: FontWeight.w800),
      displaySmall: heading.copyWith(fontWeight: FontWeight.w800),
      headlineLarge: heading.copyWith(fontWeight: FontWeight.w700),
      headlineMedium: heading.copyWith(fontWeight: FontWeight.w700),
      headlineSmall: heading.copyWith(fontWeight: FontWeight.w600),
      titleLarge: heading.copyWith(fontWeight: FontWeight.w700),
      titleMedium: heading.copyWith(fontWeight: FontWeight.w600),
    ),
    scaffoldBackgroundColor: scheme.surface,
    appBarTheme: AppBarTheme(
      backgroundColor: scheme.surface,
      foregroundColor: scheme.onSurface,
      elevation: 0,
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: GoogleFonts.bricolageGrotesque(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface,
      ),
      iconTheme: IconThemeData(color: scheme.onSurface),
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: scheme.primary,
      unselectedLabelColor: scheme.onSurfaceVariant,
      indicatorColor: scheme.primary,
      indicatorSize: TabBarIndicatorSize.tab,
      dividerColor: Colors.transparent,
      labelStyle: GoogleFonts.plusJakartaSans(
          fontSize: 14, fontWeight: FontWeight.w600),
      unselectedLabelStyle:
          GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w400),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: scheme.surface,
      selectedItemColor: scheme.primary,
      unselectedItemColor: scheme.onSurface.withOpacity(0.45),
      elevation: 0,
      type: BottomNavigationBarType.fixed,
    ),
    cardTheme: CardThemeData(
      color: scheme.surfaceContainer,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outlineVariant, width: 0.5),
      ),
    ),
    dividerColor: scheme.outlineVariant,
    dividerTheme: DividerThemeData(color: scheme.outlineVariant),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: scheme.inverseSurface,
      contentTextStyle: TextStyle(color: scheme.onInverseSurface),
    ),
  );
}
