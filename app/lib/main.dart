import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/join_screen.dart';
import 'services/signalling_service.dart';

void main() {
  runApp(const FileShareApp());
}

class FileShareApp extends StatelessWidget {
  final String websocketUrl = "ws://192.168.0.63:5000";

  const FileShareApp({super.key});

  @override
  Widget build(BuildContext context) {
    SignallingService.instance.init(websocketUrl: websocketUrl);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    const text = Color(0xff0f3346);
    const darkerBackground = Color(0xfff3deca);
    const background = Color(0xfffff7e5);
    const accent = Color(0xffff7e46);

    const radius = BorderRadius.all(Radius.circular(15.0));
    const buttonPadding = 15.0;
    const borderWidth = 2.0;

    var theme = ThemeData(
      textTheme: GoogleFonts.poppinsTextTheme(
        Theme.of(context).textTheme,
      ).copyWith(
        titleLarge: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 26.0,
        ),
        titleMedium: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          fontSize: 18.0,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontWeight: FontWeight.w700,
          color: accent,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: const RoundedRectangleBorder(borderRadius: radius),
          padding: const EdgeInsets.symmetric(vertical: buttonPadding),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(width: borderWidth),
          shape: const RoundedRectangleBorder(borderRadius: radius),
          padding: const EdgeInsets.symmetric(vertical: buttonPadding),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        fillColor: darkerBackground,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: radius,
        ),
      ),
      colorScheme: const ColorScheme.light().copyWith(
        surface: background,
        onSurface: text,
        primary: text,
        onPrimary: background,
        secondary: darkerBackground,
        onSecondary: text,
        tertiary: accent,
        onTertiary: background,
      ),
    );

    const InputDecoration().applyDefaults(InputDecorationTheme(
      fillColor: Theme.of(context).colorScheme.primary,
      filled: true,
      border: InputBorder.none,
    ));

    return MaterialApp(
      theme: theme,
      themeMode: ThemeMode.light,
      home: const JoinScreen(),
    );
  }
}
