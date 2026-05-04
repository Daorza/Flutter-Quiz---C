import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> mhs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Detail Mahasiswa"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 📷 Foto
            CircleAvatar(
              radius: 62,
              backgroundColor: cs.surface,
              backgroundImage: NetworkImage(
                (mhs['foto'] != null && mhs['foto'] != '')
                    ? mhs['foto']
                    : 'https://via.placeholder.com/150',
              ),
            ),
            const SizedBox(height: 16),

            // 🏷️ Nama
            Text(
              mhs['nama'] ?? 'Tanpa Nama',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: cs.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              mhs['nim'] ?? '-',
              style: TextStyle(
                color: cs.onSurface.withOpacity(0.4),
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 24),

            // 📋 Info card
            Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.06) : cs.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: cs.onSurface.withOpacity(0.08)),
                boxShadow: isDark
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
              ),
              child: Column(
                children: [
                  _buildTile(
                    context,
                    Icons.badge_outlined,
                    "NIM",
                    mhs['nim'],
                    Colors.blue,
                  ),
                  _divider(context),
                  _buildTile(
                    context,
                    Icons.cake_outlined,
                    "Tanggal Lahir",
                    mhs['tanggal_lahir'],
                    Colors.redAccent,
                  ),
                  _divider(context),
                  _buildTile(
                    context,
                    Icons.sports_esports_outlined,
                    "Hobi",
                    mhs['hobi'],
                    Colors.green,
                  ),
                  _divider(context),
                  _buildTile(
                    context,
                    Icons.phone_outlined,
                    "No HP",
                    mhs['no_hp'],
                    Colors.orange,
                  ),
                  _divider(context),
                  _buildTile(
                    context,
                    Icons.location_on_outlined,
                    "Alamat",
                    mhs['alamat'],
                    Colors.purple,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTile(
    BuildContext context,
    IconData icon,
    String label,
    String? value,
    Color iconColor,
  ) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: cs.onSurface.withOpacity(0.4),
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value ?? '-',
                style: TextStyle(color: cs.onSurface, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _divider(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Divider(
      height: 1,
      color: cs.onSurface.withOpacity(0.07),
      indent: 16,
      endIndent: 16,
    );
  }
}
