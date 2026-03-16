import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'features/app_shell/presentation/screens/app_shell.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return MaterialApp(
      title: 'TikTok Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF070707),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        colorScheme: const ColorScheme.dark(
          primary: Colors.white,
          surface: Color(0xFF070707),
        ),
      ),
      home: const AppShell(),
    );
  }
}
