import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Map<String, String>> allData = [
    {
      'foto': 'https://i.pravatar.cc/150?img=1',
      'nama': 'Budi Santoso',
      'nim': '123456789',
      'tanggal_lahir': '2002-05-10',
      'hobi': 'Futsal',
      'no_hp': '08123456789',
      'alamat': 'Jakarta',
    },
    {
      'foto': 'https://i.pravatar.cc/150?img=2',
      'nama': 'Siti Aminah',
      'nim': '987654321',
      'tanggal_lahir': '2001-11-22',
      'hobi': 'Membaca',
      'no_hp': '08234567890',
      'alamat': 'Bandung',
    },
    {
      'foto': 'https://i.pravatar.cc/150?img=3',
      'nama': 'Andi Wijaya',
      'nim': '1122334455',
      'tanggal_lahir': '2000-03-15',
      'hobi': 'Gaming',
      'no_hp': '08345678901',
      'alamat': 'Surabaya',
    },
  ];

  List<Map<String, String>> filteredData = [];

  String searchText = "";
  String selectedHobi = "All";

  @override
  void initState() {
    super.initState();
    filteredData = List.from(allData); // ✔ fix copy list
  }

  void applyFilter() {
    List<Map<String, String>> temp = List.from(allData);

    // 🔍 SEARCH
    if (searchText.isNotEmpty) {
      temp = temp.where((item) {
        return item['nama']!.toLowerCase().contains(searchText.toLowerCase()) ||
            item['nim']!.contains(searchText);
      }).toList();
    }

    // 🎯 FILTER HOBI
    if (selectedHobi != "All") {
      temp = temp.where((item) => item['hobi'] == selectedHobi).toList();
    }

    // 🔤 SORT
    temp.sort((a, b) => a['nama']!.compareTo(b['nama']!));

    setState(() {
      filteredData = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Mahasiswa"),
        centerTitle: true,
        actions: [
          // ℹ️ ABOUT BUTTON
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.pushNamed(context, '/about');
            },
          ),
        ],
      ),

      body: Column(
        children: [
          // 🔍 SEARCH
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
                searchText = value;
                applyFilter();
              },
            ),
          ),

          // 🎯 FILTER
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
                selectedHobi = value!;
                applyFilter();
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

          // 📋 LIST
          Expanded(
            child: ListView.builder(
              itemCount: filteredData.length,
              itemBuilder: (context, index) {
                final mhs = filteredData[index];

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
                      backgroundImage: NetworkImage(mhs['foto'] ?? ''),
                    ),
                    title: Text(mhs['nama'] ?? '-'),
                    subtitle: Text(mhs['nim'] ?? '-'),

                    // Tap untuk ke Detail
                    onTap: () {
                      Navigator.pushNamed(context, '/detail', arguments: mhs);
                    },

                    // Aksi di sebelah kanan
                    trailing: Row(
                      mainAxisSize: MainAxisSize
                          .min, // Penting agar Row tidak makan tempat ke samping
                      children: [
                        // Tombol EDIT
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/edit',
                              arguments: mhs,
                            );
                          },
                        ),
                        // Tombol DELETE
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // Tambahkan logika delete kamu di sini, misal:
                            // _deleteMahasiswa(mhs['id']);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // ➕ ADD
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
