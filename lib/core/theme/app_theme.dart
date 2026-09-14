import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  static const obsidianDark = Color(0xFF0B0B10);
  static const imperialGold = Color(0xFFFFD700);
  static const amberWarmGold = Color(0xFFF0B90B);
  static const deepMaroon = Color(0xFF5A0E17);
  static const glassWhite = Color(0x1AFFFFFF);
  static const glassBorder = Color(0x33FFFFFF);

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [imperialGold, amberWarmGold, Color(0xFFE6B800)],
  );
}

class AppTheme {
  const AppTheme._();

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    final bodyText = GoogleFonts.cairoTextTheme(base.textTheme);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.obsidianDark,
      primaryColor: AppColors.imperialGold,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.imperialGold,
        secondary: AppColors.amberWarmGold,
        surface: AppColors.obsidianDark,
        surfaceContainerHighest: AppColors.deepMaroon,
      ),
      textTheme: bodyText.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        color: AppColors.glassWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AppColors.glassBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.glassBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: AppColors.glassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: AppColors.imperialGold,
            width: 1.6,
          ),
        ),
        hintStyle: GoogleFonts.cairo(color: Colors.white70, fontSize: 16),
      ),
    );
  }

  static TextStyle goldTitleStyle({double fontSize = 32}) {
    final shader = AppColors.goldGradient.createShader(
      const Rect.fromLTWH(0, 0, 400, 120),
    );

    return GoogleFonts.amiri(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      letterSpacing: 0.5,
      height: 1.4,
      foreground: Paint()..shader = shader,
      shadows: const [
        Shadow(color: Colors.black54, blurRadius: 8, offset: Offset(2, 2)),
      ],
    );
  }

  static TextStyle bodyStyle({double fontSize = 18}) => GoogleFonts.cairo(
    fontSize: fontSize,
    color: Colors.white,
    fontWeight: FontWeight.w600,
  );

  static TextStyle smallBodyStyle({double fontSize = 14}) => GoogleFonts.cairo(
    fontSize: fontSize,
    color: Colors.white70,
    fontWeight: FontWeight.w500,
  );
}
