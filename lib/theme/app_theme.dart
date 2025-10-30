import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _primary = Color(0xFF00C853);
  static const _secondary = Color(0xFF006E1C);

  static final lightTheme = ThemeData(
    colorSchemeSeed: _primary,
    useMaterial3: true,
    brightness: Brightness.light,
    textTheme: GoogleFonts.poppinsTextTheme(),
    scaffoldBackgroundColor: Colors.grey[50],
  );

  static final darkTheme = ThemeData(
    colorSchemeSeed: _secondary,
    useMaterial3: true,
    brightness: Brightness.dark,
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
  );
}
