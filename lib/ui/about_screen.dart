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
    final cs = Theme.of(context).colorScheme;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("About App"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔵 Logo & judul
            Center(
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [cs.primary, const Color(0xFF0288D1)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: cs.primary.withOpacity(0.4),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    "Aplikasi Data Mahasiswa",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Versi 1.0.0",
                    style: TextStyle(
                      color: cs.onSurface.withOpacity(0.4),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // 📋 Deskripsi
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkTheme
                    ? Colors.white.withOpacity(0.06)
                    : cs.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: cs.onSurface.withOpacity(0.08)),
                boxShadow: isDarkTheme
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Text(
                "Aplikasi ini dikembangkan menggunakan Flutter dan Firebase Firestore sebagai backend utamanya. Fitur utama mencakup manajemen data (CRUD) mahasiswa secara real-time.",
                style: TextStyle(
                  color: cs.onSurface.withOpacity(0.6),
                  height: 1.6,
                  fontSize: 13,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ⚙️ Pengaturan Tema
            Text(
              "Pengaturan Tema",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: cs.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: isDarkTheme
                    ? Colors.white.withOpacity(0.06)
                    : cs.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: cs.onSurface.withOpacity(0.08)),
                boxShadow: isDarkTheme
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        isDark
                            ? Icons.dark_mode_outlined
                            : Icons.light_mode_outlined,
                        color: cs.secondary,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        isDark ? "Dark Mode" : "Light Mode",
                        style: TextStyle(color: cs.onSurface, fontSize: 14),
                      ),
                    ],
                  ),
                  // ✅ onToggleTheme (sama persis)
                  Switch(
                    value: isDark,
                    onChanged: onToggleTheme,
                    activeColor: cs.primary,
                    activeTrackColor: cs.secondary.withOpacity(0.4),
                  ),
                ],
              ),
            ),

            const Spacer(),

            Center(
              child: Text(
                "© 2026 Mahasiswa App",
                style: TextStyle(
                  color: cs.onSurface.withOpacity(0.25),
                  fontSize: 11,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
