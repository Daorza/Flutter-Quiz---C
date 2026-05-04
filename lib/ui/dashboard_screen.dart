import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firebase_service.dart'; // Sesuaikan path-nya

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Panggil service yang sudah Anda buat
  final FirebaseService _firebaseService = FirebaseService();

  String searchText = "";
  String selectedHobi = "All";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Mahasiswa"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => Navigator.pushNamed(context, '/about'),
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari nama atau NIM...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
            ),
          ),

          // 🎯 FILTER HOBI
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButtonFormField<String>(
              value: selectedHobi,
              items: ["All", "Futsal", "Membaca", "Gaming"]
                  .map(
                    (hobi) => DropdownMenuItem(value: hobi, child: Text(hobi)),
                  )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedHobi = value!;
                });
              },
              decoration: InputDecoration(
                labelText: "Filter Hobi",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // 📋 LIST DATA (REAL-TIME DARI FIREBASE)
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firebaseService
                  .getData(), // Memanggil fungsi dari service Anda
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return const Center(child: Text("Terjadi kesalahan"));
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Ambil dokumen dan filter secara lokal untuk pencarian/hobi
                var docs = snapshot.data!.docs.where((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  bool matchesSearch =
                      data['nama'].toString().toLowerCase().contains(
                        searchText,
                      ) ||
                      data['nim'].toString().contains(searchText);
                  bool matchesHobi =
                      selectedHobi == "All" || data['hobi'] == selectedHobi;
                  return matchesSearch && matchesHobi;
                }).toList();

                if (docs.isEmpty)
                  return const Center(child: Text("Data tidak ditemukan"));

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var docId = docs[index].id;
                    var data = docs[index].data() as Map<String, dynamic>;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            data['foto'] ?? 'https://via.placeholder.com/150',
                          ),
                        ),
                        title: Text(data['nama'] ?? '-'),
                        subtitle: Text(data['nim'] ?? '-'),
                        onTap: () {
                          // Mengirim data Map + ID ke halaman detail
                          data['id'] = docId;
                          Navigator.pushNamed(
                            context,
                            '/detail',
                            arguments: data,
                          );
                        },
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                data['id'] = docId;
                                Navigator.pushNamed(
                                  context,
                                  '/edit',
                                  arguments: data,
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Konfirmasi hapus
                                _showDeleteDialog(docId);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/add'),
        child: const Icon(Icons.add),
      ),
    );
  }

  // Fungsi pembantu untuk delete
  void _showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Data"),
        content: const Text("Apakah Anda yakin ingin menghapus mahasiswa ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () {
              _firebaseService.deleteData(id); // Menggunakan service Anda
              Navigator.pop(context);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
