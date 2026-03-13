import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'auth/auth_gate.dart';
import 'localization/app_localization.dart';

class CustomFlixApp extends StatefulWidget {
  const CustomFlixApp({super.key});

  @override
  State<CustomFlixApp> createState() => _CustomFlixAppState();
}

class _CustomFlixAppState extends State<CustomFlixApp> {
  final AppLanguageController _languageController = AppLanguageController();

  @override
  void dispose() {
    _languageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppLanguageScope(
      controller: _languageController,
      child: AnimatedBuilder(
        animation: _languageController,
        builder: (context, _) {
          return MaterialApp(
            title: 'CustomFlix',
            debugShowCheckedModeBanner: false,
            locale: _languageController.locale,
            supportedLocales: const [
              Locale('pt', 'BR'),
              Locale('en'),
            ],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: ThemeData(
              brightness: Brightness.dark,
              scaffoldBackgroundColor: const Color(0xFF111111),
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFFE50914),
                secondary: Color(0xFFB20710),
                surface: Color(0xFF1A1A1A),
              ),
              appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF111111)),
              useMaterial3: true,
            ),
            home: const AuthGate(),
          );
        },
        ),
    );
  }
}
