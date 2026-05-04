import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 🔥 Ambil data dari dashboard (diubah menjadi dynamic agar fleksibel)
    final Map<String, dynamic> mhs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Mahasiswa"), centerTitle: true),
      body: SingleChildScrollView(
        // Tambahkan scroll agar tidak overflow di layar kecil
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Foto Mahasiswa
              Center(
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(
                    mhs['foto'] != null && mhs['foto'] != ""
                        ? mhs['foto']
                        : 'https://via.placeholder.com/150',
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Nama Mahasiswa
              Text(
                mhs['nama'] ?? 'Tanpa Nama',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),
              const Divider(thickness: 1),

              // Info NIM
              ListTile(
                leading: const Icon(Icons.badge, color: Colors.blue),
                title: const Text("NIM"),
                subtitle: Text(mhs['nim'] ?? '-'),
              ),

              // Info Tanggal Lahir (Menggunakan key 'tanggal_lahir' sesuai toMap)
              ListTile(
                leading: const Icon(Icons.cake, color: Colors.redAccent),
                title: const Text("Tanggal Lahir"),
                subtitle: Text(mhs['tanggal_lahir'] ?? '-'),
              ),

              // Info Hobi
              ListTile(
                leading: const Icon(Icons.sports_soccer, color: Colors.green),
                title: const Text("Hobi"),
                subtitle: Text(mhs['hobi'] ?? '-'),
              ),

              // Info No HP (Menggunakan key 'no_hp' sesuai toMap)
              ListTile(
                leading: const Icon(Icons.phone, color: Colors.orange),
                title: const Text("No HP"),
                subtitle: Text(mhs['no_hp'] ?? '-'),
              ),

              // Info Alamat
              ListTile(
                leading: const Icon(Icons.home, color: Colors.purple),
                title: const Text("Alamat"),
                subtitle: Text(mhs['alamat'] ?? '-'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
