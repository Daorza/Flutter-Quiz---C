import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
// Import UI Anda (Pastikan path folder 'ui' sudah sesuai dengan struktur project)
import 'ui/splash_screen.dart';
import 'ui/login_screen.dart';
import 'ui/dashboard_screen.dart';
import 'ui/detail_screen.dart';
import 'ui/add_screen.dart';
import 'ui/edit_screen.dart';
import 'ui/about_screen.dart';
import 'ui/register_screen.dart';

void main() async {
  // Wajib dipanggil sebelum Firebase.initializeApp()
  WidgetsFlutterBinding.ensureInitialized();

  // Pastikan Anda sudah menambahkan google-services.json di folder android/app
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Default tema aplikasi
  ThemeMode _themeMode = ThemeMode.light;

  // Fungsi untuk mengubah tema yang akan dipanggil dari AboutScreen
  void toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplikasi Mahasiswa',
      debugShowCheckedModeBanner: false,

      // Konfigurasi Tema
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark),
      themeMode: _themeMode,

      // Navigasi
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/detail': (context) => DetailScreen(),
        '/add': (context) => AddScreen(),
        '/edit': (context) => EditScreen(),
        '/register': (context) => RegisterScreen(),

        // Mengirim state tema dan fungsi pengubahnya ke AboutScreen
        '/about': (context) => AboutScreen(
          isDark: _themeMode == ThemeMode.dark,
          onToggleTheme: toggleTheme,
        ),
      },
    );
  }
}
