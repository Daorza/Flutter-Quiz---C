import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  final bool isDark;
  final Function(bool) onToggleTheme;

  const AboutScreen({
    super.key,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About App")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Aplikasi Demo Database Firebase",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              "Aplikasi ini dibuat menggunakan Flutter + Firebase untuk CRUD data mahasiswa dengan fitur login, dashboard, detail, tambah, edit, dan delete data.",
            ),

            const SizedBox(height: 30),

            const Text(
              "Tema Aplikasi",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(isDark ? "Dark Mode" : "Light Mode"),
                Switch(value: isDark, onChanged: onToggleTheme),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
