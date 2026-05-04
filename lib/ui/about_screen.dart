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
      appBar: AppBar(title: const Text("About App"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(
                Icons
                    .account_balance_wallet_outlined, // Anda bisa ganti dengan logo aplikasi
                size: 80,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Aplikasi Data Mahasiswa",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Aplikasi ini dikembangkan menggunakan Flutter dan Firebase Firestore sebagai backend utamanya. Fitur utama mencakup manajemen data (CRUD) mahasiswa secara real-time.",
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 30),
            const Divider(),
            const Text(
              "Pengaturan Tema",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(isDark ? Icons.dark_mode : Icons.light_mode),
                        const SizedBox(width: 12),
                        Text(
                          isDark ? "Dark Mode" : "Light Mode",
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                    Switch(
                      value: isDark,
                      onChanged: onToggleTheme,
                      activeColor: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            const Center(
              child: Text("Versi 1.0.0", style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }
}
