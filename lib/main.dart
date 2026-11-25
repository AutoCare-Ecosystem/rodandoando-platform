import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'screens/login/login_screen.dart';
import 'navigation/app_shell.dart';

void main() {
  runApp(const RodandoAndoApp());
}

/// Raíz de la aplicación Rodando Ando — plataforma de gestión vehicular.
class RodandoAndoApp extends StatefulWidget {
  const RodandoAndoApp({super.key});

  @override
  State<RodandoAndoApp> createState() => _RodandoAndoAppState();
}

class _RodandoAndoAppState extends State<RodandoAndoApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  bool _isLoggedIn = false;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rodando Ando',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: _themeMode,
      home: _isLoggedIn
          ? AppShell(
              themeMode: _themeMode,
              onToggleTheme: _toggleTheme,
            )
          : LoginScreen(
              onLogin: () => setState(() => _isLoggedIn = true),
              onToggleTheme: _toggleTheme,
            ),
    );
  }
}
