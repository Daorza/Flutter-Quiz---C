import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  String searchText = "";
  String selectedHobi = "All";

  // ✅ fungsi logout (sama persis)
  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

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
              _firebaseService.deleteData(id);
              Navigator.pop(context);
            },
            child: const Text(
              "Hapus",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Mahasiswa"),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => Navigator.pushNamed(context, '/about'),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: const Text("Logout"),
                content: const Text("Yakin ingin keluar?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Batal"),
                  ),
                  TextButton(
                    onPressed: _logout,
                    child: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.redAccent),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // 🔍 Search
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari nama atau NIM...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (v) => setState(() => searchText = v.toLowerCase()),
            ),
          ),

          // 🎯 Filter
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButtonFormField<String>(
              value: selectedHobi,
              dropdownColor: cs.surface,
              decoration: InputDecoration(
                labelText: "Filter Hobi",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              items: [
                "All",
                "Futsal",
                "Membaca",
                "Gaming",
              ].map((h) => DropdownMenuItem(value: h, child: Text(h))).toList(),
              onChanged: (v) => setState(() => selectedHobi = v!),
            ),
          ),

          const SizedBox(height: 10),

          // 📋 List data
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firebaseService.getData(),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return const Center(child: Text("Terjadi kesalahan"));
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(
                    child: CircularProgressIndicator(color: cs.primary),
                  );

                var docs = snapshot.data!.docs.where((doc) {
                  var data = doc.data() as Map<String, dynamic>;
                  bool matchSearch =
                      data['nama'].toString().toLowerCase().contains(
                        searchText,
                      ) ||
                      data['nim'].toString().contains(searchText);
                  bool matchHobi =
                      selectedHobi == "All" || data['hobi'] == selectedHobi;
                  return matchSearch && matchHobi;
                }).toList();

                if (docs.isEmpty)
                  return const Center(child: Text("Data tidak ditemukan"));

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var docId = docs[index].id;
                    var data = docs[index].data() as Map<String, dynamic>;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.06)
                            : cs.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: cs.onSurface.withOpacity(0.08),
                        ),
                        boxShadow: isDark
                            ? []
                            : [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            data['foto'] ?? 'https://via.placeholder.com/150',
                          ),
                        ),
                        title: Text(
                          data['nama'] ?? '-',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: cs.onSurface,
                          ),
                        ),
                        subtitle: Text(
                          data['nim'] ?? '-',
                          style: TextStyle(
                            color: cs.onSurface.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                        onTap: () {
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
                              icon: Icon(
                                Icons.edit_outlined,
                                color: cs.secondary,
                                size: 20,
                              ),
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
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                                size: 20,
                              ),
                              onPressed: () => _showDeleteDialog(docId),
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
        backgroundColor: cs.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
