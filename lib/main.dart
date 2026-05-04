import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'ui/splash_screen.dart';
import 'ui/login_screen.dart';
import 'ui/dashboard_screen.dart';
import 'ui/detail_screen.dart';
import 'ui/add_screen.dart';
import 'ui/edit_screen.dart';
import 'ui/about_screen.dart';
import 'ui/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void toggleTheme(bool isDark) {
    setState(() => _themeMode = isDark ? ThemeMode.dark : ThemeMode.light);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Mahasiswa',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,

      // 🌙 Dark theme
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0F1B2D),
        colorScheme: ColorScheme.dark(
          primary: const Color(0xFF1565C0),
          secondary: const Color(0xFF42A5F5),
          surface: const Color(0xFF1A2E4A),
          onSurface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A2E4A),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white70),
        ),
        cardColor: Colors.white10,
        dividerColor: Colors.white12,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white10,
          labelStyle: const TextStyle(color: Colors.white38, fontSize: 13),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF42A5F5)),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1565C0),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        dialogTheme: const DialogThemeData(
          backgroundColor: Color(0xFF1A2E4A),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: TextStyle(color: Colors.white70),
        ),
      ),

      // ☀️ Light theme
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF0F4FF),
        colorScheme: ColorScheme.light(
          primary: const Color(0xFF1565C0),
          secondary: const Color(0xFF42A5F5),
          surface: Colors.white,
          onSurface: const Color(0xFF1A1A2E),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1565C0),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        cardColor: Colors.white,
        dividerColor: Colors.black12,
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          labelStyle: const TextStyle(fontSize: 13),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF1565C0)),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1565C0),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        dialogTheme: const DialogThemeData(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(
            color: Color(0xFF1A1A2E),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          contentTextStyle: TextStyle(color: Colors.black54),
        ),
      ),

      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/detail': (context) => DetailScreen(),
        '/add': (context) => AddScreen(),
        '/edit': (context) => EditScreen(),
        '/register': (context) => RegisterScreen(),
        '/about': (context) => AboutScreen(
          isDark: _themeMode == ThemeMode.dark,
          onToggleTheme: toggleTheme,
        ),
      },
    );
  }
}
