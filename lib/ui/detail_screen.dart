import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 🔥 ambil data dari dashboard
    final Map<String, String> mhs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    return Scaffold(
      appBar: AppBar(title: Text("Detail Mahasiswa")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(mhs['foto']!),
            ),

            SizedBox(height: 20),

            Text(
              mhs['nama']!,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),

            Divider(),

            ListTile(
              leading: Icon(Icons.badge),
              title: Text("NIM"),
              subtitle: Text(mhs['nim']!),
            ),

            ListTile(
              leading: Icon(Icons.cake),
              title: Text("Tanggal Lahir"),
              subtitle: Text(mhs['tanggal_lahir']!),
            ),

            ListTile(
              leading: Icon(Icons.sports_soccer),
              title: Text("Hobi"),
              subtitle: Text(mhs['hobi']!),
            ),

            ListTile(
              leading: Icon(Icons.phone),
              title: Text("No HP"),
              subtitle: Text(mhs['no_hp']!),
            ),

            ListTile(
              leading: Icon(Icons.home),
              title: Text("Alamat"),
              subtitle: Text(mhs['alamat']!),
            ),
          ],
        ),
      ),
    );
  }
}
