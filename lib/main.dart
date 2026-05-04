import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase/ui/splash_screen.dart';
import 'package:firebase/ui/login_screen.dart';
import 'package:firebase/ui/dashboard_screen.dart';
import 'package:firebase/ui/detail_screen.dart';
import 'package:firebase/ui/add_screen.dart';
import 'package:firebase/ui/edit_screen.dart';
import 'package:firebase/ui/about_screen.dart';

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
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Database',
      debugShowCheckedModeBanner: false,

      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,

      initialRoute: '/',

      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/detail': (context) => DetailScreen(),
        '/add': (context) => AddScreen(),
        '/edit': (context) => EditScreen(),

        // 👉 ABOUT SCREEN
        '/about': (context) => AboutScreen(
          isDark: _themeMode == ThemeMode.dark,
          onToggleTheme: toggleTheme,
        ),
      },
    );
  }
}
