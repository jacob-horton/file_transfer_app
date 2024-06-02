import 'package:flutter/material.dart';
import 'screens/join_screen.dart';
import 'services/signalling_service.dart';

void main() {
  runApp(const FileShareApp());
}

class FileShareApp extends StatelessWidget {
  const FileShareApp({super.key});

  final String websocketUrl = "ws://localhost:5000";

  @override
  Widget build(BuildContext context) {
    SignallingService.instance.init(websocketUrl: websocketUrl);

    return MaterialApp(
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: const ColorScheme.dark(),
      ),
      themeMode: ThemeMode.dark,
      home: const RoomScreen(),
    );
  }
}
